using Plots
include("figure.jl")

@doc raw"""
`Re=f2Re(f,[eps[,fig[,turb]]])`

`f2Re` computes the Reynolds number Re, given
the Darcy friction factor f and
the relative roughness eps for
for laminar regime and,
when possible, also
for turbulent regime.

By default, pipe is assumed to be smooth, eps = 0.
If eps > 0.05, eps is reset to eps = 0.05.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

If turb = true is given and
both laminar and turbulent regimes are possible,
then `f2Re` returns the number of Reynolds
for turbulent regime alone.

`f2Re` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `hDeps2fRe`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Reynolds number Re given
the Darcy friction factor f = 0.028 and
the relative roughness eps = 0.001.
In this case, both laminar and turbulent
solutions are possible:
```
f=2.8e-2;eps=1e-3;
Re=f2Re(f;eps=1e-3)
```
Compute Re and plot a schematic Moody diagram:
```
Re=f2Re(2.8e-2;eps=1e-3,fig=true)
```

Compute the Reynolds number Re given
the Darcy friction factor f = 0.028
for a smooth tube and plot
a schematic Moody diagram
with the solution:
```
Re=f2Re(2.8e-2)
```
"""
function f2Re(f::Number; eps::Number=0, fig::Bool=false, isturb::Bool=false, isnotrough::Bool=true)
    if (eps > 5e-2) & isnotrough
        eps = 5e-2
    end
    Re = []
    f_ = []
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
        if !(Re[end] < 2.3e3)
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
        Re = Re[end]
    end
    return Re
end
