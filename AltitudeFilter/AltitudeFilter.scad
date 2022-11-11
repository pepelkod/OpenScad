$fn=80;

module frame(){
    difference(){
        linear_extrude(1){
            import("AltitudeFilter.svg");
        }
        translate([0,0,-1]){
            scale([0.9,0.8,1]){
                linear_extrude(6){
                    import("AltitudeFilter.svg");
                }   
            }
        }       
    }
}

 

frame();