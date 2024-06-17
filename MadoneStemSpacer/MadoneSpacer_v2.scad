

module madone_spacer(height=16, skew=0.26){
    linear_extrude(16, center=true, slices=100){
        import(file="MadoneSpacer.svg", center=true);
    }
}

module madone_adapter(angle=16.2){
    height=18;
    skew = tan(angle);
    echo("angle ", angle)
    echo("skew ", skew)
    union(){
        // ANGLE TEXT
        color("Green"){
            translate([0,-27,6.5]){
                rotate([90,180,0]){
                    linear_extrude(3, center=true){
                        text(str(angle), size=4, halign="center");
                    }
                }
            }
        }
        intersection(){
            difference(){ 
                union(){
                    // main body
                    translate([0,0,8]){
                        madone_spacer(height, skew);
                        //cylinder(d=32,h=16, center=true);
                    }

                    // roof
                    color("Blue"){
                        translate([0,0,0]){
                            rotate([-0,0,0]){
                                linear_extrude(1, center=true, slices=100){
                                    import(file="MadoneSpacerTop.svg", center=true);
                                }
                            }
                        }         
                    }       
                }
                // cable holes
                rotate([0,180,0]){
                    translate([0,0,-40]){
                        rotate([45,0,0]){
                            hull(){
                                translate([3,0,0]){
                                    cylinder(h=100,d=8, center=true);
                                }
                                translate([-3,0,0]){
                                    cylinder(h=100,d=8, center=true);
                                }
                            }
                        }
                    }
                }
                // stem groove
                translate([0,0,-19]){
                    rotate([90-angle,0,0]){
                        #cylinder(h=100, d=25.4, center=true);
                    }
                }
                
            }
            // sloped area
            translate([0,0,-8]){
                rotate([-angle,0,0]){
                    cube([100,100,32], center=true);
                }
            }
        }
    }
}
vspace=30;
hspace=20;
translate([-hspace,-vspace,0]){
    madone_adapter(16.4);
}
translate([-hspace,vspace,0]){
    madone_adapter(16.5);
}
translate([hspace,-vspace,0]){
    madone_adapter(16.6);
}