using Plots
# include("newtonraphson.jl")

@doc raw"""
`smooth` produces the representation of the
relation of Reynolds number and the Darcy friction factor
by the Colebrook-White equation for a smooth pipe.

`smooth` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function smooth()
    N = 30
    u = log10(2.3e3):(log10(1e7)-log10(2.3e3))/N:log10(1e7)
    Re = 10 .^ u
    f=Re2f.(Re)
    plot!(Re, f,
        seriestype=:line,
        color=:blue)
end
