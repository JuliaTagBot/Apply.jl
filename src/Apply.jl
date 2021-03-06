module Apply

export apply, offset_apply
using Base: tail

apply(f::F, a::Tuple{A,Vararg}, args...) where {F,A} = 
    (f(a[1], args...), apply(f, tail(a), args...)...)
apply(f::F, a::Tuple{A,Vararg}, b::Tuple{B,Vararg}, args...) where {F,A,B} = 
    (f(a[1], b[1], args...), apply(f, tail(a), tail(b), args...)...)
apply(f::F, a::Tuple{A,Vararg}, b::Tuple{B,Vararg}, c::Tuple{C,Vararg}, args...) where {F,A,B,C} = 
    (f(a[1], b[1], c[1], args...), apply(f, tail(a), tail(b), tail(c), args...)...)

apply(f, ::Tuple{}, ::Tuple{}, ::Tuple{}, args...) = ()
apply(f, a, ::Tuple{}, ::Tuple{}, args...) = ()
apply(f, ::Tuple{}, b, ::Tuple{}, args...) = ()
apply(f, a, b, ::Tuple{}, args...) = ()
apply(f, ::Tuple{}, ::Tuple{}, args...) = ()
apply(f, a, ::Tuple{}, args...) = ()
apply(f, ::Tuple{}, args...) = ()


offset_apply(f, o::Tuple{O,Vararg}, a::AbstractArray, offset::Int, args...) where O = begin
    offset = f(o[1], a, offset, args...)
    offset_apply(f, tail(o), a, offset::Int, args...)
    nothing
end
offset_apply(f, a::AbstractArray, o::Tuple{O,Vararg}, offset::Int, args...) where O = begin
    offset = f(a, o[1], offset, args...)
    offset_apply(f, a, tail(o), offset::Int, args...)
    nothing
end
offset_apply(f, o::Tuple{O,Vararg}, offset::Int, args...) where O = begin
    offset = f(o[1], offset, args...)
    offset_apply(f, tail(o), offset::Int, args...)
    nothing
end
offset_apply(f, o::Tuple{}, offset::Int, args...) = nothing
offset_apply(f, a::AbstractArray, o::Tuple{}, offset::Int, args...) = nothing
offset_apply(f, o::Tuple{}, a::AbstractArray, offset::Int, args...) = nothing

end # module
