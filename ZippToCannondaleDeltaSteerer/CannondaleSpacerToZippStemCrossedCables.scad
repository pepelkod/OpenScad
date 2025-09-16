

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
    cable_out_angle=107;
    linear_len=10;
    translate([0,24,0]){
        rotate([0,0,-90]){
            // curve
            rotate([90,0,0]){
                rotate_extrude(angle = cable_out_angle ){
                    cable_hole_2d();
                }
            }
            // upper straight part
            rotate([0,-cable_out_angle,0]){
                translate([0,0,(linear_len/2)-0.1]){           
                    linear_extrude(linear_len, center=true){
                        cable_hole_2d();
                    }
                }
            }
            // lower straight part;
            translate([0,0,-(linear_len/2)+0.1]){           
                linear_extrude(linear_len, center=true){
                    cable_hole_2d();
                }
            }
        }
    }
}


module delta_steerer(){
    color("blue"){
        linear_extrude(100, center=true){
            import("DeltaSteerer.svg");
        }
    }
}

/*
color(c = [.5, .5, .5, .5]){
    delta_steerer();
}*/
module tapered_spacer(){
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
        translate([-12,0,-2]){
            rotate([0,0,-25]){
                cable_hole();
            }
        }
        // right cable hole
        translate([12,0,2]){
            rotate([0,0,25]){
                cable_hole();
            }
        }
        
        delta_steerer();

    }
}
module stem(){
    rotate([90-17,0,0]){
        linear_extrude(100, center=true){
            import("ZippStemProfile.svg");
        }
    }
}
    
module straight_spacer(){
    difference(){
        union(){
            hull(){
                translate([0,0,20]){
                    bottom(1);
                }
                translate([0,0,0]){
                    bottom(1);
                }
            }
        }
        steerer_hole();
        // left cable  hole
        translate([-12,0,0]){
            rotate([0,0,0]){
                cable_hole();
            }
        }
        // right cable hole
        translate([12,0,0]){
            rotate([0,0,0]){
                cable_hole();
            }
        }
        
        delta_steerer();

        translate([0,0,41.5]){
            stem();
        }

    }
}

straight_spacer();

