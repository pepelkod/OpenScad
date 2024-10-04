

module clamp(){
    
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
            cube([20,10,cutout],center=true);
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


shield();