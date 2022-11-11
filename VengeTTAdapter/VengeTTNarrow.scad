use <bend.scad>
$fn=80;

dia = 31.75;
rad = dia/2;


difference(){
   union(){
        translate([0,0,rad]){
            rotate([-90,-90,0]){
                cylinder(d=dia, h=32);
            }
        }
        /*linear_extrude(height=dia){
            import("VengeTTNarrow.svg");
        }
        */
    }
    translate([0,-dia-5, 0]){
        rotate([-90, -90, 37.5]){
          parabolic_bend([dia, 80.0, dia], 0.009, nsteps=40){
               translate([rad, 0, rad]){
                    rotate([0,90,90]){
                        cylinder(d=dia, h=80.0);
                    }
                }
            }
        }
    }
}