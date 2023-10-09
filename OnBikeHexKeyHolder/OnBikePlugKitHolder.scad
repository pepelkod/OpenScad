
$fn=80;

use <Hextrude.scad>;

function defined(a) = str(a) != "undef";

module mock_bottle(h=150, d=73){
    cylinder(h=h, d=d, center=true);
}

// Makes a rivnut and screw punch 
// thickness...amount it sticks out of the seat tube
// d = diameter of outside
// d_screw = diameter of screw hole punch.
// elongate = make it an oval for adjustment slack
module rivnut(thickness=1, d=12.5, d_screw=5, elongate=false){
    h=thickness*6;  // because the seat tube curves away from the plane
    offset = -((h-1)/2);
    // elongate length
    el= elongate==true ? 1: 0;
    el_amt = (d/4)*el;
    
    translate([0, offset,0]){
        rotate([90,90,0]){
            union(){
                // rivnut recess
                hull(){
                    translate([el_amt,0, 0])
                        cylinder(h=h, d=d, center=true);
                    translate([-el_amt, 0, 0])
                        cylinder(h=h, d=d, center=true);
                }
                // screw hole
                hull(){
                    translate([el_amt,0,0])
                        cylinder(h=h*2, d=d_screw, center=true); 
                    translate([-el_amt,0,0])
                        cylinder(h=h*2, d=d_screw, center=true); 
                }

            }
        }
    }
}    

module mock_seat_tube(h=200, svg_name){
    if(svg_name){
        translate([0,0,-h/2]){
            rotate([0,0,-90]){
                linear_extrude(h){
                    import(svg_name);
                }
            }
        }
       // rivnuts
        // upper
        translate([0,0,32]){
            rivnut();
        }
        // lower oval
        translate([0,0,-32]){
            rivnut(elongate=true);
        }
    }
}

module mock_plug_kit(h=150, d=5, position=0, thickness=8, chopper=false){
    // body
    cylinder(h=h, d=d, center=true, $fn=60);
}
module mock_co2_kit(h=150, d=5, position=0, thickness=8, chopper=false){
    // body
    cylinder(h=h, d=d, center=true, $fn=60);
}

// a cylinder used to cut away the tool bracket and make it lighter
module lightner(h=400, d=60, left=true, grid_width=5){
    //side = left==true ? 1: -1;

    // two big side cuts
    
    for(side=[-1:2:1]){
        translate([(d/2+7)*side,h/2, 0]){
            rotate([90,90,0]){
                cylinder(h=h, d=d, $fn=6);
            }
        }
    }
    
    /*
    // three vertical holes
    for(vert=[-2:2:2]){
        translate([0,h/2, vert*6]){
            rotate([90,90,0]){
                cylinder(h=h, d=d/8+(vert*vert), $fn=6);
            }
        }
    }
    */
    /*rotate([90,0,0]){
        hextrude(h=4, grid_height=1 , grid_width=grid_width, coverage=0);
    }*/
        
}    

module mock_cage_nub(svg="LezyneCageProfile.svg", length=20, position=32, cage_thickness=3){
    difference(){
        #translate([0,0,position]){
            translate([0,0,-length/2]){
                rotate([0,0,0]){
                    linear_extrude(length){
                        import(svg);
                    }
                }
            }
        }
        rotate([0,90,0]){
            hull(){
                offset = -5;
                space = 10;
                translate([-space,offset,0]){
                    cylinder(d=20, h=40, center=true);
                }
                translate([space,offset,0]){
                    cylinder(d=20, h=40, center=true);
                }
            }
        }
    }
}


module tool_body(width=60, thickness=1, left_size=17.5, right_size=22, seat_tube_d=34.9, show_mock=false, label="", tube_name="RibbleDownTubeProfile.svg", cage_name="LezyneCageProfile.svg", angle_add=0, height=85){
    
    cylinder_ratio=1.2;
    left_outer_size = left_size*cylinder_ratio;
    right_outer_size = right_size*cylinder_ratio;

    difference(){
        // body of tool holder
        union(){
            hull(){
                // rounded ends
                translate([width/2, right_outer_size/2 , 0]){
                    cylinder(d=right_size*cylinder_ratio,h=height, center=true); 
                }
                // other rounded end
                translate([-width/2, left_outer_size/2, 0]){
                    cylinder(d=left_size*cylinder_ratio,h=height, center=true); 
                }
                //cube([width, mx_thick, height], center=true);
            }                
        }
        // holes for tools
        // left
        translate([-width/2, left_outer_size/2, 0]){
            d=left_size;
            mock_plug_kit(d=left_size, h=height*2);
        }
        // right
        translate([width/2, right_outer_size/2, 0]){
            d = right_size;
            mock_co2_kit(d=right_size, h=height*2);
        }

        // remove seat area
        // note this includes rivnuts and drill holes
        translate([0,thickness,0]){
            mock_seat_tube(svg_name=tube_name);
        }

        // remove extra weight
        lightner();
        
        // CAGE
        // remove cage area
        translate([0,5,0]){
            mock_cage_nub();
            mock_cage_nub(position=-32);
        }
    }
}            


                       // bottle diameter 73 + thickness 4
module mock_cage(h=40, d=73+4, hollow=true, bolt_nub_upper_svg="CanondaleRedCageProfile.svg", bolt_nub_lower_svg="CanondaleRedCageProfile.svg", bolt_nub_upper_height=27, bolt_nub_lower_height=27){
    // make upper and lower
    for(z=[-32:64:32]){
        translate([0,0,z]){
            // mounting nub
            rotate([0,0,90]){
                if(defined(bolt_nub_lower_svg)){
                    if(z<0){
                        linear_extrude(bolt_nub_lower_height, center=true){
                            import(bolt_nub_lower_svg);
                        }
                    }else{
                        linear_extrude(bolt_nub_upper_height, center=true){
                            import(bolt_nub_upper_svg);
                        }
                    }
                }
            }
            // round cage part
            translate([0, d/2+4, 0]){
                if(hollow==true) {
                    difference(){
                        cylinder(h=h, d=d, center=true);
                        mock_bottle();
                    } 
                }else{
                   cylinder(h=h, d=d, center=true);            
                }
            }
        }
    }    
}

tool_body();
