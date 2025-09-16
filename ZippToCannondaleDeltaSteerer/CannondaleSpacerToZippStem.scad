
$fn=120;


module top(thick=1){
    linear_extrude(thick, center=true){
        import("SpacerTop.svg");
    }
}


module bottom(thick=1){
    linear_extrude(thick, center=true){
        import("Spacer.svg");
    }
}
module steerer_hole(){
    linear_extrude(100, center=true){
        import("HoleCutter.svg");
    }
}
module top_cap_ring(){
    rotate_extrude(){
        translate([29.6/2, 0, 0]){
            circle(d=2.25);
        }
    }
}


module top_cap(){
    difference(){
        // core
        union(){
            hull(){
                // top profile
                translate([0,0,4.5]){
                    linear_extrude(1, center=true){
                        import("CannondaleConcealTopCap.svg");
                    }
                }
                // bottom profile
                cylinder(d=34.9, h=1);
                // raised edge
                translate([0,0,5.51]){
                    cylinder(h=1, d=30, center=true);
                }
            }
            // ring to sit inside topcap
            translate([0,0,5]){
                top_cap_ring();
            }

        }
        // hole through middle for steerer
        cylinder(h=100, d=28.95, center=true);
    }
}
    
module cable_hole_2d(){
    translate([14, 0, 0]){
        translate([4,0,0]){
            circle(4);
        }
        translate([3,0]){
            circle(4);
        }

        translate([2,0,0]){
            circle(4);
        }
        translate([1,0,0]){
            circle(4);
        }
        translate([0,0,0]){
            circle(4);
        }
    }
}
module cable_hole(){
    translate([0,24,0]){
        rotate([0,0,-90]){
            rotate([90,0,0]){
                rotate_extrude(angle = 107 ){
                    cable_hole_2d();
                }
            }
            translate([0,0,-1.9]){           
                linear_extrude(4, center=true){
                    cable_hole_2d();
                }
            }
        }
    }
}

module spacer(){
    difference(){
        union(){
            hull(){
                translate([0,0,20]){
                    top(1);
                }
                translate([0,0,0]){
                    bottom(5);
                }
            }
        }
        steerer_hole();
        // left cable  hole
        translate([-8,0,0]){
            cable_hole();
        }
            // right cable hole
        translate([8,0,0]){
            #cable_hole();
        }

    }
}
// two spacers

module two_top_caps(){
    // with full ring.
    translate([0,0,5]){
        top_cap_ring();
    }
    top_cap();
    
    // with ring cut by steerer 
    translate([35,0,0]){
        top_cap();
    }
}

two_top_caps();