const NCube{N} = Tuple{Vararg{TV.AbstractTransform, N}}

struct TupleHC{T} <: VectorHC
    transformations::T
    dimension::Int
    function TupleHC(transformations::T) where {T <: NCube}
        return new{T}(transformations, _sum_dimensions(transformations))
    end
    function TupleHC(
            transformations::T
        ) where {N, S <: NCube, T <: NamedTuple{N, S}}
        return new{T}(transformations, _sum_dimensions(transformations))
    end
end
ascube(transformations::NCube) = TupleHC(transformations)
ascube(dists::Tuple{Vararg{Union{Dists.Distribution}, N}}) where {N} = ascube(map(ascube, (dists)))

ascube(transformations::NamedTuple{N, <:NCube}) where {N} = TupleHC(transformations)

function ascube(dists::NamedTuple{N, <:Tuple{Vararg{Union{Dists.Distribution}, M}}}) where {N, M}
    return ascube(NamedTuple{N}(ascube.(values(dists))))
end
dimension(tt::TupleHC) = tt.dimension

@inline ascube(d::NamedTuple) = ascube(prototype(d)(ascube.(fieldvalues(d))))


"""
    $(SIGNATURES)
Helper function that steps through the transformation tuple
"""
function transform_tuple(tt::NCube, x, index)
    return _transform_tuple(x, index, tt)
end

# ends the tuple stepper
_transform_tuple(::AbstractVector, index, ::Tuple{}) = (), index

# steps through
function _transform_tuple(x::AbstractVector, index, ts)
    tfirst = first(ts)
    yfirst, index1 = _step_transform(tfirst, x, index)
    yrest, index2 = _transform_tuple(x, index1, Base.tail(ts))
    return (yfirst, yrest...), index2
end

# _inverse_eltype_tuple(ts::NCube, ys::Tuple) =
#     reduce(promote_type, map((t, y) -> inverse_eltype(t, y), ts, ys))

function _inverse!_tuple(x::AbstractVector, index, ts::NCube, ys::Tuple)
    for (t, y) in zip(ts, ys)
        index = _step_inverse!(x, index, t, y)
    end
    return index
end


function TV.inverse_eltype(tt::TupleHC, y::Type)
    return TV.inverse_eltype(TV.TransformTuple(tt.transformations), y)
end


function _step_transform(c::TupleHC{<:Tuple}, x, index)
    return transform_tuple(c.transformations, x, index)
end

function _step_inverse!(x::AbstractVector, index, tt::TupleHC{<:Tuple}, y::Tuple)
    transformations = tt.transformations
    @argcheck keys(transformations) == keys(y)
    # @argcheck length(x) == dimension(tt)
    return _inverse!_tuple(x, index, transformations, y)
end

function _step_transform(c::TupleHC{<:NamedTuple{N}}, x, index) where {N}
    transformations = c.transformations
    y, index′ = transform_tuple(values(transformations), x, index)
    return NamedTuple{keys(transformations)}(y), index′
end

# function TV.inverse_eltype(tt::TupleHC{<:NamedTuple}, y::NamedTuple)
#     transformations = tt.transformations
#     @argcheck keys(transformations) == keys(y)
#     return _inverse_eltype_tuple(values(transformations), values(y))
# end

function _step_inverse!(x::AbstractVector, index, tt::TupleHC{<:NamedTuple}, y::NamedTuple)
    transformations = tt.transformations
    @argcheck keys(transformations) == keys(y)
    # @argcheck length(x) == dimension(tt)
    return _inverse!_tuple(x, index, values(transformations), values(y))
end
