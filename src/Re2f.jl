@doc raw"""
```
Re2f(; # Darcy friction factor
    Re::Number, # Reynolds number
    ε::Number=0, # relative roughness
    fig::Bool=false, # default hide plot
    lam::Bool=true, # check on laminar flow bounds
    turb::Bool=true, # check on turbulent flow bounds
    msgs::Bool=true # show warning message
    )
```

`Re2f` computes the Darcy friction f factor given
the Reynolds number Re and
the relative roughness ε.

By default, pipe is assumed to be smooth (ε = 0).
If ε > 0.05, relative roughness is reset to upper limit ε = 0.05.

If fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

If lam = false is given
then `Re2f` disregards the laminar flow bounds (Re < 4e3).

If turb = false is given
then `Re2f` disregards the turbulent flow bounds (Re > 2.3e3).

`Re2f` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `f2Re`, `h2fRe` and `doPlot`.

Examples
==========
Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness ε = 3e-3.
```
julia> Re2f( # Darcy friction factor
       Re=120e3, # Reynolds number
       ε=3e-3 # relative roughness
       )
InternalFluidFlow.Moody(120000.0, 0.02726577561075442, 0.003)
```

Compute the Darcy friction factor f given
the Reynolds number Re = 120,000 and
the relative roughness ε = 6e-2.
In this case, relative roughness is reassigned to ε = 5e-2 for turbulent flow.
```
julia> Re2f( # Darcy friction factor
       Re=120e3, # Reynolds number
       ε=6e-2 # relative roughness
       )
Be aware that ε was reassigned to 5e-2.
InternalFluidFlow.Moody(120000.0, 0.07174263668795722, 0.05)
```

Compute the Darcy friction factor f given
the Reynolds number Re = 3,500 and
the relative roughness ε = 6e-3 and
show results on a schematic Moody diagram.
```
julia> Re2f( # Darcy friction factor
       Re=3500, # Reynolds number
       ε=6e-3, # relative roughness
       fig=true # show plot
       )
Be aware that laminar flow bounds extends up to Re = 4e3.
(InternalFluidFlow.Moody(3500.0, 0.018285714285714287, 0.006), InternalFluidFlow.Moody(3500.0, 0.04696863298595428, 0.006))
```
"""
function Re2f(;
    Re::Number,
    ε::Number=0,
    fig::Bool=false,
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true
)
    if lam
        if Re < 4e3
            if msgs && Re > 2.3e3
                printstyled(
                    "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                    color=:magenta)
            end
            f = 64 / Re
            lam = true
            moody_lam = Moody(Re, f, ε)
        else
            lam = false
        end
    end

    if turb
        if Re > 2.3e3
            ε_turb = ε
            if ε_turb > 5e-2
                ε_turb = 5e-2
                if msgs
                    printstyled(
                        "Be aware that pipe roughness for turbulent flow is reassigned to ε = 5e-2.\n",
                        color=:cyan)
                end
            end
            foo(f) = 1 / f^(1 / 2) + 2 * log10(ε_turb / 3.7 + 2.51 / Re / f^(1 / 2))
            f = newtonraphson(foo, 1e-2, 1e-4)
            turb = true
            moody_turb = Moody(Re, f, ε_turb)
        else
            turb = false
        end
    end

    if fig
        if turb
            doPlot(ε_turb)
        else
            doPlot()
        end
        if turb
            plot!(
                [moody_turb.Re],
                [moody_turb.f],
                seriestype=:scatter,
                markerstrokecolor=:red,
                color=:red
            )
        end
        if lam
            plot!(
                [moody_lam.Re],
                [moody_lam.f],
                seriestype=:scatter,
                markerstrokecolor=:red,
                color=:red
            )
        end
        plot!(
            [Re, Re],
            [6e-3, 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash
        )
        display(plot!())
    end

    if lam && turb
        moody_lam, moody_turb
    elseif lam
        moody_lam
    elseif turb
        moody_turb
    end
end
