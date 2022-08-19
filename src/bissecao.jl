function bissecao(foo, x1, x2, tol)
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