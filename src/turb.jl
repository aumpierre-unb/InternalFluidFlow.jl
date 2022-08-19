using Plots

function turb(eps)
    Re = []
    f = []
    N = 51
    for i in 1:N
        w = log10(2e3) + (i - 1) * (log10(1e8) - log10(2e3)) / (N - 1)
        Re = [Re; 10^w]
        function foo(f)
            return 1 / sqrt(f) + 2 * log10(eps / 3.7 + 2.51 / Re[end] / sqrt(f))
        end
        f = [f; bissecao(foo, 6e-4, 1e-1, 1e-4)]
    end
    display(plot!(Re, f,
        seriestype=:line,
        color=:black))
end
