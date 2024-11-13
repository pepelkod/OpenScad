
$fn=360;

module test_plug(size){
    difference(){
        cube([size+12, size+12, 2], center=true);
        cube(size, center=true);
    }
}

    
module square(width, height){
    translate([0,0,height/2]){
        cube([width, width, height], center = true);
    }
    
}

module jack(od, sq_width, sq_height, depth){
    union(){
        difference(){
            translate([0,0, (depth-1)/2]){
                cube([od+2, od+2, depth+2], center=true);
            }
            cylinder(h=depth, d=od);
        }
        square(sq_width, sq_height);
    }
}

module insert(id, sq_width, lower_taper_height){

    intersection(){
        difference(){
            union(){
                // upper taper
                translate([0,0,lower_taper_height+5]){
                    cylinder(h=30, d1=id+0.5, d2=id);
                }
                // middle lip
                translate([0,0,lower_taper_height-0.1]){
                    cylinder(h=5.2, d=id+0.5);
                }
                // lower taper            
                cylinder(h=lower_taper_height, d2=id+0.5, d1=id-2);
            }
            translate([0,0,-0.1]){
                square(sq_width, lower_taper_height+5);
            }
            // side notch
            translate([(id/2.0), 0,0]){
                cylinder(d=2.5, h=200, center=true);
            }
            
            
        }
    }    
}

in2mm = 25.4;
hole_depth_in = 2;
hole_depth_mm = hole_depth_in * in2mm;
sq_height_mm = 15.875;

rotate([180,0,0]){
    insert(id=26.8, sq_width=15, lower_taper_height=28.3);
}

//jack(od=30, sq_width=15, sq_height=sq_height_mm, depth=hole_depth_mm);




