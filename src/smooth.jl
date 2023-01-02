using Plots
include("newtonraphson.jl")

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
    for n = 1:N
        u = log10(2.3e3) + (n - 1) * (log10(1e7) - log10(2.3e3)) / (N - 1)
        Re = [Re; 10^u]
        f = [f; Re2f(Re[end], eps)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end
