
mms = 25.4;
width = 42*mms;
length= 71*mms;
thick = (3/4)*mms;
cross_depth = 6*mms;

leg_angle = 80;
leg_len = 31*mms;


module top(width, length, thick){
    color("Sienna")
    cube([width, length, thick], center=true);
}

module cross_under(width, length, depth, thick){
    cross_len = sqrt(width*width + length*length);
    cross_angle = atan(width/length);

color("SaddleBrown")
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
module leg(width, length, thick, leg_angle, cross_angle, distance){
 
    rotate([0,0,cross_angle]){
        rotate([90+leg_angle, 0, 0]){
            translate([thick, distance-(width/2),length/2]){
                cube([thick, width, length], center = true);
            }
        }
    }
    rotate([0,0,cross_angle]){
        rotate([90+leg_angle, 0, 0]){
            translate([-thick, distance-(width/2),length/2]){
                cube([thick, width, length], center = true);
            }
        }
    }

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