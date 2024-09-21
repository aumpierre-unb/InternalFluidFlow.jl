@doc raw"""
```
f2Re(; # Reynolds number
    f::Number, # Darcy friction factor
    ε::Number=0, # relative roughness, default is smooth pipe
    lam::Bool=true, # default is search within laminar bounds
    turb::Bool=true, # default is search within turbulent bounds
    msgs::Bool=true, # default is show warning messages
    fig::Bool=false # default is hide plot
    )
```

`f2Re` computes the Reynolds number Re given
the Darcy friction factor f and
the relative roughness ε
for both laminar and turbulent regime, if possible.

`f2Re` returns solutions found both
within laminar (Re < 4e3) and
within turbulent (Re < 2.3e3) bounds.

Pipe is assumed to be smooth (default is ε = 0).
The upper limit for relative roughness is ε = 0.05.
If given relative roughness ε > 0.05 is out of bounds then
relative roughness is reassigned to ε = 0.05 for tubulent flow.
Unless msgs = false is given, user will noticed.

If lam = false is given
then `f2Re` disregards the laminar flow bounds (Re < 4e3).

If turb = false is given
then `f2Re` disregards the turbulent flow bounds (Re > 2.3e3).

It is possible that no solution be found
neither within laminar nor within turbulent bounds (see on examples).
Unless msgs = false is given, user will noticed.

If fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`f2Re` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `h2fRe` and `doPlot`.

Examples
==========
Compute the Reynolds number Re given
the Darcy friction factor f = 2.8e-2 and
the pipe relative roughness ε = 5e-3.
In this case, only laminar
solution is possible:
```
julia> f2Re( # Reynolds number
       f=2.8e-2, # Darcy friction factor
       ε=5e-3 # relative roughness
       )
InternalFluidFlow.Moody(2285.714285714286, 0.028, 0.005)
```

Compute the Reynolds number Re given
the Darcy friction factor f = 1.8e-2 and
the pipe relative roughness ε = 5e-3.
In this case, only turbulent
solution is possible:
```
julia> f2Re( # Reynolds number
       f=1.8e-2, # Darcy friction factor
       ε=5e-3 # relative roughness
       )
Be aware that laminar flow bounds extends up to Re = 4e3.
InternalFluidFlow.Moody(3555.5555555555557, 0.018, 0.005)
```

Compute the Reynolds number Re given
the Darcy friction factor f = 1.2e-2 and
the pipe relative roughness ε = 9e-3.
In this case, both laminar and turbulent
solutions are impossible:
```
julia> f2Re( # Reynolds number
       f=1.2e-2, # Darcy friction factor
       ε=9e-3 # relative roughness
       )
There is no solution within laminar bounds (Re < 4e3) or within turbulent bounds (Re < 2.3e3).
```

Compute the Reynolds number Re given
the Darcy friction factor f = 0.028
for a smooth pipe and plot and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible:
```
julia> f2Re( # Reynolds number
       f=0.028, # Darcy friction factor
       fig=true # show plot
       )
(InternalFluidFlow.Moody(2285.714285714286, 0.028, 0.0), InternalFluidFlow.Moody(14593.727381591969, 0.028, 0.0))
```
"""
function f2Re(;
    f::Number,
    ε::Number=0,
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true,
    fig::Bool=false
)
    if lam
        Re = 64 / f
        if Re < 4e3
            moody_lam = Moody(Re, f, ε)
            if msgs && Re > 2.3e3
                printstyled(
                    "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                    color=:magenta)
            end
        else
            lam = false
        end
    end

    if turb
        ε_turb = ε
        if ε_turb > 5e-2
            ε_turb = 5e-2
            ε_reassign = true
        else
            ε_reassign = false
        end
        if f > (2 * log10(3.7 / ε_turb))^-2
            Re = 2.51 / (10^(1 / f^(1 / 2) / -2) - ε_turb / 3.7) / f^(1 / 2)
            if Re > 2.3e3
                moody_turb = Moody(Re, f, ε_turb)
                if msgs && ε_reassign
                    printstyled(
                        "Be aware that pipe roughness for turbulent flow is reassigned to ε = 5e-2.\n",
                        color=:cyan)
                end
            else
                turb = false
            end
        else
            turb = false
        end
    end

    if !lam && !turb
        if msgs
            printstyled(
                "There is no solution within laminar bounds (Re < 4e3) or within turbulent bounds (Re < 2.3e3).\n",
                color=:red)
        end
    end

    if fig
        doPlot(ε_turb)
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
            [1e2, 1e8],
            [f, f],
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
