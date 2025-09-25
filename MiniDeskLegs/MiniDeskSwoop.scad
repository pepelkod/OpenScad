
$fn=160;

module top(width, depth){
    top_thick = 19.5;

    translate([-width/2, -depth/2, top_thick/2]){
        linear_extrude(top_thick, center=true){
            import("SwoopTop.svg");
        }
    }
}


module leg(width, depth, thick, angle){
    translate([width/2-thick/2, -depth/2-thick/2, 0]){
        rotate([angle,0,90]){
            linear_extrude(thick, center=true){
                import("SwoopLeg.svg");
            }
        }
    }
}
module back(width, depth, thick, angle){
    angle_from_vert = 90-angle;
    
    translate([-width/2+thick, depth/2-123, 0]){
        rotate([90+angle_from_vert,0,0]){
            linear_extrude(thick, center=true){
                import("SwoopBack.svg");
            }
        }
    }
}
module front_short(width, depth, thick, angle, top_height){
    angle_from_vert = 90-angle;
    full_height = 296.058;
    angle_height = full_height * 0.707; // cos 45
    
    translate([-width/2, -100, top_height-angle_height]){
        rotate([90+angle_from_vert,0,0]){
            linear_extrude(thick, center=true){
                import("SwoopFrontBrace.svg");
            }
        }
    }
}

module front_long(width, depth, thick, angle, top_height){
    angle_from_vert = 90-angle;
    full_height = 710;
    angle_height = full_height * cos(angle_from_vert); // cos 45
    
    translate([(-width/2), -280, top_height-angle_height]){
        rotate([90-angle_from_vert,0,0]){
            linear_extrude(thick, center=true){
                import("SwoopFrontBrace2.svg");
            }
        }
    }
}


module desk(){
    width = 889;
    depth = 779;
    angle = 80;
    leg_thick = 19.5;
    height = 710;   // 71 cm
    inset = cos(angle)*height;    // inset from edge
    height_after_angling_legs = sin(angle)*height;
    echo ("angled leg height");
    echo(height_after_angling_legs)
    
    // top
    translate([0,-inset/4,height_after_angling_legs]){
        top(width=width, depth=depth);
    }
    
    // side legs
    leg(width=width, depth=depth, thick=leg_thick, angle=angle);
    mirror([1,0,0]){
        leg(width=width, depth=depth, thick=leg_thick, angle=angle);
    }
    
    // back
    color("Blue"){
        back(width=width, depth=depth, thick=leg_thick, angle=angle);
    }
    // front bracing outside
    /*
    color("Red"){
        front_long(width=width, depth=depth, thick=leg_thick, angle=45, top_height=height);
    }*/
    
    // front long bracing 
    color("Red"){
        front_long(width=width, depth=depth, thick=leg_thick, angle=70, top_height=height);
    }
}

//color("Brown"){
    desk();
//}