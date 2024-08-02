
$fn=160;



//openscad resolution
$fa = 4;
$fs = 1;
 
mms = 25.4;



module makeChainRing(numberOfTeeth = 50, numberOfBolts = 5, bcd = 110, boltHoleDiameter=10) {
    ////////
    // CHAINRING OPTIONS
    //cam options
    makeBoundsForToothCutPocket = "false";
    doProjectionFor2dCam = "false";

    //general chainring options
    //boltHoleDiameter 10mm seems standard (a bit bigger to be safe)
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
    r_in = 20.3/2;
    r_gask = 3/2;    
    pos = r_in+r_gask;
    
    rotate_extrude(){
        translate([pos,0,0]){
            //rotate([90,0,0]){   
                circle(d=1.55);
            //}
        }
    }
}


module insert(axle_dia=12.0, width=142, gasket=false, lower_gasket_groove=true, upper_gasket_groove=true, text_thick=0.5){
    axle_dia_with_clearance=axle_dia*1.03;
    extension_len = 4.75 + ((width-100)/2);
    extension_dia = axle_dia * 1.3660130718954248366013071895425;
    text_size = 4;
    flange_dia = 30;
    upper_gasket_height = 16;
    lower_gasket_height = 4;
    
    translate([0,0,3]){  
    union(){
    // insert
    //color("gray"){
        
        difference(){
            union(){
                // diameterlabel
                color("Green"){
                    translate([0,0,23.5]){
                        translate([0,-flange_dia/2+text_size,0]){
                            rotate([90,0,0]){
                                linear_extrude(text_thick){
                                    text(str(width), text_size, halign="center", valign="center");}
                            }
                        }
                        translate([0,flange_dia/2-text_size,0]){
                            rotate([-90,0,0]){
                                linear_extrude(text_thick){
                                    text(str(axle_dia), 6, halign="center", valign="center");
                                }
                            }
                        }

                    }
                }
                // insert part
                cylinder(h=21, d=23.75);
                translate([0,0,20]){
                    union(){
                        // lip
                        cylinder(h=3.5, d = flange_dia);
                        translate([0, 0, 3.5]){
                            union(){
                                // extension
                                cylinder(h=extension_len, d=extension_dia);
                                // strengthen extension  with CONE
                                cylinder(h=extension_len-5, d1=flange_dia, d2=extension_dia);
                            }
                        }
                    }
                }
            }
            // axle hole
            translate([0,0,-1]){     
                cylinder(h=100, d=axle_dia_with_clearance);
            }
            if(lower_gasket_groove){
                // groove for rubber gasket
                translate([0,0,lower_gasket_height]){
                    gasket();
                }
            }
            if(upper_gasket_groove){
                // second groove
                translate([0,0,upper_gasket_height]){
                    gasket();
                }
            }
            // entrance chamfer for easier axle insert
            translate([0,0,-0.1]){
                cylinder(h = 10, d1=axle_dia*1.1, d2=axle_dia*0.9);
            }
        }
   // }
    if(gasket==true){
        // rubber gasket
        //color("DarkSlateGray"){                        
            if(lower_gasket_groove){
                translate([0,0,lower_gasket_height]){
                    gasket();
                }
            }
            if(upper_gasket_groove){
                // second 
                translate([0,0,upper_gasket_height]){
                    gasket();
                }
            }
        //}
    }   
    }
    }
}

module alu_receivder(height=86.4){
    color("red"){
        union(){
            // round top
            difference(){
                cylinder(h=height, d=30, center=true);
                translate([0,0,0]){
                    cylinder(h=height+2, d=24, center=true);
                }
            }
            // base
        }  
    }
} 

module alu_receiver(height=86){
    translate([0,0, -height/2]){
        color("red"){
            linear_extrude(height=height){
                import("RockBrosThruAxleSilhoet.svg", center=false);
            }
        }
    }
}
module front_100x15mm_insert(gasket=false, upper_gasket_groove=false){
    insert(axle_dia=15.0, width=100, gasket=gasket, upper_gasket_groove=upper_gasket_groove);
}
module front_100x12mm_insert(gasket=false, upper_gasket_groove=false){
    insert(axle_dia=12.0, width=100, gasket=gasket, upper_gasket_groove=upper_gasket_groove);
}

