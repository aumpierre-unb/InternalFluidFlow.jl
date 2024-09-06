@doc raw"""
`h2fRe( # Reynolds number Re and the Darcy friction factor
    h::Number; # head loss in cm
    L::Number=100, # pipe's length in cm, default is 100 cm
    ε::Number=NaN, # pipe's relative roughness
    k::Number=NaN, # pipe's roughness in cm
    D::Number=NaN, # pipe's hydraulic diameter in cm
    v::Number=NaN, # flow speed in cm/s
    Q::Number=NaN, # volumetric flow rate in cc/s
    ρ::Number=0.997, # fluid's dynamic density in g/cc
    μ::Number=0.0091, # fluid's dynamic viscosity in g/cm/s
    g::Number=981, # gravitational accelaration in cm/s/s
    fig::Bool=false # default is hide plot
    )`

`h2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h in cm,
the pipe's hydraulic diameter D in cm or
the flow speed v in cm/s or
the volumetric flow rate Q in cc/s,
the pipe's length L in cm (default L = 100 cm),
the pipe's roughness k in cm (default k = 0 cm) or
the pipe's relative roughness ε (default ε = 0),
the fluid's density ρ in g/cc (default ρ = 0.997 g/cc),
the fluid's dynamic viscosity μ in g/cm/s (default μ = 0.0091 g/cm/s), and
the gravitational accelaration g incm/s/s (default g = 981 cm/s/s).

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
the pipe's hydraulic diameter D = 10 cm,
length L = 25 m and
relative roughness ε = 0.0027
for water flow:
```
Re, f = h2fRe(40, D=10, L=2.5e3, ε=2.7e-3)
```

Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss per meter h/L = 1.6 cm/m,
the volumetric flow rate Q = 8.6 L/s,
the fluid's density ρ = 0.989 g/cc and
dynamic viscosity μ = 0.89 cP
for a smooth pipe and
show results on a schematic Moody diagram:
```
Re, f = h2fRe(1.6, Q=8.6e3, ε=0, ρ=0.989, μ=8.9e-3, fig=true)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the flow speed v = 1.1 m/s,
the pipe's length L = 25 m
for water flow in a smooth pipe:
```
Re, f = h2fRe(40, v=1.1e2, L=2.5e3, k=0)
```
"""
function h2fRe(
    h::Number;
    L::Number=100,
    ε::Number=NaN,
    k::Number=NaN,
    D::Number=NaN,
    v::Number=NaN,
    Q::Number=NaN,
    ρ::Number=0.997,
    μ::Number=0.0091,
    g::Number=981,
    fig::Bool=false
)
    a = isnan.([D, v, Q]) .!= 1
    if sum(a) != 1
        error("""h2fRe requires that either
            the hydraulic diameter,
            the flow speed or
            the flow rate
            be given alone.""")
    end
    b = isnan.([ε, k]) .!= 1
    if sum(b) != 1
        error("""h2fRe requires that either
            the pipe's roughness or
            the pipe's relative roughness
            be given alone.""")
    end
    if a == [1, 0, 0] && b == [1, 0]
        Re, f = hDeps2fRe(h, D, L, ε, ρ, μ, g, fig)
    elseif a == [1, 0, 0] && b == [0, 1]
        Re, f = hDeps2fRe(h, D, L, k / D, ρ, μ, g, fig)
    elseif a == [0, 1, 0] && b == [1, 0]
        Re, f = hveps2fRe(h, v, L, ε, ρ, μ, g, fig)
    elseif a == [0, 1, 0] && b == [0, 1]
        Re, f = hvthk2fRe(h, v, L, k, ρ, μ, g, fig)
    elseif a == [0, 0, 1] && b == [1, 0]
        Re, f = hQeps2fRe(h, Q, L, ε, ρ, μ, g, fig)
    elseif a == [0, 0, 1] && b == [0, 1]
        Re, f = hQthk2fRe(h, Q, L, k, ρ, μ, g, fig)
    end
end
