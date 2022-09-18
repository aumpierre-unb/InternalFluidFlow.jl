using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho[,fig=true])`

`hDeps2fRe` compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the pipe's hydraulic diameter D,
the pipe's length L,
the pipe's relative roughness eps,
the gravitational accelaration g,
the fluid's dynamic viscosity mu and
the fluid's density rho.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

See also: `Re2f`, `f2Re`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 40 cm,
the pipe's hydraulic diameter D = 10 cm,
length L = 2.5e3 cm and
relative roughness eps = 2.5e-3,
the gravitational acceleration g = 981 cm/s/s, and
the fluid's dynamic viscosity mu = 8.9e-3 g/cm/s and
density rho = 0.989 g/cc.
Compute Re and f:
```
    h=40;D=10;L=2.5e3;eps=2.5e-3;g=981;mu=8.9e-3;rho=0.989;
    Re,f=hDeps2fRe(h,D,L,eps,g,mu,rho)
```
Compute Re and f and plot a schematic Moody diagram:
```
    Re,f=hDeps2fRe(40,10,2.5e3,2.5e-3,981,8.9e-3,0.989,true)
```
"""
function hDeps2fRe(h, D, L, eps, g, mu, rho, fig=false)
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
