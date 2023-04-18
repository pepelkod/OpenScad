
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
    total_len=63;
    scale_amt = diam/38;
    scale(scale_amt){
        translate([-16,-0, -total_len/2]){
            rotate([0,-90,0]){
                difference(){
                    linear_extrude(length){
                        import("KammTail.svg");
                    }
                    translate([0,0,-14]){
                        rotate([90,90,90]){
                            cylinder(r=diam*.85, h=100);
                        }
                    }
                }
            }
        }
    }
}
module CrossOld(diam, length){
    difference(){
        translate([-length/2,0,0]){
            rotate([0,90,0]){
                difference(){
                    hull(){
                        translate([diam/2.5,0,0]){
                            cylinder(d=diam, h=length, center=true);
                        }
                        translate([-diam/2.5,0,0]){
                            cylinder(d=diam, h=length, center=true);
                        }
                    }
                    translate([0,6,0]){
                        hull(){
                            translate([diam/3,0,0]){
                                cylinder(d=diam, h=length+1, center=true);
                            }
                            translate([-diam/3,0,0]){
                                cylinder(d=diam, h=length+1, center=true);
                            }

                        }
                    }
                }
            }
        }    
        cylinder(d=diam+0.1, h=diam*2, center=true);
        translate([-diam/2+1, 4, -diam]){
            cube([diam, diam, diam*2]);
        }
    }
}

module Half(width, diam, length, rotate_clasp_amt=180){
    rotate([rotate_clasp_amt,0,0]){
        translate([0,4,0]){
            Clasp(width, diam);
        }
    }
    Cross(diam, length);

}

module Whole(width, diam, length){
    union(){
        // reinforce ring 
        translate([0,8.5,0]){
            rotate([90,0,0]){
                difference(){
                    cylinder(d=38, h=15, center=true);
                    cylinder(d=33, h=20, center=true);
                }
            }
        }
        rotate([3.5,0,0]){
            translate([0,18,120]){
                import("GarminFemale.stl");
            }
        }
        translate([length/2,0,0]){
            rotate([0, 0, 0]){
                Half(width, diam, length, rotate_clasp_amt=180);
            }
        }
        translate([-length/2,0,0]){
            rotate([0, 0, 180]){
                Half(width, diam, length, rotate_clasp_amt=0);
            }
        }
    }
}
// const
inch = 25.4;
// vars
tt_diam = 22.25;
inside_to_inside = 69.51;
clamp_len = 40;
// calculated
center_to_center = inside_to_inside + tt_diam;

Whole(clamp_len, tt_diam, center_to_center);
