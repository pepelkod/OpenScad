

$fn=260;


module side_rounded_end(offset_amt, side_thick){
    // side rounded end
    //translate([(-(side_thick/2)),0,offset_amt]){
    translate([(-(side_thick/2)),0,offset_amt]){
        rotate([0,90,0]){
            cylinder(d=11, h=side_thick);
        }   
    }
}
module tool_side(trans_amt, length=51){
    thick=2.5;
    if(trans_amt > 0){
        trans_amt2 = trans_amt+thick/2;
        translate([trans_amt2,0,0]){
            // total len 61
            union(){
                // side
                cube([thick, 11, length], center=true);
                // side rounded end
                side_rounded_end(offset_amt=length/2, side_thick=thick);
                side_rounded_end(offset_amt=-length/2, side_thick=thick);
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
                side_rounded_end(offset_amt=length/2, side_thick=thick);
                side_rounded_end(offset_amt=-length/2, side_thick=thick);
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
    translate([0,0,0]){
        cube([tools_thick, 10, length], center=true);
    }
}

    
module tools_cutout(shrink_z_percent,shift_amt, tools_thick){
    translate([0,-shift_amt,0]){
        scale([1,0.5,shrink_z_percent]){
            tools(length=76.2, tools_thick=tools_thick);
        }
    }
}


module tool(cut=false, tools_thick, tool_length, name){    
    difference(){
        tools(length=tool_length, tools_thick=tools_thick);
        
        // cut out of tool middle
        // shift all the way out.... 1/2 of full size "tools" and 1/2 of scaled "tools"
        shift_out = (10/2 + 5/2);
 
        if(cut==true){
            // this makes smooth inside curves for tools chunk.
            // then shift back in by amount to cut from "tools"
            shift_amt = shift_out - 0.25;
            tools_cutout(shrink_z_percent=0.585, shift_amt=shift_amt, tools_thick=tools_thick);
        }else{
            // then shift back in by amount to cut from "tools"
            shift_amt = shift_out - 4;
            tools_cutout(shrink_z_percent=0.5, shift_amt=shift_amt, tools_thick=tools_thick);
        }
        
    }
    tool_side(trans_amt=tools_thick/2 - 0.01, length=tool_length);
    tool_side(trans_amt=tools_thick/-2 + 0.01, length=tool_length);

    // name embossed
    if(cut){
        translate([3,-5,10]){
            rotate([90,-90,0]){
                linear_extrude(1, center=true){
                    mirror([1,0,0]){
                        text(name, size=5);
                    }
                }
            }
        }
    }
    // rounded sides
    difference(){
        intersection(){
            cylinder(h=tool_length+11, r=12, center=true);
            rotate([0,90,0]){
                hull(){
                    translate([tool_length/2,0,0]){
                        cylinder(h=100, d=11, center=true);
                    }
                    translate([-tool_length/2,0,0]){
                        cylinder(h=100, d=11, center=true);
                    }
                }
            }

        }
        cube([21.2, 100, 100], center=true);
    } 

}

module bontrager_tool(cut=false){
    tools_thick=16.3;
    tool_length = 51;

    tool(cut=cut, tools_thick=tools_thick, tool_length=tool_length, name="Bontrager");
}


module oneup_tool(cut=false){
    tools_thick=16.3;
    tool_length = 49.375;  // tool bolt center to tool bolt center. Actual length is 
    
    tool(cut=cut, tools_thick=tools_thick, tool_length=tool_length, name="OneUp");
}


oneup_tool(cut=true);

//bontrager_tool(cut=true);
