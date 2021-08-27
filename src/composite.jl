const NCube{N} = Tuple{Vararg{AbstractHypercubeTransform, N}}

struct TupleHC{T} <: VectorHC
    transformations::T
    dimension::Int
    function TupleHC(transformations::T) where {T<:NCube}
        new{T}(transformations, _sum_dimensions(transformations))
    end
    function TupleHC(transformations::T
                    ) where {N, S <: NCube, T <: NamedTuple{N,S}}
        new{T}(transformations, _sum_dimensions(transformations))
    end
end
ascube(transformations::NCube) = TupleHC(transformations)
ascube(dists::Tuple{Vararg{Union{Dists.Distribution, MT.AbstractMeasure},N}}) where {N}= ascube(ascube.(dists))

ascube(transformations::NamedTuple{N, <:NCube}) where {N} = TupleHC(transformations)

function ascube(dists::NamedTuple{N, <:Tuple{Vararg{Union{Dists.Distribution, MT.AbstractMeasure},M}}}) where {N,M}
    ascube(NamedTuple{N}(ascube.(values(dists))))
end
dimension(tt::TupleHC) = tt.dimension




"""
    $(SIGNATURES)
Helper function that steps through the transformation tuple
"""
function transform_tuple(tt::NCube, x, index)
    return _transform_tuple(x, index, tt)
end

# ends the tuple stepper
_transform_tuple(x::AbstractVector, index, ::Tuple{}) = (), index

# steps throught
function _transform_tuple(x::AbstractVector, index, ts)
    tfirst = first(ts)
    yfirst, index1 = _step_transform(tfirst, x, index)
    yrest, index2  = _transform_tuple(x, index1, Base.tail(ts))
    return (yfirst, yrest...), index2
end


function _step_transform(c::TupleHC{<:Tuple}, x, index)
    transform_tuple(c.transformations, x, index)
end

function _step_transform(c::TupleHC{<:NamedTuple{N}}, x, index) where {N}
    transformations = c.transformations
    y, index′ = transform_tuple(values(transformations), x, index)
    NamedTuple{keys(transformations)}(y), index′
end
