
include <../BOSL2/std.scad>

$fn=120;

translate([-80,20.5,-15]){
    rotate([0,24.5,0]){
        rotate([23.0,0,0]){
            import("Cage.stl");
        }
    }
}
color("LightBlue"){
    intersection(){
        difference(){
            translate([3,0,23.6]){
                rotate([0,90,0]){
                    tube(h=10, id=52.5, od=57.5);
                }
            }
            translate([-4,0,0]){
                cylinder(h=100, d=15,center=true);
            }
        }
        translate([0,0,-25])
        cube([100, 17, 100], center=true);
    }
}