
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

module mock_seat_tube(h=200, d=34.9, svg_name){
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

    }else{
    // offset to surface of 0
    translate([0, -d/2, 0]){
        // main seat_tube
        cylinder(h=h, d=d, center=true);
        // rivnuts
        // upper
        translate([0,d/2,32]){
            rivnut();
        }
        // lower oval
        translate([0,d/2,-32]){
            rivnut(elongate=true);
        }

    }
}
}
module mock_hex_key(h=150, d=5, position=0, thickness=8, chopper=false){
    curve_amount = d*2;
    head_ratio=h/8;
    diameter_scaled = (chopper==true)?d*1.2:d;
    
    // numbers
    // rotate by 60 degrees (360/60 = 6 sides of hex key)
    rotate([0,0,position*60]){
        // text
        for(i=[0:1:3]){
            rotate([0,0,30+(i*90)])
                translate([-((thickness*2)-0.5),0,-h*3/7])
                    rotate([90,0,0])
                        rotate([0,-90,0])
                            linear_extrude(2)
                                text(str(d), size=5, halign="center", valign="center");
        }
        // head
        translate([head_ratio/2+curve_amount, 0, h/2+curve_amount]){ // align with elbow
            rotate([0,90,0]){
                rotate([0,0,30]){ // align flat top to bend

                    // chop front half of tool area
                    if(chopper==true){
                        cylinder(h=head_ratio+(d*4), d=diameter_scaled, center=true, $fn=6);
                    }else{
                        cylinder(h=head_ratio, d=diameter_scaled, center=true, $fn=6);
                    }
                }
            }
        }
        // elbow in position
        translate([0, 0, h/2]){
            // elbow
            translate([curve_amount, 0, 0]){            // align back with body
                rotate([90, 0, 180]){
                    rotate_extrude(angle=90){
                        translate([curve_amount,0,0]){  // set actual curve amt by moving out
                            rotate([0,0,30]){ // align flat top bend
                                circle(d=diameter_scaled, $fn=6);
                            }
                        }
                    }
                }
            }
        }
        // body
        // chop_dist is used to make a full
        // cut out like it had a square corner
        // not a rounded corner like
        // from rotate extrude
        // is this used for difference in tool body?
        // if so chopper = true
        // make the end of the hex key area square
        // by lifting the body up by diameter
        rotate([0,0,30]){ // align flat top bend
            if(chopper==true){
                cylinder(h=h+d*4.1, d=diameter_scaled, center=true, $fn=6);
            }else{
                cylinder(h=h, d=diameter_scaled, center=true, $fn=6);
            }            
        }
    }
}
// a cylinder used to cut away the tool bracket and make it lighter
module lightner(h=20, d=60, left=true, grid_width=5){
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
    rotate([90,0,0]){
        hextrude(h=20, grid_height=5 , grid_width=grid_width);
    }
        
}    
// thickness = thickness at center line
// left_size = size of left hex key
// width = width
// height = height
// show_mock = show the tools, seat-tube and bottle cage
// label = text that get printed on top to ID the bike it goes on
// {
//   seat_tube_d = diameter of seat tube
//     XOR
//   svg_name = svg with profile of tube
// }
module tool_bracket(width=30, thickness=2, left_size=5, right_size=4, seat_tube_d=34.9, show_mock=false, label="", svg_name, angle_add=0, height=85){
    cylinder_ratio=2.0;
    mx_thick=left_size>right_size?right_size:left_size;
    
    left_key_pos = 4+angle_add;
    right_key_pos = 5-angle_add;
    
    //echo("angle_add ", angle_add);
    //echo("left_key_pos ", left_key_pos);
    //echo("right_key_pos ", right_key_pos);
    
