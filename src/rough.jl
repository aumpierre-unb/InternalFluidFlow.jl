using Plots
include("bissection.jl")

@doc raw"""
`rough` produces the representation of the
relation of Reynolds number and the Darcy friction factor
for a fully rough regime.

`rough` is an auxiliary function of
the `InternalFluidFlow` toolbox for Julia.
"""
function rough()
    eps = []
    f = []
    Re = []
    N = 31
    for i = 1:N
        w = log10(4e-5) + (i - 1) * (log10(5e-2) - log10(4e-5)) / (N - 1)
        eps = [eps; 10^w]
        f = [f; 1.01 * (2 * log10(3.7 / eps[end]))^-2]
        function foo(Re)
            return 1 / sqrt(f[end]) + 2 * log10(eps[end] / 3.7 + 2.51 / Re / sqrt(f[end]))
        end
        z = bissection(foo, 1e3, 1e8, 1e-4)
        Re = [Re; z[end]]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end

