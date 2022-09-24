using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hDeps2fRe(h,D,L,eps[,rho[,mu[,g[,fig]]]])`

`hDeps2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the pipe's hydraulic diameter D,
the pipe's length L,
the pipe's relative roughness eps,
the fluid's density rho,
the fluid's dynamic viscosity mu, and
the gravitational accelaration g.

By default, fluid is assumed to be water at 25 °C,
rho = 0.997 (in g/cc) and
mu = 0.91 (in g/cm/s),
and gravitational acceleration is assumed to be
g = 981 (in cm/s/s).
Please, notice that these default values are given in the cgs unit system and,
if taken, all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

See also: `Re2f`, `f2Re`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.4 m,
the pipe's hydraulic diameter D = 10 cm,
length L = 25 m and
relative roughness eps = 0.0027,
for water flow:
```
h=40;Q=1e2;L=2.5e3;eps=2.7e-3; # inputs in cgs units
Re,f=hDeps2fRe(h,D,L,eps)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 g/cc and
dynamic viscosity mu = 0.0089 g/cm/s:
```
h=40;D=10;L=2.5e3;eps=2.7e-3;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hDeps2fRe(h,D,L,eps,rho,mu)
```
Compute Re and f and plot a schematic Moody diagram:
```
Re,f=hDeps2fRe(0.40,0.10,25,2.7e-3,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```
"""
function hDeps2fRe(h::Number, D::Number, L::Number, eps::Number, rho::Number=0.997, mu::Number=0.91, g::Number=981, fig::Bool=false)
    K = 2 * g * h * rho^2 * D^3 / mu^2 / L
    islam = true
    Re = K / 64
    f = 64 / Re
    if Re > 2.3e3
        islam = false
        Re = 1e4
        f = Re2f(Re, eps)
        while abs(f - K / Re^2) / f > 5e-3
            if f - K / Re^2 < 0
                Re = Re * 1.02
            else
                Re = Re * 0.98
                if Re < 2.3e3
                    islam = true
                    Re = K / 64
                    f = 64 / Re
                    break
                end
            end
            f = Re2f(Re, eps)
        end
    end
    if fig
        figure(eps)
        display(plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red))
        display(plot!([Re / 10; Re * 10], [K / (Re / 10)^2; K / (Re * 10)^2],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end
