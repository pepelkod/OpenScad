
use <threads.scad>

outer_dia=31.9;  //30.9;
inner_dia = 28.2; //27.2;
one_inner_len = 185+5;  /// velogical electronics len + 5mm
thread_len = 10;

$fn=186;


// for the plug wires that are 3.1mm and the usb wire
// wire diamterrs
module three_wire_holes(wd = 3.2, length=100, usb_width=16.6, one_wire=true){
    offset_out = usb_width/2;
    
    if(one_wire==true){
        // usb wire hole
        //translate([offset_out-wd/2,0,0]){
        translate([offset_out,0,0]){
            cylinder(h=length*3, d=wd, $fn=186, center=true);
        }
    }else{
    
        // wire hole
        translate([-offset_out,0,0]){
            cylinder(h=length*3, d=wd, $fn=186, center=true);
        }
        // wire hole
        translate([offset_out,0,0]){
            cylinder(h=length*3, d=wd, $fn=186, center=true);
        }
    }
}    


// extra bit to plug hole after putting wires thru...should be
// made of TPU
// `cut` means it is for cutting the hole in the body
module plug(length, usb_wide = 8.7, usb_high = 16.6, cut=true, one_wire=true){
    
    // usb dims
    
    intersection(){
        // limit z to "length"
        translate([0,0,length/2]){
            if(cut==true){
                cube([100, 100, length*8], center=true);
            }else{
                cube([100, 100, length], center=true);
            }
        }
        difference(){
            union(){
                // od..plug diameter
                cylinder(h=length*20, r=6-0.1, $fn=186, center=true);
                // chamfer outside
                translate([0, 0, 1]){
                    cylinder(h=length,r1=12, r2=1, $fn=186, center=true);
                }
                // rectangular usb hole plug
                cube([usb_high-0.1, usb_wide-0.1, 100], center=true);
                if(cut==true){
                    three_wire_holes(one_wire=one_wire);
                }
                    
            }
            if(cut==false){
                three_wire_holes(one_wire=one_wire);
            }
      }
   }
}
    
module zip_tie(od,h){
    difference(){
        cylinder(h=h, d=od+1);
        cylinder(h=h*2, d=od-0.5);
    }
}

module inside_cylinder_cut(id, length){
    cl = length * 0.55;
    intersection(){
        cylinder(d=id, h=length, center=true);
        union(){
            translate([0,0,-0.01]){
                cylinder(d1=cl*2, d2=0, h=cl+0.01);
            }
            rotate([0,180,0]){
                cylinder(d1=cl*2, d2=0, h=cl);
            }
        }
    }
}

module holder(od, id, internal_length, bottom_thick){
    //thread_dia = thread_dia * 1.1;

    echo("id", id);
    echo("internal_length", internal_length);
    echo("bottom_thick", bottom_thick);
    
    total_length = internal_length+(bottom_thick*2);
    
    difference(){
        cylinder(d=od, h=total_length, center=true);
        //cylinder(d=id, h=internal_length, center=true);
        inside_cylinder_cut(id=id, length=internal_length);
        translate([0,0,(-total_length/2)-0.01]){
            plug(length=bottom_thick+0.02, cut=true, one_wire=false);
        }
        rotate([0,180,0]){
            translate([0,0,(-total_length/2)-0.01]){
                plug(length=bottom_thick+0.02, cut=true, one_wire=true);
            }
        }

    }
}

module holder_unit(outer_dia, inner_dia, internal_length, bottom_thick, print_body=true){

    echo("inner_dia", inner_dia);
    echo("outer_dia", outer_dia);

    // main body
    if(print_body){
        translate([0,0,(internal_length+bottom_thick*2)/2]){
            //rotate([180,0,0]){
                holder(od=outer_dia, id=inner_dia, internal_length=internal_length, bottom_thick=bottom_thick);
            //}
        }
    }
    translate([outer_dia+1, 0, 0]){
        plug(length=5, cut=false, one_wire=true);
    }
    translate([-outer_dia-1, 0, 0]){
        plug(length=5, cut=false, one_wire=false);
    }

   
}


   
//echo("first holder_dia", holder_dia);
////////////////
// whole thing
//holder_unit(outer_dia=outer_dia, inner_dia=inner_dia, num_batts=1);


//////////////////////// 
// just head and plug

holder_unit(outer_dia=outer_dia, inner_dia=inner_dia, internal_length=112, bottom_thick=5, print_body=true);

//inside_cylinder_cut(id=20, length=100);