

$fn=40;

module bar_clamp(){
    translate([0,0,-12]){
        rotate([90,0,0]){
            linear_extrude(40, center=true){
                import("BarClampVision.svg");
            }
        }
    }
    color("Green"){
        translate([-21,0,-21.5]){
            rotate([90,90,0]){
                cylinder(h=40, d=3, center=true);
                translate([2,1,0]){
                    cylinder(h=40, d=3, center=true);
                }
            }
        }
    }
    color("Orange"){
        translate([21,0,-21.5]){
            rotate([90,90,0]){
                cylinder(h=40, d=3, center=true);
                translate([2,-1,0]){
                    cylinder(h=40, d=3, center=true);
                }
            }
        }
    }

}

module remote_clamp(){
    union(){
        /*
        color("Red"){
            translate([0,0,2]){
                rotate([90,0,90]){
                    linear_extrude(40, center=true){
                        import("RemoteClamp.svg");
                    }
                }
            }
        }
        */
        color("Blue"){
            translate([0,0,2]){
                rotate([90,0,0]){
                    linear_extrude(40, center=true){
                        import("RemoteClampLong.svg");
                    }
                }
            }
        }
    }
}

module whole_thing(){
    union(){
        remote_clamp();
        bar_clamp();
        // attachment cylinders
        
        translate([15,0,-5.5]){
            rotate([90,90,0]){
                cylinder(h=40, d=5, center=true);
            }
        }
        translate([-15,0,-5.5]){
            rotate([90,90,0]){
                cylinder(h=40, d=5, center=true);
            }
        }

    }
}

module remote(){
    color("Black"){
        cube([41, 87, 7],center=true);
    }
}

whole_thing();
//remote();
//remote_clamp();
//bar_clamp();
