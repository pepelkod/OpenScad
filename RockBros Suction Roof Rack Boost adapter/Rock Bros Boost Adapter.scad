
$fn=80;

module gasket(){
    r_in = 19/2;
    r_gask = 3/2;    
    pos = r_in+r_gask;
    
    rotate_extrude(){
        translate([pos,0,0]){
            //rotate([90,0,0]){   
                circle(d=3);
            //}
        }
    }
}


module insert(gasket=false){
    // insert
    color("gray"){
        
        difference(){
            union(){
                cylinder(h=41, d=23.75);
                translate([0,0,40]){
                    cylinder(h=3.5, d = 30);
                    translate([0, 0, 2.5]){
                        cylinder(h=4.75+5, d=20.9);
                    }
                }
            }
            // axle hole
            translate([0,0,-1]){    
                cylinder(h=100, d=15.3);
            }
            // groove for rubber gasket
            translate([0,0,10]){
                gasket();
            }
            // second groove
            translate([0,0,35]){
                gasket();
            }
        }
    }
    if(gasket==true){
        // rubber gasket
        color("DarkSlateGray"){            
            translate([0,0,10]){
                gasket();
            }
            // second 
            translate([0,0,35]){
                gasket();
            }
        }
    }        
}

module alu_receiver(height=86.4){
    color("red"){
        difference(){
            cylinder(h=height, d=30, center=true);
            translate([0,0,0]){
                cylinder(h=height+2, d=24, center=true);
            }
        }
    }
} 
 
translate([0,0,3.4]){
    insert();
}
//alu_receiver();

translate([0,0,-3.4]){
    rotate([0,180,0]){
        insert(gasket=true);
    }
}


