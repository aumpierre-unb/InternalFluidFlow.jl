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
