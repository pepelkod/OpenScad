
$fn=160;

module hope_valve_spacer(){

    difference(){
        intersection(){
            rotate([90,0,0]){
                linear_extrude(15, center=true){
                    import("HopeRimProfile.svg");
                }
            }
            cylinder(h=100, d=10.6, center=true);
        }
        cylinder(h=100, d=6, center=true);
    }
}

hope_valve_spacer();
/*        rotate([90,0,0]){
            linear_extrude(10, center=true){
                import("HopeRimProfile.svg");
            }
        }
*/