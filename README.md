# InternalFluidFlow.jl

<!-- [![DOI](https://zenodo.org/badge/524550191.svg)](https://zenodo.org/badge/latestdoi/524550191) -->
[![DOI](https://zenodo.org/badge/524550191.svg)](https://zenodo.org/doi/10.5281/zenodo.7019888)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![version](https://juliahub.com/docs/General/InternalFluidFlow/stable/version.svg)](https://juliahub.com/ui/Packages/General/InternalFluidFlow)
[![pkgeval](https://juliahub.com/docs/General/InternalFluidFlow/stable/pkgeval.svg)](https://juliahub.com/ui/Packages/General/InternalFluidFlow)

## Installing and Loading InternalFluidFlow

`InternalFluidFlow` can be installed and loaded either
from the JuliaHub repository (last released version) or from the
[maintainer's repository](https://github.com/aumpierre-unb/InternalFluidFlow.jl).

### Last Released Version

The last version of `InternalFluidFlow` can be installed from JuliaHub repository:

```julia
using Pkg
Pkg.add("InternalFluidFlow")
using InternalFluidFlow
```

If `InternalFluidFlow` is already installed, it can be updated:

```julia
using Pkg
Pkg.update("InternalFluidFlow")
using InternalFluidFlow
```

### Pre-Release (Under Construction) Version

The pre-release (under construction) version of InternalFluidFlow
can be installed from the [maintainer's repository](https://github.com/aumpierre-unb/InternalFluidFlow.jl).

```julia
using Pkg
Pkg.add(path="https://github.com/aumpierre-unb/InternalFluidFlow.jl")
using InternalFluidFlow
```

## Citation of `InternalFluidFlow`

You can cite all versions (both released and pre-released), by using
[DOI 105281/zenodo.7019888](https://doi.org/10.5281/zenodo.7019888).
This DOI represents all versions, and will always resolve to the latest one.

<!--For citation of the last released version of InternalFluidFlow, please check CITATION file at the [maintainer's repository](https://github.com/aumpierre-unb/InternalFluidFlow.jl).-->

## The InternalFluidFlow Module for Julia

`InternalFluidFlow` provides the following functions:

- **Re2f**
- **f2Re**
- **h2fRe**
- **doPlot**

### **Re2f**

`Re2f` computes the Darcy friction f factor given
the Reynolds number Re and
the relative roughness ε.

Pipe is assumed to be smooth (default is ε = 0).
The upper limit for relative roughness is ε = 0.05.
If given relative roughness ε > 0.05 is out of bounds then
relative roughness is reassigned to ε = 0.05 for turbulent flow.
Unless msgs = false is given, user will noticed.

If lam = false is given
then `Re2f` disregards the laminar flow bounds (Re < 4e3).

If turb = false is given
then `Re2f` disregards the turbulent flow bounds (Re > 2.3e3).

If fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`Re2f` is a main function of
the `InternalFluidFlow` toolbox for Julia.

**Syntax:**

```julia
Re2f(; # Darcy friction factor
    Re::Number, # Reynolds number
    ε::Number=0, # relative roughness
    lam::Bool=true, # default is search within laminar bounds
    turb::Bool=true, # default is search within turbulent bounds
    msgs::Bool=true, # default is show warning messages
    fig::Bool=false # default is hide plot
    )::Moody
```

**Examples:**

Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness ε = 3e-3.

```julia
flow = Re2f( # Darcy friction factor
    Re=120e3, # Reynolds number
    ε=3e-3 # relative roughness
    )
flow.Re # Re of the flow
flow.f # f of the flow
```

Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness ε = 6e-2.
In this case, relative roughness is reassigned to ε = 5e-2 for turbulent flow.

```julia
Re2f( # Darcy friction factor
    Re=120e3, # Reynolds number
    ε=6e-2 # relative roughness
    )
```

Compute the Darcy friction factor f given
the Reynolds number Re = 3,500 and
the relative roughness ε = 6e-3 and
show results on a schematic Moody diagram.

```julia
Re2f( # Darcy friction factor
    Re=3500, # Reynolds number
    ε=6e-3, # relative roughness
    fig=true # show plot
    )
```

### **f2Re**

`f2Re` computes the Reynolds number Re given
the Darcy friction factor f and
the relative roughness ε
for both laminar and turbulent regime, if possible.

`f2Re` returns solutions found both
within laminar (Re < 4e3) and
within turbulent (Re < 2.3e3) bounds.

Pipe is assumed to be smooth (default is ε = 0).
The upper limit for relative roughness is ε = 0.05.
If given relative roughness ε > 0.05 is out of bounds then
relative roughness is reassigned to ε = 0.05 for turbulent flow.
Unless msgs = false is given, user will noticed.

If lam = false is given
then `f2Re` disregards the laminar flow bounds (Re < 4e3).

If turb = false is given
then `f2Re` disregards the turbulent flow bounds (Re > 2.3e3).

It is possible that no solution be found
neither within laminar nor within turbulent bounds (see on examples).
Unless msgs = false is given, user will noticed.

If fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```julia
f2Re(; # Reynolds number
    f::Number, # Darcy friction factor
    ε::Number=0, # relative roughness, default is smooth pipe
    lam::Bool=true, # default is search within laminar bounds
    turb::Bool=true, # default is search within turbulent bounds
    msgs::Bool=true, # default is show warning messages
    fig::Bool=false # default is hide plot
    )::Moody
```

**Examples:**

Compute the Reynolds number Re given
the Darcy friction factor f = 2.8e-2 and
the pipe relative roughness ε = 5e-3.
In this case, only laminar
solution is possible:

```julia
flow = f2Re( # Reynolds number
    f=2.8e-2, # Darcy friction factor
    ε=5e-3 # relative roughness
    )
flow.Re # Re of the laminar flow
flow.f # f of the turbulent flow
```

Compute the Reynolds number Re given
the Darcy friction factor f = 1.8e-2 and
the pipe relative roughness ε = 5e-3.
In this case, only turbulent
solution is possible:

```julia
f2Re( # Reynolds number
    f=1.8e-2, # Darcy friction factor
    ε=5e-3 # relative roughness
    )
```

Compute the Reynolds number Re given
the Darcy friction factor f = 1.2e-2 and
the pipe relative roughness ε = 9e-3.
In this case, both laminar and turbulent
solutions are impossible:

```julia
f2Re( # Reynolds number
    f=1.2e-2, # Darcy friction factor
    ε=9e-3 # relative roughness
    )
```

Compute the Reynolds number Re given
the Darcy friction factor f = 0.028
for a smooth pipe and plot and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible:

```julia
flow = f2Re( # Reynolds number
    f=0.028, # Darcy friction factor
    fig=true # show plot
    )
lam, turb = flow; # laminar flow and turbulent flow
lam.Re # Re of the laminar flow
turb.f # f of the turbulent flow
```

### **h2fRe**

`h2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h in cm,
the pipe hydraulic diameter D in cm or
the flow speed v in cm/s or
the volumetric flow rate Q in cc/s `(D or Q or v)`,
the pipe length L in cm (default L = 100 cm),
the pipe roughness k in cm or
the pipe relative roughness ε `(ε or k)`,
the fluid density ρ in g/cc (default ρ = 0.997 g/cc),
the fluid dynamic viscosity μ in g/cm/s (default μ = 0.0091 g/cm/s), and
the gravitational accelaration g in cm/s/s (default g = 981 cm/s/s).

`h2fRe` returns solutions found both
within laminar (Re < 4e3) and within turbulent (Re < 2.3e3) bounds.

Pipe is assumed to be 100 cm long (default is L = 100).

Fluid is assumed to be water at 25 °C, with
0.997 g/cc density and 0.0091 g/cm/s dynamic viscosity
(default is ρ = 0.997 and μ = 0.0091).

Gravitational acceleration is assumed to be 981 cm/s/s (default is g = 981).

Notice that default parameters are given in the cgs unit system and
all parameters must be given in a consistent unit system.

The upper limit for relative roughness is ε = 0.05.
If either given or calculated relative roughness ε > 0.05 is out of bounds then
relative roughness is reassigned to ε = 0.05 for turbulent flow.
Unless msgs = false is given, user will noticed.

If lam = false is given then
`h2fRe` disregards the laminar flow bounds (Re < 4e3).

If turb = false is given then
`h2fRe` disregards the turbulent flow bounds (Re > 2.3e3).

It is possible that no solution be found
neither within laminar nor within turbulent bounds (see on examples).
Unless msgs = false is given, user will noticed.

If fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```julia
h2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number; # head loss in cm
    L::Number=100, # pipe length in cm
    ε::Number=NaN, # pipe relative roughness
    k::Number=NaN, # pipe roughness in cm
    D::Number=NaN, # pipe hydraulic diameter in cm
    v::Number=NaN, # flow speed in cm/s
    Q::Number=NaN, # volumetric flow rate in cc/s
    ρ::Number=0.997, # fluid dynamic density in g/cc
    μ::Number=0.0091, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    lam::Bool=true, # default is search within laminar bounds
    turb::Bool=true, # default is search within turbulent bounds
    msgs::Bool=true, # default is show warning messages
    fig::Bool=false # default is hide plot
    )::Moody
```

**Examples:**

Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss h = 262 mm,
the pipe hydraulic diameter D = 10 mm,
the pipe length L = 25 m and
the pipe relative roughness ε = 0,
the fluid density ρ = 0.989 g/cc and
the fluid dynamic viscosity μ = 0.89 cP.
In this case, both laminar and turbulent
solutions are possible (at their limit bounds!):

```julia
flow = h2fRe( # Reynolds number Re and Darcy friction factor f
    h=262e-1, # head loss in cm
    D=10e-1, # volumetric flow rate in cc/s
    L=25e2, # pipe length in cm
    ε=0, # pipe relative roughness
    ρ=0.989, # fluid dynamic density in g/cc
    μ=8.9e-3, # fluid dynamic viscosity in g/cm/s
    fig=true # show plot
    )
lam, turb = flow; # laminar flow and turbulent flow
lam.Re # Re of the laminar flow
turb.f # f of the turb flow
```

Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss h = 270 mm,
the pipe hydraulic diameter D = 10 mm,
the pipe length L = 25 m and
the pipe relative roughness ε = 0.02,
the fluid density ρ = 0.989 g/cc and
the fluid dynamic viscosity μ = 0.89 cP.
This is an extraordinary situation as there is no solution
within laminar bounds (Re < 4e3) and
within turbulent bounds (Re > 2.3e3) and
`h2fRe` returns `Nothing`:

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    h=270e-1, # head loss in cm
    D=10e-1, # volumetric flow rate in cc/s
    L=25e2, # pipe length in cm
    ε=0.02, # pipe relative roughness
    ρ=0.989, # fluid dynamic density in g/cc
    μ=8.9e-3, # fluid dynamic viscosity in g/cm/s
    fig=true # show plot
    )
```

Compute the Reynolds number Re and
the Darcy friction factor fgiven
the head loss h = 40 cm,
the pipe hydraulic diameter D = 10 mm,
the pipe length L = 25 m and
the pipe roughness k = 0.30 mm,
for water flow.
In this case, pipe roughness is converted to relative roughness ε = k / D and `h2fRe` is called again:

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    h=40, # head loss in cm
    D=10e-1, # pipe hyraulic diameter in cm
    L=25e2, # pipe length in cm
    k=0.30e-1 # pipe  roughness in cm
    )
```

Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss per meter h/L = 1.6 cm/m,
the volumetric flow rate Q = 8.6 L/s,
the pipe length L = 25 m,
the pipe roughness k = 0.08 cm,
the fluid density ρ = 0.989 g/cc and
the fluid dynamic viscosity μ = 0.89 cP.

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    h=1.6*25, # head loss in cm
    Q=8.6e3, # volumetric flow rate in cc/s
    L=25e2, # pipe length in cm
    k=0.08, # pipe roughness in cm
    ρ=0.989, # fluid dynamic density in g/cc
    μ=8.9e-3 # fluid dynamic viscosity in g/cm/s
    )
```

Compute the Reynolds number Re and
the Darcy friction factor fgiven
the head loss h = 0.30 m,
the flow speed v = 25 cm/s,
the pipe length L = 25 m,
the pipe roughness k = 0.02 cm
for water flow and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible:

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    h=0.30e2, # head loss in cm
    v=25, # flow speed in cm/s
    L=25e2, # pipe length in cm
    k=0.02, # pipe roughness in cm
    fig=true # show plot
    )
```

Compute the Reynolds number Re and
the Darcy friction factor fgiven
the head loss h = 0.12 m,
the flow speed v = 23 cm/s,
the pipe length L = 25 m,
the pipe roughness k = 0.3 cm
for water flow and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible,
however laminar flow is extended to Re = 4e3 and
relative roughness is reassigned to maximum ε = 5e-2 for turbulent flow:

```julia
flow = h2fRe( # Reynolds number Re and Darcy friction factor f
    h=0.12e2, # head loss in cm
    v=23, # flow speed in cm/s
    L=25e2, # pipe length in cm
    k=0.3, # pipe roughness in cm
    fig=true # show plot
    )
lam, turb = flow; # laminar flow and turbulent flow
lam.Re # Re of the laminar flow
lam.ε # ε of the laminar flow
turb.f # f of the turbulent flow
turb.ε # ε of the turbulent flow
```

### **doPlot**

`doPlot` produces a schematic Moody diagram
including the the turbulent line for given relative roughness ε
(default is smooth pipe, ε = 0).

**Syntax:**

```julia
doPlot(;
    ε::Number=0, # pipe relative roughness
    back::Symbol=:white # background color
    )
```

**Examples:**

Build a schematic Moody diagram
with transparent background
with one extra line for turbulent flow
with ε = 4.5e-3.

```julia
doPlot(
    ε=4.5e-3, # extra turbulent line in Moody diagram
    back=:transparent # transparent background
    )
using Plots
savefig("moodyDiagram_transparent.svg")
```

### See Also

<!-- [McCabeThiele.jl](https://github.com/aumpierre-unb/McCabeThiele.jl), -->
<!-- [PonchonSavarit.jl](https://github.com/aumpierre-unb/PonchonSavarit.jl), -->
[Psychrometrics.jl](https://github.com/aumpierre-unb/Psychrometrics.jl).

Copyright &copy; 2022 2023 2024 2025 Alexandre Umpierre

email: <aumpierre@gmail.com>
