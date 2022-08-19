using Plots

function smooth()
    Re = []
    f = []
    N = 31
    for i = 1:N
        w = log10(2e3) + (i - 1) * (log10(1e7) - log10(2e3)) / (N - 1)
        Re = [Re; 10^w]
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(2.51 / Re[end] / sqrt(f))
        end
        f = [f; bissecao(foo, 6e-3, 1e-1, 1e-4)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:blue))
end
