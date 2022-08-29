## Using the InternalFluidFlow module for Julia:

### 1) Add the module

It requires module Pkg to be previously installed:

``julia> using Pkg``

``julia> Pkg.add("InternalFluidFlow")``

### 2) Load the module

``julia> using InternalFluidFlow``

### 3) Use the module

InternalFluidFlow has seven functions.

The first two are basic functions, to compute either

the Reynolds number *Re* or the Darcy friction factor *f*,

provided the other is given along with the relative roughness *eps*.

``julia> f=Re2f(Re,[eps[,s]])``

and

``julia> Re=f2Re(f,[eps[,s]])``

The other functions compute both

the Reynolds number *Re* and the Darcy friction factor *f*, given

the head loss *h*,

the pipe's length *L*,

the gravitational acceleration *g*,

the fluid's density *rho* and dynamic viscosity *mu*,

the pipe's roughness *thk* or relative roughness *eps*, and

the pipe's hydraulic diameter *D* or the speed flow *v* or the volumetric rate flow *Q*:

``julia> Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho[,s])``

``julia> Re,f=hveps2fRe(h,v,L,eps,g,mu,rho[,s])``

``julia> Re,f=hvthk2fRe(h,v,L,thk,g,mu,rho[,s])``

``julia> Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho[,s])``

``julia> Re,f=hQthk2fRe(h,Q,L,thk,g,mu,rho[,s])``