module front_110x15mm_boost_insert(gasket=false,lower_gasket_groove=false, upper_gasket_groove=false){
    insert(axle_dia=15.0, width=110, gasket=gasket, lower_gasket_groove=lower_gasket_groove, upper_gasket_groove=upper_gasket_groove, text_thick=4.5);
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
module rear_148x12mm_insert(gasket=false, cog=false){
    axle_dia = 12.0;
    insert(axle_dia=axle_dia, width=148, gasket=gasket);

    base_cog_position=63;

    if(cog == true){
        translate ([0, 0, base_cog_position]) {
            makeChainRing(numberOfTeeth = 11, numberOfBolts = 6,bcd = axle_dia*2);
        }    
    }
}

/*
translate([0,0,0]){
    front_110x15mm_boost_insert();
}
*/

/*
translate([0,0,0]){
    rotate([180,0,0]){
        rear_142x12mm_insert(gasket=false);
    }
}
*/

module main_rack(){
    len_main = 74 * mms;
    width = 4 * mms;
    height = 3 * mms;
    len_ends = 4 * mms;
    color("Silver"){
        translate([0, -width/2,0]){
            union(){
                // main beam
                cube([len_main, width, height], center=false);
                // front
                translate([0,0,height]){
                    cube([len_ends, width, height], center=false);
                }
                // back
                translate([len_main-len_ends,0,height]){
                    cube([len_ends, width, height], center=false);
                }
            }
        }
    }
}

module back_end(){
    rotate([90,0,0]){
        union(){
            translate([38.4,65.9,0]){
                rotate([0,0,0]){
                    rear_148x12mm_insert(gasket=true, cog=false);
                }
                rotate([0,180,0]){
                    rear_148x12mm_insert(gasket=true, cog=true);
                }
            }
            translate([0,0,0]){
                alu_receiver();
            }
        }
    }
}
module front_end(){
    rotate([90,0,180]){

        union(){
            translate([38.4,65.9,0]){
                rotate([0,0,0]){
                    front_110x15mm_boost_insert(gasket=true);
                }
                rotate([0,180,0]){
                    front_110x15mm_boost_insert(gasket=true);
                }
            }
            translate([0,0,0]){
                alu_receiver();
            }
        }
    }
}

module tandem(height=52){
       
    rotate([90,0,180]){
        union(){
            // chainring
            translate([-1410, 145, (2.2*mms)]){
                makeChainRing(numberOfTeeth = 53, numberOfBolts = 5, bcd = 110,                 boltHoleDiameter=10) ;
                translate([0,0,-5.9]){
                    color("LightYellow"){
                    makeChainRing(numberOfTeeth = 39, numberOfBolts = 5, bcd = 110,                  boltHoleDiameter=10) ;
                    }
                }

            }
            // frame
            translate([-(73.5*mms),(4.75*mms), -height/2]){
                color("SteelBlue"){
                    linear_extrude(height=height){
                        import("TandemSilhouet.svg", center=false);
                    }
                }
            }
        }
    }
}
module bolt(size=8, length=150){
    head_height=size;
    
    color("DimGray"){
        union(){
            // optional washers
            translate([0,0, mms]){
                cylinder(h=2, d=mms);
            }
            // shaft
            cylinder(d=8, h=length);
            // head
            translate([0,0,-head_height]){
                difference(){
                    cylinder(d=13, h=head_height);
                    // hex hole
                    translate([0,0,-1]){
                        cylinder(d=size, h=7, $fn=6);
                    }
                }
            }
        }
    }
}
module plate(){
    length = 4*mms;
    width = 6*mms;
    thick = 0.5*mms;
    
    cube([length, width, thick], center=true);
}
module plates(){
    position_x = (74/2)*mms;

    translate([position_x, 0, 0]){
        translate([0, 0, 3.25*mms]){
            plate();
        }
        translate([0, 0, -2.25*mms]){
            plate();
        
            for ( i = [-1,1] ){
                for ( j = [-1,1] ){
                    translate([i*(1.5*mms), j*(2.5*mms), -.15*mms]){
                        bolt();
                    }
                }
            }
        }
    }
}
module thule(){
    length = 32*mms;
    diameter = 2*mms;
    
    translate([(74/2)*mms, 0, -diameter/2]){
        color("DarkGray"){
            cube([diameter, length, diameter], center=true);
        }
    }
}

module whole_thing(){
    union(){
        tandem();
        
