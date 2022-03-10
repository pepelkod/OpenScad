


module doit(){
   union(){
       translate([0,0,15]){
            linear_extrude(30, center=true){
                import("aero light adapter.svg");
            }
        }
        translate([0,0,1.5]){
            scale(1.1){
                linear_extrude(3, center=true){
                    import("aero light adapter.svg");
                }
            }
        }
    }

}

doit();