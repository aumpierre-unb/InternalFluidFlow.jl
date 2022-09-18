using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hDeps2fRe(h,D,L,eps[,rho=0.997[,mu=9.1e-3[,g=981[,fig=true]]]])`

``hDeps2fRe`` compute the Reynolds number ``Re`` and
the Darcy friction factor ``f``, given
the head loss ``h``,
the pipe's hydraulic diameter ``D``,
the pipe's length ``L``,
the pipe's relative roughness ``eps``,
the fluid's density ``rho``,
the fluid's dynamic viscosity ``mu``, and
the gravitational accelaration ``g``.

If ``fig=true`` is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

See also: `Re2f`, `f2Re`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 g/cc and
dynamic viscosity mu = 8.9e-3 g/cm/s.

Compute Re and f:
```
    h=40;D=10;L=2.5e3;eps=2.5e-3;rho=0.989;mu=8.9e-3;
    Re,f=hDeps2fRe(h,D,L,eps,rho,mu)
```
Compute Re and f and plot a schematic Moody diagram:
```
    Re,f=hDeps2fRe(40,10,2.5e3,2.5e-3,0.997,9.1e-3,981,true)
```
"""
function hDeps2fRe(h::Float64, D::Float64, L::Float64, eps::Float64, rho::Float64=0.997, mu::Float64=0.91, g::Float64=981, fig::Bool=false)
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
