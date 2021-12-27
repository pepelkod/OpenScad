
$fn=80;

function defined(a) = str(a) != "undef";

module mock_bottle(h=150, d=73){
    cylinder(h=h, d=d, center=true);
}
                       // bottle diameter 73 + thickness 4
module mock_cage(h=40, d=73+4, hollow=true, bolt_nub_svg="CanondaleRedCageProfile.svg"){
    // make upper and lower
    for(z=[-32:64:32]){
        translate([0,0,z]){
            // mounting nub
            rotate([0,0,90]){
                if(defined(bolt_nub_svg)){
                    echo("canondale");
                    linear_extrude(27, center=true){
                       import(bolt_nub_svg);
                    }
                }
            }
            // round cage part
            translate([0, d/2+1, 0]){
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
    head_ratio=h/8;
    
    // rotate by 60 degrees (360/60 = 6 sides of hex key)
    rotate([0,0,position*60]){
        // text
        for(i=[0:1:5]){
            rotate([0,0,30+(i*60)])
                translate([-((thickness*2)-0.5),0,-h*3/7])
                    rotate([90,0,0])
                        rotate([0,-90,0])
                            linear_extrude(2)
                                #text(str(d), size=5, halign="center", valign="center");
        }
        // head
        translate([head_ratio/2+d, 0, h/2+d]){
            rotate([0,90,0]){
                // chop front half of tool area
                if(chopper==true){
                    cylinder(h=head_ratio+(d*1.5), d=d, center=true, $fn=6);
                }else{
                    cylinder(h=head_ratio, d=d, center=true, $fn=6);
                }
            }
        }
        // elbow in position
        translate([0, 0, h/2]){
            // elbow
            translate([d, 0, 0]){
                rotate([90, 0, 180]){
                    rotate_extrude(angle=90){
                        translate([d,0,0]){
                            circle(d=d, $fn=6);
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
        if(chopper==true){
            cylinder(h=h+d*3, d=d, center=true, $fn=6);
        }else{
            cylinder(h=h, d=d, center=true, $fn=6);
        }            
    }
}
// a cylinder used to cut away the tool bracket and make it lighter
module lightner(h=20, d=60, left=true){
    //side = left==true ? 1: -1;

    // two big side cuts
    for(side=[-1:2:1]){
        translate([(d/2+8)*side,h/2, 0]){
            rotate([90,90,0]){
                cylinder(h=h, d=d);
            }
        }
    }
    // three vertical holes
    for(vert=[-2:2:2]){
        translate([0,h/2, vert*6]){
            rotate([90,90,0]){
                cylinder(h=h, d=d/8+(vert*vert));
            }
        }
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
module tool_bracket(width=30, thickness=2, left_size=5, right_size=4, seat_tube_d=34.9, show_mock=false, label="", svg_name, angle_add=0, height=85, bolt_nub_svg){
    mx_thick=thickness*4;
    
    left_key_pos = 4+angle_add;
    right_key_pos = 5-angle_add;
    
    echo("angle_add ", angle_add);
    echo("left_key_pos ", left_key_pos);
    echo("right_key_pos ", right_key_pos);
    
    if(show_mock==true){
        // mock cage gets move out to acommodate 
        %translate([0, 2, 0]){
            mock_cage(bolt_nub_svg=bolt_nub_svg);
        }
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
    }
    // now we make the tool bracket
    difference(){
        // body of tool holder
        union(){
            cube([width, mx_thick, height], center=true);
            // rounded ends
            translate([width/2, 0, 0]){
                cylinder(d=mx_thick,h=height, center=true); 
            }
            // other rounded end
            translate([-width/2, 0, 0]){
                cylinder(d=mx_thick,h=height, center=true); 
            }
            // text on top
            translate([0,0.7,height/2-0.5])
                linear_extrude(1)
                    text(text=label, size=3, halign="center", valign="center");
        }
        // name
        
        
        // holes for tools
        chop_percentage=2.6;
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
        // remove cage area
        // space out for bracket
        translate([0, 2, 0]){
            // remove the cage part
            mock_cage(h=100, hollow=false,bolt_nub_svg=bolt_nub_svg);
        }
        // remove seat area
        // note this includes rivnuts and drill holes
        mock_seat_tube(d=seat_tube_d, svg_name=svg_name);
        
        // remove extra weight
        lightner();
    }            
}

canondale_seat_tube_d = 35.25;
canondale_down_tube_d = 46.8;   //-48.25 lower end
fuji = 32;
height=85;
show_mock=false;
shift_amt_X= show_mock?40:20;
shift_amt_Y= show_mock?40:5;
/*
translate([shift_amt_X*-1, shift_amt_Y*-1, height/2])
    tool_bracket(left_size=3, right_size=4,
                        thickness=1.5,
                        label="CAD         DT",
                        seat_tube_d=canondale_down_tube_d,
                        show_mock=show_mock,
                        height=height,
                        extra_wide=true);
translate([shift_amt_X*1, shift_amt_Y*-1, height/2])
    tool_bracket(left_size=6, right_size=5,
                        thickness=2,
                        label="CAD          ST",
                        seat_tube_d=canondale_seat_tube_d,
                        show_mock=show_mock,
                        height=height);

translate([shift_amt_X*-1, shift_amt_Y*1, height/2])
    tool_bracket(left_size=3, right_size=4,
                        thickness=1.5,
                        label="FUJI         DT",
                        svg_name="FujiDowntubeProfile.svg",
                        show_mock=show_mock,
                        height=height);

translate([shift_amt_X*1, shift_amt_Y*1, height/2])
    tool_bracket(left_size=6, right_size=5,
                        thickness=2.0,
                        label="FUJI         ST",
                        seat_tube_d=fuji,
                        show_mock=show_mock,
                        height=height);
*/
/*
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
*/
// debug
//mock_seat_tube(svg_name="FujiDowntubeProfile.svg");
//rivnut(elongate=true);
/*translate([-10,0,0])
    mock_hex_key(d=3);
mock_hex_key(d=5);
*/
//mock_cage(bolt_nub_svg="CanondaleRedCageProfile.svg");