# using Plots
# include("Re2f.jl")
# include("figure.jl")

@doc raw"""
`hDeps2fRe(h,D,L,eps,rho,mu,g,fig)`

`hDeps2fRe` computes the Reynolds number Re and
the Darcy friction factor f given
the head loss h,
the pipe's hydraulic diameter D,
the pipe's length L,
the pipe's relative roughness eps,
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
if taken, all other parameters must as well be given in cgs units.

If parameter fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hDeps2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hDeps2fRe(h, D, L, eps, rho, mu, g, fig)
    if eps > 5e-2
        eps = 5e-2
    end
    K = 2 * g * h * rho^2 * D^3 / mu^2 / L
    f = (-2 * log10(eps / 3.7 + 2.51 / K^(1 / 2)))^-2
    Re = (K / f)^(1 / 2)
    if Re > 2.3e3
        islam = false
    else
        Re = K / 64
        f = 64 / Re
        islam = true
    end
    if fig
        figure(eps)
        if !(Re < 2.3e3) && eps != 0
            turb(eps)
        end
        plot!([Re], [f],
            seriestype=:scatter,
            markerstrokecolor=:red,
            color=:red)
        display(plot!(
            (K ./ [6e-3; 1e-1]) .^ (1 / 2),
            [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    Re, f
end
