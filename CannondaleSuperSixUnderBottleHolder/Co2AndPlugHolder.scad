

//include <BOSL2/std.scad>
include <../BOSL2/std.scad>

include <knurledFinish.scad>


$fn=120;

module plug(d){
    plug_length = 50;
    
    cylinder(plug_length, d=d, center=true);
}

module plug_holder(){
    wall_percent = 1.2;
    d=13;
    
    translate([(d/2)*wall_percent,(d/2)*wall_percent,0]){
        difference(){
            scale([wall_percent, wall_percent, 1]){
                plug(d);
            }
            translate([0,0,2]){
                scale([1.0, 1.0, 1]){
                    plug(d);
                }
            }
        }
    }
}

module co2_holder(bar){
    id = 22;
    od = 27.5;
    height=90;
    
    valve_id = 17;
    

    translate([0,od/2,0]){
        union(){
            // valve clamp
            color("Blue"){
                translate([0,0,70]){
                    difference(){
                        cylinder(h=10, d=id+0.1, center=true);
                        cylinder(h=16, d=valve_id, center=true);
                        translate([0,10,0]){
                            rotate([0,0,45]){
                                cube(20, center=true);
                            }
                        }
                    }
                }
            }
            difference(){
                // tube
                translate([0,0,-0.1]){
                    difference(){
                        cylinder(h=height, d=od);
                        translate([0,0,-1]){
                            cylinder(h=555, d=id);
                        }
                    }
                }
                // side opening
                translate([-50,4,0]){
                    cube(100);
                }
                // magnet holes
                mag_thick=2.5;
                mag_height=10;
                mag_width=5;
                mag_y_amt = -(id/2+mag_thick/2)+0.1;
                translate([0,mag_y_amt,33-mag_height]){
                    cube([mag_width,mag_thick,mag_height], center=true);
                }
                translate([0,mag_y_amt,34]){
                    #cube([mag_width,mag_thick,mag_height], center=true);
                }

            }
            // ball end
            difference(){
                sphere(d=od);
                sphere(d=id);
                // chop top half sphere off
                translate([0,0,50]){
                    cube([100,100,100], center=true);
                }
                // make hole at bottom
                translate([0,0,-60]){
                    cube([100,100,100], center=true);
                }

            
            }
        }
    }
}
module screw_hole(){
    
    hull(){
        // ovalize the hole
        translate([0,0,0.5]){
            rotate([90,0,0]){
                cylinder(h=100, d=6, center=true);
            }
        }
        translate([0,0,0.5]){
            rotate([90,0,0]){
                cylinder(h=100, d=6, center=true);
            }
        }
    }
}
module cage(){
    color("Gray"){
        rotate([0,0,180]){
            translate([-116.5, -133, 64-18]){
                import("Everyday V3.stl");
            }
        }
    }
}

module knurl(height, dia, knurl_width, knurl_height, knurl_depth, knurl_cutoff, knurl_smooth_amount){
    knurled_cyl(height, 
        dia, 
        knurl_width, 
        knurl_height, 
        knurl_depth, 
        knurl_cutoff, 
        knurl_smooth_amount);    
}    

module valve(){
    /*
    knurl(21.3, 17.1, 1,2,0.5,0.6, 0);
    translate([0,0,21.3]){
        cylinder(h=13.3, d=17.1);
        translate([0,0,13]){
            // top
            knurl(13.3, 17, 1,2,0.5,0.6, 0);
        }
    }
    */
    import("Valve.stl");
}    
module co2_with_valve(){
    id = 22;
    height=67;
    

        color("LightGray"){
            union(){
                // valve
                translate([0,0,height]){
                    cylinder(47, d = 15);                
                    valve();
                }
                // Co2
                translate([0,0,id/2]){
                    cylinder(h=height-id, d=id);
                
                    sphere(d=id);
                    translate([0,0,height-id]){
                        sphere(d=id);
                    }
                    // neck
                    translate([0,0,height-20]){
                        cylinder(10, d1=16, d2=10);
                    }
                }

            }
        }
    //}
}

