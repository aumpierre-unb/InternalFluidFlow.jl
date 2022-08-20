using Plots
include("f2Re.jl")

function rough()
    eps = []
    f = []
    Re = []
    N = 31
    for i = 1:N
        w = log10(4e-5) + (i - 1) * (log10(5e-2) - log10(4e-5)) / (N - 1)
        eps = [eps; 10^w]
        f = [f; 1.01 * (2 * log10(3.7 / eps[end]))^-2]
        z = f2Re(f[end], eps[end])
        Re = [Re; z[end]]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end
