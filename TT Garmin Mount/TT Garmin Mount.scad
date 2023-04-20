
$fn=160;

module Clasp(width, diam){
    rotate([0,0,90]){
        difference(){
            cylinder(d=diam*1.3 , h=width, center=true);
            cylinder(d=diam, h=100, center=true);
            translate([4   ,-50,-50]){
                cube(100);
            }
        }
    }
}

module Cross(diam, length){
    //total_len=63;
    scale_amt = diam/37;
        rotate([0,-90,0]){
            difference(){
                translate([0, 0,  -length/2]){
                    linear_extrude(length){
                        scale(scale_amt){
                            import("KammTail.svg", center= true);
                        }
                    }
                }
                translate([0,0,-length/2]){
                    rotate([90,90,90]){
                        cylinder(d=diam, h=100, center=true);
                    }
                }
                translate([0,0,length/2]){
                    rotate([90,90,90]){
                        cylinder(d=diam, h=100, center = true);
                    }
                }
            }
      }
}

module Whole(width, diam, length){
    union(){
        // reinforce ring 
        translate([0,7,0]){
            rotate([90,0,0]){
                difference(){
                    cylinder(d=38, h=10, center=true);
                    cylinder(d=33, h=20, center=true);
                }
            }
        }
        // garmin mount
        rotate([3.5,0,0]){
            translate([0,14,120]){
                import("GarminFemale.stl");
            }
        }
        // clasp 1
        translate([length/2,0,0]){
            rotate([180, 0, 0]){
                Clasp(width, diam);
            }
        }
        // clasp21
        translate([-length/2,0,0]){
            rotate([180, 0, 0]){
                Clasp(width, diam);
            }
        }
        // cross / bridge
        Cross(diam, length);
        

    }
}
// const
inch = 25.4;
// vars
tt_diam = 22.2;
inside_to_inside = 69.51;
clamp_len = 40;
// calculated
center_to_center = inside_to_inside + tt_diam;

Whole(clamp_len, tt_diam, center_to_center);
