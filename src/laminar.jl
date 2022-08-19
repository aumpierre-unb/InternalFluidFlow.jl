using Plots

function laminar()
    Re = [500; 4000]
    f = 64 ./ Re
    display(plot!(Re, f,
        seriestype=:line,
        color=:black))
end
