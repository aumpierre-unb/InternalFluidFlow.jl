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
    # N = 30
    # u = log10(4e-5):(log10(5e-2)-log10(4e-5))/N:log10(5e-2)
    # z = 10 .^ u
    # f = 1.01 .* (2 .* log10.(3.7 ./ z)) .^ -2
    # Re = f2Re.(f; eps=z, isturb=false)
    N = 31
    z = Vector{Float16}(undef, N)
    f = Vector{Float16}(undef, N)
    Re = Vector{Float16}(undef, N)
    N = 31
    for i = 1:N
        u = log10(5e-2) + (i - 1) * (log10(4e-5) - log10(5e-2)) / (N - 1)
        z = [z; 10^u]
        f = [f; 1.01 * (2 * log10(3.7 / z[end]))^-2]
        z = f2Re(f[end]; eps=z[end], isturb=true)
        Re = [Re; z[end]]
    end
    plot!(Re, f,
        seriestype=:line,
        color=:blue)
end
