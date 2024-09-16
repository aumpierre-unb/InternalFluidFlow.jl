@doc raw"""
```
hvthk2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number, # head loss in cm
    v::Number=NaN, # flow speed in cm/s
    L::Number=100, # pipe length in cm, default is 100 cm
    k::Number=NaN, # pipe roughness in cm
    ρ::Number=NaN, # fluid dynamic density in g/cc
    μ::Number=NaN, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    lam::Bool=true, # default is search within laminar bounds
    turb::Bool=true, # default is search within turbulent bounds
    msgs::Bool=true, # default is show warning messages
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

Please, notice that all parameters are given in cgs units.

`hvthk2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hvthk2fRe(;
    h::Number,
    v::Number,
    L::Number,
    k::Number,
    ρ::Number,
    μ::Number,
    g::Number=981,
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true,
    fig::Bool=false
)
    M = 2 * g * μ * h / v^3 / ρ / L

    if lam
        Re = (64 / M)^(1 / 2)
        if Re < 4e3
            f = 64 / Re
            D = Re * μ / ρ / v
            ε = k / D
            moody_lam = Moody(Re, f, ε)
            if msgs && 2.3e3 < Re < 4e3
                printstyled(
                    "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                    color=:magenta)
            end
        else
            lam = false
        end
    end

    if turb
        function foo(f)
            Re = f / M
            D = Re * μ / ρ / v
            ε_turb = k / D
            f = 1 / f^(1 / 2) + 2 * log10(ε_turb / 3.7 + 2.51 / Re / f^(1 / 2))
            f
        end
        f = newtonraphson(foo, 1e-2, 1e-4)
        Re = f / M
        D = Re * μ / ρ / v
        ε_turb = k / D
        if Re > 2.3e3
            D = Re * μ / ρ / v
            ε_turb = k / D
            if ε_turb > 5e-2
                ε_turb = 5e-2
                ε_reassign = true
            else
                ε_reassign = false
            end
            moody_turb = hveps2fRe(
                h=h, v=v, L=L, ε=ε_turb, ρ=ρ, μ=μ, lam=false, fig=false
            )
            if moody_turb.Re > 2.3e3
                D = moody_turb.Re * μ / ρ / v
                k = ε_turb * D
                if msgs && ε_reassign
                    printstyled(string(
                            "Be aware that pipe roughness for turbulent flow is reassigned to k = ", k, " cm. All other parameters are unchanged.\n"
                        ), color=:cyan)
                end
            else
                turb = false
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
