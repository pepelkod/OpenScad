
$fn=160;

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


module insert(axle_dia=12.0, width=142, gasket=false){
    axle_dia_with_clearance=axle_dia*1.02;
    extension_len = 4.75 + ((width-100)/2);
    extension_dia = axle_dia * 1.3660130718954248366013071895425;
    // insert
    color("gray"){
        
        difference(){
            union(){
                // insert part
                cylinder(h=41, d=23.75);
                translate([0,0,40]){
                    // lip
                    cylinder(h=3.5, d = 30);
                    translate([0, 0, 2.5]){
                        // extension
                        cylinder(h=extension_len, d=extension_dia);
                        // strengthen extension
                        cylinder(h=extension_len-5, d=23.75);

                    }
                }
            }
            // axle hole
            translate([0,0,-1]){     
                cylinder(h=100, d=axle_dia_with_clearance);
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
 
module front_110x15mm_boost_insert(){
    insert(axle_dia=15.0, width=110, gasket=false);
}
module rear_142x12mm_insert(){
    insert(axle_dia=12.0, width=142, gasket=false);
}

//*
translate([16,0,0]){
    front_110x15mm_boost_insert();
}
/*/
translate([-16,0,0]){
    rear_142x12mm_insert();
}
//*/

//alu_receiver();

/*translate([0,0,-3.4]){
    rotate([0,180,0]){
        insert(gasket=true);
    }
}
*/

