

module madone_spacer(height=16, skew=0.26){
    M = [ 
        [ 1  , 0  , 0  , 0   ],
        [ 0  , 1  , skew*height, 0   ],  // The "0.7" is the skew value; pushed along the y axis as z changes.
        [ 0  , 0  , 1*height  , 0   ],
        [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(M) {
        linear_extrude(1, center=true, slices=100){
            import(file="MadoneSpacer.svg", center=true);
        }
    }
}

intersection(){
    angle = 16.2;
    skew = tan(angle);
    echo("angle ", angle)
    echo("skew ", skew)
    //difference(){ 
        translate([0,0,8]){
            madone_spacer(20, skew);
            //cylinder(d=32,h=16, center=true);
        }
        translate([0,0,-8]){
            rotate([angle,0,0]){
                cube([100,100,32], center=true);
            }
        }
    //}
}