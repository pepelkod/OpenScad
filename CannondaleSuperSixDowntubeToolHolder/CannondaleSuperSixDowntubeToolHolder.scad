
include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;

include <../BOSL2/std.scad>
//cuboid([30,40,50], rounding=10);

module faceplate(){
    intersection(){
        translate([0,36,0]){
            cube([60, 40, 30], center=true);
        }
        translate([-25, 0, -12.5]){
            import("Cable_stop_7.STL");
        }
    }
}
        
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
rotate([0,90,0]){
    //%tool2();
}

holder();
