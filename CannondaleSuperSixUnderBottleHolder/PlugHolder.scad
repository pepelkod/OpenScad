
$fn=120;


module hole_swole(big_r, small_r){
    difference(){
        rotate([90,0,0]){
            hull(){
                rotate_extrude(){
                    translate([big_r-small_r,0,0]){
                        circle(small_r);
                    }
                }
            }
        }
        // rivnut recess
        rivnut_depth=1;
        translate([0,-8+rivnut_depth,0]){
            rotate([90,0,0]){
                cylinder(h=10, d=10.5, center=true);
            }
        }
    }
}

module clamp(plug_dia){
    id = plug_dia;
    od = id+4;
    translate([0,od/2,0]){
        intersection(){
            difference(){
                cylinder(h=40, d=od, center=true);
                cylinder(h=41, d=id, center=true);
            }
            // curved edge
            translate([0,-20,0]){
                rotate([0,90,0]){
                    cylinder(h=100, d=48,center=true);
                }
            }
        }
    }
    translate([od/2-0.5,od/3,8]){
        rotate([90,90,90]){
            linear_extrude(1){
                text(str(id),size =5);
            }
        }
    }
}

module thing(plug_dia){
    small_r = 3;
    difference(){
        union(){
            translate([0,small_r/2,0]){
                clamp(plug_dia);
            }
            hole_swole(big_r = 9, small_r=small_r);
        }
        // drill main hole
        translate([0,5,0]){
            rotate([90,0,0]){
                cylinder(h=20, d=6, center=true);
            }
        }
        // bolt head hole
        translate([0,10+1,0]){
            rotate([90,0,0]){
                cylinder(h=20, d=10, center=true);
            }
        }

    }
}

translate([-15,-10,0]){
    thing(15);
}
translate([15,-10,0]){
    thing(16);
}
translate([-15,10,0]){
    thing(14.9);
}
translate([15,10,0]){
    thing(15.9);
}