

module make_one(filename, height){
  linear_extrude(height = height, center = true, scale=1)
    import(file =filename, center = true);
}  

height=22.225;


/*
make_one("End.svg", height=height);
translate([0,0,height]){
    make_one("OddHalf.svg", height=height);
    translate([0,0,height]){
        make_one("EvenHalf.svg", height=height);
        translate([0,0,height]){
            make_one("OddFull.svg", height=height);
            translate([0,0,height]){
                make_one("EvenFull.svg", height=height);
                translate([0,0,height]){
                    make_one("OddFull.svg", height=height);
                }
            }
        }
    }
}
*/


make_one("End.svg", height=height);