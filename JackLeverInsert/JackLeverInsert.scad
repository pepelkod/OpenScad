module test_plug(size){
    difference(){
        cube([size+12, size+12, 2], center=true);
        cube(size, center=true);
    }
}

    
module square(width, height){
    translate([0,0,height/2]){
        cube([width, width, 26], center = true);
    }
    
}
$fn=360;
module insert(id, od, sq_width, sq_height){

    intersection(){
        difference(){
            union(){
                // upper taper
                translate([0,0,29.9]){
                    cylinder(h=30, d1=id+0.5, d2=id-1);
                }
                // middle lip
                translate([0,0,26]){
                    cylinder(h=5, d=od);
                }
                // lower taper            
                cylinder(h=30, d2=id+0.5, d1=id-2);
            }
            translate([0,0,-0.1]){
                square(sq_width, sq_height);
            }
            // side notch
            translate([(id/2), 0,0]){
                cylinder(d=5, h=200, center=true);
            }
            
            
        }
    }    
}
/*
dist = 14;
translate([dist,dist,0]){
    test_plug(12);
}
translate([-dist,dist,0]){
    test_plug(13);
}
translate([dist,-dist,0]){
    test_plug(14);
}
translate([-dist,-dist,0]){
    test_plug(15);
}

*/


insert(id=26.5, od=30, sq_width=15, sq_height=26);
//square(width=14, height=26);