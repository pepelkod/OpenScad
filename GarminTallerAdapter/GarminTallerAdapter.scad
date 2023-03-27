$fn=160;

module Bloob(vect, rad=5, center=true){
    x = vect[0]/2-rad;
    y = vect[1]/2-rad;
    z = vect[2]/2-rad;
    hull(){
        translate([x,y,z]){
            sphere(r=5);
        }
        translate([x,y,-z]){
            sphere(r=5);
        }
        translate([x,-y,z]){
            sphere(r=5);
        }
        translate([x,-y,-z]){
            sphere(r=5);
        }
        translate([-x,y,z]){
            sphere(r=5);
        }
        translate([-x,y,-z]){
            sphere(r=5);
        }
        translate([-x,-y,z]){
            sphere(r=5);
        }
        translate([-x,-y,-z]){
            sphere(r=5);
        }

    }
}
module GarminFemale(){
    rotate([93,0,0]){
        translate([0,5,121]){
            import("GarminFemale.stl");
        }
    }
}
module Stack(height=0){

    union(){
        difference(){
            translate([0,0,-1.9]){
                Bloob([45,45, 10], center=true);
            }
            cylinder(d=32, h=100, center=true);
        }
        
        GarminFemale();
        translate([0,0,-5.5]){
            rotate([180,0,0]){
                import("GarminMale.stl");
            }
        }
    }
}


Stack();