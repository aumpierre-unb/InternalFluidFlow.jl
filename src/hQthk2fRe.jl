@doc raw"""
```
hQthk2fRe( # Reynolds number Re and Darcy friction factor f
    h::Number; # head loss in cm
    Q::Number=NaN, # volumetric flow rate in cc/s
    L::Number=100, # pipe length in cm, default is 100 cm
    k::Number=NaN, # pipe roughness in cm
    ρ::Number=0.997, # fluid dynamic density in g/cc
    μ::Number=0.0091, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`hQthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the volumetric flow rate Q,
the pipe length L,
the pipe roughness k,
the fluid density ρ,
the fluid dynamic viscosity μ, and
the gravitational accelaration g.

By default, pipe is assumed to be 1 m long,
L = 100 (in cm).

By default, pipe is assumed to be smooth,
ε = 0. Relative roughness ε is reset to ε = 0.05,
if ε > 0.05.

By default, fluid is assumed to be water at 25 °C,
ρ = 0.997 (in g/cc) and
μ = 0.0091 (in P),
and gravitational acceleration is assumed to be
g = 981 (in cm/s/s).
Please, notice that these default values are given in the cgs unit system and,
if taken, all other parameters must as well be given in cgs units.

If parameter fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hQthk2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hQthk2fRe(
    h::Number,
    Q::Number,
    L::Number,
    k::Number,
    ρ::Number,
    μ::Number,
    g::Number,
    fig::Bool
)
    if k > 5e-2
        k = 5e-2
    end
    P = 2 * g * h * Q^3 / (pi / 4)^3 / (μ / ρ)^5 / L
    foo(f) = 1 / f^(1 / 2) + 2 * log10(
        k / (ρ * Q / (pi / 4) / μ / ((P / f)^(1 / 5))) / 3.7 + 2.51 / (P / f)^(1 / 5) / f^(1 / 2)
        )
    f = newtonraphson(foo, 1e-2, 1e-4)
    Re = (P / f)^(1 / 5)
    if Re > 2.3e3
    else
        Re = (P / 64)^(1 / 4)
        f = 64 / Re
    end
    D = ρ * Q / Re / μ / (pi / 4)
    ε = k / D
    if fig
        fontSize = 8
        doPlot(ε)
        if !(Re < 2.3e3) && ε != 0
            turb(ε, lineColor=:black)
            # annotate!(
            #     0.92e8, 0.95 * (
            #         2 * log10(3.7 / ε)
            #     )^-2, text(
            #         string(round(ε, sigdigits=3)), fontSize,
            #         :center, :right,
            #         :darkblue)
            # )
        end
        plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!(
            (P ./ [6e-3, 1e-1]) .^ (1 / 5),
            [6e-3, 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    Re, f, ε
end
