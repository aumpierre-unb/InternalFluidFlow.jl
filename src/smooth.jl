using Plots
include("bissection.jl")

@doc raw"""
`smooth` produces the representation of the
relation of Reynolds number and the Darcy friction factor
by the Colebrook-White equation for a smooth pipe.

`smooth` is an auxiliary function of
the `InternalFluidFlow` toolbox for Julia.
"""
function smooth()
    Re = []
    f = []
    N = 31
    for i = 1:N
        w = log10(2e3) + (i - 1) * (log10(1e7) - log10(2e3)) / (N - 1)
        Re = [Re; 10^w]
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(2.51 / Re[end] / sqrt(f))
        end
        f = [f; bissection(foo, 6e-3, 1e-1, 1e-4)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end
