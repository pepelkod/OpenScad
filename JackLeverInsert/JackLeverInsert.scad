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

module insert(id, od, sq_width, sq_height){
    difference(){
        union(){
            translate([0,0,5]){
                cylinder(sq_height, d=id);
            }
            translate([0,0,0.1]){
                cylinder(5, d=od);
            }
        }
        square(sq_width, sq_height);
        
    }
    
}
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




//insert(id=24.5, od=32, sq_width=14, sq_height=26);
//square(width=14, height=26);