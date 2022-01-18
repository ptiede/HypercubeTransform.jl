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

    @test transform(ca, 0.5) == 0.0
    @test transform(cb, 0.5) == 0.5
    @test transform(cc, 0.5) == Dists.quantile(c, 0.5)

    @inferred Float64 transform(ca, 0.5)
end

@testset "ArrayHC" begin
    d = Dists.Product([Dists.Normal(), Dists.Uniform(), Dists.Normal()])
    m = MT.For(d.v) do p
            return p
    end
    cd = ascube(d)
    cm = ascube(m)
    @test transform(cd, [0.5,0.5,0.5]) == transform(cm, [0.5,0.5,0.5])
    cc = ascube.(d.v)
    @test transform.(cc, [0.5,0.5,0.5]) == transform(cd, [0.5,0.5,0.5])
    @inferred Vector{Float64} transform(cm, [0.5, 0.5, 0.5])
end

@testset "Dirichlet" begin
    d = Dists.Dirichlet([1.0,1.0,1.0])
    a = Dists.Normal()
    dc = ascube(d)
    @inferred transform(dc, [0.5, 0.5, 0.5])
    p = rand(3, 10_000_00)
    x = transform.(Ref(dc), eachcol(p))
    @test isapprox(mean(x), mean(d), atol=1e-3)

    dad = ascube((a, d))
    @inferred transform(dad, [0.5,0.5,0.5,0.5])
    pad = rand(4, 10_000_00)
    xad = transform.(Ref(dad), eachcol(pad))
    mN = mean(first.(xad))
    mD = mean(last.(xad))
    @test isapprox(mN, mean(a), atol=1e-3)
    @test isapprox(mD, mean(d), atol=1e-3)

end
