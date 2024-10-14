
use <roundedcube.scad>;

$fn=85;

module clamp(dia=35, clamp_dia=16.25, space_between=10, clamp_height=10){
    union(){
   translate(v = [dia/2, 0, -7]){
        color("Orange"){
            difference(){
                roundedcube([space_between*2, 10, 10], true, 2); 
                //cube([space_between*2, 10, 10], center=true); 
                translate(v = [-dia/2, 0, +7]){
                    sphere(d=dia);
                }
            }
            
        }
   }
   translate([dia/2+clamp_dia/2+space_between,0,-7]){
       difference(){
           cylinder(d=clamp_dia*1.25, h=clamp_height, center=true);
           translate([0,0,-0.5]){
            cylinder(d=clamp_dia, h=clamp_height+2, center=true);
           }
           translate([clamp_dia/2,0,0]){
            cube([clamp_dia, clamp_dia*.8, 100], center=true);
           }
       }
   }
   }
}


module shield(dia=35, length=15){
    
    wall_percent=1.05;
    
    difference(){
        union(){
            // dome
            difference(){
                sphere(d=dia*wall_percent);
                sphere(d=dia);
                translate([0,0,dia]){
                    cylinder(h=dia*2, d=dia*2, center=true);
                }
            }
            // side walls
            difference(){
                cylinder(h=dia, d=dia*wall_percent);
                translate([0,0,-1]){
                    cylinder(h=38+2, d=dia);
                }
            }
        }
        // connector cutout
        cutout=40;
        translate([20,-(dia/2-(20/2)),cutout/2]){
            #roundedcube([20,10,cutout],center=true, radius=4);
        }
        // tire cutout
        hull(){
            // tire cutout
            translate([-50,dia/2,dia/2]){
                rotate([0,90,0]){
                    cylinder(d=32, h=100);
                }
            }
            translate([-50,0,dia]){
                rotate([0,90,0]){
                    cylinder(d=32, h=100);
                }
            }

        }
    }    
}

module whole_thing(dia=35){
    union(){
        shield(dia=35, length=15);
        clamp(dia=35, clamp_dia=16.25, space_between=10, clamp_height=10);

    }
}

whole_thing();