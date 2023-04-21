include("hDeps2fRe.jl")
include("hveps2fRe.jl")
include("hvthk2fRe.jl")
include("hQeps2fRe.jl")
include("hQthk2fRe.jl")

@doc raw"""
`Re,f=hDeps2fRe(h::Number,D::Number,L::Number,eps::Number=0,rho::Number=0.997,mu::Number=0.0091,g::Number=981,fig::Bool=false)`

`hDeps2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the pipe's hydraulic diameter D,
the pipe's length L,
the pipe's relative roughness eps,
the fluid's density rho,
the fluid's dynamic viscosity mu, and
the gravitational accelaration g.

By default, pipe is assumed to be smooth, eps = 0.
Relative roughness eps is reset to eps = 0.05, if eps > 0.05.

By default, fluid is assumed to be water at 25 °C,
rho = 0.997 (in g/cc) and
mu = 0.0091 (in P),
and gravitational acceleration is assumed to be
g = 981 (in cm/s/s).
Please, notice that these default values are given in the cgs unit system and,
if taken, all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hDeps2fRe` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `f2Re`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the pipe's hydraulic diameter D = 10 cm,
length L = 25 m and
relative roughness eps = 0.0027,
for water flow:
```
h=40; # all inputs in cgs units
D=10;
L=2.5e3;
Re,f=hDeps2fRe(h,D,L,eps=2.7e-3)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 g/cc and
dynamic viscosity mu = 0.89 cP:
```
h=40; # all inputs in cgs units
D=10;
L=2.5e3;
Re,f=hDeps2fRe(h,D,L,eps=2.7e-3,rho=0.989,mu=8.9e-3)
```
Compute Re and f and plot a schematic Moody diagram:
```
# inputs in a consistent system of units
Re,f=hDeps2fRe(0.40,0.10,25,eps=2.7e-3,rho=989,mu=8.9e-4,g=9.81,fig=true)
```
"""
function h2fRe(h::Number, L::Number; D::Number=NaN, v::Number=NaN, Q::Number=NaN, eps::Number=NaN, thk::Number=NaN, rho::Number=0.997, mu::Number=0.0091, g::Number=981, fig::Bool=false)
    a = isnan.([D, v, Q]) .!= 1
    if sum(a) != 1
        error("""h2fRe demands that either 
            the hidraulic diameter, 
            the flow speed or 
            the flow rate
            be given.""")
    end
    b = isnan.([eps, thk]) .!= 1
    if sum(b) != 1
        error("""h2fRe demands that either 
            the pipe's rougness or 
            the pipe's relative roughness 
            be given.""")
    end

    if a == [1, 0, 0] && b == [1, 0]
        Re, f = hDeps2fRe(h, D, L, eps=eps, rho=rho, mu=mu, g=g, fig=fig)
    elseif a == [1, 0, 0] && b == [0, 1]
        Re, f = hDeps2fRe(h, D, L, eps=thk / D, rho=rho, mu=mu, g=g, fig=fig)
    elseif a == [0, 1, 0] && b == [1, 0]
        Re, f = hveps2fRe(h, v, L, eps=eps, rho=rho, mu=mu, g=g, fig=fig)
    elseif a == [0, 1, 0] && b == [0, 1]
        Re, f = hvthk2fRe(h, v, L, thk=yhk, rho=rho, mu=mu, g=g, fig=fig)
    elseif a == [0, 0, 1] && b == [1, 0]
        Re, f = hQeps2fRe(h, Q, L, eps=eps, rho=rho, mu=mu, g=g, fig=fig)
    elseif a == [0, 0, 1] && b == [0, 1]
        Re, f = hQthk2fRe(h, Q, L, thk=yhk, rho=rho, mu=mu, g=g, fig=fig)
    end
end
