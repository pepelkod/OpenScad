
$fn=128;

module faceplate_end(length, big_r, small_r){
    translate([(length/2.0)-big_r, 0,0]){
        intersection(){
            rotate_extrude(){
                translate([big_r-small_r,0,0]){
                    circle(small_r);
                }
            }
            translate([50,0,0]){
                cube([100,100,100], center=true);
            }
        }
    }
}

module faceplate_side(length, big_r, small_r){
    translate([0, big_r-small_r, 0]){
        rotate([0,90,0]){
            cylinder(h=(length-big_r*2), r=small_r, center=true);
        }
    }
}
module screw(head_height, head_top_dia, screw_dia){
    body_height = 10;
    union(){
        // cone head
        translate([0,0,-head_height/2]){
            cylinder(h=head_height, d1=screw_dia, d2=head_top_dia, center=true);
        }
        // screw body
        translate([0,0,-(body_height/2 + head_height)]){
            cylinder(h=body_height+0.01, d=screw_dia, center=true); 
        }
    }
  
}
    

module faceplate(length){
    big_r = 26.15/2;
    small_r=2;
    hole_spacing = 32;
    
    difference(){
        hull(){
        //union(){
            // rounded ends
            mirror([1,0,0]){
                faceplate_end(length=length, big_r=big_r, small_r=small_r);

               
            }
            faceplate_end(length=length, big_r=big_r, small_r=small_r);
            // sides
            mirror([0,1,0]){
                faceplate_side(length=length, big_r=big_r, small_r=small_r);
            }
            faceplate_side(length=length, big_r=big_r, small_r=small_r);
        }
        // screw holes
        mirror([1,0,0]){
            translate([hole_spacing/2,0,small_r+0.01]){
                screw(head_height=2, head_top_dia=8, screw_dia=3.7);
            }
        }
        translate([hole_spacing/2,0,small_r+0.01]){
            screw(head_height=2, head_top_dia=8, screw_dia=3.7);
        }
        // back screw hole recess
        translate([hole_spacing/2,0,-(small_r-(0.4/2))]){
            cylinder(h=0.41, d=6, center=true);
        }
        mirror([1,0,0]){
            translate([hole_spacing/2,0,-(small_r-(0.4/2))]){
                cylinder(h=0.41, d=6, center=true);
            }
        }
        /* size text
        translate([-8,-2.5,1.5]){
            linear_extrude(10){
                #text(str(length), size=5);
            }
        }*/

    }
}

faceplate(5);
/*
translate([5+25, 0, 0]){
    color("Green"){
        cube([10,200,10], center=true);
    }
}
*/