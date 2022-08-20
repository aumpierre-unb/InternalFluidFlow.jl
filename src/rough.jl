using Plots
include("bissecao.jl")

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
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re / sqrt(f))
        end
        z = bissecao(foo, 1e3, 1e8, 1e-4)
        Re = [Re; z[end]]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end

