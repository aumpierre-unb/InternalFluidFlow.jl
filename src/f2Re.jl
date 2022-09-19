using Plots
include("bissecao.jl")
include("figure.jl")

@doc raw"""
`Re=f2Re(f,[eps=0[,fig=true]])`

``f2Re`` computes the Reynolds number ``Re``, given
the Darcy friction factor ``f`` and
the relative roughness ``eps`` for
for laminar regime and,
when possible, also
for turbulent regime.

By default, pipe is assumed to be smooth, ``eps=0``.
If eps > 5e-2, eps is reset to ``eps=5e-2``.

If ``fig=true`` is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

See also: `Re2f`, `hDeps2fRe`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute Reynolds number Re for
Darcy friction factor f = 2.8e-2 and
relative roughness eps = 1e-3.
In this case, both laminar and turbulent
solutions are possible.

Compute Re:
```
    f=2.8e-2;eps=1e-3;
    Re=f2Re(f,eps)
```
Compute Re and plot a schematic Moody diagram:
```
    Re=f2Re(2.8e-2,1e-3,true)
```
"""
function f2Re(f::Number, eps::Number=0, fig::Bool=false)
    if eps > 5e-2
        eps = 5e-2
    end
    Re = []
    fD = []
    if 64 / f < 2.3e3
        Re = [Re; 64 / f]
        fD = [fD; f]
    end
    if f > (2 * log10(3.7 / eps))^-2
        function foo(Re)
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re / sqrt(f))
        end
        r = bissecao(foo, 1e3, 1e8, 1e-4)
        if r > 2.3e3
            Re = [Re; r]
            fD = [fD; f]
        end
    end
    if !isempty(fD) & fig
        figure(eps)
        display(plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red))
        display(plot!([1e2; 1e8], [f; f],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return Re
end
