

module side (thickness){
    linear_extrude(thickness, center=true){
        import("side.svg", center=true);
    }
}


module body(thickness){
    rotate_angle = 2;
    outer_body=1.02; // 10%
    inner_hole=0.98; //5%
    difference(){
        // outside
        scale([outer_body, outer_body, 1]){
            side(thickness);
        }

        // outer cut (top)
        translate([0,0,thickness-2.2]){
            rotate([rotate_angle,0,0]){
                scale([outer_body+1, outer_body+1, 1]){
                    side(thickness);
                }
            }
        }
        // outer cut (bottom)
        translate([0,0,-thickness+2.2]){
            rotate([-rotate_angle,0,0]){
                scale([outer_body+1, outer_body+1, 1]){
                    side(thickness);
                }
            }
        }

        // inset (top)
        translate([0,0,thickness-4]){
            rotate([rotate_angle,0,0]){
               side(thickness);
            }
        }

        // inset (bottom)
        translate([0,0,-thickness+4]){
            rotate([-rotate_angle,0,0]){
                side(thickness);
            }
        }

        // middle hole
        scale([inner_hole, inner_hole, 2]){
          translate([0,0,-1]){
                side(thickness);
            }
        }
        


    }
}
    
module rounded(height, width, thick){
    translate([0, width/2, 0]){
        cylinder(h=height, r=thick, center=true);
    }
    translate([0, -width/2, 0]){
        cylinder(h=height, r=thick, center=true);
    }
    cube([thick*2, width, height], center=true);
}
module loop(height, width, thick){
    difference(){
        rounded(height, width, thick);
        scale([0.75, 0.75, 1.1]){
            rounded(height, width, thick);
        }
        translate([-thick/1.9,0,0]){
            cube([thick, width*2,height*2], center=true);
        }
    }
}
module all(){
    body(44);
    // bottom back
    translate([-51.6,40,0]){
        rotate([0, 180,-3]){
            loop(40, 20, 4);
        }
    }
    // bottom front
    translate([-51.6,-50,0]){
        rotate([0, 180,1]){
            loop(32, 20, 4);
        }
    }
    // top
    translate([30,72,0]){
        rotate([0, 0, 81]){
            loop(42, 20, 4);
        }
    }

}

all();