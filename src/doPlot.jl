@doc raw"""
```
doPlot(
    ε::Number=0 # pipe relative roughness
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
Build a schematic Moody diagram.
```
julia> doPlot()
```

Build a schematic Moody diagram
with one extra line for turbulent flow
with ε = 4.5e-3.
```
julia> doPlot(
       ε = 4.5e-3
       )
```
"""
function doPlot(
    ε::Number=0
)
    f_ticks = ("0.006", "0.01", "0.015", "0.02", "0.03", "0.05", "0.1")
    f_vals = parse.(Float64, f_ticks)
    fontSize = 8
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
        right_margin=13Plots.mm,
        yticks=([i for i in f_vals], [i for i in f_ticks])
    )

    ε_ticks = ("0.00001", "0.00003", "0.0001", "0.0003", "0.001", "0.003", "0.01", "0.02", "0.03", "0.05")
    ε_vals = parse.(Float64, ε_ticks)
    for i in eachindex(ε_vals)
        turb(ε_vals[i])
        annotate!(
            1.1e8, Re2f(Re=1e8, ε=ε_vals[i], msgs=false).f, text(
                ε_ticks[i], fontSize,
                :center, :left,
                :black
            )
        )
    end

    if all(ε .!= ε_vals) && ε != 0
        turb(ε)
        annotate!(
            1.1e8, Re2f(Re=1e8, ε=ε, msgs=false).f, text(
                ε, fontSize,
                :center, :left,
                :black
            )
        )
    end

    laminar()
    annotate!(
        1.2e3, 3.8e-2, text(
            "Laminar flow", fontSize,
            :center, :center,
            :black,
            rotation=-73)
    )

    rough()
    annotate!(
        1.2e6, 2.7e-2, text(
            "Hydraulically rough boundary", fontSize,
            :center, :center,
            :darkgreen,
            rotation=-44
        )
    )

    smooth()
    annotate!(
        4e5, 1.2e-2, text(
            "Hydraulically smooth boundary", fontSize,
            :center, :center,
            :blue,
            rotation=-34
        )
    )

    begin
        annotate!(
            130, 7.9e-3, text(
                "Moody Diagram", "TamilMN-Bold", fontSize + 5,
                :center, :left,
                :black
            )
        )
        annotate!(
            130, 6.6e-3, text(
                "https://github.com/.../InternalFluidFlow.jl", "TamilMN-Bold", fontSize - 3,
                :center, :left,
                :black
            )
        )
        path = pathof(InternalFluidFlow)
        path = path[1:length(path)-length("src\\InternalFluidFlow.jl")]
        file = string(path, "julia-logo-color.png")
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

    display(plot!())
end