    rotate([-90,0,0]){

        if(show_mock==true){
            // the mock seat tube stays
            %mock_seat_tube(d=seat_tube_d, svg_name=svg_name);
            // mock hex hey
            %translate([-width/2, 0, 0]){
                mock_hex_key(d=left_size, position=left_key_pos);
            }
            // mock hex hey
            %translate([width/2, 0, 0]){
                mock_hex_key(d=right_size, position=right_key_pos);
            }
            // MOCK CAGE
            // remove cage area
            // space out for bracket
            %translate([0, 2, 0]){
                // remove the cage part
                %children(0);
            }
        }
        // now we make the tool bracket
        difference(){
            // body of tool holder
            union(){
                hull(){
                    // rounded ends
                    translate([width/2, 0, 0]){
                        cylinder(d=right_size*cylinder_ratio,h=height, center=true); 
                    }
                    // other rounded end
                    translate([-width/2, 0, 0]){
                        cylinder(d=left_size*cylinder_ratio,h=height, center=true); 
                    }
                }
                // text on top
                translate([0,0.7,height/2-0.5])
                    linear_extrude(1)
                        text(text=label, size=3, halign="center", valign="center");
            }
            // name
            
            
            // holes for tools
            chop_percentage=4;
            // left
            translate([-width/2, 0, 0]){
                d=left_size;
                mock_hex_key(d=d, h=height-(d*chop_percentage), position=left_key_pos, thickness=thickness, chopper=true);
            }
            // right
            translate([width/2, 0, 0]){
                d = right_size;
                mock_hex_key(d=d, h=height-(d*chop_percentage), position=right_key_pos, thickness=thickness, chopper=true);
            }
            // remove seat area
            // note this includes rivnuts and drill holes
            mock_seat_tube(d=seat_tube_d, svg_name=svg_name);
            
            // remove extra weight
            lightner();
            
            // CAGE
            // remove cage area
            // space out for bracket
            translate([0, 2, 0]){
                children(0);
            }
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



module test(){
    canondale_seat_tube_d = 35.25;
    canondale_down_tube_d = 46.8;   //-48.25 lower end

    height=85;
    show_mock=false;
    shift_amt_X= show_mock?22:22;
    shift_amt_Y= show_mock?-1:-1;
    dt_thickness=1.5;
    st_thickness=3;

    translate([shift_amt_X*1, shift_amt_Y, dt_thickness*2]){
        tool_bracket(left_size=3, right_size=4,
                            thickness=dt_thickness,
                            label="CAD         DT",
                            seat_tube_d=canondale_down_tube_d,
                            show_mock=show_mock,
                            height=height,
                            angle_add=-0.1){
             mock_cage(h=100,
                            hollow=false,
                            bolt_nub_lower_svg="CanondaleRedCageProfile.svg",
                            bolt_nub_upper_svg="CanondaleRedCageProfile.svg");           
        }
    }
    
    translate([shift_amt_X*-1, shift_amt_Y, st_thickness*2]){
         tool_bracket(left_size=8, right_size=5,
                        thickness=st_thickness,
                        label="CAD          ST",
                        seat_tube_d=canondale_seat_tube_d,
                        show_mock=show_mock,
                        width=40,
                        height=height){
             mock_cage(h=100,
                            hollow=false,
                            bolt_nub_lower_svg="CanondaleRedCageProfile.svg",
                            bolt_nub_upper_svg="CanondaleRedCageProfile.svg");           
        }
    }     
}

module braces(){
    // braces
    difference(){
        translate([shift_amt_X, 5*shift_amt_Y, -1])
            rotate([45,0,0])
                cylinder(h=40.2, d=1);
        translate([0,0,-50])
            cube(100, center=true);
    }
    difference(){
        translate([-shift_amt_X, 5*shift_amt_Y, -1])
            rotate([45,0,0])
                cylinder(h=40.8, d=1);
        translate([0,0,-50])
            cube(100, center=true);
    }
}
test();
//mock_hex_key(chopper=false);
// debug
//mock_seat_tube(svg_name="FujiDowntubeProfile.svg");
//rivnut(elongate=true);
/*translate([-10,0,0])
    mock_hex_key(d=3);
mock_hex_key(d=5);
*/
//mock_cage(bolt_nub_svg="CanondaleRedCageProfile.svg");
