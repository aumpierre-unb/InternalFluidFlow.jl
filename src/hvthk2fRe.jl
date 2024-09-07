@doc raw"""
```
hvthk2fRe( # Reynolds number Re and Darcy friction factor f
    h::Number; # head loss in cm
    v::Number=NaN, # flow speed in cm/s
    L::Number=100, # pipe length in cm, default is 100 cm
    k::Number=NaN, # pipe roughness in cm
    ρ::Number=0.997, # fluid dynamic density in g/cc
    μ::Number=0.0091, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`hvthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the flow speed v,
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

`hvthk2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hvthk2fRe(
    h::Number,
    v::Number,
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
    Re::Vector{Float64} = []
    f::Vector{Float64} = []
    ε::Vector{Float64} = []
    M = 2 * g * μ * h / v^3 / ρ / L
    foo(f) = 1 / f^(1 / 2) + 2 * log10(
        k / (f / M * μ / ρ / v) / 3.7 + 2.51 / (f / M) / f^(1 / 2)
    )
    f_ = newtonraphson(foo, 1e-2, 1e-4)
    Re_ = f_ / M
    if Re_ > 2.3e3
        Re = push!(Re, Re_)
        f = push!(f, f_)
        D = Re_ * μ / ρ / v
        ε = push!(ε, k / D)
    end
    Re_ = (64 / M)^(1 / 2)
    if Re_ < 2.3e3
        Re = pushfirst!(Re, Re_)
        f = pushfirst!(f, 64 / Re_)
        D = Re_ * μ / ρ / v
        ε = pushfirst!(ε, k / D)
    end
    if fig
        fontSize = 8
        doPlot(ε[end])
        if !(Re[end] < 2.3e3) && ε != 0
            turb(ε[end], lineColor=:black)
            # annotate!(
            #     0.92e8, 0.95 * (
            #         2 * log10(3.7 / ε[end])
            #     )^-2, text(
            #         string(round(ε[end], sigdigits=3)), fontSize,
            #         :center, :right,
            #         :darkblue)
            # )
        end
        plot!(Re, f,
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        plot!(
            [6e-3, 1e-1] ./ M,
            [6e-3, 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash)
        display(plot!())
    end
    Re, f, ε
end
