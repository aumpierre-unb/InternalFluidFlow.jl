@doc raw"""
```
Re2f( # Darcy friction factor
    Re::Number; # Reynolds number
    ε::Number=0, # relative roughness
    fig::Bool=false # show plot
    )
```

`Re2f` computes the Darcy friction f factor given
the Reynolds number Re and
the relative roughness ε (default ε = 0).

By default, pipe is assumed to be smooth.
Relative roughness is reset to ε = 0.05, if ε > 0.05.

If parameter fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`Re2f` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `f2Re`, `h2fRe` and `doPlot`.

Examples
==========
Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness ε = 0.001:
```
f = Re2f(120e3, ε=1e-3)
```

Compute the Darcy friction factor f given
the Reynolds number Re = 120,000
for a smooth pipe and plot and
show results on a schematic Moody diagram:
```
Re2f(120e3, fig=true)
```
"""
function Re2f(
    Re::Number;
    ε::Number=0,
    fig::Bool=false
)
    if ε > 5e-2
        ε = 5e-2
    end
    if Re < 2.3e3
        f = 64 / Re
    else
        foo(f) = 1 / f^(1 / 2) + 2 * log10(ε / 3.7 + 2.51 / Re / f^(1 / 2))
        f = newtonraphson(foo, 1e-2, 1e-4)
    end
    if fig
        doPlot(ε)
        if !(Re < 2.3e3) && ε != 0
            turb(ε)
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
    f
end
