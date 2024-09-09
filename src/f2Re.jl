@doc raw"""
```
f2Re(; # Reynolds number
    f::Number, # Darcy friction factor
    ε::Number=0, # relative roughness, default is smooth pipe
    fig::Bool=false, # default hide plot
    turbulent::Bool=false # default disregard turbulent flow
    )
```

`f2Re` computes the Reynolds number Re given
the Darcy friction factor f and
the relative roughness ε (default ε = 0)
for both laminar and turbulent regime, if possible.

By default, pipe is assumed to be smooth.
Relative roughness is reset to ε = 0.05, if ε > 0.05.

If parameter fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

If parameter turbulent = true is given and
both laminar and turbulent regimes are possible,
then `f2Re` returns the number of Reynolds
for turbulent regime alone.

`f2Re` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `h2fRe` and `doPlot`.

Examples
==========
Compute the Reynolds number Re given
the Darcy friction factor f = 0.028 and
the pipe relative roughness ε = 2e-3.
In this case, both laminar and turbulent
solutions are possible:
```
julia> f2Re( # Reynolds number
       f=2.8e-2, # Darcy friction factor
       ε=2e-3 # relative roughness
       )
(InternalFluidFlow.Moody(2285.714285714286, 0.028, 0.002), InternalFluidFlow.Moody(30781.694891269137, 0.028, 0.002))
```

Compute the Reynolds number Re given
the Darcy friction factor f = 0.028
for a smooth pipe and plot and
show results on a schematic Moody diagram:
```
julia> f2Re( # Reynolds number
       f=2.8e-2, # Darcy friction factor
       fig=true # show plot
       )
(InternalFluidFlow.Moody(2285.714285714286, 0.028, 0.0), InternalFluidFlow.Moody(14593.727381591969, 0.028, 0.0))
```
"""
function f2Re(;
    f::Number,
    ε::Number=0,
    fig::Bool=false,
    turbulent::Bool=false,
    msgs::Bool=true
)
    if ε > 5e-2
        ε = 5e-2
        if msgs
            printstyled(
                "Beware that ε was reassigned to 5e-2.\n",
                color=:cyan)
        end
    end
    Re::Vector{Float64} = []
    if f > (2 * log10(3.7 / ε))^-2
        Re_ = 2.51 / (10^(1 / f^(1 / 2) / -2) - ε / 3.7) / f^(1 / 2)
        if Re_ > 2.3e3
            Re = push!(Re, Re_)
        end
        turbOK = true
    else
        turbOK = false
    end
    Re_ = 64 / f
    if Re_ < 4e3
        Re = pushfirst!(Re, Re_)
        laminOK = true
    else
        laminOK = false
    end
    if !isempty(Re) & fig
        doPlot(ε)
        if !(Re[end] < 2.3e3) && ε != 0
            turb(ε)
        end
        plot!(
            [Re], [f, f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red
        )
        display(
            plot!([1e2, 1e8], [f, f],
                seriestype=:line,
                color=:red,
                linestyle=:dash)
        )
    end
    if turbOK && laminOK && !turbulent
        (Moody(Re[1], f, ε), Moody(Re[end], f, ε))
    elseif turbOK && turbulent
        Moody(Re[end], f, ε)
    elseif turbOK || laminOK
        Moody(Re[end], f, ε)
    else
        if msgs
            printstyled(
                "Darcy friction factor f is too high for the given pipe relative roughness ε and too low for laminar flow.",
                color=:cyan)
        end
    end
end
