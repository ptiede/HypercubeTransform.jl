function _sum_dimensions(h)
    dim = 0
    for hh in values(h)
        dim += dimension(hh)
    end
    return dim
end
