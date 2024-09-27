
use <threads.scad>

seatpost_dia=30.9;
battery_dia = 27.2;
one_battery_len = 185+5;  /// velogical electronics len + 5mm
thread_len = 10;




// Create threaded_plug for the end
module head_mine(thread_dia, length, tolerance, head_len, head_dia, thread_scale=1) {
    echo("head_len" , head_len);
    echo("head_dia", head_dia);
    difference() {
        scale([thread_scale,thread_scale,1]){
          union(){
                // threads
                translate([0,0,head_len-0.01]){
                    ScrewThread(thread_dia, length+0.01, tolerance=tolerance,
                        tip_height=ThreadPitch(thread_dia), tip_min_fract=0.75);
                }
                difference(){
                    // head
                    cylinder(h=head_len, d=head_dia, $fn=176);
                            // scallops
                    for(i=[0 : 60 : 360]){
                        echo("scalop", i);
                        rotate(i,[0,0,1]){
                            translate([thread_dia,0,0]){
                                sphere(r=15,$fn=25);
                            }
                        }
                    }
                }
            }
        }
        // electronics hole
        cylinder(h=length*20, r=6, $fn=186, center=true);
        // chamfer outside
        translate([0, 0, 1]){
            cylinder(h=length, r1=12, r2=1, $fn=186, center=true);
        }
        // chamfer inside
        translate([0,0,length]){
            cylinder(h=length, r1=1, r2=12, $fn=186, center=true);
        }
        // rectangular usb hole for usb a to fit thru
        cube([16.6, 8.7, 100], center=true);
    }
}

// extra bit to plug hole after putting wires thru...should be
// made of TPU
module plug(length, usb_wide = 8.7, usb_high = 16.6){
    
    // wire diameters
    usb_wd = 3;
    wd = 2.25;
    // usb dims
    
    intersection(){
        // limit z to "length"
        translate([0,0,length/2]){
            cube([100, 100, length], center=true);
        }
        difference(){
            union(){
                // od..plug diameter
                cylinder(h=length*20,
                    r=6-0.1, $fn=186,
                    center=true);
                // chamfer outside
                translate([0, 0, 1]){
                    cylinder(h=length,
                        r1=12, r2=1, $fn=186,
                        center=true);
                }
                // rectangular usb hole plug
                cube([usb_high-0.1, usb_wide-0.1, 100], center=true);
            }
            // usb wire hole
            translate([8.7-wd/2,0,0]){
                cylinder(h=length*3, d=usb_wd, $fn=186, center=true);
            }
            // wire hole
            translate([8.7-wd/2,3,0]){
                cylinder(h=length*3, d=wd, $fn=186, center=true);
            }
            // wire hole
            translate([8.7-wd/2, -3,0]){
                cylinder(h=length*3, d=wd, $fn=186, center=true);
            }
            // wire hole
            translate([-8.7+wd/2,0,0]){
                cylinder(h=length*3, d=wd, $fn=186, center=true);
            }
            // wire hole
            translate([-8.7+wd/2,3,0]){
                cylinder(h=length*3, d=wd, $fn=186, center=true);
            }
            // wire hole
            translate([-8.7+wd/2,-3,0]){
                cylinder(h=length*3, d=wd, $fn=186, center=true);
            }

      }
   }
}
    
module zip_tie(od,h){
    difference(){
        cylinder(h=h, d=od+1);
        cylinder(h=h*2, d=od-0.5);
    }
}
    
module holder(od, id, internal_length, thread_dia, bottom_thick, head_len, thread_len=10){
    //thread_dia = thread_dia * 1.1;

    echo("id", id);
    echo("internal_length", internal_length);
    echo("bottom_thick", bottom_thick);
    
    difference(){
        // main body
        intersection(){
            union(){
                // main cylinder
                cylinder(d=od, h=internal_length);
                // rounded end
                translate([0,0,internal_length-(od/1.8)]){
                    sphere(d=od*1.5);
                }
            }
            // cylinder to intersect with rounded end
            cylinder(d=od, h=internal_length+bottom_thick);
        }
        // thread hole (slightly thicker)
        translate([0,0,-bottom_thick]){
            cylinder(h=internal_length+bottom_thick, d=id-1);
        }
        // main battery hole
        translate([0,0,thread_len]){
            cylinder(h=internal_length-(thread_len), d=id);
        }
        // actual threads
        translate([0,0,-head_len]){
            head_mine(thread_dia=thread_dia, length=thread_len,
                tolerance=0.4, head_len=head_len,
                head_dia=0);
        }
        // zip tie grooves
        translate([0,0,12]){
               zip_tie(h=4, od=od);
        }            
        translate([0,0,internal_length-12]){
               zip_tie(h=4, od=od);
        }            
        
    }
}

$fn=160;



module holder_unit(seatpost_dia, battery_dia, num_batts,thread_thick = 1,head_len = 2){
    thread_dia = seatpost_dia - thread_thick;
    bottom_thick=2;
    thread_len = 10;
    thread_scale = 0.95;
    
    internal_len =  (num_batts * one_battery_len) + thread_len;

    echo("battery_dia", battery_dia);
    echo("seatpost_dia", seatpost_dia);
    echo("total_len", internal_len+bottom_thick);
    echo("thread_thick", thread_thick);
    echo("battery_dia", battery_dia);

    // main body
    translate([0,0,internal_len+bottom_thick]){
        rotate([180,0,0]){
            holder(od=seatpost_dia, id=battery_dia, internal_length=internal_len, thread_dia=thread_dia, bottom_thick=bottom_thick, head_len=head_len, thread_len=thread_len);
        }
    }

    // threaded head
    translate([seatpost_dia+2, 0, 0]){
        head_mine(thread_dia=thread_dia, length=thread_len, tolerance=0.4, head_len=head_len, head_dia=seatpost_dia*1.2, thread_scale=thread_scale);
    }
    
    // plug (
    translate([-seatpost_dia+2, 0, 0]){
        plug(length=thread_len);        
    }
   
}




//echo("first holder_dia", holder_dia);
// whole thing
intersection(){
    cube(840, center=true);
    holder_unit(seatpost_dia=seatpost_dia, battery_dia=battery_dia, num_batts=1);
}

/* 
// just head and plug
translate([-seatpost_dia+2, 0, 0]){
    plug(length=thread_len);
}

thread_thick = 1;
head_len = 2;
thread_dia = seatpost_dia - thread_thick;

// threaded head
translate([seatpost_dia+2, 0, 0]){
    head_mine(thread_dia=thread_dia, length=thread_len, tolerance=0.4, head_len=head_len, head_dia=seatpost_dia*1.2);
}
*/