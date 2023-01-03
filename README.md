# InternalFluidFlow.jl

[![DOI](https://zenodo.org/badge/524550191.svg)](https://zenodo.org/badge/latestdoi/524550191)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![version](https://juliahub.com/docs/InternalFluidFlow/version.svg)](https://juliahub.com/ui/Packages/InternalFluidFlow/zGZKl)

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

- Re2f
- f2Re
- hDeps2fDRe
- hveps2fDRe
- hQeps2fDRe
- hvthk2fDRe
- hQthk2fDRe

### Re2f

Re2f computes the Darcy friction factor, given
the Reynolds number and
the relative roughness.

By default, pipe is assumed to be smooth,
relative roughness is eps = 0.
If eps > 0.05, eps is reset to eps = 0.05.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
f=Re2f(Re[,eps[,fig]])
```

**Examples:**

Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness eps = 0.001:

```julia
Re=1.2e5;eps=1e-3;
f=Re2f(Re,eps)
```

Compute f and plot a schematic Moody diagram:

```julia
f=Re2f(1.2e5,1e-3,true)
```

### f2Re

f2Re computes the Reynolds number, given
the Darcy friction factor and
the relative roughness for
for laminar regime and,
when possible, also
for turbulent regime.

By default, pipe is assumed to be smooth,
relative roughness is eps = 0.
If eps > 0.05, eps is reset to eps = 0.05.

If turb = true is given and
both laminar and turbulent regimes are possible,
then f2Re returns the number of Reynolds
for turbulent regime alone.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
Re=f2Re(f[,eps[,fig]])
```

**Examples:**

Compute the Reynolds number Re given
the Darcy friction factor f = 0.028 and
the relative roughness eps = 0.001.
In this case, both laminar and turbulent
solutions are possible:

```julia
f=2.8e-2;eps=1e-3;
Re=f2Re(f,eps)
```

Compute Re and plot a schematic Moody diagram:

```julia
Re=f2Re(2.8e-2,1e-3,true)
```

### hDeps2fDRe

hDeps2fRe computes the Reynolds number and
the Darcy friction factor, given
the head loss,
the pipe's hydraulic diameter,
the pipe's length,
the pipe's relative roughness,
the fluid's density,
the fluid's dynamic viscosity, and
the gravitational acceleration.

By default, fluid is assumed to be water at 25 °C,
with density rho = 0.997 kg/L and
dynamic viscosity mu = 0.91 cP,
and gravitational acceleration is assumed to be
g = 9.81 m/s/s.

Please, notice that these default values are given
in the cgs unit system and, if taken,
all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
Re,f=hDeps2fRe(h,D,L,eps[,rho[,mu[,g[,fig]]]])
```

**Examples:**

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the pipe's hydraulic diameter D = 10 cm,
length L = 25 m and
relative roughness eps = 0.0027,
for water flow:

```julia
h=40;D=10;L=2.5e3;eps=2.7e-3; # inputs in cgs units
Re,f=hDeps2fRe(h,D,L,eps)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 kg/L and
dynamic viscosity mu = 0.89 cP:

```julia
h=40;D=10;L=2.5e3;eps=2.7e-3;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hDeps2fRe(h,D,L,eps,rho,mu)
```

Compute Re and f and plot a schematic Moody diagram:

```julia
Re,f=hDeps2fRe(0.40,0.10,25,2.7e-3,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```

### hveps2fDRe

hveps2fRe computes the Reynolds number and
the Darcy friction factor, given
the head loss,
the flow speed,
the pipe's length,
the pipe's relative roughness,
the fluid's density,
the fluid's dynamic viscosity, and
the gravitational acceleration.

By default, fluid is assumed to be water at 25 °C,
with density rho = 0.997 kg/L and
dynamic viscosity mu = 0.91 cP,
and gravitational acceleration is assumed to be
g = 9.81 m/s/s.

Please, notice that these default values are given
in the cgs unit system and, if taken,
all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
Re,f=hveps2fRe(h,v,L,eps[,rho[,mu[,g[,fig]]]])
```

**Examples:**

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the flow speed v = 1.1 m/s,
the pipe's length L = 25 m and
relative roughness eps = 0.0027,
for water flow:

```julia
h=40;v=1.1e2;L=2.5e3;eps=2.7e-3; # inputs in cgs units
Re,f=hveps2fRe(h,v,L,eps)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 kg/L and
dynamic viscosity mu = 0.89 cP:

```julia
h=40;v=1.1e2;L=2.5e3;eps=2.7e-3;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hveps2fRe(h,v,L,eps,rho,mu)
```

Compute Re and f and plot a schematic Moody diagram:

```julia
Re,f=hveps2fRe(0.40,1.1,25,2.7e-3,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```

### hQeps2fDRe

hQeps2fRe computes the Reynolds number and
the Darcy friction factor, given
the head loss,
the volumetric flow rate,
the pipe's length,
the pipe's relative roughness,
the fluid's density,
the fluid's dynamic viscosity, and
the gravitational acceleration.

By default, fluid is assumed to be water at 25 °C,
with density rho = 0.997 kg/L and
dynamic viscosity mu = 0.91 cP,
and gravitational acceleration is assumed to be
g = 9.81 m/s/s.

Please, notice that these default values are given
in the cgs unit system and, if taken,
all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
Re,f=hQeps2fRe(h,Q,L,eps[,rho[,mu[,g[,fig]]]])
```

**Examples:**

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the volumetric flow rate Q = 8.6 L/s,
the pipe's length L = 25 m and
relative roughness eps = 0.0027,
for water flow:

```julia
h=40;Q=8.6e3;L=2.5e3;eps=2.7e-3; # inputs in cgs units
Re,f=hQeps2fRe(h,Q,L,eps)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 kg/L and
dynamic viscosity mu = 0.89 cP:

```julia
h=40;Q=8.6e3;L=2.5e3;eps=2.7e-3;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hQeps2fRe(h,Q,L,eps,rho,mu)
```

Compute Re and f and plot a schematic Moody diagram:

```julia
Re,f=hQeps2fRe(0.40,8.6e-3,25,2.7e-3,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```

### hvthk2fDRe

hvthk2fRe computes the Reynolds number and
the Darcy friction factor, given
the head loss,
the flow speed,
the pipe's length,
the pipe's roughness,
the fluid's density,
the fluid's dynamic viscosity, and
the gravitational acceleration.

By default, fluid is assumed to be water at 25 °C,
with density rho = 0.997 kg/L and
dynamic viscosity mu = 0.91 cP,
and gravitational acceleration is assumed to be
g = 9.81 m/s/s.

Please, notice that these default values are given
in the cgs unit system and, if taken,
all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
Re,f=hvthk2fRe(h,v,L,thk[,rho[,mu[,g[,fig]]]])
```

**Examples:**

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the flow speed v = 1.1 m/s,
the pipe's length L = 25 m and
roughness thk = 0.27 mm,
for water flow:

```julia
h=40;v=1.1e2;L=2.5e3;thk=2.7e-2; # inputs in cgs units
Re,f=hvthk2fRe(h,v,L,thk)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 kg/L and
dynamic viscosity mu = 0.89 cP:

```julia
h=40;v=1.1e2;L=2.5e3;thk=2.7e-2;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hvthk2fRe(h,v,L,thk,rho,mu)
```

Compute Re and f and plot a schematic Moody diagram:

```julia
Re,f=hvthk2fRe(0.40,1.1,25,2.7e-4,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```

### hQthk2fDRe

hQthk2fRe computes the Reynolds number and
the Darcy friction factor, given
the head loss,
the volumetric flow rate,
the pipe's length,
the pipe's roughness,
the fluid's density,
the fluid's dynamic viscosity, and
the gravitational acceleration.

By default, fluid is assumed to be water at 25 °C,
with density rho = 0.997 kg/L and
dynamic viscosity mu = 0.91 cP,
and gravitational acceleration is assumed to be
g = 9.81 m/s/s.

Please, notice that these default values are given
in the cgs unit system and, if taken,
all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

**Syntax:**

```dotnetcli
Re,f=hQthk2fRe(h,Q,L,thk[,rho[,mu[,g[,fig]]]])
```

**Examples:**

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the volumetric flow rate Q = 8.6 L/s,
the pipe's length L = 25 m and
roughness thk = 0.27 mm
for water flow:

```julia
h=40;Q=8.6e3;L=2.5e3;thk=2.7e-2; # inputs in cgs units
Re,f=hQthk2fRe(h,Q,L,thk)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 kg/L and
dynamic viscosity mu = 0.89 cP:

```julia
h=40;Q=8.6e3;L=2.5e3;thk=2.7e-2;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hQthk2fRe(h,Q,L,thk,rho,mu)
```

Compute Re and f and plot a schematic Moody diagram:

```julia
Re,f=hQthk2fRe(0.40,8.6e-3,25,2.7e-4,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```

### See Also

[McCabeThiele.jl](https://github.com/aumpierre-unb/McCabeThiele.jl),
[PonchonSavarit.jl](https://github.com/aumpierre-unb/PonchonSavarit.jl).

Copyright &copy; 2022 Alexandre Umpierre

email: <aumpierre@gmail.com>
