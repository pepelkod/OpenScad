

module teeth(){
    slices=8;
    slice_size = 360/slices;

    for(i=[0:slices]){
        rotate([slice_size*i,0,0]){
            translate([20*(i%2), 50, 0]){
                cube([20, 40, 20], center=true);
            }
        }
    }    
}

module gravel_cylinder(slices=60, teeth=true){

    slice_size = 360/slices;
    radius = 5;
    offsets=rands(-25, 25, slices+1);
    for(i=[0:slices]){
        rotate([slice_size*i,0,0]){
            translate([offsets[i], radius, 0]){
                rotate([-45, 0, 0]){
                    translate([0,14,0]){
                        scale(2){
                            if(teeth!=true){
                                import("stones.stl", center=true);
                            }else{
                                translate([-50,0,0]){
                                    cube([100,10,14]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
module teeth(){
    tooth_size=85;
    // teeth
    cube([10.02,tooth_size,tooth_size]);
    rotate([180, 0, 0]){
        cube([10.02,tooth_size, tooth_size]);
    }
}
module main(gravel=true, middle=true){
        
    difference(){
        len_tube = 130;
        half_len_tube = len_tube/2;
        
        gravel_cylinder(30, !gravel);
        // teeth
        translate([half_len_tube,0,0]){
            teeth();
        }
        if(middle==true){
            translate([-(half_len_tube+10.01),0,0]){
                teeth();
            }
        }
        // flatten right end
        translate([(half_len_tube+10), -100, -100]){
            cube(200);
        }

        
        // flatten left end
        translate([-(half_len_tube+200+10), -100, -100]){
            cube(200);
        }
        /*
        translate([150, 0, 0]){
            translate([0,0,0]){
                cube(200, center=true);
            }
        }
        */
        // hole
        rotate([0,90,0]){
            cylinder(d=85, h=1000, center=true);
        }
    }
    // 85 diameter
    // 385 len
}

main(gravel=true, middle=false);