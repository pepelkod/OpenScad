


module remote_cutter(){
    difference(){
        translate([0, 0, 0]){
            cube([41.2, 19.2, 22], center=true);
        }
        translate([0,  15.9, (22-12)/1.99]){
            cube([34.5, 19.2, 12], center=true);
        }
    }
}

module body(){
    difference(){
        cube([48,   28, 44/2], center=true);
        translate([0,0,-1]){
            difference(){
                remote_cutter();
            }
        }
    }
}


module better_cover(){
    union(){
        difference(){
            cube([36.5, 2.1, 36.5], center=true);
            translate([0,1,34.5]){
                cube([40, 2.0, 36.5], center=true);
            }
        }
        translate([0,-2.0,0]){
            cube([26.5, 2.1, 2.0], center=true);
        }
    }
}
better_cover();
//body();