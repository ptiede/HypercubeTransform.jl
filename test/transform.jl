import Distributions
const Dists = Distributions
using Distributions: mean
using HypercubeTransform
using Test
using Statistics

@testset "Scalar" begin
    a = Dists.Normal()
    b = Dists.Uniform()
    c = Dists.Gamma()

    ca = ascube(a)
    cb = ascube(b)
    cc = ascube(c)

    fa = asflat(a)
    fb = asflat(b)
    fc = asflat(c)


    @test transform(ca, 0.5) == 0.0
    @test transform(cb, 0.5) == 0.5
    @test transform(cc, 0.5) == Dists.quantile(c, 0.5)

    @inferred Float64 transform(ca, 0.5)
end

@testset "ArrayHC" begin
    d = Dists.product_distribution([Dists.Normal(), Dists.Uniform(), Dists.Normal()])
    # m = MT.For(d.v) do p
    #         return p
    # end
    cd = ascube(d)
    pos = [0.5, 0.5, 0.5]
    x = transform(cd, pos)
    @test inverse(cd, x) ≈ pos
    cc = ascube.(d.v)
    @test transform.(cc, pos) == transform(cd, pos)
end

@testset "Dirichlet" begin
    d = Dists.Dirichlet([1.0,1.0,0.5])
    a = Dists.Normal()
    dc = ascube(d)
    pos = rand(2)
    ps = transform(dc, pos)
    @test inverse(dc, ps) ≈ pos
    @inferred transform(dc, [0.5, 0.5])

    p = rand(2, 10_000_00)
    x = transform.(Ref(dc), eachcol(p))
    @test isapprox(mean(x), mean(d), atol=1e-3)

    dad = ascube((a, d))
    @inferred transform(dad, [0.5,0.5,0.5])
    pad = rand(3, 50_000_00)
    xad = transform.(Ref(dad), eachcol(pad))
    mN = mean(first.(xad))
    mD = mean(last.(xad))
    @test isapprox(mN, mean(a), atol=1e-2)
    @test isapprox(mD, mean(d), atol=1e-2)

    dda = ascube((d, a))
    @inferred transform(dda, [0.5,0.5,0.5])
    pda = rand(3, 100_000_00)
    xda = transform.(Ref(dda), eachcol(pda))
    mN = mean(last.(xda))
    mD = mean(first.(xda))
    @test isapprox(mN, mean(a), atol=1e-2)
    @test isapprox(mD, mean(d), atol=1e-2)

    tf = asflat(d)
    x = randn(dimension(tf))
    y = transform(tf, x)
    @test length(y) == dimension(tf)+1
    @test inverse(tf, y) ≈ x
end

@testset "LogNormal" begin
    d1 = Dists.LogNormal(0.0, 1.0)
    t1 = asflat(d1)
    @test dimension(t1) == 1

    dN = Dists.MvLogNormal(5, 1.0)
    tN = asflat(dN)
    @test dimension(tN) == length(dN)
end

@testset "EmptyTuple" begin
    nt = (a = Dists.Uniform(), b = ())
    tc = ascube(nt)
    tf = asflat(nt)

    x = rand(dimension(tc))
    y = transform(tc, x)
    @test y.b isa Tuple{}
    @test inverse(tc, y) == x
end

@testset "MvNormal" begin
    d = Dists.MvNormal(ones(2), [ 2.0 0.1; 0.1 2.0])
    tc = ascube(d)

    s = rand(2, 10_000_000)
    p = transform.(Ref(tc), eachcol(s))

    @test isapprox(mean(p), ones(2), atol=5*2/sqrt(10_000_000))
    @test isapprox(cov(p), [ 2.0 0.1; 0.1 2.0], atol=50/sqrt(10_000_000))

end

@testset "Product" begin
    d = Dists.product_distribution([Dists.Uniform(), Dists.Uniform()])
    d2 = Dists.product_distribution([Dists.Uniform(), Dists.Normal()])

    t = asflat(d)
    @test dimension(t) == 2
    @test_throws AssertionError asflat(d2)
end
