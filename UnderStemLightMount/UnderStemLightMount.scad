
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

module light_side(){

    intersection(){
        angled_cubes();
    
        linear_extrude(28, center=true){
            import("UnderstemLightMount.svg");
        }
    }
}

module stem_side(){

    intersection(){
        angled_cubes();
    
        linear_extrude(28, center=true){
            import("UnoStemProfileNarrower.svg");
        }
    }
    
}
module hinge_ring(ring_height,pin_dia, o_ratio, size_ratio){
    difference(){
        cylinder(h=ring_height*size_ratio, d=pin_dia*o_ratio, center=true);
        cylinder(h=100, d=pin_dia, center=true, $fn=20);
    }
}  
module hinge_side(pin_height, pin_dia, o_ratio, size_ratio){
    ring_height = pin_height/4;
    color("Red"){
        translate([0,0,ring_height/2+ring_height]){
            hinge_ring(ring_height, pin_dia, o_ratio, size_ratio);
        }
    }
    color("Blue"){
        translate([0,0,-ring_height/2]){
            hinge_ring(ring_height, pin_dia, o_ratio, size_ratio);
        }
    }
    translate([(pin_dia*o_ratio)/2+0.5, 0, 0]){
        cube([2,2,pin_height*size_ratio], center=true);
    }

}
module pin_end(pin_height, end_height, pin_dia,o_ratio){
        translate([0,0,(pin_height+end_height)/2]){
            cylinder(h=end_height, d=pin_dia*o_ratio, $fn=200, center=true);
        }
}

module hinge(
    pin_height=28,
    end_height=4,
    pin_dia=10,
    size_ratio=0.90,
    o_ratio=1.25){
    
    // left side
    hinge_side(pin_height,pin_dia, o_ratio, size_ratio);
    rotate([0,180,0]){
        color("Green"){
            hinge_side(pin_height, pin_dia, o_ratio, size_ratio);
        }
    }
    // pin
    union(){
        // top end
        pin_end(pin_height=pin_height, end_height=end_height, pin_dia=pin_dia, o_ratio=o_ratio);
        cylinder(h=pin_height, d=pin_dia*size_ratio, $fn=20,center=true);
        // bottom
        rotate([0,180,0]){
                pin_end(pin_height=pin_height,            end_height=end_height, pin_dia=               pin_dia, o_ratio=o_ratio);
        }


    }
    
}

module holder_with_hinge(){
    light_side();
    translate([0,-14.5,0]){
        rotate([90,0,0]){
            rotate([0,90,0]){
                hinge(pin_height=16, end_height=2, pin_dia=6);
   ;         }
        }
    }
    translate([0,-29,0]){
        rotate([180,0,0]){
            stem_side();
        }
    }
}
module holder_fixed_1_degree(){
    translate([0,26.85,0]){
        light_side();
    }
    rotate([181,0,0]){
        stem_side();
    }
    color("Purple"){
        translate([0, 15.5, 14]){
            linear_extrude(3, center=true){
                text("F", size=4, halign ="center", valign="center");
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