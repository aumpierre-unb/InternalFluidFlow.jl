# InternalFluidFlow.jl

[![DOI](https://zenodo.org/badge/524550191.svg)](https://zenodo.org/badge/latestdoi/524550191)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![version](https://juliahub.com/docs/InternalFluidFlow/version.svg)](https://juliahub.com/ui/Packages/InternalFluidFlow/zGZKl)

## Installing and Loading InternalFluidFlow

InternalFluidFlow can be installed and loaded either
from the JuliaHub repository (last released version) or from the <a href="https://github.com/aumpierre-unb/InternalFluidFlow.jl">maintainer's repository</a> (under construction pre-release alpha version).

### Last Released Version of InternalFluidFlow

The last version of InternalFluidFlow can be installed from JuliaHub repository:

```julia
julia> using Pkg
julia> Pkg.add("InternalFluidFlow")
julia> using InternalFluidFlow
```

If InternalFluidFlow is already installed, it can be updated:

```julia
julia> using Pkg
julia> Pkg.update("InternalFluidFlow")
julia> using InternalFluidFlow
```

### Pre-Release Alpha Version (Under Construction)

The next version (under construction) of InternalFluidFlow can be installed from the <a href="https://github.com/aumpierre-unb/InternalFluidFlow.jl">maintainer's repository</a>.

```julia
(@v1.8) pkg> add("https://github.com/aumpierre-unb/InternalFluidFlow.jl")
julia> using InternalFluidFlow
```

## Citation of InternalFluidFlow

You can cite all versions (both released and pre-released), by using the
<a href="https://doi.org/10.5281/zenodo.7019888">DOI 10.5281/zenodo.7019888</a>.
This DOI represents all versions, and will always resolve to the latest one.

For citation of the last released version of InternalFluidFlow, please check CITATION file in the <a href="https://github.com/aumpierre-unb/InternalFluidFlow.jl">maintainer's repository</a>.

<!--
## The Theory for InternalFluidFlow

The following is a very short introduction to the steady internal flow of an incompressible and inviscid fluid and to the Internal Fluid Flow module for Julia.

Our focus here is a small set of equations that described the phenomenon and are required to solve problems on internal fluid flow. Internal flow is a pretty extensive topic in fluid mechanics and there are a lot of important and interesting observations related to it that are not taken into account in this text, because they have no direct impact the computation performed by the functions in this module.

This text is divided in two main sections: The Theory and The InternalFluidFlow Module for Julia.

### The Bernoulli Equation

The Bernoulli equation is an expression of the mechanical energy balance for a very particular situation:

- internal steady flow of an
- incompressible inviscid fluid, where
- friction effects and tube fittings can be neglected.

For such a case, the mechanical energy is conserved, and for any two points 1 and 2 we have

$\displaystyle {\rho v_2^2 \over 2} + \rho g z_2 + p_2 =
{\rho v_1^2 \over 2} + \rho g z_1 + p_1$

or

$\displaystyle {v_2^2 \over 2g}+z_2+{p_2 \over \rho g}=
{v_1^2 \over 2g}+z_1+{p_1 \over \rho g}$

where

- $\rho$ is the fluid's density,
- *v* is the flow speed,
- *g* is the gravitational acceleration,
- *z* is the elevation, and
- *p* is the static pressure.

### Head Loss

The flow of viscous fluids is accompanied of energy dispersion, which can be measured as pressure drop or, equivalently, as head loss *h*, by the Darcy-Weisbach equation,

$\displaystyle h=f{v^2 \over 2g} {L \over D}$

where *f* is the Darcy friction factor, *L* is the pipe's length and *D* is the pipe's hydraulic diameter,

$\displaystyle D={4A \over P}$

where *A* is the cross-sectional area of the flow and *P* is the wet perimeter of the cross-section. *f* is described as a function of the Reynolds number,

$\displaystyle Re={\rho vg \over \mu}$

and the pipe's relative roughness,

$\displaystyle \varepsilon={k \over D}$

where

- $\mu$ is the fluid's dynamic viscosity and
- *k* is the pipe's[ internal surface] roughness.

The Reynolds number *Re*, the Darcy friction factor *f*, and the relative roughness $\varepsilon$ completely describe the internal flow of incompressible viscous fluids, for both laminar and turbulent regimes. Usually, *f* is given as a function of *Re* and $\varepsilon$.

The simplest problems on internal fluid flow consist on computing one of them given the two other. More complex situations arise when only one or none of those variables is known. Instead, dimensional variables involved are given. However not always, in most cases iterative computation is required.

### Laminar Flow and Turbulent Flow

For laminar flow, *Re* < 2.5e3 (typically), the Darcy friction factor is given by the Poiseuille condition,

$\displaystyle f={64 \over Re}$

For turbulent flow, *Re* > 2.5e3 (typically), the Darcy friction factor is given implicitly by the Colebrook-White equation,

$\displaystyle {1 \over \sqrt{f}}=2 \mathrm{log} {1 \over\displaystyle {3.7 \over \varepsilon} + {2.51 \over {Re \sqrt{f}}}}$
-->

## The InternalFluidFlow Module for Julia

This package provides a set of functions designed to solve problems of internal fluid flow. All functions are based on the Poiseuille condition for laminar flow, the Colebrook-White equation for turbulent flow, and the Darcy-Weisbach equation for head loss. The simplest problems on internal flow consist in computing either the Reynolds number or the Darcy friction factor given the other and the relative roughness. For those cases, this package provides functions f2Re and Re2f, respectively. More elaborated problems consist in computing both the Reynolds number and the Darcy friction factor given the head loss, the tube length, the fluid's density and dynamic viscosity, the gravitational acceleration, the relative roughness and either the dynamic diameter or the flow speed or the volumetric flow. For those cases, this package provides functions hDeps2fRe, hveps2fRe and hQeps2fRe, respectively. A slightly more elaborate situation arises when roughness is given instead of relative roughness along with the flow speed or the volumetric flow. For those cases, this package provides functions hvthk2fRe and hQthk2fRe, respectively. All function in this package offer the option of plotting the solution on a schematic Moody diagram.

Internal Fluid Flow Module provides the following functions:

- Re2f
- f2Re
- hDeps2fDRe
- hveps2fDRe
- hQeps2fDRe
- hvthk2fDRe
- hQthk2fDRe

### Re2f

Re2f computes the Darcy friction factor *f* given the relative roughness $\varepsilon$ and the Reynolds number *Re*. If given *Re*<2.5e3, then flow is assumed to be laminar and *f* is computed using of the Poiseuille condition. Otherwise, flow is assumed to be turbulent and *f* is computed using the Colebrook-White equation.

**Syntax:**

```julia
f=Re2f(Re,[eps[,fig]])
```

*e.g.* this call computes *f* and shows no plot:

```julia
julia> Re=1.2e5;eps=2e-3;
julia> f=Re2f(Re,eps)
```

*e.g.* this call computes *f* for the default condition of smooth tube, $\varepsilon$=0, and plots a schematic Moody diagram with the solution:

```julia
julia> f=Re2f(1.2e5,:,true)
```

*e.g.* this call computes *f* and plots a schematic Moody diagram with the solution:

```julia
julia> f=Re2f(1.2e5,2e-3,true)
```

### f2Re

espfD2Re computes the Reynolds number *Re* given the relative roughness $\varepsilon$ and the Darcy friction factor *f*. Depending on the inputs, solution may be laminar or turbulent flow, or either for smooth pipes with higher friction, or none for lower friction and rough pipes. If the Poiseuille condition produces *Re*<2.5e3, laminar solution is accepted.

<!--
If given *f* is possible for turbulent flow,

$\displaystyle {1 \over \sqrt f} < 2 \mathrm{log} {1 \over\displaystyle {3.7 \over \varepsilon}}$

(which is Colebrook-White equation for for elevated *Re*) the turbulent solution is accepted. If both solutions are accepted, espfD2Re returns both answers. If neither laminar or turbulent solutions are accepted, espfD2Re returns an empty matrix. If given $\varepsilon$>0.05, execution is aborted.
-->

**Syntax:**

```julia
Re=f2Re(f,[eps[,fig]])
```

*e.g.* this call computes *Re* for both laminar and turbulent regimes (if possible) and shows no plot:

```julia
julia> f=2.5e-2;eps=2e-3;
julia> Re=f2Re(f,eps)
```

*e.g.* this call computes *Re* for the default condition of smooth tube, $\varepsilon$=0, for both laminar and turbulent regimes (if possible) and plots a schematic Moody diagram with the solution:

```julia
julia> Re=f2Re(2.5e-2,:,true)
```

*e.g.* this call computes *Re* for both laminar and turbulent regimes (if possible) and plots a schematic Moody diagram with the solution:

```julia
julia> Re=f2Re(2.5e-2,2e-3,true)
```

### hDeps2fDRe

hDeps2fDRe computes both the Darcy friction factor *f* and the Reynolds number *Re* given the head loss *h*, the pipe's length *L*, relative roughness $\varepsilon$ and hydraulic diameter *D*, the gravitational acceleration *g*, and the fluid's density $\rho$ and dynamic viscosity $\mu$.

<!--
Replacing speed flow *v* in the Darcy-Weisbach equation by the Reynolds number *Re*,

$\displaystyle Re^2 f={2gh\rho^2D^3 \over {\mu^2 L}}$

Along with the Colebrook-White equation, this version of the Darcy-Weisbach equation produces a system of two equations with two variables. Solution is computed iteratively, however an analytic solution is possible in this case.
-->

**Syntax:**

```julia
Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho[,fig])
```

*e.g.* this call computes *Re* and *f* and shows no plot:

```julia
julia> h=40;D=10;L=2.5e3;eps=2.5e-3;g=981;mu=8.9e-3;rho=0.989;
julia> thk=eps*D
julia> Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho)
julia> v=Re*mu/rho/D
julia> Q=v*(pi/4*D^2)
```

*e.g.* this call computes *Re* and *f* and plots a schematic Moody diagram with the solution:

```julia
julia> Re,f=hDeps2fRe(40,10,2.5e3,2.5e3,981,8.9e-3,0.989,true)
```

### hveps2fDRe

hveps2fDRe computes both the Darcy friction factor *f* and the Reynolds number *Re* given the head loss *h*, the pipe's length *L* and relative roughness $\varepsilon$, the speed flow *v*, the gravitational acceleration *g*, and the fluid's density $\rho$ and dynamic viscosity $\mu$.

<!--
Replacing hydraulic diameter *D* in the Darcy-Weisbach equation by the Reynolds number *Re*,

$\displaystyle {f \over Re}={2gh\mu \over {v^3\rho L}}$

Along with the Colebrook-White equation, this version of the Darcy-Weisbach equation produces a system of two equations with two variables. Solution is computed iteratively.
-->

**Syntax:**

```julia
Re,f=hveps2fRe(h,v,L,eps,g,mu,rho[,fig])
```

*e.g.* this call computes *Re* and *f* and shows no plot:

```julia
julia> h=40;v=1.1e2;L=2.5e3;eps=2.5e3;g=981;mu=8.9e-3;rho=0.989;
julia> Re,f=hveps2fRe(h,v,L,eps,g,mu,rho)
julia> D=Re*mu/rho/v
julia> thk=eps*D
julia> Q=v*(pi/4*D^2)
```

*e.g.* this call computes *Re* and *f* and plots a schematic Moody diagram with the solution:

```julia
julia> Re,f=hveps2fRe(40,1.1e2,2.5e3,2.5e3,981,8.9e-3,0.989,true)
```

### hQeps2fDRe

hQeps2fDRe computes both the Darcy friction factor *f* and the Reynolds number *Re* given the head loss *h*, the pipe's length *L* and relative roughness $\varepsilon$, the volumetric flow rate *Q*, the gravitational acceleration *g*, and the fluid's density $\rho$ and dynamic viscosity $\mu$.

<!--
Replacing hydraulic diameter *D* in the Darcy-Weisbach equation by the Reynolds number *Re*,

$\displaystyle {Re^5 f}={2ghQ^3 \over\displaystyle {{\left[ {\pi \over 4} \right]}^3 {\left[ {\mu \over \rho} \right]}^5 L}}$

Along with the Colebrook-White equation, this version of the Darcy-Weisbach equation produces a system of two equations with two variables. Solution is computed iteratively.
-->

**Syntax:**

```julia
Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho[,fig])
```

*e.g.* this call computes *Re* and *f* and shows no plot:

```julia
julia> h=40;Q=8.6e3;L=2.5e3;eps=2.5e3;g=981;mu=8.9e-3;rho=0.989;
julia> Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho)
julia> D=Q*rho/(pi/4)/Re/mu
julia> thk=eps*D
julia> v=Q/(pi/4*D^2)
```

*e.g.* this call computes *Re* and *f* and plots a schematic Moody diagram with the solution:

```julia
julia> Re,f=hQeps2fRe(40,8.6e3,2.5e3,2.5e3,981,8.9e-3,0.989,true)
```

### hvthk2fDRe

hvthk2fDRe computes both the Darcy friction factor *f* and the Reynolds number *Re* given the head loss *h*, the pipe's length *L* and roughness *k*, the speed flow *v*, the gravitational acceleration *g*, and the fluid's density $\rho$ and dynamic viscosity $\mu$.

<!--
Replacing hydraulic diameter *D* in the Darcy-Weisbach equation by the Reynolds number *Re*,

$\displaystyle {f \over Re}={2gh\mu \over {v^3\rho L}}$

Along with the Colebrook-White equation, this version of the Darcy-Weisbach equation produces a system of two equations with two variables. Solution is computed iteratively.
-->

**Syntax:**

```julia
Re,f=hvthk2fRe(h,v,L,thk,g,mu,rho[,fig])
```

*e.g.* this call computes *Re* and *f* and shows no plot:

```julia
julia> h=40;v=1.1e2;L=2.5e3;thk=0.025;g=981;mu=8.9e-3;rho=0.989;
julia> Re,f=hvthk2fRe(h,v,L,thk,g,mu,rho)
julia> D=Re*mu/rho/v
julia> eps=thk/D
julia> Q=v*(pi/4*D^2)
```

*e.g.* this call computes *Re* and *f* and plots a schematic Moody diagram with the solution:

```julia
julia> Re,f=hvthk2fRe(40,1.1e2,2.5e3,0.025,981,8.9e-3,0.989,true)
```

### hQthk2fDRe

hQthk2fDRe computes both the Darcy friction factor *f* and the Reynolds number *Re* given the head loss *h*, the pipe's length *L* and roughness *k*, the volumetric flow rate *Q*, the gravitational acceleration *g*, and the fluid's density $\rho$ and dynamic viscosity $\mu$.

<!--
Replacing hydraulic diameter *D* in the Darcy-Weisbach equation by the Reynolds number *Re*,

$\displaystyle {Re^5 f}={2ghQ^3 \over\displaystyle {{\left[ {\pi \over 4} \right]}^3 {\left[ {\mu \over \rho} \right]}^5 L}}$

Along with the Colebrook-White equation, this version of the Darcy-Weisbach equation produces a system of two equations with two variables. Solution is computed iteratively.
-->

**Syntax:**

```julia
Re,f=hQthk2fRe(h,Q,L,thk,g,mu,rho[,fig])
```

*e.g.* this call computes *Re* and *f* and shows no plot:

```julia
julia> h=40;Q=8.6e3;L=2.5e3;thk=0.025;g=981;mu=8.9e-3;rho=0.989;
julia> Re,f=hQthk2fRe(h,Q,L,thk,g,mu,rho)
julia> D=Q*rho/(pi/4)/Re/mu
julia> eps=thk/D
julia> v=Q/(pi/4*D^2)
```

*e.g.* this call computes *Re* and *f* and plots a schematic Moody diagram with the solution:

```julia
julia> Re,f=hQthk2fRe(40,8.6e3,2.5e3,0.025,981,8.9e-3,0.989,true)
```

Copyright &copy; 2022 Alexandre Umpierre

email: <aumpierre@gmail.com>
