struct ComponentTransform{N, BS<:NamedTuple{names}, AI, A0} <: Bijectors.Bijector
    bs::BS
    axin::AI
    axout::AO
end

function ComponentTransform(bs::NamedTuple)
    ax = Axis(nt)
end

inverse(t::ComponentTransform) =
