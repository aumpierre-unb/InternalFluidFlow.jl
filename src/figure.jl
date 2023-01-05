using Plots
include("laminar.jl")
#include("turb.jl")
include("smooth.jl")
include("rough.jl")

@doc raw"""
`figure` produces a schematic Moody diagram with
a representation of the solution computed from inputs.

`figure` is an auxiliary function of
the `InternalFluidFlow` toolbox for Julia.
"""
function figure(eps)
    plot(xlabel="Re",
        ylabel="f",
        xlims=(1e2, 1e8),
        ylims=(6e-3, 1e-1),
        legend=false,
        framestyle=:box,
        scale=:log10,
        grid=:true,
        minorgrid=:true)
    laminar()
    if eps != 1e-5
        turb(1e-5)
    end
    if eps != 1e-4
        turb(1e-4)
    end
    if eps != 1e-3
        turb(1e-3)
    end
    if eps != 1e-2
        turb(1e-2)
    end
    if eps != 5e-2
        turb(5e-2)
    end
    rough()
    if eps != 0
        smooth()
    end
end
