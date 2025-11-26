
include <../BOSL2/std.scad>;
include <../BOSL2/partitions.scad>;
$fn=20;

i2m = 25.4;

module drive_nub(size_in=0.25){
    overlap=8;
    size_mm = size_in * i2m;
    
    translate([0,0,-overlap/2]){
        cuboid([size_mm,size_mm,size_mm+overlap], rounding = size_mm/8);
    }
    for( i= [ 0 : 1: 4]){
        rotate([0,0,90*i]){
            translate([size_mm/3.0,0,0]){
                if(size_in==0.25){
                    sphere(size_mm/4.5);
                }else{
                    sphere(size_mm/5);
                }
            }
        }
    }
}


function slice(arr, start, end) = [ for (i = [start : end - 1]) arr[i] ];

// recursive
module row(nub_size_in = 0.25, sockets=[4,5,6,7,8,9,10,11,12,13], offset=0, show_sock=false, special_txt=""){
    socket_size_padding = 2.25*2;
    /* socket wall thickness has a fixed value 'b'
    plus a scaling value 'a' resolved
    using these equations from real measurements
    19 * a + b = 3
    13 * a + b = 2.25
    7  * a + b = 1.8
    b = 1.8 - (7a)
    
    13a - 7a + 1.8 = 2.25
    6a = 0.45
    a = 0.45/6
    */
    a = 0.1;   //0.075;
    b = 1.275;
    pad = 2.5;
    
    // do ONE socket...the first one in the list
    socket_size = sockets[0];
    wall_thickness = (socket_size * a) + b;
    socket_size_od_mm = socket_size+ (2*wall_thickness);
    
    echo(socket_size_od_mm);
    total = offset + socket_size_od_mm + pad;
    echo(total);
    nub_size_mm =  nub_size_in * i2m;
    translate([total,0,0]){
        // make nubs level with 0
        translate([0, 0, nub_size_mm/2]){
            drive_nub(size_in=nub_size_in);
        }
        color("Red"){
            echo("show sock");
            if(nub_size_in==(3/8) && socket_size_od_mm < 17.25){
                hole_size_mm=17.25;
                if(show_sock)
                    cylinder(h=nub_size_mm,d=hole_size_mm*1.05);

            }else if(nub_size_in == (1/4) && socket_size_od_mm < 12){
                hole_size_mm=12;
                if(show_sock)
                    cylinder(h=nub_size_mm,d=hole_size_mm*1.05);

            }else{
                hole_size_mm=socket_size_od_mm;
                if(show_sock)
                    cylinder(h=nub_size_mm,d=hole_size_mm*1.05);
            }               
        }
        // name the socket
        translate([0,-20,1]){
            linear_extrude(10,center=true){
                if(special_txt==""){
                    text(str(socket_size),halign="center", size=5);
                }else{
                    text(special_txt,halign="center", size=5);
                }
            }
        }
    }
    // now recurse and do next
    ls = len(sockets);
    if(ls-1==0){
        echo("Done");
    }else{
        echo("Continue");
        sub_sockets = slice(sockets,1,ls);
        echo(sub_sockets);

            if(nub_size_in==(3/8) && socket_size_od_mm < 17.25){
                hole_size_mm=17.25;
                total = offset + hole_size_mm + pad;

                row(nub_size_in=nub_size_in, sockets=sub_sockets, offset=total, show_sock=show_sock);
            }else if(nub_size_in == (1/4) && socket_size_od_mm < 12){
                hole_size_mm=12;
                total = offset + hole_size_mm + pad;

                row(nub_size_in=nub_size_in, sockets=sub_sockets, offset=total, show_sock=show_sock);
            }else{
                row(nub_size_in=nub_size_in, sockets=sub_sockets, offset=total, show_sock=show_sock);
            }
    }
}
      
module box(dims, thick=1.12){
    difference(){
        cube([dims[0]+thick, dims[1]+thick, dims[2]+thick],center=true);
        translate([0,0,thick]){
            cube([dims[0], dims[1], dims[2]+thick*2],center=true);
        }

    }
}
module socket_wrench_38(){
    translate([-100,22,0]){
        rotate([72,-9,0]){
            rotate([0,0,-12]){
                import("SocketWrench38_repaired_and_simplified.stl");
            }
        }
    }
}
module socket_wrench_14(){
    translate([-65,-6,-20]){
        xrot(57){
            yrot(10){
                zrot(6){
                    import("SocketWrench14_simplified.stl");
                }
            }
        }
    }
}

module extension(nub_size_in=(3/8), shaft_d_mm=12, head_d_mm=17.75, shaft_l_mm=115, head_l_mm=24){
    
