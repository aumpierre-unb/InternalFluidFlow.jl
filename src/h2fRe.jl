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
    lam::Bool=true, # default is search within laminar bounds
    turb::Bool=true, # default is search within turbulent bounds
    msgs::Bool=true, # default is show warning messages
    fig::Bool=false # default is hide plot
    )
```

`h2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h in cm,
the pipe hydraulic diameter D in cm or
the flow speed v in cm/s or
the volumetric flow rate Q in cc/s `(D or Q or v)`,
the pipe length L in cm (default L = 100 cm),
the pipe roughness k in cm or
the pipe relative roughness ε `(ε or k)`,
the fluid density ρ in g/cc (default ρ = 0.997 g/cc),
the fluid dynamic viscosity μ in g/cm/s (default μ = 0.0091 g/cm/s), and
the gravitational accelaration g in cm/s/s (default g = 981 cm/s/s).

`h2fRe` returns solutions found both
within laminar (Re < 4e3) and within turbulent (Re < 2.3e3) bounds.

Pipe is assumed to be 100 cm long (default is L = 100).

Fluid is assumed to be water at 25 °C, with
0.997 g/cc density and 0.0091 g/cm/s dynamic viscosity
(default is ρ = 0.997 and μ = 0.0091).

Gravitational acceleration is assumed to be 981 cm/s/s (default is g = 981).

Notice that default parameters are given in the cgs unit system and
all parameters must be given in a consistent unit system.

If lam = false is given then
`h2fRe` disregards the laminar flow bounds (Re < 4e3).

If turb = false is given then
`h2fRe` disregards the turbulent flow bounds (Re > 2.3e3).

It is possible that no solution be found
neither within laminar nor within turbulent bounds (see on examples).
Unless msgs = false is given, user will noticed.

If fig = true is given
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
the head loss h = 262 mm,
the pipe hydraulic diameter D = 10 mm,
the pipe length L = 25 m and
the pipe relative roughness ε = 0,
the fluid density ρ = 0.989 g/cc and
the fluid dynamic viscosity μ = 0.89 cP.
In this case, both laminar and turbulent
solutions are possible (at their limit bounds!):
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=262e-1, # head loss in cm
       D=10e-1, # volumetric flow rate in cc/s
       L=25e2, # pipe length in cm
       ε=0, # pipe relative roughness
       ρ=0.989, # fluid dynamic density in g/cc
       μ=8.9e-3, # fluid dynamic viscosity in g/cm/s
       fig=true # show plot
       )
Be aware that laminar flow bounds extends up to Re = 4e3.
(InternalFluidFlow.Moody(3967.280262309052, 0.016131958361507454, 0.0), InternalFluidFlow.Moody(2320.5810994094313, 0.047149745642806745, 0.0))
```

Compute the Reynolds number Re and
the Darcy friction factor f given
the head loss h = 270 mm,
the pipe hydraulic diameter D = 10 mm,
the pipe length L = 25 m and
the pipe relative roughness ε = 0.02,
the fluid density ρ = 0.989 g/cc and
the fluid dynamic viscosity μ = 0.89 cP.
This is an extraordinary situation as there is no solution
within laminar bounds (Re < 4e3) and
within turbulent bounds (Re > 2.3e3) and
`h2fRe` returns `Nothing`:
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=270e-1, # head loss in cm
       D=10e-1, # volumetric flow rate in cc/s
       L=25e2, # pipe length in cm
       ε=0.02, # pipe relative roughness
       ρ=0.989, # fluid dynamic density in g/cc
       μ=8.9e-3, # fluid dynamic viscosity in g/cm/s
       fig=true # show plot
       )
There is no solution within laminar bounds (Re < 4e3) or within turbulent bounds (Re < 2.3e3).
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 40 cm,
the pipe hydraulic diameter D = 10 mm,
the pipe length L = 25 m and
the pipe roughness k = 0.30 mm,
for water flow.
In this case, pipe roughness is converted to relative roughness ε = k / D and `h2fRe` is called again:
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=40, # head loss in cm
       D=10e-1, # pipe hyraulic diameter in cm
       L=25e2, # pipe length in cm
       k=0.30e-1 # pipe relative roughness
       )
InternalFluidFlow.Moody(2349.5105756354287, 0.06826085272582728, 0.03)
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
the pipe roughness k = 0.02 cm
for water flow and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible:
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=0.30e2, # head loss in cm
       v=25, # flow speed in cm/s
       L=25e2, # pipe length in cm
       k=0.02, # pipe roughness in cm
       fig=true # show plot
       )
(InternalFluidFlow.Moody(2157.181854298826, 0.029668337823471388, 0.02539434478880578), InternalFluidFlow.Moody(3844.1827631348333, 0.052870142887847124, 0.014250013799282117))
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.12 m,
the flow speed v = 23 cm/s,
the pipe length L = 25 m,
the pipe roughness k = 0.3 cm
for water flow and
show results on a schematic Moody diagram.
In this case, both laminar and turbulent
solutions are possible,
however laminar flow is extended to Re = 4e3 and
relative roughness is reassigned to maximum ε = 5e-2 for tubulent flow:
```
julia> h2fRe( # Reynolds number Re and Darcy friction factor f
       h=0.12e2, # head loss in cm
       v=23, # flow speed in cm/s
       L=25e2, # pipe length in cm
       k=0.3, # pipe roughness in cm
       fig=true # show plot
       )
