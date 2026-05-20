
$fn=80
;
module rack_bolt_spacer(inner, outer){
    
    difference(){
        union(){
            // main body
            cylinder(h=21, d1=outer, d2=outer-0.1);
            // lip
            cylinder(h=1, d=outer+6);
        }
        // hole
        translate([0,0, -1]){
            cylinder(h=100, d=inner);
        }
        // size text
        translate([4.5,-1.5,10]){
            rotate([0,90,0]){
                linear_extrude(1){
                    text(str(outer), 3);
                }
            }
        }
    }
}

translate([0, 20, 0]){
    rack_bolt_spacer(5, 10.4);
}
translate([20, 0, 0]){
    rack_bolt_spacer(5, 10.5);
}
translate([20, 20, 0]){
    rack_bolt_spacer(5, 10.6);
}
translate([-20, 20, 0]){
    rack_bolt_spacer(5, 10.4);
}
translate([20, -20, 0]){
    rack_bolt_spacer(5, 10.5);
}
translate([-20, -20, 0]){
    rack_bolt_spacer(5, 10.6);
}
