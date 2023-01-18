
$fn=160;

module male(){
    rotate([0,0,90]){
        import("GarminMale.stl");
    }
}
module female(){
    rotate([0,0,90]){
        rotate([3.05-90,0,0]){
            translate([0,0,121.3]){
                import("GarminFemale.stl");
            }
        }
    }

}
module battery(){
    
    rotate([90,0,0]){
        difference(){
            union(){
                cylinder(h=50, d=36, center = true);
                rotate([90,0,0]){
                    cylinder(h=30, d1=35.0, d2=33.5, center = true);
                }
            }
        
            linear_extrude(100, center=true){
                import("BatteryHole.svg");
            }
        }
    }
}




module round_battery_holder(){
    translate([0,0,15]){
        male();
    }
    battery();

    translate([0,0,-25]){
        female();
    }
}

/*rotate([90,90,0]){
    body();
}*/
module flat_mount_remix(){
    union(){
        translate([0,0,-10.5]){
            female();
        }
        //cylinder(r1=17, r2=20, h=4);
    }
}
rotate([0,90,0]){
    flat_mount_remix();
}
    
