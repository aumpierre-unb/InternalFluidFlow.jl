## Add InternalFluidFlow module:

### 1) Add the module

It requires module Pkg to be previously installed:

``julia> using Pkg``

``julia> Pkg.add("InternalFluidFlow")``

### 2) Load the module

``julia> using InternalFluidFlow``

### 3) Use the module

InternalFluidFlow has seven functions:

``julia> f=Re2f(Re,[eps[,s]])``

``julia> Re=f2Re(f,[eps[,s]])``

``julia> Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho[,s])``

``julia> Re,f=hveps2fRe(h,v,L,eps,g,mu,rho[,s])``

``julia> Re,f=hvthk2fRe(h,v,L,thk,g,mu,rho[,s])``

``julia> Re,f=hQeps2fRe(h,Q,L,eps,g,mu,rho[,s])``

``julia> Re,f=hQthk2fRe(h,Q,L,thk,g,mu,rho[,s])``

