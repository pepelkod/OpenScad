use <OnBikePlugKitHolder.scad>;

show_mock=false;

module mock_nub(svg="LezyneCageProfile.svg", length=0, position=32, cage_thickness=3){
    difference(){
        translate([0,0,position]){
            translate([0,0,-length/2]){
                rotate([0,0,0]){
                    linear_extrude(length){
                        import(svg);
                    }
                }
            }
        }
        rotate([0,90,0]){
            hull(){
                offset = -5;
                space = 10;
                translate([-space,offset,0]){
                    cylinder(d=20, h=40, center=true);
                }
                translate([space,offset,0]){
                    cylinder(d=20, h=40, center=true);
                }
            }
        }
    }
}
    
module make(){
    ribble_down_tube_d = 10000.8;

    height=85;
    shift_amt_X= show_mock?40:22;
    shift_amt_Y= show_mock?0:0;
    dt_thickness=1.5;
    st_thickness=3;
    
    /*
    translate([shift_amt_X*1, shift_amt_Y, dt_thickness*2]){
        tool_bracket(left_size=3, right_size=4,
            thickness=dt_thickness,
            label="ORB         DT",
            seat_tube_d=orbea_down_tube_d,
            show_mock=show_mock,
            height=height,
            angle_add=0.0){
                mock_nub(length=90, position=0);

            }
    }
    */
    width = 54;
    translate([shift_amt_X*-1, shift_amt_Y,st_thickness*2]){
        difference(){
            tool_bracket(left_size=17.65, right_size=5,
                width=width,
                thickness=st_thickness,
                label="RIB                DT",
                seat_tube_d=ribble_down_tube_d,
                show_mock=show_mock,
                height=height,
                angle_add=0.0){           
                    mock_nub(length=90, position=0);
                }
            
            // remove right side
            translate([50+width/3,0,0]){    
                cube([100,100,100], center=true);
            }
            // remove excess on cage side
            translate([0,0,-4]){
                rotate([0, 45, 0]){
                    translate([0, 0, -30]){
                        #cube([10,100,40], center=true);
                    }
                }
            }
        }
    }
}
make();

//mock_nub(length=80, position=0);