
angle = -15; // [-45:45]
M = tan(angle);
echo("M", M);
Y = 10; // 
L = 30; // [0:50]

count = 50;
dz = L/count;


function hermetian_cubic_spline(z, L, M, Y) = 
    let(
        c4 = Y,
        c3 = M,
        c2 = -4*M/L -6* Y / L^2,
        c1 = -2 * (c2 * L + M)/ L^ 2,
        y = c1 * z^3 / 6  + c2 * z^2 / 2 + c3 * z + c4
    )
    (z < 0) ? M * z + Y :
    (z > L) ? 0 :
    y;
    
for (i = [-100:2* count -1]) {
    z = i * dz;
    r = hermetian_cubic_spline(z, L, M, Y);
    translate([r, 0, z]) sphere(d=1);
}

echo("hermetian_cubic_spline(L, L, M, Y) ", hermetian_cubic_spline(L, L, M, Y));



