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
    N = 50
    u = log10(2.3e3):(log10(1e8) - log10(2.3e3)) / (N - 1):log10(1e8)
    Re=10 .^ u
    f=Re2f.(Re, eps)
    plot!(Re, f,
        seriestype=:line,
        color=:black)
end
