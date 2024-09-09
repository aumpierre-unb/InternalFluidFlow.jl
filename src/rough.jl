@doc raw"""
```
rough()
```

`rough` produces the representation of the
relation of Reynolds number and the Darcy friction factor
for a fully rough regime.

`rough` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function rough()
    u = range(log10(4e-5), log10(5e-2), length=30)
    z = 10 .^ u
    f = 1.01 .* (2 .* log10.(3.7 ./ z)) .^ -2
    foo(f, z) = f2Re(f=f, ε=z, turbulent=true).Re
    Re = foo.(f, z)
    plot!(
        Re, f,
        seriestype=:line,
        color=:darkgreen
    )
end
