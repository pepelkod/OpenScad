
module hextrude(h=4, d=5, grid_height=20, grid_width=10){
    grid_height_start=-grid_height/2;
    grid_height_end = grid_height/2;
    grid_width_start=-grid_width/2;
    grid_width_end=grid_width/2;
    for(j=[grid_height_start:1:grid_height_end]){
        //translate([j*d, abs((j%2)*d/2), 0]){
        translate([j*d, (abs(j%2)-0.5)*d/2, 0]){
            for(i=[grid_width_start:1:grid_width_end]){
                translate([0, i*d, 0]){
                    rand_vect=rands(0, 1, 1);
                    rand_val = (sqrt(rand_vect[0]));
                    echo("rand is ", rand_val);
                    cylinder(h=h, d=d*round(rand_val), $fn=6, center = true);
                }
            }
        }
    }
}

module test(){
    gh=10;
    gw=20;
    d=5;
    difference(){
        cube([gw*d,gh*d,2], center=true);
        
        intersection(){
            cube([gw*d-1,gh*d-1,3], center=true);
            hextrude();
        }
    }
}