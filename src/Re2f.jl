using Plots
include("bissecao.jl")
include("figure.jl")

@doc raw"""
`f=Re2f(Re,[eps[,fig]])` computes
the Darcy friction f factor, given
the Reynolds number Re and
the relative roughness eps.

By default, pipe is assumed to be smooth, eps = 0.
If eps > 5e-2, eps is reset to eps = 5e-2.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

Example: Compute the Darcy friction factor f given
the Reynolds number Re = 1.2e5 and
the relative roughness eps = 1e-3.
This call computes f:
```
    Re=1.2e5;eps=1e-3;f=Re2f(Re,eps)
```
This call computes f and plots a schematic Moody diagram:
```
    f=Re2f(1.2e5,1e-3,true)
```

See also: f2Re, hDeps2fRe, hveps2fRe, hvthk2fRe, hQeps2fRe, hQthk2fRe
"""
function Re2f(Re, eps=0, fig=false)
    if eps > 5e-2
        eps = 5e-2
    end
    if Re < 2.3e3
        f = 64 / Re
    else
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re / sqrt(f))
        end
        f = bissecao(foo, 6e-3, 1e-1, 1e-4)
    end
    if fig
        figure(eps)
        display(plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red))
        display(plot!([Re; Re], [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return f
end
