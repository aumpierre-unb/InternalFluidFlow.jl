using InternalFluidFlow
using Test

@testset "InternalFluidFlow.jl" begin
    @test begin
        moody = InternalFluidFlow.h2fRe(
            40,
            D=10,
            L=25e2,
            ε=2.7e-3
        )
        moody.Re - 119032 < 1 && moody.f - 0.0265 < 1e-4
    end

    @test begin
        moody = InternalFluidFlow.Re2f(
            1e3,
            ε=1e-3
        )
        moody.f - 64 / 1e3 < 1e-5
    end

    @test begin
        moody = InternalFluidFlow.f2Re(
            2.8e-2,
            ε=1e-3
        )
        moody[1].Re - 2285 < 1 && moody[2].Re - 19800 < 1
    end
end
