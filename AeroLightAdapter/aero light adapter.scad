


module noclips(){
    union(){
        linear_extrude(30, center=false){
            import("aero light adapter.svg");
        }
        translate([-2.35,0,0]){
            scale([1.1,1,1]){
                linear_extrude(3, center=false){
                    import("aero light adapter.svg");
                }
            }
        }
    }
}

module clips(){
    union(){
        translate([0,0,10]){
            linear_extrude(10, center=false){
                import("aero light adapter with clips.svg");
            }
        }
        noclips();
    }
} 
noclips();

//clips();



