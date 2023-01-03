using Plots

@doc raw"""
`laminar` produces the representation of the
relation of Reynolds number and the Darcy friction factor
by the Hagen-Poiseuille equation for Re < 2,300 given
the relative roughness.

`laminar` is an auxiliary function of
the `InternalFluidFlow` toolbox for Julia.
"""
function laminar()
    plot!([64 / 1e-1; 4e3], [1e-1; 64 / 4e3],
        seriestype=:line,
        color=:black)
end
