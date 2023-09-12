$fn=80;

module venge_clip(){
//difference(){
    color("red"){

        translate([0,0,0]){

            h = 25;
            linear_extrude(h){
                import("VengeClipProfile.svg", center=true);
            }
        }
    }
}
module strap_nub(){
    leng=40;
    translate([0, leng/2,1]){
        rotate([90,0,0]){
            cylinder(h=leng,d=2);
        }
    }
}

module venge_stem(){
    translate([22.0,0,0]){
        strap_nub();
        translate([0,0,25-2]){
            strap_nub();
        }
    }
}

use <velcro.scad>

module ribble_plate(head_size=5){
    thick = 2;

    difference(){
        rotate([0,0,180]){
            difference(){
                linear_extrude(thick){
                    import("RibblePanel.svg", center=true);
                }
                // chamfer for bolt head
                color("Green"){
                    translate([-7.155,13.16,1]){
                        cylinder(d1=3, d2=head_size, h=1.01);
                    }
                }
            }
        }
        // chamfer for 2nd bolt head
        color("Green"){
            translate([-7.155,13.16,1]){
                cylinder(d1=3, d2=head_size, h=1.01);
            }
        }
    }
}

module ribble_plate_with_velcro(head_size=5){
    union(){
        translate([0,0,-1.9]){
            ribble_plate(head_size);
        }
        color("Blue"){
            difference(){
                large_array(5,15);
                translate([-7.155,13.16,-0.1]){
                    cylinder(d1=head_size, d2=head_size, h=4);
                }
                translate([7.155,-13.16,-0.1]){
                    cylinder(d1=head_size, d2=head_size, h=4);
                }

            }
        }
    }
}
module holder_with_velcro(){
    height=37;
    
    union(){
        translate([0,0,9.7]){
            large_array(5,15);
        }
        color("Purple"){
            translate([0, height/2,0]){
                rotate([90,0,0]){
                    linear_extrude(height){
                        import("HolderHollow.svg", center=true);
                    }
                }
            }
        }
        
    }
}
module holder_standalone(head_size){
    height = 36.25;
    difference(){
        translate([0, -height/2,9.6]){
            rotate([-90,0,0]){
                
                linear_extrude(height){
                    import("HolderShapeWithHoles.svg", center=true);
                }
            }
        }
        translate([-7.155,13.16,0]){
            cylinder(d1=head_size, d2=head_size, h=40);
        }
        translate([7.155,-13.16,0]){
            cylinder(d1=head_size, d2=head_size, h=40);
        }
    }
}

module ribble_plate_with_holder(){
    head_size=6;
    union(){
        ribble_plate(head_size=head_size);
         color("Purple"){
            holder_standalone(head_size=head_size);
         }
    }
}

ribble_plate_with_holder();
/*
translate([0,40,0]){
    ribble_plate_with_velcro();
}


//holder_with_velcro();

    translate([0,10,-50]){

        h = 100;
        linear_extrude(h){
            import("HolderShape.svg", center=true);
        }
    }

    translate([0,-22.5,-50]){

        h = 100;
        linear_extrude(h){
            import("HandlebarProfile.svg", center=true);
        }
    }
    */
//}