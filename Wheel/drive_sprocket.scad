use <Wheel.scad>
use <thread.scad>

/*
P = 1/2 * inch # pitch
Dr = 5/16 * inch # max roller diameter
N = 9 # number of teeth
*/
inch = 25.4;
//Dr = .312 * inch; // roller diameter
Dr = .35 * inch; // roller diameter
P = 0.5 * inch;   // chain pitch

N = 11;            // number of cogs
T = 2;            // thickness of cog // sram 11 speed

module triangle(r, t, theta){
  linear_extrude(height=t)polygon([[0, 0],
				   r * [cos(theta/2), -sin(theta/2)],
				   r * [cos(theta/2),  sin(theta/2)]]);
}

module tooth(N, P, Dr, T){
  theta = 360 / N; // DEG
  Rp = P / (2 *sin(theta/2)); // Pitch radius (using regular n-gon geometry)
  v = P;                   // velocity of chain (mm/sec)
  w = 360/N; // degrees per second
  Rcog = Rp + Dr/3;
    intersection(){
      translate([0, 0, -T/2])triangle(2 * Rp, T, theta);
      translate([0, 0, -T/2])
    difference(){
	cylinder(r=Rcog, h=T);
      for(t=[-1.125:0.125:1.125]){
	rotate([0, 0, w * t])
	  for(i=[-0:0]){
	    translate([Rp, i * P - t * v, -1])
	      cylinder(d=Dr, h=T+2, $fn=30);
	  }
      }
    }
  }
}

module cog(N, P, Dr, T, taper=.25){
  Ttaper = T * taper;
  middle_width = T * (1 - 2 * taper);

  theta = 360 / N; // DEG
  Rp = P / (2 *sin(theta/2)); // Pitch radius (using regular n-gon geometry)
  Rcog = Rp + Dr/3;
  intersection(){
    union(){
      for(i=[1:N]){
	rotate([0, 0, i * theta])tooth(N, P, Dr, T);
      }
    }
    union(){
      translate([0, 0, middle_width/2])cylinder(r2=Rp, r1=Rcog, h=Ttaper);
      translate([0, 0, -middle_width/2])cylinder(r=Rcog, h=middle_width);
      translate([0, 0, -Ttaper-middle_width/2])cylinder(r1=Rp, r2=Rcog, h=Ttaper);
    }
  }
    
}
module dShaft(D, d, h){
  difference(){
    cylinder(d=D, h=h, $fn=50);
    translate([d/2, -(h+2)/2, -1])cube(h+2);
  }
}


dtheta = 3;
dz = 3.5;

stack = [11, 12, 13, 14, 15, 17, 19, 21, 24, 27, 30];
//projection(){

//for(i=[0:2]){
i = N;
//    N = stack[i];
    difference(){
    rotate([0, 0, i * dtheta])translate([0, 0, 0])cog(N, P, Dr, 3*T/4, taper=.25);
    //translate([0, 0, -10])dShaft(10.5, 9.5, 20);
    /*
    if(N == 11){
      translate([0, 0,-T/2-1])metric_thread(diameter=32, pitch=1, length=T+2, leadin=1);
    }
    else{
      translate([0, 0, -T])freehub();
    }
    */
  }
//}




