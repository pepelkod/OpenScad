

module food(name){
    linear_extrude(4){
        import(str(name,"Base.svg"));
        
    }
    
    translate([0,0,4]){
        linear_extrude(2){
            import(str(name,"Top.svg"));
        }
    }
}


translate([30,0,0])
food("Egg");
translate([-30,0,0])
food("Cake");
translate([0,-30,0])
food("Strawberry");
translate([0,30,0])
food("Bread");