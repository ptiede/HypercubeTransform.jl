import Distributions
const Dists = Distributions
using Distributions: mean
import MeasureTheory
const MT = MeasureTheory
using HypercubeTransform
using Test

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
    m = MT.For(d.v) do p
            return p
    end
    cd = ascube(d)
    cm = ascube(m)
    pos = [0.5, 0.5, 0.5]
    x = transform(cd, pos)
    @test transform(cd, pos) == transform(cm, pos)
    @test inverse(cd, x) ≈ pos
    cc = ascube.(d.v)
    @test transform.(cc, pos) == transform(cd, pos)
    @inferred Vector{Float64} transform(cm, pos)
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
    @test isapprox(mN, mean(a), atol=1e-3)
    @test isapprox(mD, mean(d), atol=1e-3)

    dda = ascube((d, a))
    @inferred transform(dda, [0.5,0.5,0.5])
    pda = rand(3, 50_000_00)
    xda = transform.(Ref(dda), eachcol(pda))
    mN = mean(last.(xda))
    mD = mean(first.(xda))
    @test isapprox(mN, mean(a), atol=1e-3)
    @test isapprox(mD, mean(d), atol=1e-3)


end
