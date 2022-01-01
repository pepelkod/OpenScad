use <OnBikeHexKeyHolder.scad>;
module mock_nub(svg="SpecializedCageProfile.svg", length=0, position=32, cage_thickness=3){
    translate([0, position, -cage_thickness]){
        hull(){
            for(i=[-1:2:1]){
                translate([0, i*length,0]){
                    rotate_extrude(){
                        import(svg);
                    }
                }
            }
        }
    }
}
    
module make(){

    height=85;
    show_mock=false;
    shift_amt_X= show_mock?30:30;
    shift_amt_Y= 0;
    dt_thickness=1.5;
    st_thickness=3.0;

    translate([shift_amt_X*1, shift_amt_Y,dt_thickness*2]){
        difference(){
            tool_bracket(left_size=3, right_size=4,
                            thickness=dt_thickness,
                            label="SPEC                      DT",
                            svg_name="SpecializedDowntubeProfile.svg",
                            show_mock=show_mock,
                            height=height,
                            width = 48,
                            angle_add=0.42);
             mock_nub(svg="SpecializedCageProfile.svg", length=1, position=32, cage_thickness=dt_thickness);
             mock_nub(svg="SpecializedCageProfile.svg", length=5, position=-32, cage_thickness=dt_thickness);
        }
    }

    translate([shift_amt_X*-1, shift_amt_Y,st_thickness*2]){
        difference(){
            tool_bracket(left_size=8, right_size=5,
                            thickness=st_thickness,
                            label="SPEC                ST",
                            svg_name="SpecializedSeattubeProfile.svg",
                            show_mock=show_mock,
                            height=height,
                            width=42,
                            angle_add=0.45);                        
             mock_nub(svg="SpecializedCageProfile.svg", length=1, position=32, cage_thickness=st_thickness);
             mock_nub(svg="SpecializedCageProfile.svg", length=5, position=-32, cage_thickness=st_thickness);
        }
    }
}
make();

//mock_nub(length=10);