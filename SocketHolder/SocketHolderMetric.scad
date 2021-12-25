
module create_socket_hole(size_mm, height=10){
    translate([0,0,-height/2]){
        difference(){
            dia = size_mm+3;
            hei = height+1;
            cylinder(h=hei, d=dia);
            translate([0,0,-0.1])
                cylinder(h=height/3, d=size_mm+0.2, $fn=6);
        }
        translate([-3, -(size_mm+2), height-2]){
            linear_extrude(3){
                #text(str(size_mm), size=4);
            }
        }
    }
}

difference(){
    width = 357;
    height =25;
    cube([width, 117, height], center=true);
    for( s = [4:1:13]){
        translate([ -(width/2-8) + ((s)*s), 30, height/3])
            create_socket_hole(s, 10);
    }

    for( s = [[19,19],[18,18],[17,17],[15,16],[14,15],[13,14],[12,13],[10,12]]){
        dia=s[0];
        idx=s[1];
        translate([width/2.6,0,0])
        translate([ -(idx*idx*.8), 0, height/5])
            create_socket_hole(dia, 15);
    }
        
}