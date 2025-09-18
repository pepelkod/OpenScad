
include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;

include <../BOSL2/std.scad>
//use <helix.scad>
//use <path_extrude.scad>

//cuboid([30,40,50], rounding=10);

module faceplate(){
    intersection(){
        translate([0,36,0]){
            cube([60, 40, 30], center=true);
        }
        /*
        #translate([-25, 0, -12.5]){
            import("Cable_stop_7.STL");
        }*/
        translate([-5.5, -3, -5]){
            rotate([-90,0,0]){
                import("cannondale v14.stl");
            }
        }
    }
}

module faceplate2(){
    linear_extrude(){
        import("hole.svg");
    }
}
//faceplate2();

module faceplate_end(big_r=22, small_r=1.5){
    translate([big_r, 0,0]){
        intersection(){
            rotate_extrude(){
                translate([22,0,0]){
                    circle(small_r);
                }
            }
            translate([big_r,0,0]){
                cube([50,50,50], center=true);
            }
        }
    }
}
module faceplate_side(big_r=22, small_r=1.5){
    translate([0, big_r, 0]){
        rotate([0,90,0]){
            cylinder(h=big_r*2+0.1, r=small_r, center=true);
        }
    }
}


module faceplate3(){
    small_r=4;
    hull(){
    mirror([1,0,0]){
        faceplate_end(small_r=small_r);

       
    }
    faceplate_end(small_r=small_r);
    
    mirror([0,1,0]){
        faceplate_side(small_r=small_r);
    }
    faceplate_side(small_r=small_r);
    }
}
faceplate3();

module holder(){
    cube_w = 16;
    cube_d = 24.05;
    cube_h = 40;
    tool_hole_angle=90;
    difference(){
        // make solid faceplate and body
        union(){
            faceplate();
            rotate([0,tool_hole_angle,0]){
                cuboid([cube_d, cube_h, cube_w], rounding=2);
                translate([0,cube_h/2,0]){
                    cuboid([cube_d+4, 4, cube_w], rounding=2);
    
                }
            }
        }
        // cut tool hole
        translate([0,15,0]){
            rotate([90,tool_hole_angle,0]){
                scale([1.0,1.0,1.0]){
                    tool(cut=true);
                }
            }
        }
    }
}

module tool2(){
    color("Green"){
        translate([0,15,0]){
            rotate([90,0,0]){
                scale(0.95){
                    tool(cut=true);
                }
            }
        }
    }
}
//rotate([0,90,0]){
    //%tool2();
//}

//holder();

// debug
//faceplate();