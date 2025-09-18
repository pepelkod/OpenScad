
include <../BOSL2/std.scad>
include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;


$fn=180;

module magnet(cut=false){
    height = 3.0;
    dia = 18.05;
    cut_scale = 1.02;       // X  percent larger
    rotate([90,0,0]){
        if(cut){
            end_height=height*cut_scale;
            end_dia = dia*cut_scale;
            cylinder(h=end_height, d=end_dia);
        }else{
            end_height=height;
            end_dia = dia;
            cylinder(h=end_height, d=end_dia);
        }
    }
}
module body(){
    thickness = 12;
    width = 20;
    height = 68;
    difference(){
        cuboid([width,thickness,height], rounding=2 );
        translate([0,2,0]){
            tool(cut=true);
        }
        translate([0,thickness/2,10]){
            cuboid([width+1,thickness,height], rounding=2 );
        }
        translate([0,-4,0]){
            magnet(cut=true);
        }

    }
}

body();