        main_rack();
        translate([0,0,(6*mms)]){
            translate([(71.325*mms),0, 0]){
                back_end();
            }
            translate([(2.5*mms), 0, 0]){
                front_end();
            }
        }
    }
    thule();
    plates();
}


module receiver_with_inserts(){
    
    translate([38.4,65.9,0]){
        front_100x15mm_insert(gasket=false, upper_gasket_groove = false);
        rotate([0,180,0]){
            front_100x15mm_insert(gasket=false, upper_gasket_groove = false);
        }
    }
    alu_receiver();
}


    


module sucker_post(post_dia){
    cylinder(d=post_dia,h=25.4);
}
module sucker_base(sucker_dia, post_dia){
    color("Gray"){
        cylinder(d1=sucker_dia, d2=post_dia, h=25.4);
    }
}
module sucker(sucker_dia, post_dia){
    sucker_base(sucker_dia, post_dia);
    translate([0,0,25.4]){
        sucker_post(post_dia);
    }
}
module alu(bar_len, bar_wid, bar_thick){
    cube([bar_wid, bar_len, bar_thick], center=true);
}

module short_rack(){
    mms = 25.4;
    sucker_dia = 6*mms;
    post_dia = 56;
    bar_len = 610;
    bar_wid = 63.5;
    bar_thick = 4.7625;
    receiver_wid = 86.4;

    // main bar
    translate([0, bar_len/2 - post_dia/2,mms * 2 + 2]){
        alu(bar_len, bar_wid, bar_thick);
    }
    // suckers
    bolt_to_bolt = bar_len-post_dia;
    space_between = bolt_to_bolt/3;
    for(idx = [0: 1: 3]){
        offset = idx * space_between;
        echo("offset ", offset+post_dia/2);
        translate([0, offset, 0]){ 
            sucker(sucker_dia, post_dia);
        }
    }
    // receivers
    translate([-bar_wid/3,-post_dia/2,2*mms+bar_thick]){
        translate([0,490.0 ,0]){
            rotate([90,0,0]){
                receiver_with_inserts();

            }
        }
        translate([0,120.3333,0]){
            rotate([90,0,0]){
                receiver_with_inserts();

            }
        }
    }
    //}
}

module shipping_spacer(axle_dia=12, axle_len=148, text_thick=2){
    axle_dia_with_clearance=axle_dia*1.03;
    extension_dia = axle_dia * 1.2660130718954248366013071895425;
    text_size = 4;
    
    union(){
        // len and diameter labels
        color("Green"){
            translate([0,0,23.5]){
                translate([0,-extension_dia/2+1,0]){
                    rotate([90,90,0]){
                        linear_extrude(text_thick){
                            text(str(axle_len), text_size, halign="center", valign="center");}
                    }
                }
                translate([0,extension_dia/2-1,0]){
                    rotate([-90,90,0]){
                        linear_extrude(text_thick){
                            text(str(axle_dia), 6, halign="center", valign="center");
                        }
                    }
                }

            }
        }
        // Tube
        difference(){
            // body
            cylinder(h=axle_len, d=extension_dia);
            // axle hole
            translate([0,0,-1]){     
                cylinder(h=axle_len+2, d=axle_dia_with_clearance);
            }
            // entrance chamfer for easier axle insert
            translate([0,0,-0.1]){
                cylinder(h = 10, d1=axle_dia*1.1, d2=axle_dia*0.9);
            }
        }
    }
}

//short_rack();

/*

translate([-16, 0, 0]){
    translate([0, -16, 0]){
        insert(axle_dia=12.0, width=100, gasket=false);
    }
    translate([0, 16, 0]){
        insert(axle_dia=12.0, width=100, gasket=false);
    }
}
translate([16, 0, 0]){
    translate([0, -16, 0]){
        insert(axle_dia=15.0, width=100, gasket=false);
    }
    translate([0, 16, 0]){
        insert(axle_dia=15.0, width=100, gasket=false);
    }
}
*/
//front_110x15mm_boost_insert(gasket=true, lower_gasket_groove=true, upper_gasket_groove=true);

shipping_spacer(12, 148);
translate([20,10,0]){
    shipping_spacer(15, 110);
}



//plates();
//whole_thing();
//bolt();

