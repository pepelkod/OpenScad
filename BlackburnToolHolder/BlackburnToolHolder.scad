$fn=80;

module venge_clip(){
//difference(){
    color("red"){

        translate([0,0,0]){

            h = 25;
            linear_extrude(h){
                import("VengeClipProfile.svg", center=true);
            }
        }
    }
}
module strap_nub(){
    leng=40;
    translate([0, leng/2,1]){
        rotate([90,0,0]){
            cylinder(h=leng,d=2);
        }
    }
}

module venge_stem(){
    translate([22.0,0,0]){
        strap_nub();
        translate([0,0,25-2]){
            strap_nub();
        }
    }
}

use <velcro.scad>

module ribble_plate(){
    thick = 2;

    difference(){
        rotate([0,0,180]){
            difference(){
                linear_extrude(thick){
                    import("RibblePanel.svg", center=true);
                }
                // chamfer for bolt head
                color("Green"){
                    translate([-7.155,13.16,1]){
                        cylinder(d1=3, d2=6, h=1.01);
                    }
                }
            }
        }
        // chamfer for 2nd bolt head
        color("Green"){
            translate([-7.155,13.16,1]){
                cylinder(d1=3, d2=6, h=1.01);
            }
        }
    }
}

translate([0,0,-1.9]){
    ribble_plate();
}
color("Blue"){
    difference(){
        large_array(5,15);
        translate([-7.155,13.16,-0.1]){
            cylinder(d1=6, d2=6, h=4);
        }
        translate([7.155,-13.16,-0.1]){
            cylinder(d1=6, d2=6, h=4);
        }

    }
}
/*
    translate([0,10,-50]){

        h = 100;
        linear_extrude(h){
            import("HolderShape.svg", center=true);
        }
    }

    translate([0,-22.5,-50]){

        h = 100;
        linear_extrude(h){
            import("HandlebarProfile.svg", center=true);
        }
    }
    */
//}