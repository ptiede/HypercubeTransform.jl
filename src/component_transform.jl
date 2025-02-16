struct ComponentTransform{T, Ax} <: TV.VectorTransform
    transformations::T
    axes::Ax
    dimension::Int
    function ComponentTransform(transformations::T, ax
                            ) where {N, S <: TV.NTransforms, T <: NamedTuple{N, S}}
        new{T, typeof(ax)}(transformations, ax, _sum_dimensions(transformations))
    end
end

dimension(tt::ComponentTransform) = tt.dimension

TV.as(ax::Axis, transformations) = ComponentTransform(transformations, ax)
TV.as(ax::Tuple{Axis}, transformations) = ComponentTransform(transformations, ax)

function TV.transform_with(flag::TV.LogJacFlag, tt::ComponentTransform, x::AbstractVector, index)
    data, index2 = _transform_components(flag, tt, x, index)
    out = ComponentVector(data[begin:end-1], tt.axes)
    ℓ = TV.logjac_zero(flag, eltype(out))
    if flag isa TV.LogJac
        ℓ = data[end]
    end
    return out, ℓ, index2
end

function TV.inverse_eltype(::ComponentTransform, ::ComponentVector{T}) where {T}
    return T
end

function TV.inverse_at!(x, index, t::ComponentTransform{T}, y::ComponentArray) where {N, T<:NamedTuple{N}}
    for n in N
        yn = getproperty(y, n)
        tn = getproperty(t.transformations, n)
        ycn = convert_comp_to_ttype(tn, yn)
        index = TV.inverse_at!(x, index, tn, ycn)
    end
    return index
end

convert_comp_to_ttype(t, x) = x
convert_comp_to_ttype(::TV.TransformTuple{<:Tuple}, x::Array) = Tuple(x)
function convert_comp_to_ttype(::TV.TransformTuple{<:NamedTuple{N}}, x::ComponentArray) where {N}
    NamedTuple(x)
end



function _transform_components(flag::TV.LogJacFlag, tt::ComponentTransform, x, index)
    (;transformations, axes) = tt
    data = similar(x, lastindex(axes[1])+1)
    data[end] = 0
    index2 = transform_components!(data, axes, flag, transformations, x, index)
    return data, index2
end

Base.@constprop :aggressive getvalproperty(tt::NamedTuple, k) = getproperty(tt, k)


@generated function transform_components!(data, axis, flag::TV.LogJacFlag, transformation::NamedTuple{N}, x, index) where {N}
    exprs = []
    push!(exprs, :(out = ComponentVector(@view(data[begin:end-1]), axis)))
    for k in N
        trf_sym = Symbol("trf_$k")
        y_sym = Symbol("y_$k")
        index_sym = Symbol("index_$k")
        ℓ_sym = Symbol("ℓ_$k")
        sym = QuoteNode(Symbol("$k"))
        push!(exprs, :($(trf_sym) = transformation.$k))
        push!(exprs, :(($(y_sym), $(ℓ_sym), $(index_sym)) = TV.transform_with(flag, $(trf_sym), x, index)))
        push!(exprs, :(index = $(index_sym)))
        push!(exprs, :(flexible_setproperty!(out, Val(Symbol($sym)), $(y_sym))))
        if flag === TV.LogJac
            push!(exprs, :(data[end] += $(ℓ_sym)))
        end
    end
    return quote
        $(exprs...)
        return index
    end
end


function TV._summary_rows(transformation::ComponentTransform, mime)
    (;transformations) = transformation
    repr1 = "ComponentArray of transformations"
    rows = TV._summary_row(transformation, repr1)
    _index = 0
    for (key, t) in pairs(transformations)
        for row in TV._summary_rows(t, mime)
            _repr = row.level == 1 ? (repr(key) * " → " * row.repr) : row.repr
            push!(rows, (level = row.level + 1, indices = TV._offset(row.indices, _index),
                         repr = _repr))
        end
        _index += TV.dimension(t)
    end
    rows
end
