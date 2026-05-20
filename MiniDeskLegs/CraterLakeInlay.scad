
//include <../BOSL2/std.scad>
include <../lasercut/lasercut.scad>

module island(pattern="WizardIsland.svg"){
       linear_extrude(25.4/4, scale=1){
            import(pattern, center=true);
        }
 
}
module inlay(pattern="CraterLake.svg"){
    translate([0,0,(25.4/4)
    ]){
        linear_extrude(25.4/4, scale=1){
            import(pattern, center=true);
        }
    }
}

module pocket(pattern){
    difference(){
        cube([800, 600, (25.4/4)*3], center=true);
        inlay(pattern);
    }
}

//inlay("CraterLake.svg");

pocket("CraterLake.svg");