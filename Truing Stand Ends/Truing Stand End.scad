
$fn=80;

module body(axle_dia=15){
    insert_len = 33.5;
    body_len = 45;
    body_dia = 28.6;
    shim_len = 16;
    taper_len = 10;
    insert_dia = 26;
    taper_dia = insert_dia - 4;
    
    union(){
        translate([0,0,shim_len-1.2]){
          rotate([-5,0,0]){
            // upper body
            difference(){
                translate([0,0,body_len/2]){
                    cylinder(d=body_dia, h=body_len, center=true);
                    // flat plate
                    translate([0,body_dia/2-6,0]){
                        cube([30,12,45], center=true);
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
                        cylinder(h=100, d=axle_dia*1.01, center=true);
                    }
                    translate([0,0,50]){
                        cube([axle_dia*1.01,100, 100], center=true);
                    }
                }
            } // difference
          } // rotate
        } // translate
        // spacer between upper an insert
        translate([0,0,shim_len/2]){
            cylinder(d=body_dia, h=shim_len, center=true);
        }
        // lower insert
        difference(){
            translate([0,0,-insert_len/2]){
                cylinder(d=insert_dia, h=insert_len+0.1, center=true);
                // hole for pin
            }
            // pin hole
            translate([0,0,-17.25]){
                rotate([90,90,0]){
                    cylinder(d=6.1, h=100, center=true);
                }
            }
        }
        // lower insert taper
        translate([0,0,-(insert_len + taper_len/2)]){
            cylinder(d1=taper_dia, d2 = insert_dia, h=taper_len+0.1, center=true);
        }
        
    }
}


translate([15, 0, 0]){
    body(9+0.5);
}
/*
translate([-15, 0, 0]){
    body(12+0.5);
}
translate([15, 30, 0]){
    body(15+0.5);
}*/