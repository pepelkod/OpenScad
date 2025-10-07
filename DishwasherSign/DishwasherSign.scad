
$fn=180;

include <../BOSL2/std.scad>
module magnet(){
        cylinder(h=2.1, d=5.1, center=true);
}

module sign_label(front, back){
    size=14;
    difference(){
        translate([30,10,0.0]){
            cuboid([60,20,3], rounding=1);
        }
        translate([8,5,0.5]){
            linear_extrude(10){
                text(front, size=size);
            }
        }
        translate([5,16,-0.5]){
            rotate([180,0,0]){
                linear_extrude(10){
                    text(back, size=size);
                }
            }
        }
        // magnet
        translate([4,10,0]){
            magnet();
        }
        translate([31,10,0]){
            magnet();
        }
        translate([56,10,0]){
            magnet();
        }

    }
}

sign_label("Dirty","Clean");

    