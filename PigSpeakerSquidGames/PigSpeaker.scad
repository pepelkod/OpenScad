
$fn=40;

module eye_carat(height){
    linear_extrude(height){
        import("eye_carat.svg");
    }
 
}
module eye_oval(height){
    linear_extrude(height){
        import("pig_eye.svg");
    }
}

module eye(radius, offset){
    translate([0,0,radius  + radius*0.1]){
        rotate([110, 0, offset]){       
            translate([0,0,-radius-2]){
                difference(){
                    eye_oval(20);
                    eye_carat(200);
                }
                
                color("Black"){
                    translate([0,0,-1]){
                        eye_carat(20);
                    }
                }
                
            }
        }
    }
}
module eyes(radius){
    offset = 32;
    intersection(){
        union(){
            eye(radius, offset);
            eye(radius, -offset);
        }
        translate([0,0,radius*1.1]){
            sphere(r = radius*1.02);
        }
    }
}
module leg(){
    dia = 20;
    dist = 20;
    
    intersection(){
        translate([dist,dist,30]){
            rotate([15, -15, 0]){
                translate([0,0,-40]){
                    cylinder(h=100, d=dia);
                }
            }
        }
        translate([0,0,500]){
            cube([1000,1000,1000], center=true);
        }
    }
}

module legs(){
    rotate([0,0,90]){
        leg();
    }
    rotate([0,0,180]){
        leg();
    }
    rotate([0,0,0]){
        leg();
    }
    rotate([0,0,270]){
        leg();
    }
}

module nose_bump(length, radius){
    difference(){
        cylinder($fn=6, h=length, r=radius);
        cylinder($fn=6, h=length+0.1, r=radius*0.8);
    }
    /*
    translate([0,0,length-radius/2]){
        sphere(r=radius*0.9);
    }*/
}

module nose_row(radius, rbump, span, xspacing){
    //row
   
    for(i=[-span : 1 : span]){
        rotate([i*xspacing,0,0]){
            nose_bump(length=radius, radius=rbump);
        }
    }
}
module nose_column(radius){
    yspan = 10;
    xspan = 7;
    rbump = 2.0;
    yspacing = rbump*1.4;
    xspacing = rbump*1.54;
    for(j = [-yspan: 1 : yspan]){
        echo("j mod 2", j%2);
        if(0==j%2){
            rotate([0,j*yspacing,0]){
                nose_row(radius, rbump, xspan, xspacing);
            }
        }else{
            rotate([xspacing/2, j*yspacing, 0]){
                nose_row(radius, rbump, xspan, xspacing);
            }
        }
    }
}
module nose(pig_radius, nose_radius){
    
    difference(){            
        union(){
            difference(){
                cylinder(h=pig_radius-4, r=nose_radius+1);
                cylinder(h=pig_radius*2, r=nose_radius);
            }
            intersection(){
                nose_column(pig_radius);
                cylinder(h=pig_radius*2, r=nose_radius);
            }
        }
        sphere(r=pig_radius-2);
    }
}

module body(radius=100){
    nose_radius=25;
    nose_angle=-100;

    difference(){
        union(){
            translate([0,0,radius + radius*0.1]){
                union(){
                    difference(){
                        sphere(r=radius);
                        rotate([nose_angle,0,0]){
                            cylinder(h=radius*2, r=nose_radius+0.1);
                        }
                    }
                    rotate([nose_angle,0,0]){
                        nose(radius+2, nose_radius);
                    }
                }
            }
            legs();
            eyes(radius=radius);
        }
        // hollow center
        translate([0,0,radius + radius*0.1]){
            sphere(r=radius-2);
        }
    }

}

radius=60;

body(radius=radius);
