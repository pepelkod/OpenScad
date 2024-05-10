
use <threads.scad>

module seatpost(dia=27.2, length=200, wall_thick=2){
    color("Gray"){
        difference(){
            cylinder(h=length, d=dia);
            translate([0,0,-1.5]){
                linear_extrude(length+2){
                    import("SeatpostInside.svg");
                }
            }
        }
    }
}

module battery(dia=18, len=65){
    color("Red"){
        cylinder(h=len, d=dia);
    }
}



// Create threaded_plug for the end
module head_mine(thread_dia=18, length=10, tolerance=0.4, head_len=5, head_dia=27.2-4, hex_size=8) {
  drive_tolerance = pow(3*tolerance/HexDriveAcrossCorners(hex_size),2)
    + 0.75*tolerance;

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
        cylinder(h=head_len, d=head_dia);
    }
    // hex key socket
    cylinder(h=length,
        r=(HexDriveAcrossCorners(hex_size)+drive_tolerance)/2, $fn=6,
        center=true);
  }
}



module holder(id, internal_length, thread_thick=4, bottom_thick=2, head_len=5, thread_len=10){
    thread_dia = id+thread_thick * 1.1;

    echo("id", id);
    echo("internal_length", internal_length);
    echo("thread_thick", thread_thick);
    echo("bottom_thick", bottom_thick);
    
    color("White"){
        ScrewHole(outer_diam=id+thread_thick, height=thread_len*1.1, position=[0,0,0], rotation=[0,0,0], pitch=0, tooth_angle=30, tolerance=0.4, tooth_height=0){
            translate([0,0,0]){
                difference(){
                    // main body
                    linear_extrude(internal_length+bottom_thick){
                        import("SeatpostInside.svg");
                    }
                    // main battery hole
                    translate([0,0,-bottom_thick]){
                        cylinder(h=internal_length+bottom_thick, d=id);
                    }
                }
            }
        }
    }
}

$fn=160;

//battery();

//seatpost();

//seatpost_dia=27.2;
//seatpost_wall_thick=2;
//holder_dia=seatpost_dia-seatpost_wall_thick;
battery_dia = 18.5;
one_battery_len = 65;
thread_len = 10;

module holder_unit(battery_dia, num_batts){
    thread_thick = 4;
    thread_dia = battery_dia+thread_thick;
    bottom_thick=2;
    head_len = 2;
    thread_len = 10;
    
    internal_len = (num_batts * one_battery_len) + thread_len;

    echo("battery_dia", battery_dia);
    echo("total_len", internal_len+bottom_thick);
    echo("thread_thick", thread_thick);
    
    translate([0,0,internal_len+bottom_thick]){
        rotate([180,0,0]){
            holder(id=battery_dia, internal_length=internal_len, thread_thick=thread_thick, bottom_thick=bottom_thick, head_len=head_len, thread_len=thread_len);
        }
    }
    //echo("holder_dia", holder_dia);
    //echo("battery_dia", battery_dia);

    translate([30, 0, 0]){
       head_mine(thread_dia=thread_dia-1, length=thread_len, tolerance=0.4, head_len=head_len, head_dia=24.5, hex_size=8);

    }
    // ears to keep it from slipping into the seatpost
    translate([0,0,bottom_thick/2]){
        cube([4,27.8,bottom_thick-0.1], center=true);
    }
}
//echo("first holder_dia", holder_dia);
holder_unit(battery_dia=battery_dia, num_batts=0.1);
translate([-35, 0, 0]){

    seatpost(31.6);
}
