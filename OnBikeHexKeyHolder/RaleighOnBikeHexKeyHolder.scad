include <OnBikeHexKeyHolder.scad>;

raleigh_seat_tube_d = 28.8;
raleigh_down_tube_d = 35.2;

height=85;
show_mock=false;
shift_amt_X= 0;
shift_amt_Y= show_mock?50:5;
translate([shift_amt_X, shift_amt_Y*1, height/2])
    tool_bracket(left_size=3, right_size=4,
                        thickness=1.5,
                        label="CAD         DT",
                        seat_tube_d=raleigh_down_tube_d,
                        show_mock=show_mock,
                        height=height,
                        angle_add=-0.1,
                        bolt_nub_svg="RaleighCageProfile.svg");

translate([shift_amt_X, shift_amt_Y*-1, height/2])
    tool_bracket(left_size=8, right_size=5,
                        thickness=3,
                        label="CAD          ST",
                        seat_tube_d=raleigh_seat_tube_d,
                        show_mock=show_mock,
                        height=height,
                        bolt_nub_svg="RaleighCageProfile.svg");

// braces
difference(){
    translate([shift_amt_X, 5*shift_amt_Y, -1])
        rotate([45,0,0])
            cylinder(h=36.0, d=1);
    translate([0,0,-50])
        cube(100, center=true);
}
