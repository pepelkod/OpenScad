
$fn=80;

module body(axle_dia=15){
    insert_len = 33.5;
    body_len = 45;
    body_dia = 28.6;
    
    // upper body
    difference(){
        translate([0,0,body_len/2]){
            cylinder(d=body_dia, h=body_len, center=true);
            // flat plate
            translate([0,body_dia/2-3,0]){
                cube([20,6,45], center=true);
            }
        }
        // side notch
        translate([0, -body_dia/2-8, body_dia/2+body_len/2]){
            union(){
                // angled entrance cuts
                translate([0,0,15]){
                    rotate([0,45,0]){
                        cube([22,100,22], center=true);
                    }
                }
                // vert slot
                translate([0,25,0]){
                    cube([22,10,30], center=true);
                }
                // round hole
                rotate([0,90,0]){
                    cylinder(d=body_dia*2, h=100, center=true);
                }
            }
        }
        
        
        //////////////////////
        // axle
        translate([0,0,32]){
            rotate([90,90,0]){
                cylinder(h=100, d=axle_dia, center=true);
            }
            translate([0,0,50]){
                cube([axle_dia,100, 100], center=true);
            }
        }
    }
    // lower insert
    difference(){
        translate([0,0,-insert_len/2]){
            cylinder(d=26, h=insert_len+0.1, center=true);
            // hole for pin
        }
        // pin hole
        translate([0,0,-17.25]){
            rotate([90,90,0]){
                cylinder(d=6.1, h=100, center=true);
            }
        }
    }
}


translate([15, 0, 0]){
    body(9+0.5);
}
translate([-15, 0, 0]){
    body(12+0.5);
}
translate([15, 30, 0]){
    body(15+0.5);
}