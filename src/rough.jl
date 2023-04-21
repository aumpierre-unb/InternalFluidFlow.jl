using Plots
include("newtonraphson.jl")

@doc raw"""
`rough` produces the representation of the
relation of Reynolds number and the Darcy friction factor
for a fully rough regime.

`rough` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function rough()
    N = 30
    u = log10(4e-5):(log10(5e-2)-log10(4e-5))/N:log10(5e-2)
    z = 10 .^ u
    f = 1.01 .* (2 .* log10.(3.7 ./ z)) .^ -2
    f2Re_(f,z)=f2Re(f,eps=z)
    Re=f2Re_.(f, z, isturb=true)
    plot!(Re, f,
        seriestype=:line,
        color=:blue)
end
