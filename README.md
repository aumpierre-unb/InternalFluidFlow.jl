# InternalFluidFlow.jl

<!-- [![DOI](https://zenodo.org/badge/524550191.svg)](https://zenodo.org/badge/latestdoi/524550191) -->
[![DOI](https://zenodo.org/badge/524550191.svg)](https://zenodo.org/doi/10.5281/zenodo.7019888)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![version](https://juliahub.com/docs/General/InternalFluidFlow/stable/version.svg)](https://juliahub.com/ui/Packages/General/InternalFluidFlow)
[![pkgeval](https://juliahub.com/docs/General/InternalFluidFlow/stable/pkgeval.svg)](https://juliahub.com/ui/Packages/General/InternalFluidFlow)

## Installing and Loading InternalFluidFlow

InternalFluidFlow can be installed and loaded either
from the JuliaHub repository (last released version) or from the
[maintainer's repository](https://github.com/aumpierre-unb/InternalFluidFlow.jl).

### Last Released Version

The last version of InternalFluidFlow can be installed from JuliaHub repository:

```julia
using Pkg
Pkg.add("InternalFluidFlow")
using InternalFluidFlow
```

If InternalFluidFlow is already installed, it can be updated:

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

## Citation of InternalFluidFlow

You can cite all versions (both released and pre-released), by using
[DOI 105281/zenodo.7019888](https://doi.org/10.5281/zenodo.7019888).
This DOI represents all versions, and will always resolve to the latest one.

<!--For citation of the last released version of InternalFluidFlow, please check CITATION file at the [maintainer's repository](https://github.com/aumpierre-unb/InternalFluidFlow.jl).-->

## The InternalFluidFlow Module for Julia

InternalFluidFlow provides the following functions:

- **Re2f**
- **f2Re**
- **h2fRe**
- **doPlot**

### **Re2f**

Re2f computes the Darcy friction f factor given the Reynolds number Re and the relative roughness ε (default ε = 0).

By default, pipe is assumed to be smooth. Relative roughness is reset to ε = 0.05, if ε > 0.05.

If parameter fig = true is given a schematic Moody diagram is plotted as a graphical representation of the solution.

**Syntax:**

```julia
Re2f( # Darcy friction factor
    Re::Number; # Reynolds number
    ε::Number=0, # relative roughness
    fig::Bool=false # show plot
    )
```

**Examples:**

Compute the Darcy friction factor f given the Reynolds number Re = 120,000 and the relative roughness ε = 0.001:

```julia
Re2f( # Darcy friction factor
    120e3, # Reynolds number
    ε=1e-3 # relative roughness
    )
```

Compute the Darcy friction factor f given the Reynolds number Re = 120,000 for a smooth pipe and plot and show results on a schematic Moody diagram:

```julia
Re2f( # Darcy friction factor
    120e3, # Reynolds number
    fig=true # show plot
    )
```

### **f2Re**

f2Re computes the Reynolds number Re given the Darcy friction factor f and the relative roughness ε (default ε = 0) for both laminar and turbulent regime, if possible.

By default, pipe is assumed to be smooth. Relative roughness is reset to ε = 0.05, if ε > 0.05.

If parameter fig = true is given a schematic Moody diagram is plotted as a graphical representation of the solution.

If parameter isturb = true is given and both laminar and turbulent regimes are possible, then f2Re returns the number of Reynolds for turbulent regime alone.

**Syntax:**

```julia
f2Re( # Reynolds number
    f::Number; # Darcy friction factor
    ε::Number=0, # relative roughness, default is smooth pipe
    fig::Bool=false, # default hide plot
    isturb::Bool=false # default disregard turbulent flow
    )
```

**Examples:**

Compute the Reynolds number Re given the Darcy friction factor f = 0.028 and the pipe's relative roughness ε = 0.001. In this case, both laminar and turbulent solutions are possible:

```julia
f2Re( # Reynolds number
    2.8e-2, # Darcy friction factor
    ε=1e-3 # relative roughness
    )
```

Compute the Reynolds number Re given the Darcy friction factor f = 0.028 for a smooth pipe and plot and show results on a schematic Moody diagram:

```julia
f2Re( # Reynolds number
    2.8e-2, # Darcy friction factor
    fig=true # show plot
    )
```

### **h2fRe**

h2fRe computes the Reynolds number Re and Darcy friction factor f f given the head loss h, the pipe's hydraulic diameter D or the flow speed v or the volumetric flow rate Q, the pipe's length L (default L = 100 cm), the pipe's roughness k (default k = 0 cm) or the pipe's relative roughness ε (default ε = 0), the fluid's density ρ (default ρ = 0.997 g/cc), the fluid's dynamic viscosity μ (default μ = 0.0091 g/cm/s), and the gravitational accelaration g (default g = 981 cm/s/s).

By default, pipe is assumed to be 1 m long, L = 100 (in cm).

By default, pipe is assumed to be smooth. Relative roughness is reset to ε = 0.05, if ε > 0.05.

Notice that default values are given in the cgs unit system and, if taken, all other parameters must as well be given in cgs units.

If parameter fig = true is given a schematic Moody diagram is plotted as a graphical representation of the solution.

**Syntax:**

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    h::Number; # head loss in cm
    L::Number=100, # pipe's length in cm, default is 100 cm
    ε::Number=NaN, # pipe's relative roughness
    k::Number=NaN, # pipe's roughness in cm
    D::Number=NaN, # pipe's hydraulic diameter in cm
    v::Number=NaN, # flow speed in cm/s
    Q::Number=NaN, # volumetric flow rate in cc/s
    ρ::Number=0.997, # fluid's dynamic density in g/cc
    μ::Number=0.0091, # fluid's dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

**Examples:**

Compute the Reynolds number Re and Darcy friction factor f f given the head loss h = 40 cm, the pipe's hydraulic diameter D = 10 cm, length L = 25 m and relative roughness ε = 0.0027 for water flow:

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    40, # head loss in cm
    D=10, # pipe's hyraulic diameter in cm
    L=2.5e3, # pipe's length in cm
    ε=2.7e-3 # pipe's relative roughness
    )
```

Compute the Reynolds number Re and Darcy friction factor f f given the head loss per meter h/L = 1.6 cm/m, the volumetric flow rate Q = 8.6 L/s, the fluid's density ρ = 0.989 g/cc and dynamic viscosity μ = 0.89 cP for a smooth pipe and show results on a schematic Moody diagram:

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    40, # head loss in cm
    1.6, # head loss in cm
    Q=8.6e3, # volumetric flow rate in cc/s
    ε=0, # relative roughness
    ρ=0.989, # fluid's dynamic density in g/cc
    μ=8.9e-3, # fluid's dynamic viscosity in g/cm/s
    fig=true # show plot
    )
```

Compute the Reynolds number Re and Darcy friction factor f f, given the head loss h = 0.40 m, the flow speed v = 1.1 m/s, the pipe's length L = 25 m for water flow in a smooth pipe:

```julia
h2fRe( # Reynolds number Re and Darcy friction factor f
    40, # head loss in cm
    v=1.1e2, # flow speed in cm/s
    L=2.5e3, # pipe's length in cm
    k=0 # pipe's roughness in cm
    )
```

### **doPlot**

doPlot produces a schematic Moody diagram..

**Syntax:**

```julia
doPlot()
```

**Examples:**

Build a schematic Moody diagram:

```julia
doPlot()
```

Compute the Darcy friction factor f given the Reynolds number Re = 120,000 for a smooth pipe and plot and show results on a schematic Moody diagram:

```julia
Re2f( # Darcy friction factor
    120e3, # Reynolds number
    fig=true # show plot
    )
```

### See Also

[McCabeThiele.jl](https://github.com/aumpierre-unb/McCabeThiele.jl),
[Psychrometrics.jl](https://github.com/aumpierre-unb/Psychrometrics.jl),
[PonchonSavarit.jl](https://github.com/aumpierre-unb/PonchonSavarit.jl).

Copyright &copy; 2022 2023 Alexandre Umpierre

email: <aumpierre@gmail.com>