    rotate([0,90,0]){
        union(){
            translate([0,0,-((shaft_l_mm+head_l_mm)/2)]){
                cylinder(h=head_l_mm, d=head_d_mm, center=true);
            }
            cylinder(h=shaft_l_mm, d=shaft_d_mm, center=true);
            
            nub_size_mm = nub_size_in * i2m;
            translate([0,0,(shaft_l_mm+nub_size_mm)/2]){
                drive_nub(nub_size_in);
            }
        }
    }
}

module extensions(){
    color("Green"){
        translate([80,-5,0]){
            rotate([0,180,0]){    
                extension();
            }
        }
        
        translate([90, 20, 0]){    
            extension(shaft_l_mm=40);
        }
        translate([100, 40, 0]){    
            rotate([0,180,0]){    
            
                extension(nub_size_in=(1/4), shaft_d_mm=8.25, head_d_mm=12, shaft_l_mm=24, head_l_mm=20);
            }
        }
    }
}
module torus(d1, d2){
  rotate([90,0,0]){
    rotate_extrude(){
        translate([d2, 0, 0]){
            circle(r = d1);
        }
    }
  } 
}
module insert(dims){    
    width = dims[0];
    depth = dims[1];
    height = dims[2];
    recess = 4;
    
    // 1/4 drive row
    translate([-width/2,10,-recess]){
//        row(show_sock=false);
    }
    // 3/8 drive row
    translate([-width/2-5,-30,-recess]){
//        row(nub_size_in = (3/8),
//            sockets=[10,12,13,14,15,17,18,19],
//            show_sock=false);
    }
    // adapter 1/4 to 3/8
    translate([-10,10,-recess]){
        row(nub_size_in=(3/8), sockets=[10],show_sock=false, special_txt="AD");
    }
    
    difference(){
        // base
        union(){
            translate([0,0,-height/3.99]){
                cube([width-2, depth-2, height/2], center=true);
            }
            // hold 3/8 wrench
            translate([-45,35,0]){
                cuboid([16,25,10], rounding=4);
            }
            // hold both 3/8  exts
            color("LightBlue"){
                translate([80,7,0]){
                    cuboid([16,51,8], rounding=4);
                }
            }
            // hold 1/4 ext
            color("Blue"){
                translate([100,39.5,0]){
                    cuboid([10,16,6], rounding=3);
                }
            }            
            // hold 1/4 wrench
            color("Pink"){
                translate([100,-31.5,-1.6]){
                    cuboid([10,19,6], rounding=3);
                }
            }            

        }
        // finger hole 3/8 wrench
        translate([-70,43,0]){
            cylinder(h=100,d=30,center=true);
        }
        // finger hole 3/8 long ext and baby
        translate([155,-22,0]){
            cylinder(h=100,d=40,center=true);
        }        
        // finger hole 3/8 short and 1/4 ext
        translate([125,25,0]){
            cylinder(h=100,d=30,center=true);
        }        
        scale(1.02){
            extensions();
        }
        // 1/4 drive row
        translate([-width/2,10,-recess]){
//             row(show_sock=true);
        }
        // 3/8 drive row
        translate([-width/2-5,-30,-recess]){
//            row(nub_size_in = (3/8),
//                sockets=[10,12,13,14,15,17,18,19],
//                show_sock=true);
        }
        // adapter 1/4 to 3/8
        translate([-10,10,-recess]){
            row(nub_size_in=(3/8), sockets=[10],show_sock=true, special_txt="AD");
        }

        // wrench slot
        translate([-68, 35,-20.0]){
            scale([1.02,1.02,1.02]){
                //socket_wrench_38();
            }
            // round hole for driver
            right(82){
                back(0.3){
                    cylinder(h=100, d=13,center=true);
                }
            }
        }
        // baby wrench
        translate([107, -38,-7.0]){
            union(){
                fwd(-3.7){
                    left(56){
                        cylinder(h=100, d=12,center=true);
                    }
                }
                scale([1.04,1.04,1.04]){
                    xrot(180){
                        zrot(180){
                            down(6){
                                socket_wrench_14();
                                cylinder(1,1);
                            }
                        }
                    }
                }
            }
        }
        
    }
}

module side(left=true){
    intersection(){
        if(left){
            fwd(500){
                cube(1000,center=true);
            }
        }else{
            back(500){
                cube(1000, center=true);
            }
        }
        partition(size=400,gap=0.5,spread=12, cutpath="dovetail"){
           fwd(30){ 
            zrot(90){
                insert([355,115,47]);
            }      
           }
        }
    }
}
side(left=false);

//socket_wrench_38();
//socket_wrench_14();
//insert([356,116,47]);
/*
translate([10,0,((3/8)/2)*i2m]){
    drive_nub(3/8);
}
translate([-10,0,((1/4)/2)*i2m]){
    drive_nub(1/4);
}
*/

//box([356,116,47]);