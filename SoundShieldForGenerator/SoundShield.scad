
$fn=80;

module small(){
    linear_extrude(1, center=true){
        import("SmallArc.svg",center=true);
    }
}

module big(){
    linear_extrude(1, center=true){
        import("BigArc.svg", center=true);
    }
}

module chunk(){
    hull(){
        small();
        translate([0,0,137]){
            big();
        }
    }
}
module stay(){
    translate([30,0,14]){
        rotate([0,0,15]){
            rotate([75,0,0]){
                #cylinder(h=200, d=12.7, center=true);
            }
        }
    }
}


difference(){
    translate([0,1.4,0]){
        scale([1.02, 1.02, 0.99]){
            chunk();
        }
    }
    chunk();
    stay();
    mirror([1,0,0]){
        stay();
    }
}