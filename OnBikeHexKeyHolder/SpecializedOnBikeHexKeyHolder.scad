include <OnBikeHexKeyHolder.scad>;


fuji = 32;
height=85;
show_mock=false;
shift_amt_X= 0;
shift_amt_Y= show_mock?40:5;

translate([shift_amt_X, shift_amt_Y*1, height/2])
    tool_bracket(left_size=3, right_size=4,
                        thickness=1.5,
                        label="SPEC         DT",
                        svg_name="SpecializedDowntubeProfile.svg",
                        show_mock=show_mock,
                        height=height,
                        width = 48,
                        angle_add=0.42);

translate([shift_amt_X, shift_amt_Y*-1, height/2])
    tool_bracket(left_size=8, right_size=5,
                        thickness=3.0,
                        label="SPEC         ST",
                        svg_name="SpecializedSeattubeProfile.svg",
                        show_mock=show_mock,
                        height=height,
                        width=42,
                        angle_add=0.45);                        

// braces
difference(){
    translate([shift_amt_X, 5*shift_amt_Y, -1])
        rotate([45,0,0])
            cylinder(h=40.2, d=1);
    translate([0,0,-50])
        cube(100, center=true);
}
