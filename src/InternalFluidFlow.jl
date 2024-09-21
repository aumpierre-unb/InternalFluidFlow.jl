@doc raw"""
`InternalFluidFlow` provides a set of functions designed to solve problems 
of steady incompressible internal fluid flow. All functions are based on the Poiseuille condition 
for laminar flow, the Colebrook-White equation for turbulent flow, 
and the Darcy-Weisbach equation for head loss.

Author: Alexandre Umpierre `aumpierre@gmail.com`

Maintainer's repository: `https://github.com/aumpierre-unb/InternalFluidFlow.jl`

Citation (all versions): `DOI 10.5281/zenodo.7019888`

See also: `Re2f`, `f2Re`, `h2fRe` and `doPlot`.
"""
module InternalFluidFlow

using Plots
using Images
using Test

export Re2f, f2Re, h2fRe, doPlot

struct Moody
    Re::Float64
    f::Float64
    ε::Float64
end

include("newtonraphson.jl")
include("laminar.jl")
include("turb.jl")
include("smooth.jl")
include("rough.jl")
include("Re2f.jl")
include("f2Re.jl")
include("hDeps2fRe.jl")
include("hDthk2fRe.jl")
include("hveps2fRe.jl")
include("hvthk2fRe.jl")
include("hQeps2fRe.jl")
include("hQthk2fRe.jl")
include("h2fRe.jl")
include("doPlot.jl")

end
