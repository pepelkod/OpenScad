
include <../BOSL2/std.scad>

$fn=80;

module notch(){
    bottom = 31.25;
    top = 30;
    
    
    rotate([90,0,0]){
        difference(){
            // main body
            linear_extrude(11){
                trapezoid(h=40.14, w2=top, w1=bottom);
            }
            // rounded notch at top
            translate([0,(40.14/2),7.0]){
                rotate([0,90,0]){
                    cylinder(h=100, d=14, center=true);
                }
            }

        }
    }
}

module bracket(){
    translate([0,0,-15.6]){
        difference(){
            // main body
            cuboid([ 55.308, 20, 50], rounding=0);
            // notch
            translate([0,0.99,-5]){
                notch();
            }
        }        
    }
}

module outer_clamp_plug(){       
    rotate([180,0,180]){
        for(i=[0:40]){
            translate([0,0,i*.99]){
                scale([1+(i/40)*0.02, 1+(i/40)*0.02, 1]){
                    linear_extrude(1){
                        import("Clamp_Profile.svg");
                    }
                }
            }
        }
    }
}

module outer_clamp(){
    
    difference(){
        // actual clamp
        scale([1.2,1.2,1]){
            outer_clamp_plug();
        }
        // cut out center
        translate([0,0,0.01]){
            scale([1.0,1.0,1.02]){
                outer_clamp_plug();
            }
        }
        // cut back notch for pole
        translate([0,0,-50]){
            rotate([0,0,45]){
                cube([40,40,100]);
            }
        }
        // cut square front
        //(using a flipped
        // center cutout
        // plug)                             
        translate([0,-38,0.01]){
            rotate([0,0,180]){
                scale([1.0,1.0,1.02]){
                    outer_clamp_plug();
                }
            }
        }

    }
}

module pole(){
    color("Red"){
        cylinder(h=100, d=38.17);
    }
}
module pole_cutter(){
    hull(){
        translate([0,100,0]){
            pole();
        }
        pole();
    }
}

module hex_tray(){
    tray(depth=91, width=167, height=73);
}
module tray(depth=91, width=167, height=73){

    color("LightBlue"){
        translate([0,0,height/2]){
            difference(){
                cuboid([depth+9, width+9, height], rounding=6);
                // cut block
                translate([0,0,10]){
                    cuboid([depth,width,height], rounding=6);
                }
            }
        }
    }
}



module main(){
   
    // flatten the thing
    intersection(){
        union(){
            // bottom box to remove
            // the curves between the clamp
            // and the trays
            translate([0,-30,-35.6]){
                difference(){
                    cube([65,50,10], center=true);
                    translate([0,15,0]){
                        cube([50,70,100], center=true);
                    }
                }   
            }
            // clamp
            color("Green"){
                outer_clamp();
            }
            // bracket
            translate([0,-42.825,0]){
                rotate([0,0,180]){
                    bracket();
                }
            }
            
            // top
            difference(){
                translate([0,-20,-1]){
                    color("Blue"){
                        cube([55.6,30, 10], center=true);
                    }
                }
                //  cut pole out
                translate([0,4,-10]){
                    pole();
                }
            }
        }
        // flatten bottom
        // with intersection 
        translate([0,0,-50]){
            cube([200,200,100], center=true);
        }
    }
    
    tray_down_amt=-40.6;
    // right side...hex tray
    translate([77,0,tray_down_amt]){
        hex_tray();
    }
    // left side tray
    translate([-77,0,tray_down_amt]){
        tray(depth=91, width=167, height=20);
    }
    // front tray
    difference(){
        translate([0,-100,tray_down_amt]){
            rotate([0,0,90]){
                tray(depth=91, width=245, height=20);
            }
        }
        translate([81,-32,0]){
            cube([100,100,100], center=true);
        }
    }
}

main();
