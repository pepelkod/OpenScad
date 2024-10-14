
$fn=80;

module spacer(oo_width = 24.5, o_width=19.6, od=10.5, i_width = 14.5, id=5.4, h1=7.1, h2=1.5){
    ood = od*(oo_width/o_width);
    
    difference(){
        union(){
            // outermost oval
            echo("OOD ", ood);
            echo("oo_width ", oo_width);
            hull(){
                translate([(oo_width-ood)/2, 0, 0]){
                    cylinder(h=h1, d = ood, center=true);
                }
                translate([-(oo_width-ood)/2, 0, 0]){
                    cylinder(h=h1, d = ood, center=true);
                }
            }

            // middle oval
            echo("OD ", od);
            echo("o_width ", o_width);
            hull(){
                translate([(o_width-od)/2, 0, h2]){
                    cylinder(h=h1, d = od, center=true);
                }
                translate([-(o_width-od)/2, 0, h2]){
                    cylinder(h=h1, d = od, center=true);
                }
            }
        }
    
        // inner cutout oval
        echo("iD ", id);
        echo("iwidth", i_width);
        hull(){
            translate([(i_width-id)/2, 0, 2.5]){
                cylinder(h=18.5, d = id, center=true);
            }
            translate([-(i_width-id)/2, 0, 2.5]){
                cylinder(h=18.5, d = id, center=true);
            }
        }
    }
}


spacer();
    