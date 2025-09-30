
$fn=120;

module hole_swole_old(thick){
    difference(){
        // main body
        translate([0,thick/2,0]){
            intersection(){
                translate([0,-thick+thick*2,0]){
                    sphere(d=20);
                }
                translate([0,thick-thick*2,0]){
                    sphere(d=20);
                }
                translate([0, 0,0]){
                    cube([20,thick,20], center=true);
                }
            }
        }
        // rivnut recess
        rivnut_depth=1;
        translate([0,-5+rivnut_depth,0]){
            rotate([90,0,0]){
                cylinder(h=10, d=10, center=true);
            }
        }
    }
}
module hole_swole(big_r, small_r){
    difference(){
        rotate([90,0,0]){
            hull(){
                rotate_extrude(){
                    translate([big_r-small_r,0,0]){
                        circle(small_r);
                    }
                }
            }
        }
        // rivnut recess
        rivnut_depth=1;
        translate([0,-8+rivnut_depth,0]){
            rotate([90,0,0]){
                cylinder(h=10, d=10, center=true);
            }
        }
    }
}

module clamp(){
    od = 20;
    translate([0,od+1,0]){
        intersection(){
            difference(){
                cylinder(h=20, r=od, center=true);
                cylinder(h=21, r=16, center=true);
            }
            translate([0,-8,0]){
                rotate([0,90,0]){
                    cylinder(h=100, d=28,center=true);
                }
            }
        }
    }
}

module thing(){
    difference(){
        union(){
            clamp();
            hole_swole(big_r = 12, small_r=3);
        }
        // drill main hole
        translate([0,5,0]){
            rotate([90,0,0]){
                cylinder(h=20, d=6, center=true);
            }
        }
        // bolt head hole
        translate([0,10+2.5,0]){
            rotate([90,0,0]){
                cylinder(h=20, d=10, center=true);
            }
        }

    }
}

thing();