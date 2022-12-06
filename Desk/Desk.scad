
mms = 25.4;
width = 42*mms;
length= 71*mms;
thick = (3/4)*mms;
cross_depth = 6*mms;

leg_angle = 80;
leg_len = 31*mms;


module top(width, length, thick){
    color("Sienna"){
        cube([width, length, thick], center=true);
    }
}

module cross_under(width, length, depth, thick){
    cross_len = sqrt(width*width + length*length);
    cross_angle = atan(width/length);

    color("SaddleBrown"){
        translate([0,0,depth/2]){
            // cross beam 1
            rotate([0,0,-cross_angle]){
                cube([thick, cross_len, depth], center=true);
            }
            // cross beam 2
            rotate([0,0,cross_angle]){
                cube([thick, cross_len, depth], center=true);
            }
        }
    }
}

 
  /*  rotate([0,0,cross_angle]){
        rotate([90+leg_angle, 0, 0]){
            translate([thick, distance-(width/2),length/2]){
                cube([thick, width, length], center = true);
            }
        }
    }*/
module leg_side(width, length, thick, leg_angle, cross_angle, distance, offset){
    rotate([0,0,cross_angle]){
        rotate([90+leg_angle, 0, 0]){
            translate([offset, distance-(width/2),length/2]){
                cube([thick, width, length], center = true);
            }
        }
    }
}
module leg(width, length, thick, leg_angle, cross_angle, distance){
    leg_side(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance, offset=-thick);
    leg_side(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance, offset=+ thick);

}

module base(width, length, cross_depth, leg_angle, leg_len, thick){
    // how far in will leg angle hit cross piece?
    inset = cos(leg_angle)*leg_len;
    // length of table from corner to corner.
    total_cross_len = sqrt(width*width + length*length);
    cross_len = total_cross_len - (2*inset);
    ratio = cross_len/total_cross_len;
    
    cross_under(width*ratio, length*ratio, cross_depth, thick);

    cross_angle = atan(width/length);

    leg(cross_depth, leg_len, thick, leg_angle, cross_angle, cross_len/2);
    leg(cross_depth, leg_len, thick, leg_angle, cross_angle-180, cross_len/2);
    leg(cross_depth, leg_len, thick, leg_angle, -cross_angle, cross_len/2);   
    leg(cross_depth, leg_len, thick, leg_angle, -cross_angle-180, cross_len/2);

    
}

module desk(){
    difference(){
        union(){
            translate([0,0,cross_depth]){
                top(width, length, thick);
            }
            base(width, length, cross_depth, leg_angle, leg_len, thick);
        }
        // cut plane to flatten bottoms of legs
        translate([0,0,-leg_len+cross_depth]){
            top(width*2, length*2, thick*2);
        }
    }
}

module taper_leg(width, length, thick, leg_angle, cross_angle, distance){
    difference(){
        leg(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance);
        translate([0,150,0])
        rotate([-5,0,0]){
        leg(width=width+1, length=length+10, thick=thick+1, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance);
        }
    }
}
desk();
//leg(width=6*mms, length=31*mms, thick=1*mms, leg_angle= 90, cross_angle= 0, distance= 0);