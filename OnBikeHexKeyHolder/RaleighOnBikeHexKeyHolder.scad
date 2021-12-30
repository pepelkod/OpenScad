use <OnBikeHexKeyHolder.scad>;

raleigh_seat_tube_d = 28.8;
raleigh_down_tube_d = 35.2;

height=85;
show_mock=false;
shift_amt_X= show_mock?22:22;
shift_amt_Y= show_mock?40:5;

dt_thickness=1.5;
translate([shift_amt_X*-1, shift_amt_Y, dt_thickness*2]){
    tool_bracket(left_size=3, right_size=4,
                        thickness=dt_thickness,
                        label="CAD         DT",
                        seat_tube_d=raleigh_down_tube_d,
                        show_mock=show_mock,
                        height=height,
                        angle_add=-0.1,
                        bolt_nub_svg="RaleighCageProfile.svg");
}
st_thickness=3;
translate([shift_amt_X*1, shift_amt_Y, st_thickness*2]){
    tool_bracket(left_size=8, right_size=5,
                        thickness=st_thickness,
                        label="CAD          ST",
                        seat_tube_d=raleigh_seat_tube_d,
                        show_mock=show_mock,
                        height=height,
                        bolt_nub_svg="RaleighCageProfile.svg");
}