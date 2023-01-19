
$fn=160;

module male(){
    rotate([0,0,90]){
        import("GarminMale.stl");
    }
}
module female(){
    rotate([0,0,90]){
        rotate([3.05-90,0,0]){
            translate([0,0,121.3]){
                import("GarminFemale.stl");
            }
        }
    }

}
module battery(){
    
    rotate([90,0,0]){
        difference(){
            union(){
                cylinder(h=50, d=36, center = true);
                rotate([90,0,0]){
                    cylinder(h=30, d1=35.0, d2=33.5, center = true);
                }
            }
        
            linear_extrude(100, center=true){
                import("BatteryHole.svg");
            }
        }
    }
}




module round_battery_holder(){
    translate([0,0,15]){
        male();
    }
    battery();

    translate([0,0,-25]){
        female();
    }
}

module flat_mount_remix(){
    union(){
        translate([0,0,-10.5]){
            female();
        }
        //cylinder(r1=17, r2=20, h=4);
    }
}
module flat_battery_holder(){
    thickness = 8.6;
    width = 62;
    length = 96;
    wall = -4;
    outer_width=width+wall;

    difference(){
        union(){
            translate([-6,-(outer_width/2),0]){
                cube([12,outer_width,outer_width]);
            }
            translate([0,outer_width/2,0]){
                sphere(d=12);
            }
            translate([0,-(outer_width/2),0]){
                sphere(d=12);
            }
            translate([0, outer_width/2, 0]){
                cylinder(d=12, h=outer_width);
            }
            translate([0, outer_width/2, 0]){
                rotate([90,0,0]){
                    cylinder(d=12, h=outer_width);
                }
            }
            translate([0, -(outer_width/2), 0]){
                cylinder(d=12, h=outer_width);
            }
            translate([4.31,0,20]){
                rotate([0,90,0]){
                    male();
                }
            } 
            translate([-14,0,20]){
                rotate([0,90,0]){
                    female();
                }
            } 
        }
        color("Black"){
            translate([-thickness/2, -(width/2), 0]){ 
                cube([thickness, 62,  96]);
            }
        }
        translate([-10,0,-42]){
            rotate([0,90,0]){
                cylinder(d=86, h=20);
            }
        }
    }
}
module flat_mount_remix(){
    intersection(){
        #union(){
            translate([0,0,-8.5]){
                difference(){
                    cylinder(r=18,h=8);
                    translate([0,0,-1]){
                        cylinder(r=14.7,h=12);
                    }
                }
            }
            translate([0,0,-10.5]){
                female();
            }
            //cylinder(r1=17, r2=20, h=4);
        }
        translate([0,0,-8.5]){
            cylinder(r=18,h=4.68 );
        }
        
    }
}
flat_battery_holder();

/*rotate([90,90,0]){
    round_battery_holder();
}*/

/*
rotate([0,90,0]){
    flat_mount_remix();
}
    */

