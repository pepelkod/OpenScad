
module hextrude(h=4, d=5, grid_height=20, grid_width=10){
    grid_height_start=-grid_height/2;
    grid_height_end = grid_height/2;
    grid_width_start=-grid_width/2;
    grid_width_end=grid_width/2;
    
    echo("ghs ", grid_height_start);
    echo("ghe ", grid_height_end);
    for(h_idx=[grid_height_start:1:grid_height_end]){
        echo("h_idx ", h_idx);
        // should we toggle at center line?
        half_shift_odd = (grid_height%2==1) ? h_idx%2 : abs(h_idx%2);
        // calc the amount to shift up or down to hex_stack them
        half_shift_amt = (half_shift_odd-0.5)*d/2;
        // shift rows,  then up and down 1/2d to mesh    
        translate([h_idx*d, half_shift_amt , 0]){
            // create single row
            for(w_idx=[grid_width_start:1:grid_width_end]){
                translate([0, w_idx*d, 0]){
                    rand_vect=rands(0, 1, 1);
                    rand_val = (sqrt(rand_vect[0]));
                    //echo("rand is ", rand_val);
                    cylinder(h=h, d=d*round(rand_val), $fn=6, center = true);
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


hextrude(grid_height=5, grid_width=30);
