using .Soss

export hform
hform(m::Soss.ConditionalModel{A, B}, _data::NamedTuple) where {A,B} = hform(m | _data)


"""
    hform(m)
Create the hypercube transform from Soss models that moves from the
unit hypercube to the model parameter space. To transform use the transform function
"""
function hform(m::Soss.ConditionalModel{A,B}) where {A,B}
    return _hform(Soss.getmoduletypencoding(m),
                  Soss.Model(m),
                  Soss.argvals(m),
                  Soss.observations(m)
                  )
end

sourceHform(m::Model) = sourceHform()(m)

function sourceHform(_data=NamedTuple())
    function (_m::Model)
        _datakeys = Soss.getntkeys(_data)
        proc(_m, st::Soss.Assign) = :($(st.x) = $(st.rhs))
        proc(_m, st::Soss.Return) = nothing
        proc(_m, st::Soss.LineNumber) = nothing

        function proc(_m, st::Soss.Sample)
            x = st.x
            xname = QuoteNode(x)
            rhs = st.rhs

            thecode = Soss.@q begin
                _t = hform($rhs, get(_data, $xname, NamedTuple()))
                if !isnothing(_t)
                    _result = merge(_result, ($x=_t,))
                end
            end

            Soss.isleaf(_m, st.x) || pushfirst!(thecode.args, :($x = Soss.testvalue($rhs)))

            return thecode
        end

        wrap(kernel) = Soss.@q begin
            _result=NamedTuple()
            $kernel
            $ascube(_result)
        end

        Soss.buildSource(_m, proc, wrap) |> Soss.MacroTools.flatten
    end
end


hform(d, _data) = nothing
hform(d::Union{Dists.Distribution, MT.AbstractMeasure}, _data) = d


Soss.@gg function _hform(M::Type{<:Soss.TypeLevel},
                         _m::Model{Asub,B},
                         _args::A,
                         _data) where {Asub, A,B}

    body = Soss.type2model(_m) |> sourceHform(_data) |> Soss.loadvals(_args, _data)
    Soss.@under_global Soss.from_type(Soss._unwrap_type(M)) Soss.@q let M
        $body
    end
end
