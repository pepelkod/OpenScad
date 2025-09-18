
include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;

include <../BOSL2/std.scad>

module faceplate(){
    translate([0,18,0]){
        rotate([-90,0,0]){
            import("FacePlate.stl");    
        }
    }
}


module holder(){
    cube_w = 16;
    cube_d = 22.05;
    cube_h = 40;
    tool_hole_angle=0;
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

holder();

// debug
//faceplate2();