using InternalFluidFlow
using Test

@testset "InternalFluidFlow.jl" begin
    @test all(
        abs.(
            InternalFluidFlow.h2fRe(
                40,
                D=10,
                L=25e2,
                ε=2.7e-3
            ) .- (119032, 0.0265)
        ) .< (1, 1e-4)
    )
    @test abs(
        InternalFluidFlow.Re2f(
            1e3,
            ε=1e-3
        ) - 64 / 1e3
    ) < 1e-5
    @test all(
        abs.(
            InternalFluidFlow.f2Re(
                2.8e-2,
                ε=1e-3
            ) .- [2285, 19800]
        ) .< [1, 1]
    )
end
