using Plots
include("newtonraphson.jl")

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
    N = 30
    u=log10(4e-5):(log10(5e-2) - log10(4e-5))/N:log10(5e-2)
    eps=10 .^ u
    f=1.01 .* (2 .* log10.(3.7 ./ epsilon)).^-2
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end

