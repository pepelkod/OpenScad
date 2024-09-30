

$fn=260;

module inside_curve(rad, height){
    difference(){
        cube([rad, rad, height]);
        translate([0,0,-1]){
            cylinder(height+2, r = rad);
        }
    }
    
}

module o_ring(d_small, d_big){
    difference(){
        cylinder(h=d_small, d=d_big+(d_small*2));
        translate([0, 0, -0.1]){
            cylinder(h=d_small*2, d=d_big);
        }
    }
}
module side_rounded_end(offset){
    // side rounded end
    translate([-1.2,0,offset]){
        rotate([0,90,0]){
            cylinder(d=11, h=2.4);
        }   
    }
}
module tool_side(trans_amt, length=51){
    thick=2.4;
    if(trans_amt > 0){
        trans_amt2 = trans_amt+thick/2;
        translate([trans_amt2,0,0]){
            // total len 61
            union(){
                // side
                cube([thick, 11, length], center=true);
                // side rounded end
                side_rounded_end(length/2);
                side_rounded_end(-length/2);
            }
        }
    }
    else{
        trans_amt2 = trans_amt-thick/2;
        translate([trans_amt2,0,0]){
            // total len 61
            union(){
                // side
                cube([thick, 11, length], center=true);
                // side rounded end
                side_rounded_end(length/2);
                side_rounded_end(-length/2);
            }
        }
    }        
}
// internal part of tool
module tools(length, tools_thick){
    // ends
    translate([-tools_thick/2,0,-length/2]){
        rotate([0,90,0]){
            cylinder(h=tools_thick,d=10);
        }
    }
    translate([-tools_thick/2,0,length/2]){
        rotate([0,90,0]){
            cylinder(h=tools_thick,d=10);
        }
    }
    // body
    translate([0,1,0]){
        cube([tools_thick, 8, length], center=true);
    }
}

    

module tool(){
    tools_thick=16.3;
    difference(){
        tools(length=51, tools_thick=tools_thick);
        
        // cut out of tool middle
        translate([0,-5,0]){
            scale([1,0.5,0.5]){
                tools(length=80, tools_thick=tools_thick);
            }
        }
    }
    tool_side(tools_thick/2);
    tool_side(tools_thick/-2);

}

module body(){
    top_thick = 3.6;
    
    union(){
        translate([0,0,-top_thick+0.1]){
            // center of top
            cylinder(h=top_thick, d=32.2);
            intersection(){
                // wings
                cylinder(h=top_thick, d1=40.2, d2=32.2);
                // only wings
                cube([45,14,10], center=true);
                // bevel
                cylinder(h=top_thick, d1=39, d2=40);
                
            }
        }
        // inside part
        difference(){
            cylinder(h=20, d=21.25);
            // o-ring grove
            translate([0,0,2]){
                o_ring(d_small=2, d_big=18.5);
            }
        }
    }
}   
//o_ring(d_small=2, d_big=18.6);
//body();
tool();

