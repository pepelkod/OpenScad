

//include <BOSL2/std.scad>
include <../BOSL2/std.scad>

$fn=60;

module plug(){
    plug_length = 50;
    
    cylinder(plug_length, d=13, center=true);
}

module plug_holder(){
    difference(){
        scale([1.1, 1.1, 1]){
            plug();
        }
        translate([0,0,4]){
            scale([1.0, 1.0, 1]){
                plug();
            }
        }
    }

}
module co2_holder(){
    import("..\\Canondale Tool Spacer\\CO2 Holder.stl");
}
module body_with_holes(){
    // top
    translate([0, 2.5, 50]){
        cuboid([10,5,140], rounding=2);
    }
    // bottom
    rotate([0,0,-8]){
        translate([0, 8, 3]){
            cuboid([6,8,44], rounding=2);
        }
    }

}

module thing(){
    translate([10.5, 7.0, 0]){
        plug_holder();
    }
    translate([-13, 12, -15]){
        rotate([0,0,-30]){
            co2_holder();
        }
    }
    body_with_holes();
}

thing();
    
    
