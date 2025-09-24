
$fn=160;

module top(width, depth){
    top_thick = 19.5;

    /*
    translate([0,0,top_thick/2]){ // bring desk to zero z
        cube([width, depth, top_thick], center=true);
    }
    */
    
    translate([-width/2, -depth/2+15, top_thick/2]){
        linear_extrude(top_thick, center=true){
            import("SwoopTop.svg");
        }
    }
}


module leg(width, depth, thick, angle){
    translate([width/2, -depth/2, 0]){
        rotate([angle,0,90]){
            linear_extrude(thick, center=true){
                import("SwoopLeg.svg");
            }
        }
    }
}
module front_submodule(move_y_dist, desk_height, front_height_angled, angle_front, front_width, thick){
    translate([0, move_y_dist, desk_height-front_height_angled]){
        rotate([90+angle_front, 0, 0]){
            translate([-front_width/2, 0, 0]){
                linear_extrude(thick, center=true){
                    import("SwoopFront.svg");
                }
            }
        }
    }
}
module front(width, depth, thick, angle_side, desk_height, inset, angle_front, back=false){
    front_width = width-(inset*2);
    front_height = 150;
    front_depth_angled = sin(angle_front) * front_height;
    front_height_angled = cos(angle_front) * front_height;
    if(back){
        move_y_dist = -(depth-inset)/2+front_depth_angled*3;
        front_submodule(move_y_dist=move_y_dist, desk_height=desk_height, front_height_angled=front_height_angled, angle_front=angle_front, front_width=front_width, thick=thick);
    }else{
        move_y_dist = -(depth-inset)/2+front_depth_angled;
        front_submodule(move_y_dist=move_y_dist, desk_height=desk_height, front_height_angled=front_height_angled, angle_front=angle_front, front_width=front_width, thick=thick);    }            
}

module desk(){
    width = 889;
    depth = 779;
    angle = 80;
    leg_thick = 19.5;
    height = 710;   // 71 cm
    inset = 100;    // inset from edge
    height_after_angling_legs = sin(angle)*height;
    
    translate([0,-inset/4,height_after_angling_legs]){
        top(width=width, depth=depth);
    }

    mirror([1,0,0]){
        leg(width=width, depth=depth, thick=leg_thick, angle=angle);
    }
    leg(width=width, depth=depth, thick=leg_thick, angle=angle);
    front(width=width, depth=depth, thick=leg_thick, angle_side=angle, desk_height=height, inset=inset, angle_front=65, back=false);
    
    // back
    front(width=width, depth=-depth, thick=leg_thick, angle_side=angle, desk_height=height, inset=inset, angle_front=-35, back=true);
}


desk();