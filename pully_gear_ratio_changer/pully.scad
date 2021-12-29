

$fn=80;




// PULLY_BY_FILENAME
// This is a cutaway outline of a pully.  
// erd: Effective rim diameter.  Still needed to move the shape out to the correct radius
// filename:  A svg file that has a rim "cutaway" shape.  See rim.svg for example
module pully_by_filename(erd=25, thickness=3, filename="pully.svg"){ 
err = erd/2; 
    union(){  
        // solid center
        translate([0,0,-thickness/2])
            cylinder(h=thickness, d=erd);
        // edge with groove
        rotate_extrude($fn=200){
            translate([err, 0, 0]){
                import(file=filename);
            }
        }
    }
}


// od, depth groove, both sides
erd1 = 28.7-2;
erd2 = erd1 / 1.17;
ratio = erd1/erd2;
echo("erd1", erd1);
echo("erd2", erd2);
echo("ratio", ratio);
thickness = 3;

difference(){
    difference(){
        // main body
        translate([0,0,thickness/1.9]){
            union(){
                pully_by_filename(  erd=erd1,
                                    thickness=thickness,
                                    filename="pully.svg");
                translate([0,0,thickness])
                    pully_by_filename(  erd=erd2,
                                        thickness=thickness,
                                        filename="pully.svg");
            }
        }
        // center hole
        translate([0,0,-1]){
            cylinder(h=20, d=13);
        }
    }
    // cable hole
    translate([0,13.2,3.2]){
     rotate([25,45,0]){ 
        cylinder(h=4.3, d=2, center=true);
     }
    }
    // screw hole
    rotate([0,0,-15]){
        translate([0,13.2,0]){
            cylinder(h=10, d=1.5, center=true);
        }
    }
 }
 //pully_by_filename();