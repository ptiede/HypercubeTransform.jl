using Test
@testset "DeltaDist" begin

    @testset "DeltaDist creation" begin
        d1 = DeltaDist(5.0)
        @test length(d1) == 1
        @test eltype(d1) == Float64

        d2 = DeltaDist([1.0, 2.0, 3.0])
        @test length(d2) == 3
        @test eltype(d2) == Float64
    end

    @testset "DeltaDist logpdf" begin
        d = DeltaDist(5.0)
        @test Dists.logpdf(d, 5.0) == 0.0
        @test Dists.logpdf(d, 6.0) == 0.0

        d_arr = DeltaDist([1.0, 2.0])
        @test Dists.__logpdf(d_arr, [1.0, 2.0]) == 0.0
        @test Dists.__logpdf(d_arr, [3.0, 4.0]) == 0.0
    end

    @testset "DeltaDist rand" begin
        d = DeltaDist(5.0)
        rng = Random.default_rng()
        @test Dists.rand(rng, d) == 5.0

        d_arr = DeltaDist([1.0, 2.0])
        x = zeros(2)
        Dists._rand!(rng, d_arr, x)
        @test x == [1.0, 2.0]
    end

    @testset "DeltaDist product_distribution" begin
        d1 = DeltaDist(1.0)
        d2 = DeltaDist(2.0)
        pd = Dists.product_distribution([d1, d2])
        @test pd.x0 == [1.0, 2.0]
    end

    @testset "DeltaDist Transform" begin
        d1 = DeltaDist(5.0)
        d2 = DeltaDist([1.0, 2.0])
        d3 = Dists.Exponential()
        dt = TupleDist((d1, d2, d3))
        t = asflat(dt)
        out = transform(t, rand(dimension(t)))
        @test out[1] == d1.x0
        @test out[2] == d2.x0
    end
end
