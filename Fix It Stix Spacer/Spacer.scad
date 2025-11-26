

include <../BOSL2/std.scad>;
$fn = 60;

module spacer(){
    difference(){
        translate([0, 1, 0]){
            cuboid([16, 17,  7], rounding= 2);
        }
        // cut slot
        translate([0,-1,0]){
            cube([100, 17, 2.44], center=true);
        }
        // cut hex holes
        cylinder(d= 12.9, h=3.6, $fn=6, center=true);
        // cut hex holes
        cylinder(d= 6, h=30, $fn=60, center=true);
        
        /* view
        translate([50, 0, 0]){
            cube(100, center=true);
        }*/
    }
    
}


spacer();