module seat_tube(){
    color("Gray"){
        translate([0,0,-100]){
            translate([0,0,-25]){
                rotate([90,0,0]){
                    cylinder(h=100, d=50, center=true);
                }
            }
        }
    }
}
module hole_swole(thick){
    translate([0,thick/2,0]){
        intersection(){
            translate([0,-thick*2,0]){
                sphere(d=20);
            }
            translate([0,thick*2,0]){
                sphere(d=20);
            }
            translate([0, 0,0]){
                cube([20,thick,20], center=true);
            }
        }
    }
}
module bung_hole_plate(hole_x, hole_y, thick){

    hull(){
        translate([(hole_x-hole_y)/2, 0,0]){
            cylinder(thick, d=hole_y);
        }
        translate([-(hole_x-hole_y)/2, 0,0]){
            cylinder(thick, d=hole_y);
        }
    }
}
module bung_hole_plug(){
    /*
    hole_y = 9.45;      // 9.25
    hole_x = 16.39;     // 16.19;
    top_hole_y = hole_y+2;
    top_hole_x = hole_x+2;
        
    // top plate
    translate([0,0,3]){
        bung_hole_plate(top_hole_x, top_hole_y, 1);
    }
    difference(){
        hull(){
            translate([0,0,2]){
                bung_hole_plate(hole_x, hole_y, 1);
            }
            translate([0,0,1]){
                bung_hole_plate(hole_x+0.5, hole_y+0.5, 1);
            }
            translate([0,0,0]){
                bung_hole_plate(hole_x, hole_y, 1);
            }
        }
        translate([0,0,-0.1]){
            bung_hole_plate(hole_x-3, hole_y-3, 3.2);
        }
        for(angle=[0: 45: 359]){
            rotate([0,0,angle]){
                translate([0,0,3/2]){
                    cube([0.5, 100, 3.2], center=true);
                }
            }
        }
    }
    */
    import("BungHolePlug.stl");
}
        
//bung_hole_plug();

module bar_with_holes(thick){
    length = 160;
    difference(){
        union(){
            // top
            translate([0, thick/2, -10]){
                cuboid([10,thick,length], rounding=thick/2);
            }
            // re-enforce hole
            hole_swole(thick);
            translate([0,0,64]){
                hole_swole(thick);
            }
        }
        screw_hole();
        translate([0,0,64]){
            screw_hole();
        }
    }
}

module bar_with_hole_and_bung(thick){
    length = 84;
    difference(){
        union(){
            // bar
            translate([0, thick/2, length/2]){
                cuboid([10,thick,length], rounding=thick/2);
            }
            // re-enforce hole
            hole_swole(thick);
            translate([0,-3.2,59]){
                rotate([-90,0,0]){
                    bung_hole_plug();
                }
            }
        }
        // screw hole
        screw_hole();
    }
}
module inside_curve(){
    difference(){
        translate([0,0,0]){
            cube(40);
        }
        cylinder(h=200, d=10);
    }
}

module thing(    thick ){

    // co2 holder
    difference(){
        translate([0, thick, -84]){
            co2_holder();
        }
        // drill final hole
        rotate([90,0,0]){
            cylinder(h=100, d=6, center=true);
        }
        // drill head
        translate([0,9,0]){
            rotate([90,0,0]){
                cylinder(h=10, d=10, center=true);
            }
        }
        // round
        translate([20,15.2,0.9]){
            rotate([0,-90,0]){
                inside_curve();
            }
        }
    }    

    rotate([0,180,0]){
        bar_with_hole_and_bung(thick);
    }
    // obstructions
    //cage();
    //seat_tube();
    
    //co2_with_valve();
}

thick = 2.5;

thing(thick = thick);

/* co2
translate([0, thick, -84]){
    id = 22;
    od = 27.5;
    height=40;

    translate([0,od/2,-id/2]){

        co2_with_valve();
    }
}
//*/