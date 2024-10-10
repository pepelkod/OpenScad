
$fn=180;

// rippley cut
module half_clam_cut(od, id, length){
    this_d = 3;
    translate([0,(od/2)-(this_d/2), 0]){
        cylinder(h=length, d=this_d, center=true);
    }
    translate([0,0, (length/2)-(this_d/2)]){
        rotate([90,0,0]){
            cylinder(h=od, d=this_d, center=true);
        }
    }
    
}
module clam_cuts(od, id, length){
    half_clam_cut(od=od, id=id, length=length);
    rotate([180,0,0]){
        half_clam_cut(od=od, id=id, length=length);
    }
}

/*
module clam_cuts(od, id, length){
    clam_cut(od=od, id=id, length=length);
    clam_cut(od=od-2, id=id-2, length=length-2);
}
  */  
module zip_tie(od,h){
    difference(){
        cylinder(h=h, d=od+1);
        cylinder(h=h*2, d=od-0.5);
    }
}
module wire_holes(d, length){
    // input single hole
    translate([0,0,-length/2]){
        cylinder(h=10, d=d, center=true);
    }
    
    // output double hole
    translate([0,d,length/2]){
        cylinder(h=10, d=d, center=true);
    }
    // output double hole
    translate([0,-d,length/2]){
        cylinder(h=10, d=d, center=true);
    }

}

// main body
module clam_shell(od, id, length, concave){
    difference(){
        union(){
            difference(){
                cylinder(h=length, d=od, center=true);
                cylinder(h=length-4, d=id, center=true);
                cube_size=200;
                translate([cube_size/2,0,0]){
                    cube(cube_size, center=true);
                }
                translate([0,0,length/2 - 4]){
                    zip_tie(od=od, h=2);
                }
                translate([0,0,-length/2 + 4]){
                    zip_tie(od=od, h=2);
                }
                
                if(concave==true){
                    clam_cuts(od=od, id=id, length=length);
                }
                
                    
            }
            if(concave==false){
                clam_cuts(od=od, id=id, length=length);
            }
            
        }
        wire_holes(d=3, length=length);
    }
}

od=28;
id=od-8;
length=112;

clam_shell(od=od, id=id, length=length, concave=true);
translate([10,0,0]){
    rotate([0,0,180]){
        clam_shell(od=od, id=id, length=length, concave=false);
    }
}