@doc raw"""
```
h2fRe(; # Reynolds number Re and Darcy friction factor f
    h::Number; # head loss in cm
    L::Number=100, # pipe length in cm
    ε::Number=NaN, # pipe relative roughness
    k::Number=NaN, # pipe roughness in cm
    D::Number=NaN, # pipe hydraulic diameter in cm
    v::Number=NaN, # flow speed in cm/s
    Q::Number=NaN, # volumetric flow rate in cc/s
    ρ::Number=0.997, # fluid dynamic density in g/cc
    μ::Number=0.0091, # fluid dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )
```

`h2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h in cm,
the pipe hydraulic diameter D in cm or
the flow speed v in cm/s or
the volumetric flow rate Q in cc/s,
the pipe length L in cm (default L = 100 cm),
the pipe roughness k in cm (default k = 0 cm) or
the pipe relative roughness ε (default ε = 0),
the fluid density ρ in g/cc (default ρ = 0.997 g/cc),
the fluid dynamic viscosity μ in g/cm/s (default μ = 0.0091 g/cm/s), and
the gravitational accelaration g in cm/s/s (default g = 981 cm/s/s).

By default, pipe is assumed to be smooth.
Relative roughness is reset to ε = 0.05, if ε > 0.05.

Notice that default values are given in the cgs unit system and,
if taken, all other parameters must as well be given in cgs units.

If parameter fig = true is given
a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`h2fRe` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `f2Re` and `doPlot`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss h = 40 cm,
the pipe hydraulic diameter D = 4 in,
the pipe length L = 25 m and
the pipe relative roughness ε = 0.0021 for water flow.
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=40, # head loss in cm
       D=4*2.54, # pipe hyraulic diameter in cm
       L=25e2, # pipe length in cm
       ε=0.0027 # pipe relative roughness
       )
InternalFluidFlow.Moody(125588.17661494392, 0.025055907172151323, 0.0021)
```

Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss per meter h/L = 1.6 cm/m,
the volumetric flow rate Q = 8.6 L/s,
the pipe length L = 25 m,
the pipe roughness k = 0.08 cm,
the fluid density ρ = 0.989 g/cc and
the fluid dynamic viscosity μ = 0.89 cP.
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=1.6*25, # head loss in cm
       Q=8.6e3, # volumetric flow rate in cc/s
       L=25e2, # pipe length in cm
       k=0.08, # pipe relative roughness
       ρ=0.989, # fluid dynamic density in g/cc
       μ=8.9e-3 # fluid dynamic viscosity in g/cm/s
       )
InternalFluidFlow.Moody(114711.41902151344, 0.03515951366848225, 0.007541917588470084)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.30 m,
the flow speed v = 25 cm/s,
the pipe length L = 25 m,
the pipe roughness 0.02 cm
for water flow and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible:
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
              h=0.30e2, # head loss in cm
              v=25, # flow speed in cm/s
              L=25e2, # pipe length in cm
              k=0.02,fig=true # pipe roughness in cm
              )
(InternalFluidFlow.Moody(2157.181854298826, 0.029668337823471388, 0.02539434478880578), InternalFluidFlow.Moody(3844.1827631348333, 0.052870142887847124, 0.014250013799282117))

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the flow speed v = 1.1 m/s,
the pipe length L = 25 m,
the pipe roughness 0.1 cm
for water flow and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible,
however relative roughness
is reassigned to maximum 5e-2:
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=0.40e2, # head loss in cm
       v=23, # flow speed in cm/s
       L=25e2, # pipe length in cm
       k=0.1,fig=true # pipe roughness in cm
       )
Be aware that pipe roughness for turbulent flow is reassigned to 0.06575480550721453 cm. All other parameters are unchanged.
(InternalFluidFlow.Moody(1648.538640616669, 0.03882226259255865, 0.1528559930477271), InternalFluidFlow.Moody(3313.897681507552, 0.07804063722050959, 0.05))
```
"""
function h2fRe(;
    h::Number,
    L::Number=100,
    ε::Number=NaN,
    k::Number=NaN,
    D::Number=NaN,
    v::Number=NaN,
    Q::Number=NaN,
    ρ::Number=0.997,
    μ::Number=0.0091,
    g::Number=981,
    fig::Bool=false,
    msgs::Bool=true
)
    a = isnan.([D, v, Q]) .!= 1
    if msgs && sum(a) != 1
        printstyled(
            """h2fRe requires that either
            the hydraulic diameter,
            the flow speed or
            the flow rate
            be given alone.\n""",
            color=:cyan
        )
    end
    b = isnan.([ε, k]) .!= 1
    if msgs && sum(b) != 1
        printstyled(
            """h2fRe requires that either
            the pipe roughness or
            the pipe relative roughness
            be given alone.\n""",
            color=:cyan
        )
    end
    if a == [1, 0, 0]
        hDeps2fRe(h=h, D=D, L=L, ε=ε, ρ=ρ, μ=μ, g=g, fig=fig)
    elseif a == [0, 1, 0] && b == [1, 0]
        hveps2fRe(h=h, v=v, L=L, ε=ε, ρ=ρ, μ=μ, g=g, fig=fig)
    elseif a == [0, 1, 0] && b == [0, 1]
        hvthk2fRe(h=h, v=v, L=L, k=k, ρ=ρ, μ=μ, g=g, fig=fig)
    elseif a == [0, 0, 1] && b == [1, 0]
        hQeps2fRe(h=h, Q=Q, L=L, ε=ε, ρ=ρ, μ=μ, g=g, fig=fig)
    elseif a == [0, 0, 1] && b == [0, 1]
        hQthk2fRe(h=h, Q=Q, L=L, k=k, ρ=ρ, μ=μ, g=g, fig=fig)
    end
end
