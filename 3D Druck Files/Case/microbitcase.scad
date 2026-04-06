use <MCAD/boxes.scad>

pins_accessable = 1; // [0:false, 1:true]

logo_accessable = 1; // [0:false, 1:true]

part = 0; // [0:lid + case, 1:lid, 2:case, 3:(just for view) case + battery box, 4:(just for view) case + battery box + microbit, 5:(just for view) all]

/* [Hidden] */

$fa=0.01;
$fs=($preview || part>2) ? 0.5 : 0.25;

module rounded_plate(dimensions,cornerradius) {
  translate(dimensions/2) roundedBox(dimensions, cornerradius, true);
}

// vertically extruded right-angled triangle with sides on x axis and y axis
module wedge(dimensions) {
  x=dimensions[0];y=dimensions[1];z=dimensions[2];
  linear_extrude(height=z) polygon(points=[[0,0], [0,y],[x,0]]);
}

mb_width = 52;
mb_heigth = 42;
mb_thickness = 1.6;

module microbit() {

  module button() union() { color("grey") cube([6,6,4]); color("black") translate([3,3,2.5]) cylinder(h=2,d=4);}

  module logo() {
    offset = 2;
    c1 = [-offset,0,0];
    c2 = [+offset,0,0];
    difference() {
      hull() {
        translate(c1) cylinder(d=5, h=1);
        translate(c2) cylinder(d=5, h=1);
      }
      translate([0,0,-0.5]) hull() {
        translate(c1) cylinder(d=3, h=2);
        translate(c2) cylinder(d=3, h=2);
      }
    }
    translate(c1) cylinder(d=1, h=1);
    translate(c2) cylinder(d=1, h=1);
  }

  union() {
    difference() {
      color("darkgreen") rounded_plate([mb_width,mb_heigth,mb_thickness], 3);
      // Holes
      for(x = [0:4]) {
        translate([4+x*11,7,-0.2]) cylinder(h=2, r=2);
      }
    }
    // Leds
    for(x = [0:4]) for(y = [0:4]) {
      translate([17+x*4.25,11+y*4,1]) cube([1,2,1]);
    }
    // Buttons A and B
    translate([3,18,1.1]) button();
    translate([52-6-3,18,1.1]) button();
    // Reset button
    translate([13,35.9,0.5]) mirror([0,0,1]) button();
    // Power connector with connector and 'cable'
    translate([3,35.9,-6]) union() {
      color("white") cube([8, 6, 6.5]);
      color("lightgrey") translate([1,2,1]) cube([6,6,4.5]);
      color("red") translate([2,8,1]) rotate([0,90,0]) cylinder(h=1.5, r=2);
      color("black") translate([4.5,8,1]) rotate([0,90,0]) cylinder(h=1.5, r=2);
    }
    // USB connector
    translate([22,38,-3]) color("grey") cube([8,5,3]);

    // Power led
    translate([mb_width-19,mb_heigth-3,-0.4]) cube([1,2,1]);

    translate([mb_width/2,mb_heigth-8,mb_thickness - 0.9]) logo();
  }
}

module batterybox() {
  color("darkgrey") rotate([90,0,90]) rounded_plate([26, 16, 53], 2);
}

width=62;
bottom_height=32;
top_height=48;
height=28;
top_offset=-(top_height-bottom_height)/2;
extra_height=0.6;
tolerance=0.1;
angle=atan2((top_height-bottom_height)/2, height-2);
mb_x = (width-mb_width)/2;


module case() {
  rounding=4;
  module outer() {
      module cylinders(dimensions, r) {
        x=dimensions[0]; y=dimensions[1]; z=dimensions[2];
        translate([r,r,0]) cylinder(h=z, r=r);
        translate([x-r,r,0]) cylinder(h=z, r=r);
        translate([r,y-r,0]) cylinder(h=z, r=r);
        translate([x-r,y-r,0]) cylinder(h=z, r=r);
      }
      hull() {
        cylinders([width, bottom_height, 2], 4);
        translate([0, top_offset, height-2]) cylinders([width, top_height, 2 + extra_height], 4);
      }
  }
  module inner() {
    mirror([1,0,0]) translate([-2,2,2]) rotate([0,-90,0]) {
      yoff=4;
      h0 = height-4.99;
      h1 = h0 * 4/7; // or some complex formula taking the actual angle into account
      linear_extrude(height=width-4) {
        polygon(points=[
          [0,0], [h1, -yoff], [h0,-yoff],
          [h0,bottom_height-4+yoff],[h1, bottom_height-4+yoff], [0,bottom_height-4]]);
      }
    }
  }
  module main() {
    difference() {
      outer();
      inner();
    }
  }

  module battery_holder() {
    module holder_side(h) {
      translate([mb_x+10.5,-8,1.5]) {
        difference() {
          union() {
            cube([26, 10, h]);
            translate([13,8.5,15.5]) sphere(r=2.5);
          }
          translate([1.5,-1.5,-0.5]) cube([23, 10, h+1]);
          rotate([angle,0,0]) translate([-1,-2.5,-5]) cube([28,10,h+6]);
        }
      }
    }

    holder_side(19);
    translate([0,30.5,0]) mirror([0,1,0]) difference() {
      holder_side(22);
      translate([7.01,-7,17]) cube([10,10,10]); // for power connector
    }
  }

