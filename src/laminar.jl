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
    Re = [500; 4000]
    f = 64 ./ Re
    display(plot!(Re, f,
        seriestype=:line,
        color=:black))
end
