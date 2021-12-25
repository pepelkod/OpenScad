include <OnBikeHexKeyHolder.scad>;

canondale_seat_tube_d = 35.25;
canondale_down_tube_d = 46.8;   //-48.25 lower end

height=85;
show_mock=false;
shift_amt_X= 0;
shift_amt_Y= show_mock?40:5;

translate([shift_amt_X, shift_amt_Y*1, height/2])
    tool_bracket(left_size=3, right_size=4,
                        thickness=1.5,
                        label="CAD         DT",
                        seat_tube_d=canondale_down_tube_d,
                        show_mock=show_mock,
                        height=height,
                        angle_add=-0.1);
translate([shift_amt_X, shift_amt_Y*-1, height/2])
    tool_bracket(left_size=8, right_size=5,
                        thickness=3,
                        label="CAD          ST",
                        seat_tube_d=canondale_seat_tube_d,
                        show_mock=show_mock,
                        height=height);
                        
                        // braces
difference(){
    translate([shift_amt_X, 5*shift_amt_Y, -1])
        rotate([45,0,0])
            cylinder(h=40.2, d=1);
    translate([0,0,-50])
        cube(100, center=true);
}
