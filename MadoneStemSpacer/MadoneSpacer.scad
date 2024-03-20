

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
    height=18;
    angle = 16.2;
    skew = tan(angle);
    echo("angle ", angle)
    echo("skew ", skew)
    intersection(){
        difference(){ 
            translate([0,0,8]){
                madone_spacer(height, skew);
                //cylinder(d=32,h=16, center=true);
            }
            translate([0,-24,-2]){
                rotate([45,0,0]){
                    #hull(){
                    translate([3,0,0]){
                        cylinder(h=100,d=8, center=true);
                    }
                    translate([-3,0,0]){
                        cylinder(h=100,d=8, center=true);
                    }}
                }
            }
        }
        translate([0,0,-8]){
            rotate([-angle,0,0]){
                cube([100,100,32], center=true);
            }
        }
    }
}