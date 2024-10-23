
$fn=80;
use <roundedcube.scad>;

module co2_holder(){
    id = 22;
    od = id*1.1;
    height=40;
    belt_loop_thick = 9;
    belt_loop_od = od+belt_loop_thick;
    belt_loop_id = id+belt_loop_thick-1;
    union(){
        // belt loops
        intersection(){
            // height/2 is how high to raise it
            // height/4 is 1/2 of its height since it is centered
            // 100 is 1/2 of x width 200...so we only get one loop
            translate([belt_loop_od/4, 0, height/2 + height/4]){
                roundedcube([belt_loop_od/2,10,20], radius=2, center=true);
                //cube([belt_loop_od/2,10,20], center=true);
            }
            union(){
                // belt loop outside
                difference(){
                    cylinder(h=height, d=belt_loop_od);
                    translate([0,0,-1]){
                        cylinder(h=45, d=belt_loop_id);
                    }
                }
                // top belt loop closure
                translate([0,0,height-2]){
                    difference(){
                        cylinder(h=2, d=belt_loop_od);
                        translate([0,0,-1]){
                            cylinder(h=45, d=id);
                        }
                    }
                }
                // bottom belt loop closure
                translate([0,0,height/2]){
                    difference(){
                        cylinder(h=2, d=od+6);
                        translate([0,0,-1]){
                            cylinder(h=45, d=id);
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
                        cylinder(h=45, d=id);
                    }
                }
            }
            /* optional notch to help hold
            translate([0,0,height/1]){
                cube([8, 100, height], center=true);
            }*/
        }
        // ball end
        difference(){
            sphere(d=od);
            sphere(d=id);
            translate([0,0,50]){
                cube([100,100,100], center=true);
            }
            translate([0,0,-60]){
                cube([100,100,100], center=true);
            }

        
        }
        /*
        // threads
        intersection(){
            translate([-44.25,5.5,6]){
                rotate([90,0,0]){
                    color("Red"){
                        import("Left_V2_1.stl");
                    }
                }   
            }
            cylinder(h=100, d=13, center=true);
        }
        */
    }
}
//spacer();
co2_holder();
    