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
    N = 50
    u = log10(2.3e3):(log10(1e8)-log10(2.3e3))/(N-1):log10(1e8)
    Re = 10 .^ u
    Re2f_(Re, z) = Re2f(Re, ε=z).f
    f = Re2f_.(Re, ε)
    plot!(Re, f,
        seriestype=:line,
        color=lineColor)
end
