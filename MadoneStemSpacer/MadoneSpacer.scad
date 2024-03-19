

module madone_spacer(){
    h = 16;
    M = [ 
        [ 1  , 0  , 0  , 0   ],
        [ 0  , 1  , 0.26*h, 0   ],  // The "0.7" is the skew value; pushed along the y axis as z changes.
        [ 0  , 0  , 1*h  , 0   ],
        [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(M) {
        linear_extrude(1, center=true, slices=100){
            import(file="MadoneSpacer.svg", center=true);
        }
    }
}

madone_spacer();