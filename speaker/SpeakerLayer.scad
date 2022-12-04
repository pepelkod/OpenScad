
mms = 25.4;
height=22.225;

width=248;
length = 310;
even_cut_width = 179.722;
even_cut_length = 126.964;
cut_hole_x = 7.549;
cut_hole_y = 154.85;

x_offset = -(width/2)+(even_cut_width/2) + cut_hole_x;
y_offset = -(length/2)-(even_cut_length/2) + cut_hole_y;

module plywood(width=23.5*mms, length=23.5*mms, height=(0.72)*mms){
    cube([width, length, height], center = true);
}    

module make_one(filename, height){
    color("LightBlue")
  linear_extrude(height = height, center = true, scale=1)
    import(file =filename, center = true);
}
module make_even_half(height=mms){
    difference(){
        linear_extrude(height = height, center = true, scale=1){
            import(file ="SpeakerLayerHalf.svg", center = true);
        }
        translate([x_offset, y_offset, 0]){
            linear_extrude(height = height*2, center = true, scale=1){
                import(file ="SpeakerLayerEvenCutHole.svg", center = true);
            }
        }
    }   
}    

module make_odd_half(height=mms){
    difference(){
        linear_extrude(height = height, center = true, scale=1){
            import(file ="SpeakerLayerHalf.svg", center = true);
        }
        translate([x_offset, y_offset, 0]){
            linear_extrude(height = height*2, center = true, scale=1){
                import(file ="SpeakerLayerOddCutHole.svg", center = true);
            }
        }
    }   
}    


module make_half_speaker(){
    union(){
        make_one("SpeakerLayerEnd.svg", height=height);
        translate([0,0,height]){
            make_odd_half(height=height);
            translate([0,0,height]){
                make_even_half(height=height);
                translate([0,0,height]){
                    make_one("SpeakerLayerOddFull.svg", height=height);
                    translate([0,0,height]){
                        make_one("SpeakerLayerEvenFull.svg", height=height);
                        translate([0,0,height]){
                            make_one("SpeakerLayerOddFull.svg", height=height);
                        }
                    }
                }
            }
        }
    }
}
module make_speaker_cut_pattern(){
    difference(){
        plywood();
        difference(){
            plywood(width=24.9*mms, length=24.9*mms, height=1*mms);
            //plywood();
            translate([width/1.5,width/1.9,0]){
                make_one("SpeakerLayerEnd.svg", height=height*4);
            }
            rotate([0,0,90]){
                translate([width/1.5,width/1.9,0]){
                   make_even_half(height=height*4);
                }
            }
            rotate([0,0,180]){
                translate([width/1.5,width/1.9,0]){
                    make_odd_half(height=height*4);
                }
            }
            
            rotate([0,0,270]){
                translate([width/1.5,width/1.9,0]){
                   make_one("SpeakerLayerEvenFull.svg", height=height*4);
                }
            }
            
        }
    }
}


module test_alignment(){
    make_odd_half();
    translate([0,0,mms]){
        make_one("SpeakerLayerOddFull.svg", height=height);
    }

    translate([400,0,0]){
        make_even_half();
        translate([0,0,mms]){
            make_one("SpeakerLayerEvenFull.svg", height=height);
        }
    }
}

//make_speaker_cut_pattern();
make_half_speaker();
//test_alignment();