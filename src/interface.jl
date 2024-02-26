struct FromFlat end
struct FromCube end


function transport end

transport(d::Distributions.Distribution, ::FromCube) = Bijectors.TransformedDistribution(d, ascube(d))
transport(d::Distributions.Distribution, ::FromFlat) = Bijectors.TransformedDistribution(d, asflat(d))
