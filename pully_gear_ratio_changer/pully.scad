

$fn=80;


// for wolftool tanpan sized bearing

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


ratio = 0.8547;
cable = 1.2;
halfcable = cable/2;
// od, depth groove, both sides
erd1 = 28 - 1;
// calc erd2 from the centerpoint of the cable, not the grove edge
erd2 = ((erd1 + halfcable) * 0.8529) - halfcable;

thickness = 3;
difference(){
    // body
    translate([0,0,thickness/2]){
        union(){
            pully_by_filename(erd=erd1, thickness=thickness, filename="pully.svg");
            translate([0,0,thickness-0.01])
                pully_by_filename(erd=erd2, thickness=thickness, filename="pully.svg");
        }
    }
    // bearing hole
    translate([0,0,-1]){
        cylinder(h=20, d=13);
    }
    // thru hole
    translate([0,13.5,3.2]){
        rotate([25,45,0]){ 
            cylinder(h=4, d=2, center=true);
        }
    }
    // screw hole
    translate([4, 11.7, 1.5]){
        rotate([-15,1,0]){
            cylinder(h=15, d=2, center=true);
        }
    }
}