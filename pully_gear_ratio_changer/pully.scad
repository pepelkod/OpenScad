

$fn=80;




// PULLY_BY_FILENAME
// This is a cutaway outline of a pully.  
// erd: Effective rim diameter.  Still needed to move the shape out to the correct radius
// filename:  A svg file that has a rim "cutaway" shape.  See rim.svg for example
module pully_by_filename(erd=25, thickness=2.5, filename="pully.svg"){ 
err = erd/2;   
// solid with hole in middle
translate([0,0,-thickness/2])
       cylinder(h=thickness, d=erd);
// edge with groove
rotate_extrude($fn=200)
    translate([err, 0, 0])
        import(file=filename);

}



// od, depth groove, both sides
erd1 = 25 - 1;
erd2 = erd1 * 0.8529;
thickness = 2.3;
difference(){
difference(){
    difference(){
        translate([0,0,thickness/2])
            union(){
                pully_by_filename(erd=erd1, thickness=thickness, filename="pully.svg");
                translate([0,0,thickness])
                    pully_by_filename(erd=erd2, thickness=thickness, filename="pully.svg");
            }
        translate([0,0,-1])
            cylinder(h=20, d=11);
        }
    translate([0,0,1.25])
        cylinder(h=20, d=12);
 }
 
 translate([0,13.1,2.5]){
rotate([35,45,0]){ 
    cylinder(h=3, d=2, center=true);
 }
 }
 }