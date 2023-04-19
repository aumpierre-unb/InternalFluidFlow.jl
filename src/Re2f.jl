using Plots
include("newtonraphson.jl")
include("figure.jl")

@doc raw"""
`f=Re2f(Re,[eps[,fig]])`

`Re2f` computes the Darcy friction f factor, given
the Reynolds number Re and
the relative roughness eps.

By default, pipe is assumed to be smooth, eps = 0.
If eps > 0.05, eps is reset to eps = 0.05.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`Re2f` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `f2Re`, `hDeps2fRe`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness eps = 0.001:
```
Re=1.2e5;eps=1e-3;
f=Re2f(Re;eps=1e-3)
```
Compute f and plot a schematic Moody diagram:
```
f=Re2f(1.2e5;eps=1e-3,fig=true)
```
"""
function Re2f(Re::Number, eps::Number=0, fig::Bool=false)
    if eps > 5e-2
        eps = 5e-2
    end
    if Re < 2.3e3
        f = 64 / Re
    else
        foo(f) = 1 / f^(1 / 2) + 2 * log10(eps / 3.7 + 2.51 / Re / f^(1 / 2))
        f = newtonraphson(foo, 1e-2, 1e-4)
    end
    if fig
        figure(eps)
        if !(Re < 2.3e3)
            turb(eps)
        end
        plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!([Re; Re], [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return f
end
