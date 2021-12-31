use <OnBikeHexKeyHolder.scad>;



module make(){
    raleigh_seat_tube_d = 28.8;
    raleigh_down_tube_d = 35.2;

    height=85;
    show_mock=false;
    shift_amt_X= show_mock?22:22;
    shift_amt_Y= show_mock?40:5;
    dt_thickness=1.5;
    st_thickness=3;
    
    translate([shift_amt_X*1, shift_amt_Y, dt_thickness*2]){
        cut_cage(show_mock=true){
            tool_bracket(left_size=3, right_size=4,
                                thickness=dt_thickness,
                                label="RAL         DT",
                                seat_tube_d=raleigh_down_tube_d,
                                show_mock=show_mock,
                                height=height,
                                angle_add=-0.1);
             mock_cage(h=100,
                            hollow=false,
                            bolt_nub_svg="RaleighCageProfile.svg",
                            bolt_nub_height=100);
        }
    }
    
    translate([shift_amt_X*-1, shift_amt_Y, st_thickness*2]){
        cut_cage(){
            tool_bracket(left_size=8, right_size=5,
                            thickness=st_thickness,
                            label="RAL          ST",
                            seat_tube_d=raleigh_seat_tube_d,
                            show_mock=show_mock,
                            height=height);
             mock_cage(h=100,
                            hollow=false,
                            bolt_nub_svg="RaleighCageProfile.svg",
                            bolt_nub_height=100);           
        }     
    }
}
make();