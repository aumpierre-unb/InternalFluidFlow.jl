# using Plots
# include("Re2f.jl")
# include("figure.jl")

@doc raw"""
`hvthk2fRe(h,v,L,k,rho,mu,g,fig)`

`hvthk2fRe` computes the Reynolds number Re and
the Darcy friction factor f, given
the head loss h,
the flow speed v,
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
if taken, all other parameters must as well be given in cgs units.

If parameter fig = true is given, a schematic Moody diagram
is plotted as a graphical representation
of the solution.

`hvthk2fRe` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function hvthk2fRe(h, v, L, k, rho, mu, g, fig)
    if k > 5e-2
        k = 5e-2
    end
    Re::Vector{Float64} = []
    f::Vector{Float64} = []
    M = 2 * g * mu * h / v^3 / rho / L
    foo(f) = 1 / f^(1 / 2) + 2 * log10(
        k / (f / M * mu / rho / v)
        /
        3.7 + 2.51 / (f / M) / f^(1 / 2))
    f_ = newtonraphson(foo, 1e-2, 1e-4)
    Re_ = f_ / M
    isturb = false
    if Re_ > 2.3e3
        Re = [Re_; Re]
        f = [f_; f]
        D = Re_ * mu / rho / v
        eps = k / D
        isturb = true
    end
    Re_ = (64 / M)^(1 / 2)
    if Re_ < 2.3e3
        Re = [Re_; Re]
        f = [64 / Re_; f]
    end
    if !isturb
        D = Re_ * mu / rho / v
        eps = k / D
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
            [6e-3; 1e-1] / M,
            [6e-3; 1e-1],
            seriestype=:line,
            color=:red,
            linestyle=:dash))
    end
    Re, f
end
