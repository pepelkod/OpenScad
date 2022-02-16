

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
           cylinder(h=thickness, d=erd+0.01);
    // edge with groove
    rotate_extrude($fn=200)
        translate([err, 0, 0])
            import(file=filename);

}

module double_pully(ratio=0.8547, erd1=25){
    bearing_hole=13;
    cable = 1.2;
    halfcable = cable/2;

    // calc erd2 from the centerpoint of the cable, not the grove edge
    erd2 = ((erd1 + halfcable) * ratio) - halfcable;

    thickness = 3;
    difference(){
        // body
        translate([0,0,thickness/2]){
            union(){
                pully_by_filename(erd=erd1, thickness=thickness, filename="pully.svg");
                translate([0,0,thickness-0.01])
                    color("red"){
                        pully_by_filename(erd=erd2, thickness=thickness, filename="pully.svg");
                    }
            }
        }
        // bearing hole
        translate([0,0,-1]){
            cylinder(h=20, d=bearing_hole);
        }
        // thru hole
        translate([0,erd1/2,3.4]){
            rotate([15,80,0]){ 
                cylinder(h=40, d=2, center=true);
            }
        }
        // screw hole
        //translate([4, 11.7, 1.5]){
        //    rotate([-15,1,0]){
        //        cylinder(h=15, d=2, center=true);
        //    }
        //}
    }
    color("green"){
        // print ratio
        translate([0,bearing_hole/2+1.5,thickness*2-0.2]){
            linear_extrude(2){
                text(str(ratio), size=2, halign="center", valign="center");
            }
        }
        // print erd
        translate([0,-(bearing_hole/2+1.5),thickness*2-0.2]){
            linear_extrude(2){
                text(str(erd1), size=2, halign="center", valign="center");
            }
        }
    }

}

translate([0, 30, 0]){
    double_pully(ratio=0.8547, erd1=25);
}
translate([0, -30, 0]){
    double_pully(ratio=0.7941, erd1=25);
}

translate([30, -30, 0]){
    double_pully(ratio=0.8547, erd1=23);
}
translate([-30, -30, 0]){
    double_pully(ratio=0.7941, erd1=23);
}

translate([30, 0, 0]){
    double_pully(ratio=0.8547, erd1=21);
}
translate([-30,0, 0]){
    double_pully(ratio=0.7941, erd1=21);
}

translate([30, 30, 0]){
    double_pully(ratio=0.8547, erd1=19);
}
translate([-30, 30, 0]){
    double_pully(ratio=0.7941, erd1=19);
}