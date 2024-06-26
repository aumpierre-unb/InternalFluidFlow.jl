# using Plots
# include("figure.jl")

@doc raw"""
`f2Re(f::Number;eps::Number=0,fig::Bool=false,isturb::Bool=false)`

`f2Re` computes the Reynolds number Re given
the Darcy friction factor f and
the relative roughness eps (default eps = 0)
for both laminar and turbulent regime, if possible.

By default, pipe is assumed to be smooth.
Relative roughness is reset to eps = 0.05, if eps > 0.05.

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

See also: `Re2f`, `h2fRe`.

Examples
==========
Compute the Reynolds number Re given
the Darcy friction factor f = 0.028 and
the pipe's relative roughness eps = 0.001.
In this case, both laminar and turbulent
solutions are possible:
```
f2Re(2.8e-2, eps=1e-3)
```

Compute the Reynolds number Re given
the Darcy friction factor f = 0.028
for a smooth pipe and plot and
show results on a schematic Moody diagram:
```
Re = f2Re(2.8e-2, fig=true)
```
"""
function f2Re(f::Number; eps::Number=0, fig::Bool=false, isturb::Bool=false)
    if eps > 5e-2
        eps = 5e-2
    end
    Re::Vector{Float64} = []
    f_::Vector{Float64} = []
    if f > (2 * log10(3.7 / eps))^-2
        Re_ = 2.51 / (10^(1 / f^(1 / 2) / -2) - eps / 3.7) / f^(1 / 2)
        if Re_ > 2.3e3
            Re = [Re_; Re]
            f_ = [f; f_]
        end
    end
    Re_ = 64 / f
    if Re_ < 4e3
        Re = [Re_; Re]
        f_ = [f; f_]
    end
    if !isempty(f_) & fig
        figure(eps)
        if !(Re[end] < 2.3e3) && eps != 0
            turb(eps)
        end
        plot!([Re], [f_],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!([1e2; 1e8], [f; f],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    if isturb
        Re[end]
    else
        Re
    end
end
