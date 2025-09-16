




//********************************************************** //
// Pipes //
//********************************************************** //
module pipe(diameter=dia, wall_thickness=2, s2_length=20, center=false, thread=[0, 0, 0, false, 0]) {

    $fn=128;
    radius = diameter/2;
    inner_radius = radius-wall_thickness;
    t = center ? s2_length/2 : 0;
    translate([t, 0, 0])
    difference() {
        cylinder(r=radius, h=s2_length);
        translate([0, 0, -wall_thickness/2])
        cylinder(r=inner_radius, h=s2_length+2);
        if(thread[0] > 0) {
            translate(0, 0, s2_length-thread[2]+0.01) render()	metric_thread(thread[0], thread[1], thread[2], thread[3]);
        }
    }
}

dia =1;
module elbows(diameter=dia, wall_thickness=2, s1_length=20, s2_length=20, bend_radius=20, bend_angle=90, thread=[[0, 0, 0, false],[0, 0, 0, false, 0]]) {
    $fn=128;
    radius = diameter/2;
    inner_radius = radius-wall_thickness;
    angle_1 = 0;
    angle_2 = bend_angle;

    translate([0, -bend_radius-diameter/2, s1_length]){
        union() {
            // lower arm
            rotate([0, 0, angle_1])	{
                translate([bend_radius + radius, 0.02, 0]) {
                    rotate([90, 0, 0]) pipe(diameter, wall_thickness, s1_length, false, thread[0]);
                }
            }
            // upper arm
            rotate([0, 0, angle_2]) {
                translate([bend_radius + radius, -0.02, 0]) {
                    rotate([-90, 0, 0])	pipe(diameter, wall_thickness, s2_length, false, thread[1]);
                }
            }
            // bend
            // torus cutout
            rotate_extrude(angle=bend_angle) translate([bend_radius + radius, 0, 0]) {
                difference() {
                    // torus
                    circle(r=radius);
                    // torus cutout
                    circle(r=inner_radius);
                }
            }
        }
    }
}


    
module threadneck(){
    intersection(){
        translate([0,0,40]){
                cube([80,80,80],center=true);
            }
        translate([-25, -69.4, -75]){
            import( "Katadyn_BeFree_Adapter_Final.stl", center=true);
        }
    }
    
}

difference(){
    translate([2,0,0]){
        union(){
            // bottom threading
            translate([0,0,-0.1]){
                threadneck();
            }
            // top threading
            rotate([180,0,0]){
                threadneck();
            }
        }
    }
    // hole for breather
    translate([0, 15, 0]){
        rotate([90,0,0]){
            #cylinder(h=10, d=5, center = true, $fn=80);
        }
    }
}
// breather pipe
translate([-0.5,18,3]){
    rotate([0,90,0]){
        elbows(diameter=6, wall_thickness=1, s1_length=0.5, s2_length=15.0, bend_radius=0);
    }
}