use<Wheel.scad>
pitch = 3.5;

stack = [11, 12, 13, 14, 15, 17, 19, 21, 23, 27, 30];
n_cog = 11;

module cassette(){
  difference(){
    union(){
      for(i=[0:10]){
	s = str("cogs/cog_",stack[i], ".stl");
      //translate([0,0,10 * pitch])import("cogs/cog_11.stl");
	translate([0,0,(10 - i) * pitch ])import(s);
      }
    }
    translate([0, 0, -1])scale([1, 1, 100])freehub();
  }
}

v = .4;
color([v, v, v])translate([0, 0, -30])rotate([180, 0, 0])cassette();
wheel();
