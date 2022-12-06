
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

 
module taper_leg(width, length, thick, leg_angle, cross_angle, distance, offset, taper_angle=5){
    taper_amt = length*sin(taper_angle);
    taper_width = width-taper_amt;
    angle_amt = width*cos(leg_angle);
    angled_length = length-angle_amt;
    rotate([0,0,cross_angle]){
        rotate([90+leg_angle, 0, 0]){
            translate([offset-thick/2, distance-width,angled_length]){
                rotate([90,90,90]){
                    linear_extrude(thick){
                           polygon(points=[[0,0],[0-angle_amt*(taper_width/width),taper_amt],[angled_length,width],[length,0],[0,0]]);
                       }
                }
            }
        }
    }
}
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
    taper_leg(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance, offset=-thick);
    taper_leg(width=width, length=length, thick=thick, leg_angle=leg_angle, cross_angle=cross_angle, distance=distance, offset=+ thick);

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
        union(){
            translate([0,0,cross_depth]){
                top(width, length, thick);
            }
            base(width, length, cross_depth, leg_angle, leg_len, thick);
        }
   
}

desk();
/* debug stuff
color("Green")
translate([-mms, -mms, 0])
taper_leg(width=6*mms, length=31*mms, thick=1*mms, leg_angle= 45, cross_angle= 0, distance= 0, offset=mms, taper_angle=5);
leg_side(width=6*mms, length=31*mms, thick=1*mms, leg_angle= 80, cross_angle= 0, distance= 0, offset=mms);
*/