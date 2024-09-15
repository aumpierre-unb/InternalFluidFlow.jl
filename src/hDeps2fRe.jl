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

Please, notice that all parameters are given in cgs units.

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
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true
)
    K = 2 * g * h * ρ^2 * D^3 / μ^2 / L

    if lam
        Re = K / 64
        f = 64 / Re
        if Re < 4e3
            moody_lam = Moody(Re, f, ε)
            if msgs && Re > 2.3e3
                printstyled(string(
                        "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                    ), color=:magenta)
            end
        else
            lam = false
        end
    end

    if turb
        ε_turb = ε
        if ε_turb > 5e-2
            ε_turb = 5e-2
            ε_reassign = true
        else
            ε_reassign = false
        end
        f = (-2 * log10(ε_turb / 3.7 + 2.51 / K^(1 / 2)))^-2
        Re = (K / f)^(1 / 2)
        if Re > 2.3e3
            moody_turb = Moody(Re, f, ε_turb)
            if msgs && ε_reassign
                printstyled(
                    "Be aware that pipe relative roughness for turbulent flow is reassigned to ε = 5e-2. All other parameters are unchanged.\n",
                    color=:cyan)
            end
        else
            turb = false
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
            (K ./ [6e-3, 1e-1]) .^ (1 / 2),
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
    else
        if msgs
            printstyled(
                "There is no solution within laminar bound (Re < 4e3) or within turbulent bounds (Re < 2.3e3).\n",
                color=:cyan)
        end
    end
end
