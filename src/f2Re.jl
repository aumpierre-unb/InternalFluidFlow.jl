@doc raw"""
```
f2Re( # Reynolds number
    f::Number; # Darcy friction factor
    ε::Number=0, # relative roughness, default is smooth pipe
    fig::Bool=false, # default hide plot
    isturb::Bool=false # default disregard turbulent flow
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

If parameter isturb = true is given and
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
       2.8e-2, # Darcy friction factor
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
       2.8e-2, # Darcy friction factor
       fig=true # show plot
       )
(InternalFluidFlow.Moody(2285.714285714286, 0.028, 0.0), InternalFluidFlow.Moody(14593.727381591969, 0.028, 0.0))
```
"""
function f2Re(
    f::Number;
    ε::Number=0,
    fig::Bool=false,
    isturb::Bool=false
)
    if ε > 5e-2
        ε = 5e-2
    end
    Re::Vector{Float64} = []
    if f > (2 * log10(3.7 / ε))^-2
        Re_ = 2.51 / (10^(1 / f^(1 / 2) / -2) - ε / 3.7) / f^(1 / 2)
        if Re_ > 2.3e3
            Re = push!(Re, Re_)
        end
        ftoolow = false
    else
        ftoolow = true
    end
    Re_ = 64 / f
    if Re_ < 4e3
        Re = pushfirst!(Re, Re_)
    end
    if !isempty(Re) & fig
        doPlot(ε)
        if !(Re[end] < 2.3e3) && ε != 0
            turb(ε)
        end
        plot!([Re], [f, f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!([1e2, 1e8], [f, f],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    if isturb && !ftoolow
        Moody(Re[end], f, ε)
    else
        (Moody(Re[1], f, ε), Moody(Re[end], f, ε))
    end
end
