## Using the Internal Fluid Flow module for Julia:

### 1) Add the module

It requires module Pkg to be previously installed:

``julia> using Pkg``

``julia> Pkg.add("InternalFluidFlow")``

### 2) Load the module

``julia> using InternalFluidFlow``

### 3) Use the module

The internal Fluid Flow module has seven functions.

All functions have an optional input argument with

default value *false*. If it is given as *true*,

a schematic Moody diagram is plot with the computed solution.

The first two are basic functions, to compute either

the Reynolds number *Re* or the Darcy friction factor *f*,

provided the other is given along with the relative roughness *eps*.

``julia> f=Re2f(Re,[eps[,fig]])``

``julia> Re=f2Re(f,[eps[,fig]])``

The other five functions compute both

the Reynolds number *Re* and the Darcy friction factor *f*, given

the head loss *h*,

the pipe's length *L*,

the gravitational acceleration *g*,

the fluid's density *rho* and dynamic viscosity *mu*,

the pipe's roughness *thk* or relative roughness *eps*, and

the pipe's hydraulic diameter *D* or the speed flow *v* or the volumetric rate flow *Q*:

``julia> Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho[,fig])``

``julia> Re,f=hveps2fRe(h,v,L,eps,g,mu,rho[,fig])``

``julia> Re,f=hvthk2fRe(h,v,L,thk,g,mu,rho[,fig])``

``julia> Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho[,fig])``

``julia> Re,f=hQthk2fRe(h,Q,L,thk,g,mu,rho[,fig])``

For further details on syntax, check on the functions descriptions. *e.g.*, for the description of function hQthk2fRe, type

``julia> hQthk2fRe``