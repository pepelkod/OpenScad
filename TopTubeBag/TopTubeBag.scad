

module side (thickness){
    linear_extrude(thickness, center=true){
        import("side.svg", center=true);
    }
}


module  half_body(thickness){
    outer_body=1.02; // 10%
    inner_hole=0.98; //5%
   rotate_angle = 1.2;

    rotate([rotate_angle, 0,0]){

        difference(){
            // outside
            hull(){
                scale([outer_body*1.01, outer_body*1.01, 0.99]){
                    side(thickness);
                }
                scale([outer_body*0.99, outer_body*0.99, 1.01]){
                    side(thickness);
                }

            }
            /*
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
            */
            // inset (top)
            translate([0,0,thickness-2.2]){
                //rotate([rotate_angle,0,0]){
                   side(thickness);
                //}
            }
            /*
            // inset (bottom)
            translate([0,0,-thickness+4]){
                rotate([-rotate_angle,0,0]){
                    side(thickness);
                }
            }
            */
            // middle hole
            scale([inner_hole, inner_hole, 2]){
              translate([0,0,-1]){
                    side(thickness);
                }
            }
        }

    }
}
module body(thickness){
 
    union(){
        translate([0,0,thickness/6]){
            half_body(thickness/1.4);
        }
        translate([0,0,-thickness/6]){
            mirror([0,0,1]){
                half_body(thickness/1.4);
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
        scale([0.65, 0.85, 1.1]){
            rounded(height, width, thick);
        }
        translate([-thick/1.9,0,0]){
            cube([thick, width*2,height*2], center=true);
        }
    }
}
module hinge_element(height, radius){
    cylinder(h=height, r=radius, center=true);
        
    
}
module hinge(height, radius){
    num = 5;
    
    translate([0,0,-height/2]){
    difference(){
        for(i=[0:num]){
            translate([0,0,(height/num)*i]){
                hinge_element(height/num*0.9, radius);
            }
            if(i%2==0){
                translate([radius,0,(height/num)*i]){
                    cube(height/num*0.6, center=true);
                }
            }else{
                translate([-radius,0,(height/num)*i]){
                    cube(height/num*0.6, center=true);
                }            
            }
        }
        cylinder(h=height*4, r=radius/2, center=true);
    }
}
}

module all(){
    difference(){
        body(44);
        translate([62, 129, 0]){
            rotate([0,0,-30]){
                cube([13, 13,60],center=true);
            }
        }
    }
    
    // hinge
    translate([62, 129, 0]){
        rotate([0,0,-30]){
            hinge(44, 6);
        }
    }


    // bottom back
    translate([-71,-80,0]){
        rotate([0, 180, 0]){
            loop(40, 52, 4);
        }
    }
    // bottom front
    translate([-71,85,0]){
        rotate([0, 180,0]){
            loop(48, 52, 4);
        }
    }
    // top
    translate([-15,134,0]){
        rotate([0, 0, 92.4]){
            loop(50, 52, 4);
        }
    }

}

all();