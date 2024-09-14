@doc raw"""
```
hDthk2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number, # head loss in cm
    D::Number=NaN, # pipe hydraulic diameter in cm
    L::Number=NaN, # pipe length in cm, default is 100 cm
    k::Number=NaN, # pipe roughness in cm
    ρ::Number=NaN, # fluid dynamic density in g/cc
    μ::Number=NaN, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`hDthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h,
the pipe hydraulic diameter D,
the pipe length L,
the pipe roughness k,
the fluid density ρ,
the fluid dynamic viscosity μ, and
the gravitational accelaration g.

By default, fluid is assumed to be water at 25 °C,
ρ = 0.997 (in g/cc) and
μ = 0.0091 (in P),
and gravitational acceleration is assumed to be
g = 981 (in cm/s/s).

Please, notice that all parameters are given in cgs units.

`hDthk2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hDeps2fRe(;
    h::Number,
    D::Number,
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
    if msgs
        printstyled(
            string(
                "Be aware that pipe relative roughness is assigned to ε = k / D = ", k / D, ".\n"
            ), color=:cyan
        )
    end
    if lam
        moody_lam = hDeps2fRe(h=h, D=D, L=L, ε=k / D, ρ=ρ, μ=μ, g=g, fig=fig, msgs=msgs, turb=false)
    end
    if turb
        moody_turb = hDeps2fRe(h=h, D=D, L=L, ε=k / D, ρ=ρ, μ=μ, g=g, fig=fig, msgs=msgs, lam=false)
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