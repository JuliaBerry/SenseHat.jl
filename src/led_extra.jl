const JULIA_LOGO = begin
    R = RGB565(0.796,0.235,0.2)
    r = RGB565(0.835,0.388,0.361)
    G = RGB565(0.22,0.596,0.149)
    g = RGB565(0.376,0.678,0.318)
    P = RGB565(0.584,0.345,0.698)
    p = RGB565(0.667,0.475,0.757)
    z = RGB565(0.0,0.0,0.0)

    [z z z z z z z z;
     z z z G G z z z;
     z z G g g G z z;
     z z G g g G z z;
     z R R G G P P z;
     R r r R P p p P;
     R r r R P p p P;
     z R R z z P P z] |> rotl90 |> X -> flipdim(X,1)
end
