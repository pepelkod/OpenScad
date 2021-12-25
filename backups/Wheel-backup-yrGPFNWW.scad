
use <thread.scad>


$fn=80;
no_threads=true;

// rotate as per a, v, but around point pt
module rotate_about_pt(a, v, pt) {
    translate(pt)
        rotate(a,v)
            translate(-pt)
                children();   
}

// LETTER
// Make a 3d letter appear
module letter(l, letter_size=1.5, letter_height=0.5, font, halign, valign) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
   // for (hole_num = [0 : 1 : hole_count]){
    for( index = [0: 0.05: letter_height]){
        stage_size=letter_size-index;
        stage_height=index;
        
        linear_extrude(height = stage_height) {
            //text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
            text(l, size = stage_size, font = font, halign = "center", valign = "center", $fn = 16);
        }
    }
}
// SPOKE HEAD
// head_diameter: Diameter of the spoke head
// diameter_spoke: Diameter of the spoke
// extra_length: Amount of extra spoke between the head and the elbow
module spoke_head(diameter_head=5, diameter_spoke=2, extra_length=2){
    head_radius=diameter_head/2;
    offset = head_radius/3;
    subrad = head_radius*(2/3);

    
    translate([0, 0, extra_length+offset+0.5])
        color("LightSlateGray") letter("W", letter_size=1.5);
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
module spoke_thread(diameter_spoke){
    metric_thread (diameter=diameter_spoke, pitch=0.45, length=10, leadin=1, test=no_threads);
}
module spoke(length, diameter){
    // calc length of curved part on end
    radius_curve = 3;
    bare_length=length-(radius_curve + 10); // remove bend and threads(10mm)
    echo("bare_length", bare_length);
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

module half_spoke(spoke_count, num_crosses, erd, pcd, dist, offset, flange_thickness=2){
    A = erd/2;
    B = pcd/2;
    spoke_spacing=(360/spoke_count); // in degrees
    theta = spoke_spacing*num_crosses;
    padded_flange_thickness=flange_thickness*1.75;

    // length
    C = sqrt( pow(A,2) + pow(B,2) - (2 * A * B * cos(theta)));
    echo("C", C);
    spoke_len = sqrt(pow(C,2) + pow(dist,2));
    echo("spoke_len", spoke_len);
    
    // angle to spoke hole (across other spokes)
    cos_cross_angle =  (pow(C,2) + pow(A,2) - pow(B,2))/(2*C*A);
    cross_angle = acos(cos_cross_angle);
    echo("cross_angle", cross_angle);
    
    // angle out to hub flange
    flare_angle_outer = offset ? -atan((dist-padded_flange_thickness)/C) : atan((dist+padded_flange_thickness)/C);
    flare_angle_center = offset ? -atan((dist)/C) : atan((dist)/C);
    flare_angle_offset = flare_angle_outer-flare_angle_center;      // difference between hittin center of flange and outside of flange
    //echo("flare_angle", flare_angle);
    
    // how far out do we move the spoke to line up with the spoke hole
    shift_amt = cos(theta) * (B)-3;
    //shift_amt = pcd/2;
    echo("theta", theta);
    echo("B", B);
    echo("shift_amt", shift_amt);

    spoke_num=0;
    for (spoke_num = [0 : 1 : spoke_count]){		// create spokes
        position_angle = offset ? (spoke_spacing * spoke_num) : ((spoke_spacing * spoke_num) + spoke_spacing/2 ); 
        //echo("spokenum", spoke_num);
        //echo ("angle", angle);
        even = ((spoke_num % 2) * 2) -1;
        //echo("even", even);
        flare_angle=flare_angle_center + (even * flare_angle_offset);
        cross_angle=cross_angle * even;
        flip_angle = (90*even)+90;                                         // flip the spoke over so head is in
        //echo("		cross_angle", cross_angle);
        rotate(a=[0, 0, position_angle])                                        // spread evenly around
            translate([shift_amt, 0, 0])                                // move out
                rotate_about_pt(a=[0, 0, cross_angle], pt=[spoke_len, 0, 0])        // cross
                    rotate_about_pt(a=[0, flare_angle, 0], pt=[spoke_len, 0, 0])    // flare out to flange
                        rotate(a=[0, 90, 0])		                            // lay down
                            rotate(a=[0,0,flip_angle])                       // heads in or heads out;
                                spoke(spoke_len, 2);		    // create
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
module spokes(spoke_count=32, num_crosses=3, erd=602, left_dist, left_pcd, right_dist, right_pcd, flange_thickness=2){
    // calc based on crosses, erd, pcd, flange offset
    left_spoke_count = spoke_count/2;
    right_spoke_count = left_spoke_count;
    
    half_spoke(spoke_count = left_spoke_count, num_crosses=num_crosses, erd=erd, pcd=left_pcd, dist=left_dist, offset=false, flange_thickness=flange_thickness);
    half_spoke(spoke_count = left_spoke_count, num_crosses=num_crosses, erd=erd, pcd=right_pcd, dist=right_dist, offset=true, flange_thickness=flange_thickness);
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

module rim2(erd, external_width, internal_width, depth, erto){
    err = erd/2;
    ertor = erto/2;
    
    rotate_extrude($fn=200)
        polygon( points=[
                                [err,0],                                            // spoke-bed center
                                [err+4, external_width/2],              // spoke-bed edge
                                [err+depth, external_width/2 ],         // rim lip
                                
                                [err+depth, internal_width/2],
                                [ertor, internal_width/2],
                                [ertor, -internal_width/2],
                                [err+depth, -internal_width/2],
                                
                                [err+depth, -external_width/2],         // lower rim lip
                                [err+4, -external_width/2]]);           // lower spoke-bed edge
}

// millimeters
// hub
old=142;
left_dist=33;
left_pcd=57;
right_dist=19;
right_pcd=57;

// rim
erd = 605+5;
external_width=26.3;
internal_width=23.0;
depth=15.8;
erto = 622;

// wheel
num_crosses=3;
spoke_count=32;



rear_hub(old=old, left_dist=left_dist, left_pcd=left_pcd, right_dist=right_dist, right_pcd=right_pcd, hole_count=spoke_count);
//rim(erd=erd, depth=45, external_width=25);
rim2(erd, external_width, internal_width, depth, erto);
spokes(spoke_count=spoke_count, num_crosses=num_crosses, erd=erd, left_dist=left_dist, left_pcd=left_pcd, right_dist=right_dist, right_pcd=right_pcd);

//spoke_elbow(extra_length=1);
//spoke_head();