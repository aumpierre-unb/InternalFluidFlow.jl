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
    N = 30
    z = Vector{Float16}(undef, N)
    f = Vector{Float16}(undef, N)
    Re = Vector{Float16}(undef, N)
    for i = 1:N
        u = log10(5e-2) + (i - 1) * (log10(4e-5) - log10(5e-2)) / (N - 1)
        z[i] = 10^u
        #f = [f; 1.01 * (2 * log10(3.7 / z[end]))^-2]
        f[i] = 1.01 * (2 * log10(3.7 / z[i]))^-2
        w = f2Re(f[i]; eps=z[i], isturb=true)
        Re[i] = w[end]
    end
    plot!(Re, f,
        seriestype=:line,
        markershape=:square,
        color=:blue)
end
