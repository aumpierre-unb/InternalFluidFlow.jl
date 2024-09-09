@doc raw"""
```
hQthk2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number, # head loss in cm
    Q::Number=NaN, # volumetric flow rate in cc/s
    L::Number=100, # pipe length in cm, default is 100 cm
    k::Number=NaN, # pipe roughness in cm
    ρ::Number=NaN, # fluid dynamic density in g/cc
    μ::Number=NaN, # fluid dynamic viscosity in g/cm/s
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
function hQthk2fRe(;
    h::Number,
    Q::Number,
    L::Number,
    k::Number,
    ρ::Number,
    μ::Number,
    g::Number=981,
    fig::Bool=false,
    msgs::Bool=true
)
    P = 2 * g * h * Q^3 / (π / 4)^3 / (μ / ρ)^5 / L

    function foo(f)
        Re = (P / f)^(1 / 5)
        D = ρ * Q / (π / 4) / μ / Re
        ε = k / D
        1 / f^(1 / 2) + 2 * log10(ε / 3.7 + 2.51 / Re / f^(1 / 2))
    end
    f = newtonraphson(foo, 1e-2, 1e-4)
    Re = (P / f)^(1 / 5)
    D = ρ * Q / Re / μ / (π / 4)
    ε = k / D
    if ε > 5e-2
        ε = 5e-2
        ε_reassign=true
    else
        ε_reassign=false
    end
    moody = hQeps2fRe(
        h=h, Q=Q, L=L, ε=ε, ρ=ρ, μ=μ
    )
    if moody.Re < 2.3e3
        Re = (P / 64)^(1 / 4)
        f = 64 / Re
        D = ρ * Q / Re / μ / (π / 4)
        ε = k / D
        turb = false
        moody = Moody(Re, f, ε)
    else
        turb = true
        D = ρ * Q / moody.Re / μ / (π / 4)
        k = ε * D
        if msgs && ε_reassign
            printstyled(string(
                    "Beware that pipe roughness for turbulent flow is reassigned to ", k, " cm. All other parameters are unchanged.\n"
                ), color=:cyan)
        end
    end

    if fig
        if turb
            doPlot(ε)
        else
            doPlot()
        end
        plot!(
            [moody.Re],
            [moody.f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red
        )
        plot!(
            (P ./ [6e-3, 1e-1]) .^ (1 / 5),
            [6e-3, 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash
        )
        display(plot!())
    end

    moody
end
