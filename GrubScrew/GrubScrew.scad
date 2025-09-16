include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn=160;

$slop = 0.1;
rotate([180,0,0]){
    difference(){
        key_diameter=4;
        //lweite = key_diameter * 0.58 ;
        lweite = key_diameter * cos(30) ;
        thread_len=6;

        translate([0,0,(thread_len/2)]){
            threaded_rod(spin=180, d=5, l=thread_len, pitch=0.8, $fa=1, $fs=1);
        }
        hex_len=4;
        translate([0,0,(hex_len/2)-0.1]){
            cylinder(h=hex_len, $fn=6, d=lweite, center=true);
        }

    }
}