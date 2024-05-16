

module egg(){
    scale([100, 100, 100])
    linear_extrude(4){
        import("EggBase.svg");
        
    }
    
    translate([0,0,4]){
        linear_extrude(2){
            import("EggTop.svg");
        }
    }
}


egg();