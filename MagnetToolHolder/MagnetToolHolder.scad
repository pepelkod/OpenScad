
include <../BOSL2/std.scad>
include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;


$fn=180;

module faceplate(){
    translate([0,-6.5,0]){
        rotate([90,90,180]){
            import("..\\CannondaleSuperSixDowntubeToolHolder\\Faceplate.stl", center=true);
        }
    }
}

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
module thru_screw_hole(){
    hole_spacing = 32;
    
    translate([0,3.9,hole_spacing/2]){
        rotate([90,0,0]){
            cylinder(h=10, d=8);
        }
    }
}

module body(){
    thickness = 12;
    width = 20;
    height = 68;
    difference(){
        // actual body
        cuboid([width,thickness,height], rounding=2 );
        // cut tool hole out
        translate([0,2,0]){
            tool(cut=true);
        }
        // slice face off
        translate([0,thickness/2,10]){
            cuboid([width+1,thickness,height], rounding=2 );
        }
        // magnet hole
        translate([0,-4,0]){
            magnet(cut=true);
        }
        // screw thru holes
        thru_screw_hole();
        mirror([0,0,1]){
            thru_screw_hole();
        }
    }
    faceplate();
}

body();
//faceplate();