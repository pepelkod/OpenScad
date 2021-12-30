use <OnBikeHexKeyHolder.scad>;


fuji = 32;
height=85;
show_mock=false;
shift_amt_X= show_mock?22:22;
shift_amt_Y= show_mock?40:5;

dt_thickness=1.5;
translate([shift_amt_X*-1, shift_amt_Y, dt_thickness*2]){
    tool_bracket(left_size=3, right_size=4,
                        thickness=dt_thickness,
                        label="FUJI         DT",
                        svg_name="FujiDowntubeProfile.svg",
                        show_mock=show_mock,
                        height=height);
}
st_thickness=2;
translate([shift_amt_X*1, shift_amt_Y, st_thickness*2]){
    tool_bracket(left_size=6, right_size=5,
                        thickness=st_thickness,
                        label="FUJI         ST",
                        seat_tube_d=fuji,
                        show_mock=show_mock,
                        height=height);
}        
