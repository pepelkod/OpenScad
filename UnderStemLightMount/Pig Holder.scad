

module Stem(ext_len, scale_amt){
    scale([scale_amt, scale_amt, 1]){
        linear_extrude(ext_len){
            import("Zipppp Service Course Profile handmade.svg");
        }
    }
}
// curved edges
module Outside(){
    for(x=[0 : 5 : 75]){
        translate([0,0,x/15]){
            Stem(1, 1 + (cos(x))/5);
        }
     
    }
}
module Clip(){
    difference(){
        // main body
        hull(){
            union(){
                Outside();
                mirror([0,0,1]){
                    Outside();
                }
            }
        }
        // middle hole
        translate([0,0,-20]){
            Stem(40, 0.99);
        }
        // bottom gap
        translate([0,-20.6,0]){
            rotate([0,0,45]){
                cube(20, center=true);
            }
        }
    }
}

module Holder(){
    difference(){
        union(){
            Clip();
            // mounting ball
            translate([0, 20.5, 0]){
                sphere(d=6, $fn=64);
            }
        }
        // screw hole
        rotate([90, 0, 0]){
            cylinder(100, d=2, $fn=64, center=true);
        }
        // chamfer screw head
        translate([0,19.0,0]){
            rotate([90, 0, 0]){
                cylinder(8, d1=0.0, d2=16.0, $fn=64,    center=true);
            }
        }
        // cutaway view
        /*
        translate([50,0,0]){
            cube(100, center=true);
        }
        */
    }
}

Holder();
