using Plots
include("Re2f.jl")
include("figure.jl")

@doc raw"""
`Re,f=hQthk2fRe(h::Number,Q::Number,L::Number,k::Number=0,rho::Number=0.997,mu::Number=0.0091,g::Number=981,fig::Bool=false)`

`hQthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the volumetric flow rate Q,
the pipe's length L,
the pipe's roughness k,
the fluid's density rho,
the fluid's dynamic viscosity mu, and
the gravitational accelaration g.

By default, pipe is assumed to be 1 m long,
L = 100 (in cm).

By default, pipe is assumed to be smooth,
eps = 0. Relative roughness eps is reset to eps = 0.05,
if eps > 0.05.

By default, fluid is assumed to be water at 25 °C,
rho = 0.997 (in g/cc) and
mu = 0.0091 (in P),
and gravitational acceleration is assumed to be
g = 981 (in cm/s/s).
Please, notice that these default values are given in the cgs unit system and,
if taken, all other inputs must as well be given in cgs units.

If parameter fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hQthk2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hQthk2fRe(h, Q, L, k, rho, mu, g, fig)
    if k > 5e-2
        k = 5e-2
    end
    P = 2 * g * h * Q^3 / (pi / 4)^3 / (mu / rho)^5 / L
    foo(f) = 1 / f^(1 / 2) + 2 * log10(
        k / (rho * Q / (pi / 4) / mu / ((P / f)^(1 / 5)))
        /
        3.7 + 2.51 / (P / f)^(1 / 5) / f^(1 / 2))
    f = newtonraphson(foo, 1e-2, 1e-4)
    Re = (P / f)^(1 / 5)
    if Re > 2.3e3
        islam = false
    else
        Re = (P / 64)^(1 / 4)
        f = 64 / Re
        islam = true
    end
    D = rho * Q / Re / mu / (pi / 4)
    eps = k / D
    if fig
        figure(eps)
        if !(Re < 2.3e3)
            turb(eps)
        end
        plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!(
            (P ./ [6e-3; 1e-1]) .^ (1 / 5),
            [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    Re, f
end
