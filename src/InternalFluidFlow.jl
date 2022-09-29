@doc raw"""

`InternalFluidFlow` provides a set of functions designed to solve problems 
of steady incompressible internal fluid flow. All functions are based on the Poiseuille condition 
for laminar flow, the Colebrook-White equation for turbulent flow, 
and the Darcy-Weisbach equation for head loss.

All function offer the option of plotting the solution 
on a schematic Moody diagram. Check the functions' syntaxes at Julia's help.

See also: `Re2f`, `f2Re`, `hDeps2fRe`, `hveps2fRe`, `hvthk2fRe`, `hQeps2fRe`, `hQthk2fRe`.
"""
module InternalFluidFlow

using Plots
using Test

export Re2f, f2Re, hDeps2fRe, hveps2fRe, hQeps2fRe, hvthk2fRe, hQthk2fRe

include("Re2f.jl")
include("f2Re.jl")
include("hDeps2fRe.jl")
include("hveps2fRe.jl")
include("hvthk2fRe.jl")
include("hQeps2fRe.jl")
include("hQthk2fRe.jl")
include("laminar.jl")
include("turb.jl")
include("smooth.jl")
include("rough.jl")
include("bissecao.jl")
include("figure.jl")

end
