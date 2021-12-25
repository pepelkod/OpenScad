// Included for spokes
// Maybe for hub.
use <thread.scad>

$fn=80;
no_threads=true;

// ROTATE_ABOUT_PT
// rotate as per a, v, but around point pt
// a: angle to rotate in degrees
// v: vector to rotate about [x,y,z]
// pt: center point of rotation [x,y,z]
module rotate_about_pt(a, v, pt) {
    translate(pt)
        rotate(a,v)
            translate(-pt)
                children();   
}

// LETTER
// Make a 3d letter appear
// l: letter to write
// letter_size: size_of letter in points?
// letter_height: height in mm
// font: font
// halign: horizontal alignment
// valign: vertical alignment
module letter(l, letter_size=1.5, letter_height=0.5, font, halign="center", valign="center") {
     linear_extrude(height = letter_height) {
        text(l, size = letter_size, font = font, halign = halign, valign = valign, $fn = 16);
     }
}
//  NIPPLE
// length: full length of nipple
// spoke_diameter: size in mm of spoke
// wrench_width: size of wrench flats (mm)
// body_diameter: how big is the round body of the spoke (above the wrench flat)
// head_diamter: how big is the head (above the body)
// body_length: portion of nipple that is NOT head 
// slot_width: width (and depth) of screwdriver slot on top of nipple
module nipple(length=12.1, spoke_diameter=2.0, wrench_width=3.27, body_diameter=3.92, head_diameter=6.0, body_length=9, slot_width=1.5){

      difference(){
        union(){
          rotate_extrude($fn=200)
            polygon(
                                   points=[
                                            [0,length], [head_diameter/2, length],                // top of head
                                                            [head_diameter/2, body_length*1.15],      // end of head
                                                        [body_diameter/2, body_length],           // in to body
                                                        [body_diameter/2, body_length/1.5],     // to wrench flat
                                                      [wrench_width/4, body_length/1.7],        // in to wrench flat
                                                      [wrench_width/4, 0],                              // bottom of wrench flat
                                            [0, 0] ,                                                               // across bottom of nipple
                                    ]
                        );
            translate([0,0,body_length/3])
                cube([wrench_width*0.707, wrench_width*0.707, body_length/1.5], center=true); // width of center should be sin(45)
        }
        translate([0, 0, (100/2)+(length-slot_width)])                                                         // up into position
             cube([slot_width, head_diameter, 100], center=true);                                             // screwdriver slot
        translate([0,0,-1])                                                                                                 // move down so it fully bores out hole
            cylinder(d=spoke_diameter, h=100);                                                                     // spoke hole
    }
}
    
// SPOKE HEAD
// Will be attached to the curve of the spoke
// head_diameter: Diameter of the spoke head
// diameter_spoke: Diameter of the spoke
// extra_length: Amount of extra spoke between the head and the elbow
module spoke_head(diameter_head=5, diameter_spoke=2, extra_length=2){
    head_radius=diameter_head/2;
    offset = head_radius/3;
    subrad = head_radius*(2/3);

    
    translate([0, 0, extra_length+offset+0.5])
        letter("W", letter_size=1.5);
    hull(){
    
     rotate_extrude($fn=200)
        translate([offset, extra_length, 0])
            intersection(){
                circle(r=subrad);
                polygon(
                           points=[
                                    [0,0],
                                    [(diameter_spoke/2)-offset,0],                                            
                                    [4, 3],              
                                    [4, 10],
                                    [0, 10]
                            ]
                );

            }
    }
    cylinder(d=diameter_spoke, h=extra_length);
}

// SPOKE ELBOW
// Will be attached to the curve and head of the spoke
// Creates an elbow, a short piece of spoke, and then a head
// diameter_spoke: How big diameter is the body of the spoke
// radius_curve: How sharp do it curve
// extra_length: How much extra spoke to add between the curve and the head
module spoke_elbow(diameter_spoke=2, radius_curve=3, extra_length=2){
    translate([-radius_curve,0,0])
        rotate([0,-90,0])
            spoke_head(diameter_spoke=diameter_spoke, extra_length=extra_length);
    translate([-radius_curve,0, radius_curve])                             // move to align with 0,0,0
        rotate([90, 90, 0])                                           // rotate to match spoke
            intersection(){                                             // get just one corner
                translate([0,0,-radius_curve])                  // move down to align with full circle
                    cube(radius_curve*2);                           
                rotate_extrude()                                     // extrude the whole curve (circle ring)
                    translate([radius_curve,0,0])               // shift curve radius away from 0,0,0
                        circle(diameter_spoke/2);               // make a cross section of spoke
            }
}
// SPOKE_THREAD
// A section of threaded spoke
// Not needed for a wheel since the nipple covers the threading.
// Also very slow if adding it to a full wheel.
// Use the global no_thread=true for wheels where  you don't want threads
// diameter: same as spoke.
// pitch: thread pitch
// length: Length of threaded section in mm
// leadin: amount of beveled area as threads start
// global no_threads will render a cylinder only
module spoke_thread(diameter_spoke){
    metric_thread (diameter=diameter_spoke, pitch=0.45, length=10, leadin=1, test=no_threads);
}

