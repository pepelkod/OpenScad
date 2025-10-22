
include <../BOSL2/std.scad>

$fn=60;

module get_light(){
    translate([20,10,-0.5]){
        rotate([-4,0,0]){
            rotate([0,-2,0]){
                translate([0,0,-28]){
                    rotate([38,0,-56]){
                        import("C:\\Users\\pepel\\Projects\\Three Dee Scans\\NiteRider v3 top\\Merge_01_mesh_simp.stl");
                    }
                }
            }
        }
    }
}  
module flat_bracket_quick(){
    import("flat_bracket.stl");
}
module flat_bracket(){
    // main bracket body
    difference(){
        translate([-15, 10,0.0]){
            cube([41,8,23], center=true);
        }
        get_light();
        // cut notch for tabs
        translate([-50,10,0]){
            cuboid([60,60,7.6], rounding=3.6);
        }
        // cut down tab sizes
        translate([0,17.3,15]){
            cube([100,10,10], center=true);
        }
        // cut down tab sizes
        translate([0,17.3,-15]){
            cube([100,10,10], center=true);
        }
    }
    // add levers
    translate([-40,12.2,6.2]){
        cuboid([20,4,5], rounding=2);
    }
    translate([-40,12.2,-6.4]){
        cuboid([20,4,5], rounding=2);
    }
    
}

module nite_rider_clamp_quick(){
    import("nite_rider_clamp.stl");
}
module hulled_nite_rider(length=30){
            hull(){
                intersection(){
                    get_light();
                    cube([length,100,100], center=true);
                }
            }

}
module nite_rider_clamp_quick(){
    import("nite rider clamp.stl");
}
module nite_rider_clamp(length){
    difference(){
        scale(1.12){
            /* hulled_nite_rider();*/
            import("hulled_nite_rider.stl");
        }
        // hollow out center
        intersection(){
            get_light();
            translate([1,0,0]){
                cube([length+6,100,100], center=true);
            }
        }
        // notch out bottom
        translate([0,-17 ,0]){
            rotate([45,0,-10]){
                cube([100,30,30],center=true);
            }
        }
    }
}

module stem_clamp_import(length){    
    linear_extrude(length){
        import("Zipppp Service Course Profile merged image.svg");
    }
}
module inside_curve(){
    difference(){
        translate([5,0,0]){
            cube([4,4,100.2], center=true);
        }
        cuboid([8,4,800], rounding=2);
        
    }
}
module rounded_cut(){
            // rounded cut
        translate([-14.5,16.9,-0]){
            rotate([0,0,40]){
                inside_curve();
            }
        }
    }
module stem_clamp(length){
    scaleamt = 1.15;
    difference(){
        hull(){
        scale([scaleamt, scaleamt, scaleamt]){
            stem_clamp_import(length);
        }}
        translate([0,0,-0.1]){
            scale([1,1,10]){
                stem_clamp_import();
            }
        }
        // rounded cut
        rounded_cut();
        mirror([1,0,0]){
            rounded_cut();
        }
        // middle 
        translate([0,22,0]){
            rotate([0,0,45]){
                cube([18,18,800], center=true);
            }
        }
    }    
}

module whole_body(){
    /*
    translate([-0.6,-36.7,4]){
        rotate([0,90,0]){
            flat_bracket_quick();
        }
    }*/
    nite_rider_clamp_quick();
    translate([-18,42.5,0]){
        rotate([-2,90,0]){
            color("Blue"){
                stem_clamp(30);
            }
        }
    }
    translate([-13,18,0]){
        color("Red"){
            cuboid([8,6,4], rounding=2);
        }
    }
}
whole_body();
