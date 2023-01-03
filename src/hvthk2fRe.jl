using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hvthk2fRe(h,v,L,thk[,rho[,mu[,g[,fig]]]])`

`hvthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the flow speed v,
the pipe's length L,
the pipe's roughness thk,
the fluid's density rho,
the fluid's dynamic viscosity mu, and
the gravitational accelaration g.

By default, fluid is assumed to be water at 25 °C,
rho = 0.997 (in kg/L) and
mu = 0.91 (in cP),
and gravitational acceleration is assumed to be
g = 9.81 (in m/s/s).
Please, notice that these default values are given in the cgs unit system and,
if taken, all other inputs must as well be given in cgs units.

If fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hvthk2fRe` is a main function of
the `InternalFluidFlow` toolbox for Julia.

See also: `Re2f`, `f2Re`, `hDeps2fRe`, `hveps2fRe`, `hQeps2fRe`, `hQthk2fRe`.

Examples
==========
Compute the Reynolds number Re and
the Darcy friction factor f, given
the head loss h = 0.40 m,
the flow speed v = 1.1 m/s,
the pipe's length L = 25 m and
roughness thk = 0.27 mm,
for water flow:
```
h=40;v=1.1e2;L=2.5e3;thk=2.7e-2; # inputs in cgs units
Re,f=hvthk2fRe(h,v,L,thk)
```

Compute the Reynolds number Re and
the Darcy friction factor f, given
in addition
the fluid's density rho = 0.989 g/cc and
dynamic viscosity mu = 0.89 cP:
```
h=40;v=1.1e2;L=2.5e3;thk=2.7e-2;rho=0.989;mu=8.9e-3; # inputs in cgs units
Re,f=hvthk2fRe(h,v,L,thk,rho,mu)
```
Compute Re and f and plot a schematic Moody diagram:
```
Re,f=hvthk2fRe(0.40,1.1,25,2.7e-4,989,8.9e-4,9.81,true) # inputs in a consistent system of units
```
"""
function hvthk2fRe(h::Number, v::Number, L::Number, thk::Number, rho::Number=0.997, mu::Number=0.91, g::Number=981, fig::Bool=false)
    Re = []
    f = []
    M = 2 * g * mu * h / v^3 / rho / L
    foo(f) = 1 / f^(1 / 2) + 2 * log10(
        thk / (f / M * mu / rho / v)
        /
        3.7 + 2.51 / (f / M) / f^(1 / 2))
    f_ = newtonraphson(foo, 1e-2, 1e-4)
    Re_ = f_ / M
    lam = true
    if Re_ > 2.3e3
        Re = [Re_; Re]
        f = [f_; f]
        D = Re_ * mu / rho / v
        eps = thk / D
        lam = false
    end
    Re_ = (64 / M)^(1 / 2)
    if Re_ < 2.3e3
        Re = [Re_; Re]
        f = [64 / Re_; f]
    end
    if lam
        D = Re_ * mu / rho / v
        eps = thk / D
    end
    if fig
        figure(eps)
        if !(Re[end] < 2.3e3)
            turb(eps)
        end
        plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!(
            [6e-3; 1e-1] / M,
            [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    return [Re; f]
end