Be aware that laminar flow bounds extends up to Re = 4e3.
Be aware that pipe roughness for turbulent flow is reassigned to k = 0.20701973225753548 cm. All other parameters are unchanged.
(InternalFluidFlow.Moody(3009.806001282173, 0.021263828955333366, 0.2511680263262789), InternalFluidFlow.Moody(10433.339517357244, 0.07370998224985127, 0.05))
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
    lam::Bool=true,
    turb::Bool=true,
    msgs::Bool=true,
    fig::Bool=false
)
    a = isnan.([D, v, Q]) .!= 1
    if sum(a) != 1
        if msgs
            printstyled(
                "h2fRe requires that either the hydraulic diameter, the flow speed or the volumetric flow rate be given alone.\n",
                color=:red
            )
        end
        return
    end

    b = isnan.([ε, k]) .!= 1
    if sum(b) != 1
        if msgs
            printstyled(
                "h2fRe requires that either the pipe roughness or the pipe relative roughness be given alone.\n",
                color=:red
            )
        end
        return
    end

    if a == [1, 0, 0] && b == [1, 0]
        hDeps2fRe(h=h, D=D, L=L, ε=ε, ρ=ρ, μ=μ, g=g, fig=fig, lam=lam, turb=turb, msgs=msgs)
    elseif a == [1, 0, 0] && b == [0, 1]
        hDeps2fRe(h=h, D=D, L=L, ε=k / D, ρ=ρ, μ=μ, g=g, fig=fig, lam=lam, turb=turb, msgs=msgs)
    elseif a == [0, 1, 0] && b == [1, 0]
        hveps2fRe(h=h, v=v, L=L, ε=ε, ρ=ρ, μ=μ, g=g, fig=fig, lam=lam, turb=turb, msgs=msgs)
    elseif a == [0, 1, 0] && b == [0, 1]
        hvthk2fRe(h=h, v=v, L=L, k=k, ρ=ρ, μ=μ, g=g, fig=fig, lam=lam, turb=turb, msgs=msgs)
    elseif a == [0, 0, 1] && b == [1, 0]
        hQeps2fRe(h=h, Q=Q, L=L, ε=ε, ρ=ρ, μ=μ, g=g, fig=fig, lam=lam, turb=turb, msgs=msgs)
    elseif a == [0, 0, 1] && b == [0, 1]
        hQthk2fRe(h=h, Q=Q, L=L, k=k, ρ=ρ, μ=μ, g=g, fig=fig, lam=lam, turb=turb, msgs=msgs)
    end
end
