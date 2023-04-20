using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hQthk2fRe(h::Number,Q::Number,L::Number,thk::Number=0,rho::Number=0.997,mu::Number=0.0091,g::Number=981,fig::Bool=false)`

`hQthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the volumetric flow rate Q,
the pipe's length L,
the pipe's roughness thk,
the fluid's density rho,
the fluid's dynamic viscosity mu, and
the gravitational accelaration g.

By default, pipe is assumed to be smooth,eps=0.
If eps > 0.05, eps is reset to eps=0.05.

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

`hQthk2fRe` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `f2Re`, `hDeps2fRe`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the volumetric flow rate Q = 8.6 L/s,
the pipe's length L = 25 m and
roughness thk = 0.27 mm
for water flow:
```
h=40; # all inputs in cgs units
Q=8.6e3;
L=2.5e3;
Re,f=hQthk2fRe(h,Q,L,thk=2.7e-2)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 g/cc and
dynamic viscosity mu = 0.89 cP:
```
h=40; # all inputs in cgs units
Q=8.6e3;
L=2.5e3;
Re,f=hQthk2fRe(h,Q,L,thk=2.7e-2,rho=0.989,mu=8.9e-3)
```
Compute Re and f and plot a schematic Moody diagram:
```
Re,f=hQthk2fRe(0.40,8.6e-3,25,thk=2.7e-4,rho=989,mu=8.9e-4,g=9.81,fig=true) # inputs in a consistent system of units
```
"""
function hQthk2fRe(h::Number, Q::Number, L::Number; thk::Number=0, rho::Number=0.997, mu::Number=0.0091, g::Number=981, fig::Bool=false)
    if thk > 5e-2
        thk = 5e-2
    end
    P = 2 * g * h * Q^3 / (pi / 4)^3 / (mu / rho)^5 / L
    foo(f) = 1 / f^(1 / 2) + 2 * log10(
        thk / (rho * Q / (pi / 4) / mu / ((P / f)^(1 / 5)))
        /
        3.7 + 2.51 / (P / f)^(1 / 5) / f^(1 / 2))
    f = newtonraphson(foo, 1e-2, 1e-4)
    Re = (P / f)^(1 / 5)
    if Re > 2.3e3
        islam = false
    else
        Re = (P / 64)^(1 / 4)
        f = 64 / Re
        islam = true
    end
    D = rho * Q / Re / mu / (pi / 4)
    eps = thk / D
    if fig
        figure(eps)
        if !(Re < 2.3e3)
            turb(eps)
        end
        plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!(
            (P ./ [6e-3; 1e-1]) .^ (1 / 5),
            [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return Re, f
end
