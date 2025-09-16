
rail_spacing=44;
rail_dia=7;

include <../SteererTubeToolHolder/SteererTubeToolHolder.scad>;

module rail(){
    translate([0,rail_spacing/2,0]){
        rotate([0,90,0]){
            cylinder(d=rail_dia, h=100, center=true);
        }
    }    
}
module rails(){
    rail();
    mirror([0,1,0]){
        rail();
    }
}

module tool_holder(){
    difference(){
        import("");
    }
}

rails();