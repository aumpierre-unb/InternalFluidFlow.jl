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
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true
)
    P = 2 * g * h * Q^3 / (π / 4)^3 / (μ / ρ)^5 / L

    if lam
        Re = (P / 64)^(1 / 4)
        if msgs && 2.3e3 < Re < 4e3
            printstyled(
                "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                color=:cyan)
        else
            printstyled(
                "No solution found for laminar flow (Re < 4e3) or turbulent flow (Re > 2.3e3).\n",
                color=:cyan)
            return
        end
        f = 64 / Re
        D = ρ * Q / Re / μ / (π / 4)
        ε = k / D
        if Re < 4e3
            moody_lam = Moody(Re, f, ε)
            if msgs && Re > 2.3e3
                printstyled(string(
                        "Be aware that laminar flow bounds extends up to Re = 4e3.\n",
                    ), color=:cyan)
            end
        else
            lam = false
        end
    end

    if turb
        function foo(f)
            Re = (P / f)^(1 / 5)
            D = ρ * Q / (π / 4) / μ / Re
            ε = k / D
            f = 1 / f^(1 / 2) + 2 * log10(ε / 3.7 + 2.51 / Re / f^(1 / 2))
            f
        end
        f = newtonraphson(foo, 1e-2, 1e-4)
        Re = (P / f)^(1 / 5)
        D = ρ * Q / (π / 4) / μ / Re
        ε_turb = k / D
        if ε_turb > 5e-2
            ε_turb = 5e-2
            ε_reassign = true
        else
            ε_reassign = false
        end
        moody_turb = hQeps2fRe(
            h=h, Q=Q, L=L, ε=ε_turb, ρ=ρ, μ=μ, lam=false, fig=false
        )
        if moody_turb.Re > 2.3e3
            D = ρ * Q / (π / 4) / μ / moody_turb.Re
            k = ε_turb * D
            if msgs && ε_reassign
                printstyled(string(
                        "Be aware that pipe roughness for turbulent flow is reassigned to k = ", k, " cm. All other parameters are unchanged.\n"
                    ), color=:cyan)
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
            (P ./ [6e-3, 1e-1]) .^ (1 / 5),
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
