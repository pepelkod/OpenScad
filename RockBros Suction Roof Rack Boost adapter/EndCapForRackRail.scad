$fn = 160;

module radiuser(d=6,h=100){
    difference(){
        // actual cutter
        linear_extrude(h){
            square([d*2, d*2]);
        }
        cylinder(d=d, h=h*10, center=true);
    }
}

in_to_cm_ratio = 25.4;
// make an endcap for rectangular aluminum of widthxheight with wall thickness thick_in
module end_cap(width_in=4, height_in=3, thick_in=0.125){
    cap_thick_mm=5;
    insert_depth_mm=40;
    
    internal_width_in = width_in - (2*thick_in);
    internal_height_in = height_in - (2*thick_in);
    
    internal_width_mm = internal_width_in * in_to_cm_ratio;
    internal_height_mm = internal_height_in * in_to_cm_ratio;
    
    external_width_mm = width_in * in_to_cm_ratio;
    external_height_mm = height_in * in_to_cm_ratio;
    echo("width",  external_width_mm, "height", external_height_mm);
    
    radius = 6;
    
    // insert
    difference(){
        linear_extrude(insert_depth_mm+(cap_thick_mm/2)){
            square([internal_width_mm, internal_height_mm], center=true);
        }
        // hollow middle
        linear_extrude(insert_depth_mm+(cap_thick_mm)){
            square([internal_width_mm-6, internal_height_mm-6], center=true);
        }
        // radius corners
        translate([(internal_width_mm/2)-radius, internal_height_mm/2-radius, 0]){
            rotate([0,0,0]){
                radiuser(radius*2);
            }
        }
        translate([(internal_width_mm/2)-radius, -internal_height_mm/2+radius, 0]){
            rotate([0,0,270]){
                radiuser(radius*2);
            }
        }
        translate([-(internal_width_mm/2)+radius, -internal_height_mm/2+radius, 0]){
            rotate([0,0,180]){
                radiuser(radius*2);
            }
        }
        translate([-(internal_width_mm/2)+radius, internal_height_mm/2-radius, 0]){
            rotate([0,0,90]){
                radiuser(radius*2);
            }
        }

        // groove
        translate([0, internal_height_mm/2, insert_depth_mm/2]){
            rotate([0,90,0]){
                cylinder(d=3, h=internal_width_mm*2, center=true);
            }
        }
        translate([0, -internal_height_mm/2, insert_depth_mm/2]){
            rotate([0,90,0]){
                cylinder(d=3, h=internal_width_mm*2, center=true);
            }
        }
        translate([internal_width_mm/2, 0, insert_depth_mm/2]){
            rotate([90,90,0]){
                cylinder(d=3, h=internal_height_mm*2, center=true);
            }
        }
        translate([-internal_width_mm/2, 0, insert_depth_mm/2]){
            rotate([90,90,0]){
                cylinder(d=3, h=internal_height_mm*2, center=true);
            }
        }
        // chamfer insert
        translate([(internal_width_mm/2)*.98,0,insert_depth_mm]){
            rotate([0,75,0]){
                linear_extrude(height=4){
                    square([internal_width_mm*2, internal_height_mm], center=true);
                }
            }
        }        
        translate([-(internal_width_mm/2)*.98,0,insert_depth_mm]){
            rotate([0,-75,0]){
                linear_extrude(height=4){
                    square([internal_width_mm*2, internal_height_mm], center=true);
                }
            }
        }        
        translate([0,(internal_height_mm/2)*.98,insert_depth_mm]){
            rotate([-75,0,0]){
                linear_extrude(height=4){
                    square([internal_width_mm, internal_height_mm*2], center=true);
                }
            }
        }        
        translate([0,-(internal_height_mm/2)*.98,insert_depth_mm]){
            rotate([75,0,0]){
                linear_extrude(height=4){
                    square([internal_width_mm, internal_height_mm*2], center=true);
                }
            }
        }        


    }    
    difference(){
        // head
        linear_extrude(height=cap_thick_mm){
            square([external_width_mm, external_height_mm], center=true);
        }
        // chamfer
        translate([0, (external_height_mm/2)+4,0]){
            rotate([45,0,0]){
                linear_extrude(height=4){
                    square([external_width_mm*2, external_height_mm], center=true);
                }
            }
        }
        translate([0, -(external_height_mm/2)-cap_thick_mm,0]){
            rotate([-45,0,0]){
                linear_extrude(height=4){
                    square([external_width_mm*2, external_height_mm], center=true);
                }
            }
        }
        // chamfer ends
        translate([(external_width_mm/2)+cap_thick_mm,0,0]){
            rotate([0,-45,0]){
                linear_extrude(height=4){
                    square([external_width_mm*2, external_height_mm], center=true);
                }
            }
        }
        // chamfer ends
        translate([-(external_width_mm/2)-cap_thick_mm,0,0]){
            rotate([0,45,0]){
                linear_extrude(height=4){
                    square([external_width_mm*2, external_height_mm], center=true);
                }
            }
        }

    }    
}

end_cap();
     
    