  module reset_cutout() { // FIXME Hier zit het nog niet helemaal goed?
    translate([mb_x+2, 30, 12]) {
       translate([0.5, 2, 15.5]) translate([0,0,7.5]) rotate([-90,0,0]) rounded_plate([12, 18, 10],1); // for power connector
       translate([10, 0, -15]) cube([23,20,40],1);
    }
  }

  module base() { // support for the microbit
    module side_base() {
      rotate([-90, 0, 0]) wedge([5,12.5,top_height-12]);
      translate([0,-3,-0.2]) cube([4,top_height-12+3,3.5]);
    }
    translate([0, top_offset, 24.99]) {
      translate([1,6,0]) side_base();
      translate([width-1,6,0]) mirror([1,0,0]) side_base();
    }
  }

  module pinaccess() {
      for(x = [0:4]) {
        translate([mb_x+1+x*11,top_offset-1,height-6]) 
          translate([0,0,10]) rotate([-90,0,0]) rounded_plate([6,10,10],1);
      }
  }

  module lidmount() {
    module inlet() {
      // front
      translate([5, top_offset + 30, height-6]) rotate([0,-90,0]) wedge([10,5,3]);
      // translate([4, top_offset + 30.01, height+4]) rotate([180,90,0]) wedge([10,5,3]);
      translate([2, top_offset + 28.01, height-6]) cube([3,2,5]);
      // back
      translate([2, top_offset + 12, height-6]) cube([3,5,10]);
      // hole for the knob
      translate([2+1-0.9,top_offset + 15,height-2-1.1]) sphere(r=0.9);
    }
    inlet();
    translate([width, 0, 0]) mirror([1,0,0]) inlet();
  }

  difference() {
    union() {
      difference() {
        union() {
          main();
          base();
        }
        reset_cutout();
        translate([(width-54)/2, 2.5, height-8]) cube([54, 26, 16], 1); // room to insert battery

        translate([mb_x-tolerance,-5-tolerance,25]) cube([mb_width+tolerance*2, mb_heigth+tolerance*2, 5]); // microbit board inlet
        translate([-1, -5.01, 26.6]) cube([width+2, 47, 5]); // lid inlet
        lidmount();
      }
      battery_holder();
    }
    if (pins_accessable) pinaccess();
  }
}

module lid() {
  module hooks() {
    module angles() {
      module side() translate([-0.7,0,0]) rotate([0,-35,0]) cube([2,10,5]);
      side();
      mirror([1,0,0]) side();
    }
    difference() {
      union() {
        // front
        translate([5-tolerance, 30-tolerance, -4-extra_height]) rotate([0,-90,0]) wedge([10,5,3-tolerance*2]);
        translate([5-tolerance, 30.75, 6-extra_height]) rotate([180,90,0]) wedge([10,5,3-tolerance*2]);
        // back
        difference() {
          translate([2+tolerance, 12.5+tolerance, -4-extra_height]) cube([2.5-tolerance*3,4.5-tolerance*2,10]);
          translate([5, 10, -5-extra_height]) rotate([0,-90,0]) wedge([10,5,4]);
        }
        translate([2+1+tolerance-0.9,15,-1.1-extra_height]) difference() {sphere(r=0.9);translate([0,-3,-3]) cube([2,6,6]);}
        // color("green") translate([2+1+tolerance -1.5  +0.5+2.5-tolerance*3  ,14,-1.1-extra_height]) cube([0.6,4,3]); // ff afstand controleren
      }
      translate([1,0,1]) cube([10, top_height, 8]);
      translate([1,0,-11.5]) cube([10, top_height, 8]);
      translate([3.25-tolerance/2,12,-7]) angles();
      translate([3.5,28,-7]) angles();
    }
  }

  // gap to access the touch-sensitive logo (V2)
  module logo_gap() {
    union() {
      c1=[width/2-2,37,-1];
      c2=[width/2+2,37,-1];
      hull() {
        translate(c1) cylinder(d=9, h=4);
        translate(c2) cylinder(d=9, h=4);
      }
      translate([0,0,1.5]) hull() {
        translate(c1) cylinder(d1=8.9,d2=12, h=2);
        translate(c2) cylinder(d1=8.9,d2=12, h=2);
      }
    }
  }

  color("red") {
    hooks();
    translate([width, 0, 0]) mirror([1,0,0]) hooks();
    difference() {
      rounded_plate([width, top_height, 2], 4);
      translate([-1,-1,-1]) cube([width+2, 4, 4]);
      translate([5.8,-3,-1]) rounded_plate([width-11.4, 40, 4],2);

      rotate([15,0,0]) translate([0,0.1,-1]) cube([width+2, 3,5]); // make lid placing a bit easier

      if (logo_accessable) logo_gap();
    }

  }
}

// microbit();
// lid();

if (part==0 || part==1) translate([width,42,2]) rotate([0,180,0]) lid();
difference() {
  union() {
    if (part != 1) case();
    if (part >= 3) translate([mb_x,2.25,2]) batterybox();
    if (part >= 4) translate([mb_x,-5,25]) microbit();
    if (part >= 5) translate([0,top_offset+0.01,height-2 + extra_height + 0.01  ]) lid();
  }
  // translate([-80,-15,-5]) color("red") cube([100, 60, 50]);
  // translate([0,top_offset+15-50,-1]) cube([80,50,50]);
  // translate([-10,-10,20]) cube([100,50,50]);
}

// rotate([-90,0,-90]) wedge([10,20,10]);

// rotate([0,90,0]) wedge([20,10,10]);
