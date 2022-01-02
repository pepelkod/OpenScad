use <OnBikeHexKeyHolder.scad>;

module mock_nub(svg="LezyneCageProfile.svg", length=0, position=32, cage_thickness=3){
    translate([0,0,position]){
        translate([0,0,-length/2]){
            rotate([0,0,0]){
                linear_extrude(length){
                    import(svg);
                }
            }
        }
    }
}
    
module make(){
    orbea_seat_tube_d = 28.8;
    orbea_down_tube_d = 35.2;

    height=85;
    show_mock=false;
    shift_amt_X= show_mock?22:22;
    shift_amt_Y= show_mock?40:5;
    dt_thickness=1.5;
    st_thickness=3;
    
    translate([shift_amt_X*1, shift_amt_Y, dt_thickness*2]){
        tool_bracket(left_size=3, right_size=4,
            thickness=dt_thickness,
            label="ORB         DT",
            seat_tube_d=orbea_down_tube_d,
            show_mock=show_mock,
            height=height,
            angle_add=0.0){
                union(){
                    mock_nub(svg="LezyneCageProfile.svg", length=24.5, position= 32, cage_thickness=dt_thickness);
                    mock_nub(svg="LezyneCageProfile.svg", length=27, position=-32, cage_thickness=dt_thickness);
                }
            }
    }

    translate([shift_amt_X*-1, shift_amt_Y,st_thickness*2]){
        tool_bracket(left_size=8, right_size=5,
            thickness=st_thickness,
            label="ORB                ST",
            seat_tube_d=orbea_seat_tube_d,
            show_mock=show_mock,
            height=height,
            angle_add=0.0){
                union(){
                    mock_nub(svg="LezyneCageProfile.svg", length=24.5, position= 32, cage_thickness=st_thickness);
                    mock_nub(svg="LezyneCageProfile.svg", length=27, position=-32, cage_thickness=st_thickness);
                }
            }
        }
}
make();

//mock_nub(length=10);