
mms = 25.4;
width = 42*mms;
length= 71*mms;
thick = (3/4)*mms;
cross_depth = 6*mms;

leg_angle = 10;
leg_len = 31*mms;


module top(width, length, thick){
    color("Sienna"){
        translate([0,0,thick/2]){   // starts at z=0 and grows up
            cube([width, length, thick], center=true);
        }
    }
}

module cross_under(width, length, depth, thick){
    cross_len = sqrt(width*width + length*length);
    cross_angle = atan(width/length);

    color("SaddleBrown"){
        translate([0,0,-depth/2]){     // starts at z=0 and grows down
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

 
module taper_leg(width, length, thick, leg_angle, cross_angle, distance, offset, taper_angle=5){
    taper_amt = length*tan(taper_angle);        // amt narrower to make leg bottom
    taper_width = width-taper_amt;              // actual width of bottom
    angle_amt = width*tan(leg_angle);           // amt to chop off top because leg is angled
    angled_leg_length = length-angle_amt;       // new outside leg length once we angled the leg          
    angled_leg_length_inside = (taper_width/width)*angle_amt; // new inside leg length (from bottom)
    leg_height_floor = cos(leg_angle)*angled_leg_length; // how high off the ground is the top of leg
    rotate([0,0,cross_angle]){
        translate([offset-thick/2,distance,-leg_height_floor]){
            rotate([90,-90,90]){
                rotate([0,0,leg_angle]){
                    linear_extrude(thick){
                           polygon(points=[[0,0],[0+angled_leg_length_inside,taper_width],
                                           [length,width],[angled_leg_length,0],[0,0]]);
                    }
                }
            }
        }
    }
}

module leg(width, length, thick, leg_angle, cross_angle, distance){
    taper_leg(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance, offset=-thick);
    taper_leg(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance, offset=+thick);

}

module base(width, length, cross_depth, leg_angle, leg_len, thick){
    // how far in will leg angle hit cross piece?
    angle_amt = cross_depth*tan(leg_angle);           // amt to chop off top because leg is angled
    angled_leg_length = length-angle_amt;       // new outside leg length once we angled the leg          
    leg_height_floor = cos(leg_angle)*angled_leg_length; // how high off the ground is the top of leg
    inset = tan(leg_angle)*leg_height_floor;
    leg_top_hypotenuse = sqrt(angle_amt*angle_amt + cross_depth*cross_depth);
    // length of table from corner to corner.
    total_cross_len = sqrt(width*width + length*length);
    cross_len = total_cross_len - (2*inset);
    ratio = cross_len/total_cross_len;
    
    cross_under(width*ratio, length*ratio, cross_depth, thick);
 
    cross_angle = atan(width/length);

    leg_inset = (total_cross_len/2)-leg_top_hypotenuse;
    leg(cross_depth, leg_len, thick, leg_angle, cross_angle, leg_inset);
    leg(cross_depth, leg_len, thick, leg_angle, cross_angle-180, leg_inset);
    leg(cross_depth, leg_len, thick, leg_angle, -cross_angle, leg_inset);   
    leg(cross_depth, leg_len, thick, leg_angle, -cross_angle-180, leg_inset);

    
}

module desk(){
        union(){
            top(width, length, thick);
            base(width, length, cross_depth, leg_angle, leg_len, thick);
        }
   
}

desk();
// debug stuff
//color("Green")
//taper_leg(width=6*mms, length=31*mms, thick=1*mms, leg_angle= 45, cross_angle= 0, distance= 0*mms, offset=mms, taper_angle=5);
//