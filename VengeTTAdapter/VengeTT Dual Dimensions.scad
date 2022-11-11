use <bend.scad>
$fn=200;

dia = 31.75;
rad = dia/2;

module horiz_curve(){
    intersection(){
        color("red"){
            translate([-50, 0,-50]){
                cube([100,31.9,100]);
            }
        }
        color("orange"){
            linear_extrude(height=dia*2){
                import("Venge Curve Horizontal.svg");
            }
        }
    }
}
module 32mm(){

    // widest
    translate([-4.5,32,0]){
        rotate([90,0,0]){
            color("blue"){
                linear_extrude(height=1){
                    import("Venge Handlebar Widest.svg");
                }
            }
        }
    }
}

module 24mm(){
    // 34/ 24mm
    translate([-1.95,24,0]){
        rotate([90,0,0]){
            color("brown"){
                linear_extrude(height=1){
                    import("Venge Handlebar 24mm.svg");
                }
            }
        }
    }
}
module 16mm(){
    // middle
    translate([-.4,16,0]){
        rotate([90,0,0]){
            color("green"){
                linear_extrude(height=1){
                    import("Venge Handlebar middle.svg");
                }
            }
        }
    }
}


module 8mm(){
    // 1/4 8mm
    translate([(dia/2)-0.1,8,dia/2]){
        rotate([90,0,0]){
            color("purple"){
                intersection(){
                    translate([-18.959, -50, -1]){
                        cube([18.959, 100, 3]);
                    }
                    cylinder(h=1, d=dia);
                }
            }
        }
    }
}


module 0mm(){
    // inside
    translate([(dia/2)-0.9,0.5,dia/2]){
        rotate([90,0,0]){
            color("yellow"){
                intersection(){
                    translate([-18.959, -50, -1]){
                        cube([18.959, 100, 3]);
                    }
                    cylinder(h=1, d=dia);
                }
            }
        }
    }
}

module bar_shape(){
    union(){
        hull(){
            32mm();
            24mm();
        }
        hull(){
            24mm();
            16mm();
        }
        hull(){
            16mm();
            8mm();
        }
        hull(){
            8mm();
            0mm();
        }
    }
}
module bars(){
    translate([-rad/3, 0, rad]){
        rotate([-90,0,0]){
            intersection(){
                translate([-100,-50,0]){
                    cube([100,100,32]);
                }
                translate([0,0,-2]){
                    cylinder(h=100, d=dia);
                }
            }
        }
    }
}

module bar_dip(){
        intersection(){
            color("white"){
                translate([-6,0,0]){
                    cube([dia,32,dia]);
                }
            }
        
            difference(){
                translate([10,0,0]){
                    horiz_curve();
                }
                bar_shape();
            }
        }
}
module right(){
    translate([23,0,0]){
        union(){
            bars();
            bar_dip();
        }
    }
}


right();

mirror([1,0,0]){
    right();
}