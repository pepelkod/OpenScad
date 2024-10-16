
$fn=80;
use <roundedcube.scad>;

module spacer(oo_width = 24.5, o_width=19.6, od=10.5, i_width = 14.5, id=5.4, h1=7.1, h2=1.5){
    ood = od*(oo_width/o_width);
    
    difference(){
        union(){
            // outermost oval
            echo("OOD ", ood);
            echo("oo_width ", oo_width);
            hull(){
                translate([(oo_width-ood)/2, 0, 0]){
                    cylinder(h=h1, d = ood, center=true);
                }
                translate([-(oo_width-ood)/2, 0, 0]){
                    cylinder(h=h1, d = ood, center=true);
                }
            }

            // middle oval
            echo("OD ", od);
            echo("o_width ", o_width);
            hull(){
                translate([(o_width-od)/2, 0, h2]){
                    cylinder(h=h1, d = od, center=true);
                }
                translate([-(o_width-od)/2, 0, h2]){
                    cylinder(h=h1, d = od, center=true);
                }
            }
        }
    
        // inner cutout oval
        echo("iD ", id);
        echo("iwidth", i_width);
        hull(){
            translate([(i_width-id)/2, 0, 2.5]){
                cylinder(h=18.5, d = id, center=true);
            }
            translate([-(i_width-id)/2, 0, 2.5]){
                cylinder(h=18.5, d = id, center=true);
            }
        }
    }
}
module co2_holder(){
    id = 22;
    od = id*1.1;
    union(){
        // belt loops
        color("Orange"){
            intersection(){
                translate([od/2+2, 0, 30]){
                    cube([200,10,20], center=true);
                }
                difference(){
                    cylinder(h=40, d=od+6);
                    translate([0,0,-1]){
                        cylinder(h=45, d=id+5);
                    }
                }
            }
            intersection(){
               translate([od/2+2, 0, 30]){
                    cube([200,10,20], center=true);
                }
 
                // top belt loop closure
                translate([0,0,30+6]){
                    difference(){
                        cylinder(h=4, d=od+6);
                        translate([0,0,-1]){
                            cylinder(h=45, d=id);
                        }
                    }
                    translate([0,0,-20+4]){
                        difference(){
                            cylinder(h=4, d=od+6);
                            translate([0,0,-1]){
                                cylinder(h=45, d=id);
                            }
                        }
                    }
                }                       
            }
        }
        
        // tube
        translate([0,0,-0.1]){
            difference(){
                cylinder(h=40, d=od);
                translate([0,0,-1]){
                    cylinder(h=45, d=id);
                }
            }
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
    