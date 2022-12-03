

module make_one(filename, height){
  linear_extrude(height = height, center = true, scale=1)
    import(file =filename, center = true);
}  

height=22.225;



make_one("SpeakerLayerEnd.svg", height=height);
translate([0,0,height]){
    make_one("SpeakerLayerOddHalf.svg", height=height);
    translate([0,0,height]){
        make_one("SpeakerLayerEvenHalf.svg", height=height);
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



//make_one("End.svg", height=height);