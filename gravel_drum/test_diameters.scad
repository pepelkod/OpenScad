$fn=160;


module main(id, size_text){
    difference(){
        cylinder(d=id*1.1, h=10, center=true);
        cylinder(d=id, h=12, center=true);
    }
    color("Green"){
        translate([id/2, 0, 4.9]){
            linear_extrude(2){
                 text(size_text, size=5);
            }
        }
    }
        
}

translate([0, 40, 0]){
    main(id=85.1, size_text="1");
}
translate([-100, 40, 0]){
    main(id=85.2, size_text="2");
}
translate([50, -40, 0]){
    main(id=85.3, size_text="3");
}
translate([-50, -40, 0]){
    main(id=85.4, size_text="4");
}
/*
translate([100, 40, 0]){
    main(id=85.5, size_text="5");
}
translate([-150, -40, 0]){
    main(id=85.6, size_text="6");
}
*/
/*
translate([150, -50, 0]){
    main(id=85.7, size_text="7");
}
translate([-150, -50, 0]){
    main(id=85.8, size_text="8");
}*/