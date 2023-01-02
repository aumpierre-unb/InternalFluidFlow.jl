using Plots

@doc raw"""
`turb` produces the representation of the
relation of Reynolds number and the Darcy friction factor
by the Colebrook-White equation for Re > 2,300 given
the relative roughness.

`turb` is an auxiliary function of
the `InternalFluidFlow` toolbox for Julia.
"""
function turb(eps)
    Re = []
    f = []
    N = 51
    for n = 1:N
        u = log10(2.3e3) + (n - 1) * (log10(1e8) - log10(2.3e3)) / (N - 1)
        Re = [Re; 10^u]
        f = [f; Re2f(Re[end], eps)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:black))
end
