

module sleeve(id){
    // three cylinders
    
    difference(){
        // outside
        cylinder(d=id+10, h=50, center=true);
        cylinder(d=id, h=1000);
        translate([0,0,-999]){
            cylinder(d=id-10, h=1000);
        }
    }
}

sleeve(id=75);