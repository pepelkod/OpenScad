
$fn=80;

hbod = 10;
hcap = 30;
hole_offset = -7.2;
stem_dia = 6.2;

module cap_layer(scale=1, pos=1, extrude_scale){
    color([rands(0,1,1)[0],rands(0,1,1)[0],rands(0,1,1)[0]]){

        translate([0,0,pos]){
            scale([scale/10, scale/10, 1])
            linear_extrude(height = 1, center = true, convexity = 0, scale=extrude_scale, $fn=100){
                import("Aero Valve Stem.svg", center=true);
            }
        }
    }
}
module cap_part(){
    power = 0.5;
    // 10/ sqrt(11)   scaled back to 10 on bottom
    // sqrt 11 is from "next_scale" being sqrt(10+1) on //last layer
    scale(3.0151134457776362264681206697006){
        translate([0,0,10.5]){
            rotate([180,0,0]){
                union(){
                    for(scale = [10 : -0.1 : 0]){
                        nonlinear_scale = pow(scale, power);
                        next_scale = pow(scale+1, power);
                        extrude_scale = next_scale/nonlinear_scale;
                        cap_layer(nonlinear_scale, scale, extrude_scale);
                    }
                }
            }
        }
    }
}

module cap(){
    // cap
    translate([0,0,hbod]){
        valve_hole_height = 11;
        difference(){
            scale([1, 1, 0.4]){
                cap_part();
            }
            // nut holder
            translate([hole_offset,0,0]){
                cylinder(h=3, d=10, center=true);
            }
            // valve stem
            translate([hole_offset,0,valve_hole_height/2]){
                cylinder(h=valve_hole_height, d1=stem_dia, d2=stem_dia/3, center=true);
            }
            // valve stem
            
        }
    }
}

module rim(){
        // rim cutaway
    rotate([90,90,0]){
        translate([-550,0,0]){
            rotate_extrude(angle = 360, convexity = 2, $fn=240){
                translate([550,0,0]){
                    import("Fake Rim Profile.svg", center=false);
                }
            }
        }
    }
}
module body(){
    difference(){
        // body
        translate([0,0,hbod/2]){
            difference(){
                linear_extrude(height = hbod, center = true,  $fn=100){
                    import("Aero Valve Stem.svg", center=true);
                }
                // valve stem hole
                translate([hole_offset,0,0]){
                    cylinder(h=100, d=stem_dia, center=true);
                }
            }
        }
        // rim cutaway
        translate([0,0,8]){
            rim();
        }
    }
}

body();
cap();