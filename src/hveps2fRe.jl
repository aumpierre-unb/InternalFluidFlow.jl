@doc raw"""
```
hveps2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number, # head loss in cm
    v::Number=NaN, # flow speed in cm/s
    L::Number=100, # pipe length in cm, default is 100 cm
    ε::Number=NaN, # pipe relative roughness
    ρ::Number=NaN, # fluid dynamic density in g/cc
    μ::Number=NaN, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`hveps2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the flow speed v,
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
Please, notice that these default values are given in the cgs unit system and,
if taken, all other parameters must as well be given in cgs units.

If parameter fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hveps2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hveps2fRe(;
    h::Number,
    v::Number,
    L::Number,
    ε::Number,
    ρ::Number,
    μ::Number,
    g::Number=981,
    fig::Bool=false,
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true
)
    M = 2 * g * μ * h / v^3 / ρ / L

    if turb
        ε_turb = ε
        if ε_turb > 5e-2
            ε_turb = 5e-2
            if msgs
                printstyled(
                    "Beware that relative roughness for turbulent flow is reassigned to 5e-2. All other parameters are unchanged.\n",
                    color=:cyan)
            end
        end
        foo(f) = 1 / f^(1 / 2) + 2 * log10(
            ε_turb / 3.7 + 2.51 / (f / M) / f^(1 / 2)
        )
        f_turb = newtonraphson(foo, 1e-2, 1e-4)
        Re_turb = f_turb / M
        if Re_turb > 2.3e3
            moody_turb = Moody(Re_turb, f_turb, ε_turb)
        else
            turb = false
        end
    end

    if lam
        ε_lam = ε
        Re_lam = (64 / M)^(1 / 2)
        f_lam = 64 / Re_lam
        if Re_lam < 2.3e3
            moody_lam = Moody(Re_lam, f_lam, ε_lam)
        else
            lam = false
        end
    end

    if fig
        if turb
            doPlot(ε_turb)
        else
            doPlot()
        end
        if turb
            plot!(
                [moody_turb.Re],
                [moody_turb.f],
                seriestype=:scatter,
                markerstrokecolor=:red,
                color=:red
            )
        end
        if lam
            plot!(
                [moody_lam.Re],
                [moody_lam.f],
                seriestype=:scatter,
                markerstrokecolor=:red,
                color=:red
            )
        end
        plot!(
            [6e-3, 1e-1] ./ M,
            [6e-3, 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash
        )
        display(plot!())
    end

    if lam && turb
        moody_lam, moody_turb
    elseif lam
        moody_lam
    elseif turb
        moody_turb
    end
end
