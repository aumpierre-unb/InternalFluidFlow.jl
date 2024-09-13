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

    @test isnothing( # Re > 4e3 for laminar and Re < 2.3e3 for turbulent
        InternalFluidFlow.h2fRe(
            h=1.8,
            D=1 * 2.54,
            L=25e2,
            ε=0.027
        )
    )

    @test isnothing( # k and ε can not both be given
        InternalFluidFlow.h2fRe(
            h=40,
            D=10,
            L=25e2,
            ε=2.7e-3,
            k=2.7e-3,
            msgs=false
        )
    )

    @test isnothing( # D and v can not both be given
        InternalFluidFlow.h2fRe(
            h=40,
            D=10,
            v=12,
            L=25e2,
            ε=2.7e-3,
            msgs=false
        )
    )

    @test isnothing( # f is too low for laminar and too high for turbulent given ε
        InternalFluidFlow.f2Re(
            f=1.3e-2,
            ε=5e-4,
            msgs=false
        )
    )

    @test begin
        moody_lam, moody_turb = InternalFluidFlow.f2Re(
            f=2.8e-2,
            ε=1e-3,
            msgs=false
        )
        moody_lam.Re - 2285 < 1 && moody_turb.Re - 19800 < 1
    end

    @test begin
        moody = InternalFluidFlow.Re2f(
            Re=1e3,
            ε=1e-3,
            msgs=false
        )
        moody.f - 64 / 1e3 < 1e-5
    end
end
