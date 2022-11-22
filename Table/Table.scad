

mms = 25.4;     // millimeters in inch

module top(thick, wide, deep){
    translate([0,0, thick/2]){
        cube([wide, deep, thick], center = true);
    }
}
module rotate_around(){
} 
module leg(thick, height, angle, plus){
    width = 8*mms;
    
    difference(){
        rotate([-angle*2,0,45*plus  + 45]){
            translate([0,-6*mms,0])
            intersection(){
                cube([thick, width, height*1.05]);
                rotate([angle, 0, 0]){
                    translate([-1*mms,6*mms,-2*mms]){
                       cube([thick*3, width, height*1.35, ]);
                    }
                }
            }
        }
        // trim top
        translate([0,0,height+thick+1]){
            top(thick*2, wide, deep);
        }
        // trim bottom
        translate([0,0,-thick]){
            top(thick, wide, deep);
        }
    }
}

module legs(thick, height, angle){
    for(i = [0:4]){
        rotate([0,0,90*i]){            
            d2 = (0 == (i % 2)) ? deep/2.2 : wide/2.2;
            w2 = (0 == (i % 2)) ? wide/2.2 : deep/2.2;

            translate([w2, d2, 0]){
                rotate([0,0,90])
                union(){
                    leg(thick, height, angle, 1);
                    leg(thick, height, angle, -1);
                }
            }
        }        
    }
}
module desk(thick, wide, deep, height){
    color("SaddleBrown"){
        translate([0,0,height]){
            top(thick, wide, deep);
        }
    }
    color("Tan"){
        legs(thick, height, 4);
    }
}

height = 32*mms;    
thick= .75*mms;
wide = 5*12*mms;
deep = 3*12*mms;



//leg(thick, wide, 6, 1);
desk(thick, wide, deep, height);