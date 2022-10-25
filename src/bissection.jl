@doc raw"""
`bissection` computes computes the root of
a function using the method of bissection
given it is found between the guess values.

`bissection` is an auxiliary function of
the `InternalFluidFlow` toolbox for Julia.
"""
function bissection(foo, x1, x2, tol)
    while abs(foo(x2)) > tol
        x = (x1 + x2) / 2
        if foo(x) * foo(x1) > 0
            x1 = x
        else
            x2 = x
        end
    end
    return x2
end