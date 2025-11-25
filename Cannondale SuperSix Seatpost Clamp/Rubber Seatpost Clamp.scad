

include <../BOSL2/std.scad>
$fn=120;

module around_seatpost(length=200){
    linear_extrude(length){
        import("Cannondale Seatpost Profile Around.svg", center=true);
    }
}

module rubber_strap(){
    scale = 1.2;
    shrink = 0.99;
    
    difference(){
        scale([scale, scale*.9, 1]){
            around_seatpost(22);
        }
        translate([0,0,-100]){
            scale([shrink, shrink*.99, 1]){
                around_seatpost(200);
            }
        }
    }
    // remove stress risers
    translate([0,-(20+1), 20.6]){
        rotate([0,90,0]){
            cylinder(10, d=3, center=true);
        }
    }
}
module light_hole(wide=19, the_text){
    thick=3;
    height=22;
    
    translate([0,-(20+thick+1), height/2]){
                rotate([-4.0,0,0]){

        difference(){    
            cuboid([wide+thick*2 , 2+thick*2, height], rounding=thick);
            cuboid([wide , 2, height*2], rounding=1);
        }
        mytext(the_text);
    }    }
}
module mytext(the_text){
    
    translate([0,-3, -4]){
        rotate([90,0,0]){
            linear_extrude(1.5){
                text(the_text, halign="center");
            }
        }
    }
}

module main(){
    union(){
        rubber_strap();
        //light_hole(16.2, "XE");
        light_hole(19, "NR");

    }
}

main();