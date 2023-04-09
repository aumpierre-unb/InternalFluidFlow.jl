@doc raw"""
`x=newtonraphson(f,x,tol)`

`newtonraphson` computes the root of
a function f(x) from a guess value x
within a given tolerance tol for f(x)
using the method of Newton-Raphson.

`newtonraphson` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function newtonraphson(f, x, tol)
    while abs(f(x)) > tol
        a = (f(x + 1e-7) - f(x)) / 1e-7
        x = x - f(x) / a
    end
    return x
end