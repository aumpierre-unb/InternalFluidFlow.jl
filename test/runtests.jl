using InternalFluidFlow
using Test
using Plots

@testset "InternalFluidFlow.jl" begin
    @test abs(
        InternalFluidFlow.Re2f(1e3) - 64 / 1e3
    ) < 1e-5
    @test abs(
        InternalFluidFlow.Re2f(1e3, eps=1e-3, fig=true) - 64 / 1e3
    ) < 1e-5
end
