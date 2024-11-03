

    
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
insert(id=24.5, od=32, sq_width=14, sq_height=26);
//square(width=14, height=26);