@doc raw"""
```
hQeps2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number, # head loss in cm
    Q::Number=NaN, # volumetric flow rate in cc/s
    L::Number=100, # pipe length in cm, default is 100 cm
    ε::Number=NaN, # pipe relative roughness
    ρ::Number=NaN, # fluid dynamic density in g/cc
    μ::Number=NaN, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`hQeps2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the volumetric flow rate Q,
the pipe length L,
the pipe relative roughness ε,
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

Please, notice that all parameters are given in cgs units.

If parameter fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hQeps2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hQeps2fRe(;
    h::Number,
    Q::Number,
    L::Number,
    ε::Number,
    ρ::Number,
    μ::Number,
    g::Number=981,
    fig::Bool=false,
    msgs::Bool=true
)
    P = 2 * g * h * Q^3 / (π / 4)^3 / (μ / ρ)^5 / L

    ε_turb = ε
    if ε_turb > 5e-2
        ε_turb = 5e-2
        if msgs
            printstyled(
                "Be aware that pipe relative roughness for turbulent flow is reassigned to ε = 5e-2. All other parameters are unchanged.\n",
                color=:cyan)
        end
    end
    function foo(f)
        Re = (P / f)^(1 / 5)
        ε = ε_turb
        1 / f^(1 / 2) + 2 * log10(ε / 3.7 + 2.51 / Re / f^(1 / 2))
    end
    f = newtonraphson(foo, 1e-2, 1e-4)
    Re = (P / f)^(1 / 5)

    if Re < 2.3e3
        Re = (P / 64)^(1 / 4)
        f = 64 / Re
        turb = false
        moody = Moody(Re, f, ε)
    else
        turb = true
        moody = Moody(Re, f, ε_turb)
    end

    if fig
        if turb
            doPlot(ε_turb)
        else
            doPlot()
        end
        plot!(
            [Re],
            [f],
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
