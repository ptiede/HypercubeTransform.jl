



# function Dists.rand(d::ImageDirichlet)

# end




# function ChainRulesCore.rrule(
#             ::typeof(TV.transform_with),
#             flag::TV.LogJacFlag, t::ImageSimplex,
#             y::AbstractVector{T}, index) where {T}

#     n = t.n
#     ℓ = TV.logjac_zero(flag, T)


#     x = similar(y, n)
#     stick = one(T)
#     z = similar(y)
#     diag = similar(y) # this is diagonal of the jacobian

#     @inbounds for i in eachindex(y)
#         logn_m_i = log(n-i)
#         z[i] = logistic(y[i] - logn_m_i)
#         x[i] = stick*z[i]
#         index += 1

#         if !(flag isa TV.NoLogJac)
#             ℓ += log(stick) - TV.logit_logjac(z[i])
#         end

#         # use logistic here for additional numerical stability in diag
#         # also store this since it is needed all over the place
#         diag[i] = stick*z[i]*logistic(logn_m_i - y[i])

#         stick -= x[i]
#     end
#     x[end] = stick


#     function _transform_with_simplex(ΔX)
#         (Δx, Δℓ, _) = ΔX

#         Δf = NoTangent()
#         Δflag = NoTangent()
#         Δt = NoTangent()
#         Δindex = NoTangent()

#         Δy = similar(y)

#         acc = Δx[end]
#         # handle the end case
#         Δy[end] = diag[end]*(Δx[end-1] - acc)
#         if !(flag isa TV.NoLogJac)
#             Δy[end] += Δℓ*(1 + )
#         end
#         @views for i in reverse(eachindex(y[end-1:-1:begin]))
#             # This is needed for z[i+1]
#             # Here we have the transform part
#             acc = Δx[i+1]*z[i+1] + (1-z[i+1])*acc
#             Δy[i] = diag[i]*(Δx[i] - acc)
#             # here we have the logdetJ part
#             if !(flag isa TV.NoLogJac)
#                 Δy[i] += Δℓ(1 + )
#             end
#         end

#         return (Δf, Δflag, Δt, Δy, Δindex)
#     end
#     return (x, ℓ, index), _transform_with_simplex
# end