// SPOKE
// length: Length of spoke in mm
// diameter: Diameter of spoke in mm
module spoke(length, diameter=2.0){
    // calc length of curved part on end
    radius_curve = 3;
    bare_length=length-(radius_curve + 10); // remove bend and threads(10mm)
      union(){
        translate([0, 0, radius_curve])                         // move thread and bare out for bend space
            union(){
                translate([0, 0, bare_length])                          // move thread to end of spoke
                    spoke_thread(2.2);                                          // thread
                cylinder(h=bare_length, r=diameter/2);	    // bare spoke
            }
        spoke_elbow(diameter, radius_curve);            // bend (or elbow)
    }
}

// HALF_SPOKES
// Create 1/2 of the total spokes for the wheel.  Either the drive side or non-drive side.
// spoke_count: 1/2 total wheel spoke count
// num_crosses: How many other spokes does each cross before hitting hub
// erd:  Effective rim diameter
// pcd:  Pitch circle diameter of the hub flange these will exit from
// dist:  Offset of flange from center of hub
// offset:  Drive side or non-drive side.  If offset is true it shifts the polar alignment by 1/2 of spacing degrees
// flange_thickness: needed to shift the spokes out or in based on if they are head in or head out.
module half_spokes(spoke_count=16, num_crosses=3, erd=605, pcd=57, dist=30, offset=true, flange_thickness=2, spoke_color="#202020", nipple_color="silver"){
    A = erd/2;
    B = pcd/2;
    
    // Spoke spacing is just 360 divided the total number of holes on *this* side of the hub 
    // A 32 hole hub would have 16 holes on the drive side flange 
    // 360 / 16 is 22.5 degrees.
    spoke_spacing=(360/spoke_count); // in degrees
    
    // theta
    // This is the angle made up of the three points. A,B,C w
    //          A is one of the spoke holes in the hub
    //          B is the center of the hub (where the axle is
    //          C is another spoke hole in the hub that is "num_crosses" away from A
    //  An example.  A radial laced wheel would return 0.
    // A 32 spoke wheel would have 16 holes on one side of the hub  360/16 is 22.5 degrees.
    //          So a 2 cross would be  22.5*2 = 45 degrees.
    theta = spoke_spacing*num_crosses;

    // Extra space to ensure spokes don't hit flange
    padded_flange_thickness=flange_thickness*1.75;

    // Calculate spoke length
    C = sqrt( pow(A,2) + pow(B,2) - (2 * A * B * cos(theta)));      // Calculate length of spoke cross angle using pythagorus. 
    spoke_len = sqrt(pow(C,2) + pow(dist,2));                           // Now calc in additional length to include the flare out to the hub flange
    
    // Calc angle to spoke hole (across other spokes)
    // This is the angle the spoke will be.  The three points 
    // are center of hub, rim hole, and hole the spoke will go into  (not including flare)
    cos_cross_angle =  (pow(C,2) + pow(A,2) - pow(B,2))/(2*C*A);
    cross_angle = acos(cos_cross_angle);

    // Angle that the spoke will "flare" out to meet the hub flange.
    // The three points are center of hub, rim hole, and flange dist
    flare_angle_outer = offset ? -atan((dist-padded_flange_thickness)/C) : atan((dist+padded_flange_thickness)/C);
    flare_angle_center = offset ? -atan((dist)/C) : atan((dist)/C);
    flare_angle_offset = flare_angle_outer-flare_angle_center;      // difference between hittin center of flange and outside of flange
    //echo("flare_angle", flare_angle);
    
    // Distance to move the spoke to line up with the spoke hole
    // This is one side of the triangle made up of the center of the hub,
    // the flange hole and the angle theta
    shift_amt = cos(theta) * (B)-3;
    //shift_amt = pcd/2;
    echo("theta", theta);
    echo("B", B);
    echo("shift_amt", shift_amt);

