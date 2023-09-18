$fn=80;

module ribble_plate(screw_size=3.2, head_size=6, thick = 3.2){

    difference(){
        rotate([0,0,180]){
            difference(){
                linear_extrude(thick){
                    import("RibblePanel.svg", center=true);
                }
            }
        }
    }
}
module wing_cutter(){
    leng = 31;
    fatness = 1.1;
    rotate([0,0,0]){
        cube([8.4,fatness,leng], center=true);
    }
    rotate([0,0,60]){
        cube([8.4,fatness,leng], center=true);
    }
    rotate([0,0,-60]){
        cube([8.4,fatness,leng], center=true);
    }

}
module bb_cutter_one_set(){
    diam = 3;  // ball diameter
    v_spread = 8.5/2;   // spacing between balls
    h_spread = 3;        /// spacing across hex
    translate([0,0,-8]){    // move to end of tool
        translate([0,h_spread,-v_spread]){
            sphere(d=diam);
        }
        translate([0,-h_spread,-v_spread]){
            sphere(d=diam);
        }
        translate([0,h_spread,v_spread]){
            sphere(d=diam);
        }
        translate([0,-h_spread,v_spread]){
            sphere(d=diam);
        }
    }
}
module bb_cutter(){
    rotate([0,0,-60]){
        bb_cutter_one_set();
    }
    rotate([0,0,0]){
        bb_cutter_one_set();
    }
    rotate([0,0,60]){
        bb_cutter_one_set();
    }
}
module holder_standalone(head_size, tool1upper, tool2upper, tool3upper, handleupper,
                                    tool1lower, tool2lower, tool3lower, handlelower){
    tool1x = 15.5;
    tool2x = 6.5;
    tool3x = -2.5;
                                        
    height = 36.25;
    difference(){
        translate([0, -height/2,9.6]){
            rotate([-90,0,0]){
                difference(){
                    linear_extrude(height){
                        import("HolderShape.svg", center=true);
                    }
                    // Tool holes
                    translate([tool1x, 1.6, 14]){
                        cylinder(h=40, d=tool1upper, center=true, $fn=6);
                    }
                    translate([tool2x, 1.6, 14]){
                        cylinder(h=40, d=tool2upper, center=true, $fn=6);
                    }
                    translate([tool3x, 1.6, 14]){
                        cylinder(h=40, d=tool3upper, center=true, $fn=6);
                    }
                    translate([-12.8, 0, 14]){
                        cylinder(h=40, d=handleupper, center=true, $fn=60);
                    }
                    // lower (smaller) tool holes
                    translate([tool1x, 1.6, 20]){
                        cylinder(h=40, d=tool1lower, center=true, $fn=6);
                    }
                    translate([tool2x, 1.6, 20]){
                        cylinder(h=40, d=tool2lower, center=true, $fn=6);
                    }
                    translate([tool3x, 1.6, 20]){
                        cylinder(h=40, d=tool3lower, center=true, $fn=6);
                    }
                    translate([-12.8, 0, 20]){
                        cylinder(h=40, d=handlelower, center=true, $fn=60);
                    }
                    // grooves for little wings to fit
                    translate([tool1x, 1.6, 15]){
                        wing_cutter();
                    }
                    translate([tool2x, 1.6, 15]){
                        wing_cutter();
                    }
                    translate([tool3x, 1.6, 15]){
                        wing_cutter();
                    }
                    // ball bearings
                    translate([tool1x, 1.6, 15]){
                        #bb_cutter();
                    }
                    translate([tool2x, 1.6, 15]){
                        bb_cutter();
                    }
                    translate([tool3x, 1.6, 15]){
                        bb_cutter();
                    }
                    
                }
            }
        }
    }
}

module ribble_plate_with_holder(tool1upper, tool2upper, tool3upper, handleupper,
                                tool1lower, tool2lower, tool3lower, handlelower){
    head_size=6;
    screw_size = 3.2;
    thick = 3.2;
    screw_head_height = 5.5;

    difference(){
        union(){
            ribble_plate(screw_size=screw_size, head_size=head_size, thick = thick);
            translate([0,0,1.2]){
                color("Purple"){
                    echo("tool holder", tool1upper, tool3upper, handleupper);
                    holder_standalone(head_size=head_size, tool1upper=tool1upper, tool2upper=tool2upper, tool3upper=tool3upper, handleupper=handleupper,
                                    tool1lower=tool1lower,tool2lower=tool2lower,tool3lower=tool3lower,handlelower=handlelower);
                }
            }
        }
        // screw holes for mounting
        translate([-7.155,13.16,screw_head_height]){
            union(){
                // big hole for head
                cylinder(d=head_size,  h=40);
                // chamfer for head
                translate([0,0,-1]){
                    cylinder(d1=screw_size, d2=head_size, h=1.01);
                }
                // screw hole
                translate([0,0,-20]){
                    cylinder(d=screw_size,  h=40);
                }
            }
        }

        translate([7.155,-13.16,screw_head_height]){
            union(){
                // big hole for head
                cylinder(d=head_size,  h=40);
                // chamfer for head
                translate([0,0,-1]){
                    cylinder(d1=screw_size, d2=head_size, h=1.01);
                }
                // screw hole
                translate([0,0,-20]){
                    cylinder(d=screw_size,  h=40);
                }
            }
        }
    }
}



module test_sizes(d1, d2, d3, d4){
    height = 4;
    
    difference(){
        linear_extrude(height){
            import("HolderShape.svg", center=true);
        }
        translate([14, 1.6, 0]){
            cylinder(h=40, d=d1, center=true, $fn=6);
        }
        translate([6, 1.6, 0]){
            cylinder(h=40, d=d2, center=true, $fn=6);
        }
        translate([-2, 1.6, 0]){
            cylinder(h=40, d=d3, center=true, $fn=6);
        }
        translate([-12.8, 0, 0]){
            cylinder(h=40, d=d4, center=true, $fn=60);
        }
        

    }
}
wiggle_room = 0.1;

ribble_plate_with_holder(   tool1upper=8.05+wiggle_room,
                            tool2upper=8.05+wiggle_room,
                            tool3upper=8.05+wiggle_room,
                            handleupper=10.4,
                            tool1lower=6.05,
                            tool2lower=5.05,
                            tool3lower=7.15,
                            handlelower=10.2);

/*
union(){
    thick = 4;
    translate([0, 21, 0]){
        test_sizes(7.05, 7.15, 7.25, 10.6);
    }
    translate([0, 7, 0]){
        test_sizes(7.35, 7.45, 7.55, 10.8);
    }
    translate([0, -7, 0]){
        test_sizes(7.65, 7.75, 7.85, 11.0);
    }
    translate([0, -21, 0]){
        test_sizes(7.95, 8.05, 8.15, 11.2);
    }
    translate([20,0,thick/2]){
        cube([4, 50, thick], center=true);
    }

}
*/
