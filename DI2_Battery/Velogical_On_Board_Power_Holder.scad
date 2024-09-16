
use <threads.scad>

// Create threaded_plug for the end
module head_mine(thread_dia, length, tolerance, head_len, head_dia) {
  difference() {
    union(){
        // threads
        translate([0,0,head_len-0.01]){
            ScrewThread(thread_dia, length+0.01, tolerance=tolerance,
                tip_height=ThreadPitch(thread_dia), tip_min_fract=0.75);
        }

        // head
        echo("head_len" , head_len);
        echo("head_dia", head_dia);
        cylinder(h=head_len, d=head_dia, $fn=6);
    }
    // electronics hole
    cylinder(h=length*20,
        r=6, $fn=86,
        center=true);
  }
}

module holder(od, id, internal_length, thread_dia, bottom_thick, head_len, thread_len=10){
    //thread_dia = thread_dia * 1.1;

    echo("id", id);
    echo("internal_length", internal_length);
    echo("bottom_thick", bottom_thick);
    
    difference(){
        difference(){
            // main body
            linear_extrude(internal_length+bottom_thick){
                circle(d=od);
            }
            // main battery hole
            translate([0,0,-bottom_thick]){
                cylinder(h=internal_length+bottom_thick, d=id);
            }
        }
        // screw hole
        translate([0,0,-head_len]){
            head_mine(thread_dia=thread_dia, length=thread_len,
                tolerance=0.4, head_len=head_len,
                head_dia=seatpost_dia);
        }
    }
}

$fn=160;



module holder_unit(seatpost_dia, battery_dia, num_batts){
    thread_thick = 1;
    thread_dia = seatpost_dia - thread_thick;
    bottom_thick=2;
    head_len = 2;
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
    //translate([0,0,bottom_thick]){
        rotate([180,0,0]){
            holder(od=seatpost_dia, id=battery_dia, internal_length=internal_len, thread_dia=thread_dia, bottom_thick=bottom_thick, head_len=head_len, thread_len=thread_len);
        }
    }

    // threaded head
    translate([seatpost_dia+2, 0, 0]){
        scale([thread_scale,thread_scale,1]){
            head_mine(thread_dia=thread_dia, length=thread_len, tolerance=0.4, head_len=head_len, head_dia=seatpost_dia*1.1);
        }

    }
}



seatpost_dia=30.9;

battery_dia = 27.2;
one_battery_len = 15;
thread_len = 10;

//echo("first holder_dia", holder_dia);
intersection(){
    cube(840, center=true);
    holder_unit(seatpost_dia=seatpost_dia, battery_dia=battery_dia, num_batts=1);
}


