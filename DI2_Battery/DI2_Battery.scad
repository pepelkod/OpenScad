
use <threads.scad>

module seatpost(dia=27.2, len=200, wall_thick=2){
    color("Gray"){
        difference(){
            cylinder(h=len, d=dia);
            translate([0,0,-1]){
                cylinder(h=len+2, d=dia-wall_thick);
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
    // head
    echo("head_len" , head_len);
    echo("head_dia", head_dia);
    cylinder(h=head_len, d=head_dia);
    // hex key socket
    cylinder(h=thread_dia,
      r=(HexDriveAcrossCorners(hex_size)+drive_tolerance)/2, $fn=6,
      center=true);
  }
  // threads
  translate([0,0,head_len-0.01])
    ScrewThread(thread_dia, length+0.01, tolerance=tolerance,
      tip_height=ThreadPitch(thread_dia), tip_min_fract=0.75);
}



module holder(od, id, length, thread_thick=4){
    head_len = 5;
    thread_dia = id+thread_thick * 1.1;
    
    echo("od", od);
    echo("id", id);
    echo("length", length);
    echo("thread_thick", thread_thick);
    
    color("White"){
        
        difference(){
            // main body
            cylinder(h=length+2, d=od);
            // main battery hole
            translate([0,0,-2]){
                cylinder(h=length+2, d=id);
            }
        
            // thread hole
            translate([0, 0, -head_len]){
                //head(diameter=(id+thread_thick)*1.04, length=11, head_len=head_len, head_dia=od);
                echo("thread_dia", thread_dia);
                echo("od", od);
                head_mine(thread_dia=thread_dia, length=10, tolerance=0.4, head_len=5, head_dia=od, hex_size=8);
            }
        }
    }
}

$fn=160;

//battery();

//seatpost();

seatpost_dia=27.2;
seatpost_wall_thick=2;
holder_dia=seatpost_dia-seatpost_wall_thick;
battery_dia = 18;
one_battery_len = 65;
thread_len = 10;

module holder_unit(holder_dia, battery_dia, num_batts){
    thread_thick = 4;
    thread_dia = battery_dia+thread_thick;
    
    total_len = (num_batts * one_battery_len) + thread_len;

    echo("holder_dia", holder_dia);
    echo("battery_dia", battery_dia);
    echo("total_len", total_len);
    echo("thread_thick", thread_thick);
    
    translate([0,0,total_len]){
        rotate([180,0,0]){
            holder(od=holder_dia, id=battery_dia, length=total_len, thread_thick=thread_thick);
        }
    }
    //echo("holder_dia", holder_dia);
    //echo("battery_dia", battery_dia);

    translate([30, 0, 0]){
       head_mine(thread_dia=thread_dia, length=10, tolerance=0.4, head_len=5, head_dia=holder_dia, hex_size=8);

    }
}
//echo("first holder_dia", holder_dia);
holder_unit(holder_dia=holder_dia, battery_dia=battery_dia, num_batts=1);