    // Loop creating a set of spoke and nipples
    spoke_num=0;
    for (spoke_num = [0 : 1 : spoke_count]){		// create spokes
        // Angle to rotate around the center axis of the hub. 
        // It spreads the spoke evenly around the wheel
        position_angle = offset ? (spoke_spacing * spoke_num) : ((spoke_spacing * spoke_num) + spoke_spacing/2 ); 
        // This is either -1 or +1.  
        // Used to flip spoke head-in or head-out
        // Also used to alternate between leading spoke and trailing spoke
        even = ((spoke_num % 2) * 2) -1;
        // Flare angle shifts up and down depending on if it is heads-in or heads-out
        flare_angle=flare_angle_center + (even * flare_angle_offset);
        // Cross angle alternates for every spoke
        cross_angle=cross_angle * even;
        // Heads-in heads-out alternate for every spoke
        flip_angle = (90*even)+90;                                   
        // Distribute around wheel
        rotate(a=[0, 0, position_angle])
            // Move out to rim
            translate([shift_amt, 0, 0])
                // Tilt to cross angle
                rotate_about_pt(a=[0, 0, cross_angle], pt=[spoke_len, 0, 0])      
                    // Flare out to hub flange
                    rotate_about_pt(a=[0, flare_angle, 0], pt=[spoke_len, 0, 0])  
                        // The spoke was created vertically along z-axis. 
                        // Lay it down onto x axis (rotate down 90 around y) 
                        rotate(a=[0, 90, 0]){		                          
                            // Spoke only
                            // Flip heads-in or heads-out
                            rotate(a=[0,0,flip_angle])
                                color(spoke_color)
                                    spoke(spoke_len, 2);		    // create
                            // Nipple only
                            // Move out to end of spoke where it meets rim
                            translate([0,0,spoke_len-8])
                                color(nipple_color)
                                    nipple();   // defaults
                        }
                            
    }
}
// SPOKES
// Note we need all the wheel info because we are creating and placing the spokes.
// spoke_count: How many total spokes in the wheel
// num_crosses: For each spoke, how many other spokes does it cross on the same side of the wheel.
// erd: Effective rim diameter.  See RIM erd
// left_dist: Distance from center of hub to non-drive flange
// left_pcd: Non-drive pitch circle diameter
// right_dist: Distance from center of hub to drive side flange
// right_pcd: Diameter of hole of drive side flange
module spokes(spoke_count=32, num_crosses=3, erd=602, left_dist, left_pcd, right_dist, right_pcd, flange_thickness=2, spoke_color, nipple_color){
    // calc based on crosses, erd, pcd, flange offset
    left_spoke_count = spoke_count/2;
    right_spoke_count = left_spoke_count;
    
    half_spokes(spoke_count = left_spoke_count, num_crosses=num_crosses, erd=erd, pcd=left_pcd, dist=left_dist, offset=false, flange_thickness=flange_thickness, spoke_color=spoke_color, nipple_color=nipple_color);
    half_spokes(spoke_count = left_spoke_count, num_crosses=num_crosses, erd=erd, pcd=right_pcd, dist=right_dist, offset=true, flange_thickness=flange_thickness, spoke_color=spoke_color, nipple_color=nipple_color);
}

// RIM
// erd: Effective Rim Diameter, or how far is it from nipple across the rim to the other nipple head.
// depth: From nipple head to rim bead
// external_width: How wide is the rim
module rim(erd=602, depth=32, external_width=23){
    translate([0,0,-external_width/2])
    difference(){
        color("white") cylinder(h=external_width, r=(erd+depth)/2);                // the rim
        translate([0, 0, -1]){
            color("silver") cylinder(h=external_width+2, r=erd/2); // cutout the center
        }
    }
}

// ROUNDED_DISC
// Create a disc with a radiused edge like a hub flange
// disc_radius: Diameter of disc
// thickness: How thick is 1/2 the disc in mm
module rounded_disc(disc_radius, thickness){
    hull(){
        union(){
            translate([0,0,thickness/2])                                // move along Z to be centered
                rotate_extrude()
                    translate([disc_radius,0,0])
                        circle(thickness);                                     //
            translate([0,0,-thickness*4])                               // taper align with flange
                cylinder(r=1, h=thickness*8);                           // make fat taper from middle
        }
    }
}

// FLANGE
// dist: distance from center of hub
// pcd: pitch circle diameter (of holes)
// hole_count: number of holes on THIS flange only (for 32 hole hub, this should be 16)
// offset: Should these holes be offset by 1/2 of a hole spacing
//             On all hubs the holes on the flanges are offset from each other.
// flange_thickness: How thick is the flange (Height of the cylinder)
// flange_diameter_beyond_pcd: How many millimeters bigger is the flange than the pcd
// hole_diameter: Diameter of the holes
module flange(dist=20, pcd=57, hole_count=32, offset=false, flange_thickness=2, flange_diameter_beyond_pcd=4, hole_diameter=2.5){
    flange_diameter=pcd+flange_diameter_beyond_pcd;
    hole_spacing=(360/hole_count); // in degrees

