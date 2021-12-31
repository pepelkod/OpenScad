include <OnBikeHexKeyHolder.scad>;

canondale_seat_tube_d = 35.25;
canondale_down_tube_d = 46.8;   //-48.25 lower end

height=85;
show_mock=false;
shift_amt_X= show_mock?22:22;
shift_amt_Y= show_mock?-1:-1;

dt_thickness=1.5;
translate([shift_amt_X*1, shift_amt_Y, dt_thickness*2]){    tool_bracket(left_size=3, right_size=4,
                        thickness=1.5,
                        label="CAD         DT",
                        seat_tube_d=canondale_down_tube_d,
                        show_mock=show_mock,
                        height=height,
                        angle_add=-0.1,
                        bolt_nub_svg="CanondaleRedCageProfile.svg");
}
st_thickness=3;
translate([shift_amt_X*-1, shift_amt_Y, st_thickness*2])
    tool_bracket(left_size=8, right_size=5,
                        thickness=st_thickness,
                        label="CAD          ST",
                        seat_tube_d=canondale_seat_tube_d,
                        show_mock=show_mock,
                        height=height,
                        bolt_nub_svg="CanondaleRedCageProfile.svg");
                        
                      
