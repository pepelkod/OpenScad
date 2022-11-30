
mms=25.4;

module main_block(height, width, length, thick, tube_d){
    translate([0,0,height/2+(tube_d/4)]){
	   difference(){
	       cube([length, width, height+(tube_d/2)], center=true);
        translate([0,0,height/2+tube_d/4]){
            rotate([0,90,0]){
                cylinder(h=length*2, d=tube_d, center=true);
            }
        }
    }
    }
    translate([0,0,-thick]){
    			 cube([length, width*1.25, thick*2], center=true);
    }
}
;
tube_d = 48;
height = 48;
length = 10*mms;
width = 4*mms;
thick = 3*mms;

main_block(height, width, length, thick, tube_d); 
