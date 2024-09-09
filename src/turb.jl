@doc raw"""
```
turb(
    ε::Number
)
```

`turb` produces the representation of the
relation of Reynolds number and the Darcy friction factor
by the Colebrook-White equation for Re > 2,300 given
the relative roughness.

`turb` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function turb(
    ε::Number;
    lineColor::Symbol=:black
)
    u = range(log10(2.3e3), log10(1e8), length=50)
    Re = 10 .^ u
    foo(Re, z) = Re2f(Re=Re, ε=z).f
    f = foo.(Re, ε)
    plot!(
        Re, f,
        seriestype=:line,
        color=lineColor
    )
end
