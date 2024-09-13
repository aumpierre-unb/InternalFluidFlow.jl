@doc raw"""
```
hDeps2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number, # head loss in cm
    D::Number=NaN, # pipe hydraulic diameter in cm
    L::Number=NaN, # pipe length in cm, default is 100 cm
    ε::Number=NaN, # pipe relative roughness
    ρ::Number=NaN, # fluid dynamic density in g/cc
    μ::Number=NaN, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`hDeps2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h,
the pipe hydraulic diameter D,
the pipe length L,
the pipe relative roughness ε,
the fluid density ρ,
the fluid dynamic viscosity μ, and
the gravitational accelaration g.

By default, pipe is assumed to be 1 m long,
L = 100 (in cm).

By default, pipe is assumed to be smooth (ε = 0).
If ε > 0.05, relative roughness is reset to upper limit ε = 0.05.

By default, fluid is assumed to be water at 25 °C,
ρ = 0.997 (in g/cc) and
μ = 0.0091 (in P),
and gravitational acceleration is assumed to be
g = 981 (in cm/s/s).

Please, notice that all parameters are given in cgs units.

If fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hDeps2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hDeps2fRe(;
    h::Number,
    D::Number,
    L::Number,
    ε::Number,
    ρ::Number,
    μ::Number,
    g::Number=981,
    fig::Bool=false,
    msgs::Bool=true
)
    K = 2 * g * h * ρ^2 * D^3 / μ^2 / L

    ε_turb = ε
    if ε_turb > 5e-2
        ε_turb = 5e-2
        if msgs
            printstyled(
                "Be aware that pipe relative roughness for turbulent flow is reassigned to ε = 5e-2. All other parameters are unchanged.\n",
                color=:cyan)
        end
    end
    f = (-2 * log10(ε_turb / 3.7 + 2.51 / K^(1 / 2)))^-2
    Re = (K / f)^(1 / 2)

    if Re < 2.3e3
        Re = K / 64
        if msgs && Re > 2.3e3
            printstyled(
                "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                color=:cyan)
        end
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
            (K ./ [6e-3, 1e-1]) .^ (1 / 2),
            [6e-3, 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash
        )
        display(plot!())
    end

    moody
end
