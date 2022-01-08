
module hextrude(h=4, d=5, grid_height=20, grid_width=10, do_rand=true, coverage=80){
    //grid_height_start=-grid_height/2;
    //grid_height_end = grid_height/2;
    //grid_width_start=-grid_width/2;
    //grid_width_end=grid_width/2;
    grid_height_start = 0;
    grid_height_end = grid_height;
    grid_width_start = 0;
    grid_width_end = grid_width;

    translate([d*(-grid_height/2), d*(-grid_width/2)-d/4, 0]){
        for(h_idx=[grid_height_start:1:grid_height_end]){
            // should we toggle at center line?
            // calc the amount to shift up or down to hex_stack them
            half_shift_amt =  (h_idx%2)*d/2;
            // shift rows,  then up and down 1/2d to mesh    
            translate([h_idx*d, half_shift_amt , 0]){
                // create single row
                for(w_idx=[grid_width_start:1:grid_width_end]){
                    translate([0, w_idx*d, 0]){
                        rand_vect=rands(0, 99, 1);
                        rand_val = do_rand ? rand_vect[0]<coverage?0:1 : 1;
                        //echo("rand is ", rand_val);
                        cylinder(h=h, d=d*round(rand_val), $fn=6, center = true);
                    }
                }
            }
        }
    }
}

module test(gh=10, gw=20){
    d=5;
    difference(){
        cube([gw*d,gh*d,2], center=true);
        
        intersection(){
            cube([gw*d-1,gh*d-1,3], center=true);
            hextrude(grid_height=gh, grid_width=gw);
        }
    }
}


hextrude(grid_height=30, grid_width=30, do_rand=true);
