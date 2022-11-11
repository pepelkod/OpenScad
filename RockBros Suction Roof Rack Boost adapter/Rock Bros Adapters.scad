
$fn=160;



//openscad resolution
$fa = 4;
$fs = 1;
 



module makeChainRing(numberOfTeeth = 50, numberOfBolts = 5, bcd = 110) {
    ////////
    // CHAINRING OPTIONS
    //cam options
    makeBoundsForToothCutPocket = "false";
    doProjectionFor2dCam = "false";

    //general chainring options
    boltHoleDiameter = 4; //10mm seems standard (a bit bigger to be safe)
    internalDiameterOffsetFromHoles = 2.75; //seems typical

    ringThickness = 2.5;  //seems about right (and is 7075 stock I have..)
    //toothThickness = 2.1; //should be OK for 8/9 speed - want thinner for 10
    toothThickness = 2.0;
    toothThinningRadiusInset = 9;

    pocketBoundsWidth = 3;

    //tooth options
    widthPerCog = 12.7; //.5 inch in mm
    rollerDiameter = 7.6;
    cutDepth = 5.1;
    rollerCenterInsetFromExternalDiameter = cutDepth - (rollerDiameter / 2);
    roundingDiameter = cutDepth * 5.6;
    roundingOffset = cutDepth * 2.48;
    toothAspectRatio = .9;

    // constant? 
    pi = 3.1415;

    innerDiameter = (bcd - boltHoleDiameter) -  internalDiameterOffsetFromHoles;

    externalDiameter = ((numberOfTeeth * widthPerCog) / pi)  + rollerCenterInsetFromExternalDiameter * 2;
    difference() {    
        cylinder (ringThickness, externalDiameter / 2, externalDiameter / 2);
        for (tooth = [0 : numberOfTeeth]) {
            rotate ([0, 0, (360 / numberOfTeeth) * tooth])
            translate ([externalDiameter / 2, 0, -.1])
             tooth(toothAspectRatio, ringThickness, cutDepth, roundingOffset, roundingDiameter);
        }
        
        for (bolt = [0 : numberOfBolts]) {
            rotate ([0, 0, (360 / numberOfBolts) * bolt])
            translate ([bcd / 2, 0, -.1])
            cylinder (ringThickness * 2, boltHoleDiameter / 2, boltHoleDiameter / 2);
        }

        //inner cut
        translate ([0, 0, -.1]){
            cylinder (ringThickness * 2,innerDiameter / 2,innerDiameter / 2);
        }
        //thin teeth
        translate ([0, 0, toothThickness]){
            teethThin(externalDiameter, ringThickness, toothThinningRadiusInset);
        }
        if (makeBoundsForToothCutPocket == "true"){
            boundsForToothCutPocket(
                externalDiameter,
                ringThickness,
                toothThinningRadiusInset,
                pocketBoundsWidth);
        }
    }

}

module teethThin(externalDiameter, ringThickness, toothThinningRadiusInset) {
    difference() {
        cylinder (ringThickness, (externalDiameter / 2) + 1, (externalDiameter / 2) + 1);
        translate ([0, 0, -.1])
        cylinder (ringThickness + 1, (externalDiameter / 2) - toothThinningRadiusInset,
            (externalDiameter / 2) - toothThinningRadiusInset);
    }
}


module boundsForToothCutPocket(externalDiameter, ringThickness, toothThinningRadiusInset, pocketBoundsWidth) {
    translate ([0, 0, -.1])
    difference() {    
        cylinder (ringThickness + 1, (externalDiameter / 2) - toothThinningRadiusInset,
            (externalDiameter / 2) - toothThinningRadiusInset);
        cylinder (ringThickness + 1, (externalDiameter / 2) - (toothThinningRadiusInset + pocketBoundsWidth),
            (externalDiameter / 2) - (toothThinningRadiusInset + pocketBoundsWidth));    
    }
}    


module tooth(toothAspectRatio, ringThickness, cutDepth, roundingOffset, roundingDiameter){
    scale ([1,toothAspectRatio,1])
    cylinder (ringThickness * 2, cutDepth, cutDepth);
    translate ([roundingOffset, 0, 0])
    cylinder (ringThickness * 2, roundingDiameter / 2, roundingDiameter / 2);
}
/////////////////
// spacer

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
    axle_dia_with_clearance=axle_dia*1.03;
    extension_len = 4.75 + ((width-100)/2);
    extension_dia = axle_dia * 1.3660130718954248366013071895425;
    // insert
    color("gray"){
        
        difference(){
            union(){
                // insert part
                cylinder(h=41, d=23.75);
                translate([0,0,40]){
                    union(){
                        // lip
                        cylinder(h=3.5, d = 30);
                        translate([0, 0, 3.5]){
                            union(){
                                // extension
                                cylinder(h=extension_len, d=extension_dia);
                                // strengthen extension  with CONE
                                cylinder(h=extension_len-5, d1=30, d2=extension_dia);
                            }
                        }
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
 
module front_110x15mm_boost_insert(gasket=false){
    insert(axle_dia=15.0, width=110, gasket=gasket);
}
module rear_142x12mm_insert(gasket=false){
    axle_dia = 12.0;
    insert(axle_dia=axle_dia, width=142, gasket=gasket);
    
    base_cog_position=60;
    //translate ([(externalDiameter / 2), (externalDiameter / 2), -1]) {
    translate ([0, 0, base_cog_position]) {
        makeChainRing(numberOfTeeth = 11, numberOfBolts = 6,bcd = axle_dia*2);
    }    
}
module rear_148x12mm_insert(gasket=false){
    axle_dia = 12.0;
    insert(axle_dia=axle_dia, width=148, gasket=gasket);

    base_cog_position=63;
    //translate ([(externalDiameter / 2), (externalDiameter / 2), -1]) {
    translate ([0, 0, base_cog_position]) {
        makeChainRing(numberOfTeeth = 11, numberOfBolts = 6,bcd = axle_dia*2);
    }    

}

/*
translate([0,0,0]){
    front_110x15mm_boost_insert();
}
*/
//*
translate([0,0,0]){
    rotate([180,0,0]){
        rear_148x12mm_insert(gasket=false);
    }
}
/*/
translate([0,0,0]){
    rotate([180,0,0]){
        rear_142x12mm_insert(gasket=false);
    }
}

/*
translate([0,0,-3.5]){
    #alu_receiver();
}
translate([0,0,-7]){
    rotate([0,180,0]){
        rear_148x12mm_insert(gasket=true);
    }
}


*/