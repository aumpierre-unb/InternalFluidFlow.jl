using Plots
# include("bissecao.jl")
include("laminar.jl")
include("turb.jl")
include("smooth.jl")
include("rough.jl")

function figure(eps)
    plot(xlabel="Re",
        ylabel="f",
        xlims=(1e2, 1e8),
        ylims=(6e-3, 1e-1),
        legend=false,
        framestyle=:box,
        scale=:log10,
        grid=:true,
        minorgrid=:true)
    laminar()
    turb(eps)
    if eps < 1e-4
        turb(1e-5)
    else
        turb(eps / 3)
    end
    if eps < 1e-4
        turb(1e-4)
    else
        turb(eps / 10)
    end
    if eps < 1e-4
        turb(1e-3)
    elseif eps * 3 > 5e-2
        turb(5e-2)
    else
        turb(eps * 3)
    end
    if eps < 1e-4
        turb(5e-3)
    elseif eps * 10 > 5e-2
        turb(eps / 6)
    else
        turb(eps * 10)
    end
    rough()
    if eps != 0
        smooth()
    end
end
