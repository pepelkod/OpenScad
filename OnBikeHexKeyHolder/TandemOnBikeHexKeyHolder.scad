use <OnBikeHexKeyHolder.scad>;



module make(){
    tandemonium_seat_tube_d = 34.9;
    tandemonium_down_tube_d = 44.6;

    height=85;
    show_mock=true;
    shift_amt_X= show_mock?22:22;
    shift_amt_Y= show_mock?40:5;
    dt_thickness=3;
    st_thickness=1;
    
    // downtube 
    translate([shift_amt_X*2.2, shift_amt_Y, dt_thickness*2]){
        tool_bracket(left_size=8, right_size=6,
            thickness=dt_thickness,
            label="8-TAN DT-6",
            seat_tube_d=tandemonium_down_tube_d,
            show_mock=show_mock,
            height=height,
            angle_add=-0.1){
                mock_cage(h=100,
                    hollow=false,
                    bolt_nub_upper_svg="RaleighCageProfile.svg",
                    bolt_nub_lower_svg="RaleighCageProfile.svg",
                    bolt_nub_upper_height=100,
                    bolt_nub_lower_height=100);
            }
    }
    
    // front seat tube
    translate([shift_amt_X*0, shift_amt_Y, st_thickness*2]){
        tool_bracket(left_size=4, right_size=5,
            thickness=st_thickness,
            label="4-TAN ST-5",
            seat_tube_d=tandemonium_seat_tube_d,
            show_mock=show_mock,
            height=height){
                mock_cage(h=100,
                    hollow=false,
                    bolt_nub_upper_svg="RaleighCageProfile.svg",
                    bolt_nub_lower_svg="RaleighCageProfile.svg",
                    bolt_nub_upper_height=100,
                    bolt_nub_lower_height=100);
            }     
    }
    
    // Rear seat tube
    translate([shift_amt_X*-1.8, shift_amt_Y, st_thickness*2]){
        tool_bracket(left_size=3, right_size=1,
            thickness=st_thickness,
            label="3-TAN ST-1",
            seat_tube_d=tandemonium_seat_tube_d,
            show_mock=show_mock,
            height=height){
                mock_cage(h=100,
                    hollow=false,
                    bolt_nub_upper_svg="RaleighCageProfile.svg",
                    bolt_nub_lower_svg="RaleighCageProfile.svg",
                    bolt_nub_upper_height=100,
                    bolt_nub_lower_height=100);
            }     
    }
    
}
make();