@doc raw"""
```
laminar()
```

`laminar` produces the representation of the
relation of Reynolds number and the Darcy friction factor
by the Hagen-Poiseuille equation for Re < 2,300 given
the relative roughness.

`laminar` is an internal function of
the `InternalFluidFlow` toolbox for Julia.
"""
function laminar()
    f = [1e-1, 64 / 4e3]
    plot!(
        64 ./ f, f,
        seriestype=:line,
        color=:black
    )
end