    translate([0,0,dist-(flange_thickness/2)]){
        difference(){
            rounded_disc(flange_diameter/2, flange_thickness);
            // create "hole punches"
            for (hole_num = [0 : 1 : hole_count]){		                // create spoke holes
                position_angle = offset ? (hole_spacing * hole_num) : ((hole_spacing * hole_num) + (hole_spacing/2) ); 
                rotate([0,0,position_angle])                                    // layout around center
                    translate([0,0,-2])                                             // shift down to cover whole flange
                        translate([0, pcd/2, 0])                                    // hole punch out to edge
                            color("pink") cylinder(h=flange_thickness+4, r=hole_diameter/2);    // single hole punch for spoke.
            }
        }
    }
}
// HUB
// old: Outer locknut distance.  Spacing for hub mm
// left_dist: Distance from center of hub to non-drive flange
// left_pcd: Diameter of holes in non-drive flange
// right_dist: Distance from center to right flange
// right_pcd: Diameter of holes in drive side flange
// hole_count: total holes for hub
module rear_hub(old=135, left_dist=33, left_pcd=57, right_dist=19, right_pcd=67, hole_count=32){
    locknut_length=6;
    freehub_length=35;
    body_length= old - ((2*locknut_length) + freehub_length);
    left_flange_length=2;
    right_flange_length=2;
    
    locknut_diameter=14;
    freehub_diameter = 16.5;            // shimano
    body_diameter = left_pcd/2;
    left_flange_diameter=left_pcd+2;
    right_flange_diameter=right_pcd+2;

    locknut_offset=  -(old/2)  ;                   
    freehub_offset=  -(old/2) + locknut_length;
    body_offset=      -(old/2) + locknut_length + freehub_length;
    left_flange_offset = left_dist;
    right_flange_offset = -right_dist;
  
    echo("body_length", body_length);
    echo("freehub_offset", freehub_offset);
    echo("locknut_offset", locknut_offset);
    echo("body_offset", body_offset);
    echo("body_diameter", body_diameter);

    union(){
        translate([0,0,locknut_offset]) cylinder(h=locknut_length, r=locknut_diameter/2, $fn=6);
        translate([0,0,freehub_offset]) cylinder(h=freehub_length, r=freehub_diameter/2);             // freehub splines
        color("orange") translate([0,0,body_offset]) cylinder(h=body_length, r=body_diameter/2);  // main body   
        color("orange") flange(left_flange_offset, left_pcd, hole_count/2, offset=false);
        color("orange") flange(right_flange_offset, right_pcd, hole_count/2, offset=true);
        
        //translate([0,0,2]) sphere(r=2);              // end
    }
}

// RIM2
// erd: Effective rim diameter.  Distance across rim from where the nipple heads sit.
// external_width: Width of rim from outside edges
// internal_width: From inside where tire touches how wide is it.
// depth: How aero is it.
// erto:   european rim and tire org sizing.
//                  559 = 26 inch rim
//                  584 = 27.5  or 650b
//                  622 = 29er or 700c 
module rim2(erd, external_width, internal_width, depth, erto, rim_points){
    echo("rim points", rim_points);
        rotate_extrude($fn=200)
            polygon( rim_points  );
}






// DEFAULTS
// millimeters

// RIM
erd = 605+5;
external_width=26.3;
internal_width=23.0;
depth=15.8;
erto = 622;
err = erd/2;
ertor = erto/2;
rim_points=[
                                    [err,0],                                            // spoke-bed center
                                    [err+4, external_width/2],              // spoke-bed edge
                                    [err+depth, external_width/2 ],         // rim lip
                                    
                                    [err+depth, internal_width/2],
                                    [ertor, internal_width/2],
                                    [ertor, -internal_width/2],
                                    [err+depth, -internal_width/2],
                                    
                                    [err+depth, -external_width/2],         // lower rim lip
                                    [err+4, -external_width/2]];           // lower spoke-bed edge


// hub
old=142;
left_dist=33;
left_pcd=57;
right_dist=19;
right_pcd=57;


// wheel
num_crosses=3;
spoke_count=32;


module wheel(){
    color("Gray")
        rear_hub(old=old, left_dist=left_dist, left_pcd=left_pcd, right_dist=right_dist, right_pcd=right_pcd,hole_count=spoke_count);
    //rim(erd=erd, depth=45, external_width=25);
    color("SlateGray")
        rim2(erd, external_width, internal_width, depth, erto, rim_points=rim_points);
        spokes(spoke_count=spoke_count, num_crosses=num_crosses, erd=erd, left_dist=left_dist, left_pcd=left_pcd, right_dist=right_dist, right_pcd=right_pcd, spoke_color="#202020", nipple_color="silver");
}

module test(){
    //spoke_elbow(extra_length=1);
    //spoke_head();
    // nipple(length=12.1, wrench_width=3.27, body_diameter=3.92, head_diameter=6.0, body_length=9, slot_width=1.5);
    nipples(erd=erd);
 }
 
 //test();
 wheel();