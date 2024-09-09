using InternalFluidFlow
using Test

@testset "InternalFluidFlow.jl" begin
    @test begin
        moody = InternalFluidFlow.h2fRe(
            h=40,
            D=10,
            L=25e2,
            ε=2.7e-3,
            msgs=false
        )
        moody.Re - 119032 < 1 && moody.f - 0.0265 < 1e-4
    end

    @test isnothing(
        InternalFluidFlow.f2Re(f=1.3e-2, ε=5e-4, msgs=false)
    )

    @test begin
        moody = InternalFluidFlow.f2Re(
            f=2.8e-2,
            ε=1e-3
        )
        moody[1].Re - 2285 < 1 && moody[2].Re - 19800 < 1
    end

    @test begin
        moody = InternalFluidFlow.Re2f(
            Re=1e3,
            ε=1e-3
        )
        moody.f - 64 / 1e3 < 1e-5
    end
end
