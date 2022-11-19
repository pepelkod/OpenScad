
$fn=20;


slide_width=15.7;

module slide_body(){
    linear_extrude(slide_width, center=false){
        import("slide.svg");
    }
}

module square(){
    thick = 4.78;
    width = 4.26;
    height = 13.83;
    color("green"){
        translate([0,-height,-width/2]){
            difference(){
                cube([thick,height+0.1,width]);
                translate([thick/2,height-1,width/2]){
                    rotate([90,0,0]){
                        cylinder(r=0.5,h=13);
                    }
                }
            }
        }
    }
}
tab_width = 1.31;

tab_thick = 6.63;

module tab(){
    thick = tab_thick;
    width = tab_width;
    height = 8.5;
    
    color("purple"){
        translate([0, -height, 0]){
            cube([thick, height+0.1, width]);
        }
    }
    
    // nubbin
    color("blue"){
        translate([thick,-3.22,0]){
            rotate([270,90,90]){
                linear_extrude(thick){
                    polygon(points=[[-0.1,0],[width/2,0],[-0.1,width]]);
                }
            }
        }
    }
}
union(){
    tab_right=10.12;
    tab_in=3.21;
    
    slide_body();
    translate([10.42,0,(slide_width/2)]){
        square();
    }
    // left side
    translate([tab_right,0,tab_in]){
        tab();
    }
    // right side
    translate([tab_right+tab_thick,0,slide_width-tab_in]){
        rotate([0,180,0]){
            tab();
        }
    }

}


