use <OnBikeHexKeyHolder.scad>;                

module make(){
    canondale_seat_tube_d = 35.25;
    canondale_down_tube_d = 46.8;   //-48.25 lower end

    height=85;
    show_mock=false;
    shift_amt_X= show_mock?22:22;
    shift_amt_Y= show_mock?0:0;
    dt_thickness=1.5;
    
    
    translate([shift_amt_X*1, shift_amt_Y*1, dt_thickness*2]){
        tool_bracket(left_size=3, right_size=4,
                            thickness=dt_thickness,
                            label="CAD         DT",
                            seat_tube_d=canondale_down_tube_d,
                            show_mock=show_mock,
                            height=height,
                            angle_add=-0.1){
             mock_cage(h=100,
                                hollow=false,
                                bolt_nub_upper_svg="CanondaleRedCageProfile.svg",
                                bolt_nub_lower_svg="CanondaleRedCageProfile.svg",
                                bolt_nub_upper_height=27,
                                bolt_nub_lower_height=27);
        }
    }
    
    st_thickness=3;
    translate([shift_amt_X*-1, shift_amt_Y*-1, st_thickness*2]){
        tool_bracket(left_size=8, right_size=5,
                        thickness=st_thickness,
                        label="CAD          ST",
                        seat_tube_d=canondale_seat_tube_d,
                        show_mock=show_mock,
                        height=height){
             mock_cage(h=100,
                            hollow=false,
                            bolt_nub_upper_svg="CanondaleRedCageProfile.svg",
                            bolt_nub_lower_svg="CanondaleRedCageProfile.svg",
                            bolt_nub_upper_height=27,
                            bolt_nub_lower_height=27);
        }     
    }
}

make();