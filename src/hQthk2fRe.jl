using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hQthk2fRe(h,Q,L,thk[,rho=0.997[,mu=9.1e-3[,g=981[,fig=true]]]])`

``hQthk2fRe`` compute the Reynolds number ``Re`` and
the Darcy friction factor ``f``, given
the head loss ``h``,
the volumetric flow rate ``Q``,
the pipe's length ``L``,
the pipe's roughness ``thk``,
the fluid's density ``rho``,
the fluid's dynamic viscosity ``mu``, and
the gravitational accelaration ``g``.

If ``fig=true`` is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

See also: `Re2f`, `f2Re`, `hDeps2fRe`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 40 cm,
the volumetric flow rate Q = 8.6e3 cc/s,
the pipe's length L = 2.5e3 cm and
roughness thk = 2.5e-2 cm,
for water flow.

Compute Re and f:
```
    h=40;Q=1e2;L=2.5e3;thk=2.5e-2;
    Re,f=hQthk2fRe(h,Q,L,thk)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 g/cc and
dynamic viscosity mu = 8.9e-3 g/cm/s.

Compute Re and f:
```
    h=40;Q=8.6e3;L=2.5e3;thk=2.5e-2;rho=0.989;mu=8.9e-3;
    Re,f=hQthk2fRe(h,Q,L,thk,rho,mu)
```
Compute Re and f and plot a schematic Moody diagram:
```
    Re,f=hQthk2fRe(40,8.6e3,2.5e3,2.5e-2,0.997,9.1e-3,981,true)
```
"""
function hQthk2fRe(h::Float64, Q::Float64, L::Float64, thk::Float64, rho::Float64=0.997, mu::Float64=0.91, g::Float64==981, fig::Bool=false)
    P = 2 * g * h * Q^3 / (pi / 4)^3 / (mu / rho)^5 / L
    Re = (P / 64)^(1 / 4)
    f = 64 / Re
    if Re > 2.3e3
        Re = 1e4
        f = P / Re^5
        D = rho * Q / Re / mu / (pi / 4)
        eps = thk / D
        f = Re2f(Re, eps)
        while abs(f - P / Re^5) / f > 5e-3
            if f - P / Re^5 < 0
                Re = Re * 1.02
            else
                Re = Re * 0.98
                if Re < 2.3e3
                    Re = (P / 64)^(1 / 4)
                    f = 64 / Re
                    break
                end
            end
            f = P / Re^5
            D = rho * Q / Re / mu / (pi / 4)
            eps = thk / D
            f = Re2f(Re, eps)
        end
    end
    if fig
        figure(eps)
        display(plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red))
        display(plot!([Re / 10; Re * 10], [P / (Re / 10)^5; P / (Re * 10)^5],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end
