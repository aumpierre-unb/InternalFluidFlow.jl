@doc raw"""
```
doPlot(
    ε::Number=0
    )
```

`doPlot` produces a schematic Moody diagram
including the line for ε
(default is smooth pipe, ε = 0).

`doPlot` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `f2Re` and `h2fRe`.

Examples
==========
Build a schematic Moody diagram:
```
julia> doPlot()
```

"""
function doPlot(
    ε::Number=0
)
    plot(
        xlabel="Reynolds Number",
        ylabel="Darcy Friction Factor",
        xlims=(1e2, 1e8),
        ylims=(6e-3, 1e-1),
        legend=false,
        framestyle=:box,
        xaxis=:log10,
        yaxis=:log10,
        grid=true,
        gridalpha=0.4,
        minorgrid=true,
        minorgridalpha=0.12,
        yticks=([6e-3, 1e-2, 2e-2, 3e-2, 5e-2, 1e-1],
            ["0.006", "0.01", "0.02", "0.03", "0.05", "0.1"]))
    fontSize = 8
    laminar()
    annotate!(1.2e3, 3.8e-2, text(
        "Laminar flow",
        fontSize,
        :center,
        :center,
        :black,
        rotation=-73)
    )
    if ε != 1e-5
        turb(1e-5)
    end
    annotate!(
        0.92e8, 0.77e-2, text(
            "1e-5",
            fontSize,
            :center,
            :right,
            :black)
    )
    if ε != 1e-4
        turb(1e-4)
    end
    annotate!(
        0.92e8, 1.3e-2, text(
            "1e-4",
            fontSize,
            :center,
            :right,
            :black)
    )
    if ε != 1e-3
        turb(1e-3)
    end
    annotate!(
        0.92e8, 2.15e-2, text(
            "1e-3",
            fontSize,
            :center,
            :right,
            :black)
    )
    if ε != 1e-2
        turb(1e-2)
    end
    annotate!(
        0.92e8, 4.1e-2, text(
            "1e-2",
            fontSize,
            :center,
            :right,
            :black)
    )
    if ε != 5e-2
        turb(5e-2)
    end
    annotate!(
        0.92e8, 7.85e-2, text(
            "5e-2",
            fontSize,
            :center,
            :right,
            :black)
    )
    rough()
    annotate!(
        1.2e6, 2.7e-2, text(
            "Hydraulically rough boundary",
            fontSize,
            :center,
            :center,
            :darkgreen,
            rotation=-42)
    )
    smooth()
    annotate!(
        1e5, 1.62e-2, text(
            "Hydraulically smooth boundary",
            fontSize,
            :center,
            :center,
            :blue,
            rotation=-34)
    )
    annotate!(
        130, 7.9e-3, text(
            "Moody Diagram", "TamilMN-Bold",
            fontSize + 5,
            :center,
            :left,
            :black)
    )
    annotate!(
        130, 6.6e-3, text(
            "https://github.com/aumpierre-unb/InternalFluidFlow.jl", "TamilMN-Bold",
            fontSize - 3,
            :center,
            :left,
            :black)
    )
    path = Base.find_package("InternalFluidFlow")
    file = string(
        path[1:length(path)-length("src/InternalFluidFlow.jl")],
        "\\julia-logo-color.png"
    )
    plot!(inset=bbox(
        0.127,
        0.65,
        0.11,
        0.11
    ))
    plot!(
        load(file),
        subplot=2,
        axis=false,
        grid=false
    )
end
