
include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;

include <../BOSL2/std.scad>
//cuboid([30,40,50], rounding=10);

module holder(){
    cube_w = 25;
    difference(){
        union(){
            translate([-25, 0, -12.25]){
                import("Cable_stop_7.STL");
            }
            
            translate([0, 0, 0]){
                cuboid([cube_w, 40, 16], rounding=2);
            }
        }
        translate([0,15,0]){
            rotate([90,0,0]){
                scale([1.0,1.03,1.0]){
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
%tool2();

holder();
