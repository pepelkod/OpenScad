
$fn=160;

module Clasp(width, diam){
    difference(){
        cylinder(d=diam*1.2, h=width, center=true);
        cylinder(d=diam, h=100, center=true);
        translate([3,-50,-50]){
            cube(100);
        }
    }
}

module Cross(diam, length){
    difference(){
        translate([-length/2,0,0]){
            rotate([0,90,0]){
                hull(){
                    translate([diam/2.5,0,0]){
                        cylinder(d=diam, h=length, center=true);
                    }
                    translate([-diam/2.5,0,0]){
                        cylinder(d=diam, h=length, center=true);
                    }
                }
            }           
        }    
        cylinder(d=diam+0.1, h=diam*2, center=true);
    }
}

module Half(width, diam, length){
    Cross(diam, length);
    Clasp(width, diam);
}

module Whole(width, diam, length){
    union(){
        translate([0,17,120]){
            import("GarminFemale.stl");
        }
        translate([length/2,0,0]){
            Half(width, diam, length/1.5);
        }
        translate([-length/2,0,0]){
            rotate([0, 0, 180]){
                Half(width, diam, length/1.5);
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
