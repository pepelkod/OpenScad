

$fn=120;

mms_in = 25.4;

module cutter(size=5*mms_in){
    difference(){
        cylinder(h=100, d=size*2, center=true);
        cylinder(h=200, d=size, center=true);
        translate([size/2,0,0]){
            cube([size, size, 200], center=true);
        }
        translate([size/2,-size/2,0]){
            cube([size, size*2, 200], center=true);
        }
    }
    cut_all_size=2000;
    translate([-(cut_all_size+size)/2, 0, 0]){
        cube([cut_all_size, cut_all_size, cut_all_size], center=true);
    }
}
module pattern(){
    linear_extrude(20){
        import("Pattern.svg", center=true);
    }
}

module side_circle(total_size_d, depth){
    thick = mms_in * (3/4);

    circumference = PI * total_size_d;
    difference(){
        cylinder(h=thick, d=total_size_d, center=true);
        cylinder(h=thick*2, d = total_size_d-depth*2, center=true);
        /*
        translate([180, 180,-19]){
            rotate([0,0,45]){
                scale([1.4,1.4,1]){
                    pattern();
                }
            }
        }*/
    }
}
module side(wheel_size=622, tire_size=35){
    total_size_d = wheel_size + (2 * tire_size);  
    depth = 4*mms_in;
    
    difference(){
        side_circle(total_size_d, depth=depth);
        // rounded end
        translate([0,(total_size_d - depth)/2, 0]){
            cutter(depth);
        }
        // rounded end 2
        rotate([0,0,90]){
            mirror([0,1,0]){
                translate([0,(total_size_d - depth)/2, 0]){
                    cutter(depth);
                }
            }
        }
        // cross notch
        cross_notches(offset=650);
    }
}


module cross_notch(offset=700){
    thick = (3/4)*mms_in;

    translate([offset/2,thick/2,(35+thick)/2]){
        rotate([90,0,0]){
            rotate([0,0,90]){
        
                linear_extrude(thick){
                    import("Leg2.svg", center=true);
                }
            }
        }
    }
}
module cross_notches(offset=700){
    angle_amt=15;
    rotate([0,0,angle_amt]){
        #cross_notch(offset);
    }
    rotate([0,0,90-angle_amt]){
        #cross_notch(offset);
    }
}

//side();
//cross_notches();
rotate([90,0,0]){
    cross_notch();
}