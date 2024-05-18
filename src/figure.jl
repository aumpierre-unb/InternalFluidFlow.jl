# using Plots
# include("laminar.jl")
# include("smooth.jl")
# include("rough.jl")

@doc raw"""
`figure` produces a schematic Moody diagram with
a representation of the solution computed from parameters.

`figure` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function figure(eps)
    plot(xlabel="Reynolds Number",
        ylabel="Darcy Friction Factor",
        xlims=(1e2, 1e8),
        ylims=(6e-3, 1e-1),
        legend=false,
        framestyle=:box,
        scale=:log10,
        grid=:true,
        gridalpha=0.4,
        minorgrid=:true,
        minorgridalpha=0.12,
        yticks=([6e-3, 1e-2, 2e-2, 3e-2, 5e-2, 1e-1],
            ["0.006", "0.01", "0.02", "0.03", "0.05", "0.1"]))
    fontSize = 8
    laminar()
    annotate!(1.2e3, 3.8e-2, text(
        "Laminar flow",
        fontSize,
        :center, :center,
        :black,
        rotation=-73))
    if eps != 1e-5
        turb(1e-5)
        annotate!(0.92e8, 0.77e-2, text(
            "1e-5",
            fontSize,
            :center, :right,
            :black))
    end
    if eps != 1e-4
        turb(1e-4)
        annotate!(0.92e8, 1.3e-2, text(
            "1e-4",
            fontSize,
            :center, :right,
            :black))
    end
    if eps != 1e-3
        turb(1e-3)
        annotate!(0.92e8, 2.15e-2, text(
            "1e-3",
            fontSize,
            :center, :right,
            :black))
    end
    if eps != 1e-2
        turb(1e-2)
        annotate!(0.92e8, 4.1e-2, text(
            "1e-2",
            fontSize,
            :center, :right,
            :black))
    end
    if eps != 5e-2
        turb(5e-2)
        annotate!(0.92e8, 7.85e-2, text(
            "5e-2",
            fontSize,
            :center, :right,
            :black))
    end
    rough()
<<<<<<< Updated upstream
    annotate!(1.2e6, 2.7e-2, text(
        "Hydraulically rough boundary",
        fontSize,
        :center, :center,
        :darkgreen,
        rotation=-42))
    smooth()
    annotate!(1e5, 1.62e-2, text(
        "Hydraulically smooth boundary",
        fontSize,
        :center, :center,
        :blue,
        rotation=-34))
    annotate!(1.15e2, 6.6e-3, text(
        "https://github.com/aumpierre-unb/InternalFluidFlow.jl",
        fontSize-2,
        :center, :left,
        :black))
=======
    smooth()
>>>>>>> Stashed changes
end
