
//include <BOSL2/constants.scad>
//include <BOSL2/bottlecaps.scad>

// A custom mirror module that retains the original
// object in addition to the mirrored one.
module mirror_copy(v = [1, 0, 0]) {
    children();
    mirror(v) children();
}

$fn=180;

module angled_cubes(){
    angle = 10.5;
    offset = 3;

        union(){
            rotate([angle,0,0]){
                translate([0,0,-offset]){
                    cube([50,35,17], center=true);
                }
            }
            color("Red"){
                rotate([-angle,0,0]){
                    translate([0,0,offset]){
                        cube([50,35,17], center=true);
                    }
                }
            }
        }
}

module light_side(profile="LightClipProfile.svg"){

    intersection(){
        angled_cubes();
    
        linear_extrude(28, center=true){
            import(profile);
        }
    }
}

module stem_side(profile="UnoStemProfile.svg"){

    intersection(){
        angled_cubes();
    
        linear_extrude(28, center=true){
            import(profile);
        }
    }
    
}

module pin_end(pin_height, end_height, pin_dia,o_ratio){
        translate([0,0,(pin_height+end_height)/2]){
            cylinder(h=end_height, d=pin_dia*o_ratio, $fn=200, center=true);
        }
}


module holder_fixed_1_degree(){
    union(){
        translate([0,26.85,0]){
            scale([1,1,1.05]){
                light_side("LightClipProfileInset.svg");
            }
            light_side("LightClipProfile.svg");
        }
        rotate([181,0,0]){
            stem_side("UnoStemProfile.svg");
            scale([1,1,1.05]){
                stem_side("UnoStemProfileInset.svg");
            }
        }
        color("Purple"){
            translate([0, 15.5, 14]){
                linear_extrude(3, center=true){
                    text("F", size=4, halign ="center", valign="center");
                }
            }
        }
    }
}

holder_fixed_1_degree();

// stem dims
//34.8 wide
//34.5 tall
//35.3 angle


/*
hinge(pin_height=16, end_height=2, pin_dia=6, size_ratio=0.9);
translate([15, 0, 0]){
    hinge(pin_height=16, end_height=2, pin_dia=6, size_ratio=0.93);
}

translate([30, 0, 0]){

hinge(pin_height=16, end_height=2, pin_dia=6, size_ratio=0.96);
}
*/
