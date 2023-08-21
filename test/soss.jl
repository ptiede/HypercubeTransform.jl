using Soss
using HypercubeTransform
import Distributions
const Dists = Distributions
using Test

@testset "Soss" begin
    m1 = @model begin
        a~Dists.Normal()
        b~Dists.Uniform()
        c~Dists.Gamma()
        return a*b/c
    end

    m2 = @model m1 begin
        z ~ m1
        y ~ Dists.Normal(z)
    end

    h2 = ascube(m2(m1=m1(),)|(y=1.0,))
    h1 = ascube(m1())
    @test dimension(h2) == dimension(h1)
    pos = [0.5, 0.5, 0.5, 0.5]
    @test transform(h1, pos) == transform(h2, pos)[1]
    @inferred transform(h2, pos)
end
