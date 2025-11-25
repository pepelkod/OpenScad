

module foot(){
    rotate([90,0,90]){
        linear_extrude((25.4/4)*3, center = true){
            import("foot.svg");
        }
    }
}

module bb(){
    rotate([90,0,0]){
        linear_extrude((25.4/4)*3, center = true){
            import("bb.svg");
        }
    }
}

module pedal(){
    rotate([90,0,0]){
        linear_extrude((25.4/4)*3, center = true){
            import("pedal.svg");
        }
    }
}



foot();
translate([0, -30, 71.9]){
    color("White"){
        bb();
    }
}
translate([0,-138,31]){
    color("Red"){
        pedal();
    }
}