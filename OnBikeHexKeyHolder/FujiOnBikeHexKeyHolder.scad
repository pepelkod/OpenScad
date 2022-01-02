
use <OnBikeHexKeyHolder.scad>;

module make(){
    fuji_seat_tube_d = 32;


    height=85;
    show_mock=false;
    shift_amt_X= show_mock?22:22;
    shift_amt_Y= show_mock?40:5;
    dt_thickness=1.5;
    st_thickness=3;
    
    translate([shift_amt_X*1, shift_amt_Y, dt_thickness*2]){
        tool_bracket(left_size=3, right_size=4,
            thickness=dt_thickness,
            label="FUJI         DT",
            svg_name="FujiDowntubeProfile.svg",
            show_mock=show_mock,
            height=height){
                mock_cage(h=100,
                    hollow=false,
                    bolt_nub_upper_svg="FujiUpperCageProfile.svg",
                    bolt_nub_lower_svg="FujiLowerCageProfile.svg",
                    bolt_nub_upper_height=200,
                    bolt_nub_lower_height=20);           
        }
    }
    
    translate([shift_amt_X*-1, shift_amt_Y, st_thickness*2]){
        tool_bracket(left_size=6, right_size=5,
            thickness=st_thickness,
            label="FUJI          ST",
            seat_tube_d=fuji_seat_tube_d,
            show_mock=show_mock,
            height=height){
                mock_cage(h=100,
                    hollow=false,
                    bolt_nub_upper_svg="FujiUpperCageProfile.svg",
                    bolt_nub_lower_svg="FujiLowerCageProfile.svg",
                    bolt_nub_upper_height=200,
                    bolt_nub_lower_height=25);           
        }     
    }
}
make();