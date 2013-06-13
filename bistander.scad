t = 5.2; // lowes birch ply

monitor_w = to_mm(15 + 5/8);
monitor_h = to_mm(25 + 5/8);
monitor_total_d = to_mm(2 + 15/16);
monitor_square_part_d = to_mm(13/16);

monitor_vesa_mount_w = to_mm(4 + 15/16);
monitor_vesa_mount_h = to_mm(5 + 7/8);

vesa_plate_w = 120;
vesa_plate_h = 120;

mounting_plate_dim = 100;

nut_t = 5;
nut_w = 7;
screw_len = 15;
screw_w = 4;
tab_width = 20;
corner_rad = 30;
arm_depth = 75;
arm_bottom_thickness = 50;
arm_bottom_depth = 250;
arm_bottom_clearance = 10;


function to_mm(in) = in * 25.4;

module display_blank() {
  color([240/255, 240/255, 240/255, 0.5]) union() {
    translate([(monitor_total_d - monitor_square_part_d)/-2, 0, 0]) cube(size=[monitor_total_d - monitor_square_part_d, monitor_vesa_mount_w, monitor_vesa_mount_h], center=true);
    translate([-monitor_total_d + monitor_square_part_d/ 2, 0, 0]) cube(size=[monitor_square_part_d, monitor_w, monitor_h], center=true);
  }
}

module mounting_plate_1() {
  color([64/255, 64/255, 64/255])
  render()
  difference() {
    cube(size=[vesa_plate_w, vesa_plate_h, t], center=true);
    cube(size=[2*t, tab_width, t*2], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * 50, y * 50, 0]) cylinder(r=2, h=t*2, center=true, $fn=36);
      translate([0, y * mounting_plate_dim / 3, 0]) cylinder(r=screw_w, h=t*2, center=true, $fn=36);
      translate([x * mounting_plate_dim / 3, 0, 0]) cylinder(r=screw_w, h=t*2, center=true, $fn=36);
    }
  }
}

module mounting_plate_3() {
  color([96/255, 96/255, 96/255])
  render()
  difference() {
    cube(size=[vesa_plate_w, vesa_plate_h, t], center=true);
    cube(size=[2*t, tab_width, t*2], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * 50, y * 50, 0]) cylinder(r=2, h=t*2, center=true, $fn=36);
      translate([0, y * mounting_plate_dim / 3, 0]) cylinder(r=screw_w/2, h=t*2, center=true, $fn=36);
      translate([x * mounting_plate_dim / 3, 0, 0]) cylinder(r=screw_w/2, h=t*2, center=true, $fn=36);
    }
  }
}


module mounting_plate_2() {
  color([96/255, 96/255, 96/255])
  render()
  difference() {
    cube(size=[vesa_plate_w, vesa_plate_h, t], center=true);
    cube(size=[2*t, tab_width, t*2], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * 50, y * 50, 0]) cylinder(r=4, h=t*2, center=true, $fn=36);
      translate([0, y * mounting_plate_dim / 3, 0]) cylinder(r=screw_w/2, h=t*2, center=true, $fn=36);
      translate([x * mounting_plate_dim / 3, 0, 0]) cylinder(r=screw_w/2, h=t*2, center=true, $fn=36);
    }
  }
}

module vertical_arm() {
  assign(outside_gutter = 10)
  assign(display_height = monitor_h)

  render()
  difference() {
    union() {
      // tab into vesa plate
      translate([-3*t/2, 0, 0]) cube(size=[3*t, tab_width, t], center=true);

      // rounded top corner
      translate([arm_depth - corner_rad, mounting_plate_dim/2 - corner_rad, 0]) 
        cylinder(r=corner_rad, h=t, center=true, $fn=72);
      translate([(arm_depth - corner_rad)/2, mounting_plate_dim/2 - corner_rad, 0]) 
        cube(size=[(arm_depth - corner_rad), (arm_depth - (arm_depth-corner_rad))*2, t], center=true);
      translate([arm_depth/2, (mounting_plate_dim/2 - 2 * corner_rad), 0]) 
        cube(size=[arm_depth, 2 * corner_rad, t], center=true);

      // main vertical portion
      translate([arm_depth/2, -(display_height / 2 + arm_bottom_thickness + arm_bottom_clearance)/2, 0]) 
        cube(size=[arm_depth, display_height / 2 + arm_bottom_thickness + arm_bottom_clearance, t], center=true);

      // curved-under portion
      translate([arm_depth - (arm_bottom_depth - corner_rad) / 2, -(display_height / 2 + arm_bottom_thickness + arm_bottom_clearance) + arm_bottom_thickness/2, 0]) 
        cube(size=[arm_bottom_depth - corner_rad, arm_bottom_thickness, t], center=true);
      translate([arm_depth - (arm_bottom_depth - corner_rad), -(display_height / 2 + arm_bottom_clearance + corner_rad), 0]) 
        intersection() {
          cylinder(r=corner_rad, h=t, center=true);
          translate([0, corner_rad/2, 0]) cube(size=[corner_rad*3, corner_rad, t*2], center=true);
        }
      translate([arm_depth - arm_bottom_depth + corner_rad/2, -(display_height/2 + arm_bottom_clearance + arm_bottom_thickness) + (arm_bottom_thickness-corner_rad) / 2, 0]) 
        cube(size=[corner_rad, arm_bottom_thickness - corner_rad, t], center=true);
    }
    
    translate([arm_depth, 0, 0]) cube(size=[arm_depth, t*2, t*2], center=true);
    
    // screw slots
    for (i=[-1,1]) {
      translate([0, i * mounting_plate_dim/3, 0]) {
        cube(size=[screw_len*2, screw_w, t*2], center=true);
        translate([screw_len/2, 0, 0]) cube(size=[nut_t, nut_w, t*2], center=true);
      }
    }
  }
}

module arm_assembly() {
  group() {
    translate([t/2, 0, 0]) rotate([90, 0, 90]) mounting_plate_1();
    translate([t + t/2, 0, 0]) rotate([90, 0, 90]) mounting_plate_3();
    translate([2*t + t/2, 0, 0]) rotate([90, 0, 90]) mounting_plate_2();

    translate([3*t, t/2, 0]) rotate([90, 0, 0]) vertical_arm();
    translate([3*t, -t/2, 0]) rotate([90, 0, 0]) vertical_arm();
  }
}

module foot() {
  color([240/255, 240/255, 128/255])
  // render()
  assign(d = monitor_total_d)
  assign(w = monitor_w)
  assign(h = sqrt(d*d + w/2*w/2))
  assign(beta = asin(w/2/h))
  assign(theta = 10)
  assign(omega = 90 - beta - theta)
  assign(tolerance = 0.5)
  assign(x = h * cos(omega) + tolerance)
  assign(a = 3*t + arm_depth)
  assign(y = a * sin(theta))
  assign(z = (y + x) / cos(theta))
  assign(f = arm_bottom_depth - arm_depth - 3*t - monitor_total_d)
  assign(p = x - (monitor_total_d + f) * sin(theta))
  assign(q = p / cos(theta))
  // assign(s = 30)
  assign(arm_d = (3 * t + 75))
  assign(o = (arm_d * sin(theta)))
  assign(l = 2 * (x + o))
  // assign(r = (s*s + l * l) / 2 / s + 1)
  // translate([-r + t + arm_d, 0, 0]) 
  // difference() {
  //   cylinder(r=r, h=t, center=true, $fn=360);
  //   cylinder(r=r-arm_bottom_depth, h=t*2, center=true, $fn=360);
  // }
  difference() {
    union() {
      for (i=[-1,1]) translate([0, i * x, 0]) rotate([0, 0, i * theta]) group(){
        translate([arm_depth + 3*t - arm_bottom_depth/2, 0, 0]) {
          translate([arm_bottom_depth/2 - corner_rad, 0, 0]) cylinder(r=corner_rad, h=t, center=true);
          translate([-(arm_bottom_depth/2 - corner_rad), 0, 0]) cylinder(r=corner_rad, h=t, center=true);
        
          translate([0, i*corner_rad/2, 0]) cube(size=[arm_bottom_depth - corner_rad*2, corner_rad, t], center=true);
        
          linear_extrude(height=t, center=true) {
            polygon(points=[
              [arm_bottom_depth/2, 0],
              [arm_bottom_depth/2, -i * z],
              [-arm_bottom_depth/2, -i * q],
              [-arm_bottom_depth/2, 0]
              ]);
          }
        }
         // cube(size=[arm_bottom_depth, 100, t], center=true);
      }
    }
    translate([75, 0, 0])  {
      for (y=[-1:1]) {
        translate([0, y * (x*2)/3, 0]) {
          cylinder(r=screw_w/2, h=t*2, center=true, $fn=36);
          for (y2=[-1,1]) {
            translate([0, y2 * tab_width*3/2, 0]) cube(size=[t, tab_width, t*2], center=true);
          }
        }
      }
    }
  }
}

module top_rib() {
  color([128/255, 240/255, 128/255])
  render()
  assign(d = monitor_total_d)
  assign(w = monitor_w)
  assign(h = sqrt(d*d + w/2*w/2))
  assign(beta = asin(w/2/h))
  assign(theta = 10)
  assign(omega = 90 - beta - theta)
  assign(tolerance = 0.5)
  assign(x = h * cos(omega) + tolerance)
  assign(a = 3*t + arm_depth)
  assign(y = a * sin(theta))
  assign(z = (y + x) / cos(theta))
  assign(f = 3*t)
  assign(p = f * sin(theta))
  assign(q = (p + x) / cos(theta))
  difference() {
    union() {
      for (i=[-1,1]) translate([0, i * x, 0]) rotate([0, 0, i * theta]) difference() {
        union() {
          translate([arm_depth + 3*t - arm_bottom_depth/2, 0, 0]) group() {
            translate([arm_bottom_depth/2 - corner_rad, i*(50 - corner_rad), 0]) cylinder(r=corner_rad, h=t, center=true);

            translate([arm_bottom_depth/2 - corner_rad - (arm_depth - corner_rad)/2, 0, 0]) cube(size=[arm_depth - corner_rad, 100, t], center=true);

            linear_extrude(height=t, center=true) {
              polygon(points=[
                [arm_bottom_depth/2, i*(50 - corner_rad)],
                [arm_bottom_depth/2, -i * z],
                [arm_bottom_depth/2 - arm_depth, -i * q],
                [arm_bottom_depth/2 - arm_depth, 0]
                ]);
            }
          }
        }
        translate([arm_depth + 3*t - arm_depth, 0, 0]) cube(size=[arm_depth, t*2, t*2], center=true);
        
        for (y=[-1,1]) {
          translate([arm_depth + 3*t - arm_depth, y*(mounting_plate_dim/3), 0]) {
            cube(size=[screw_len*2, screw_w, t*2], center=true);
            translate([screw_len/2, 0, 0]) cube(size=[nut_t, nut_w, t*2], center=true);
          }
        }
        
      }
    }
    translate([75, 0, 0])  {
      for (y=[-1:1]) {
        translate([0, y * (x*2)/3, 0]) {
          cylinder(r=screw_w/2, h=t*2, center=true, $fn=36);
          for (y2=[-1,1]) {
            translate([0, y2 * tab_width*3/2, 0]) cube(size=[t, tab_width, t*2], center=true);
          }
        }
      }
    }
  }
}


module cross_support() {
  render()
  assign(strut_width = 30)
  assign(support_h = monitor_h/2 + arm_bottom_clearance + arm_bottom_thickness - t)
  assign(cutout_h = support_h / 2 - strut_width - strut_width/2)
  assign(d = monitor_total_d)
  assign(w = monitor_w)
  assign(h = sqrt(d*d + w/2*w/2))
  assign(beta = asin(w/2/h))
  assign(theta = 10)
  assign(omega = 90 - beta - theta)
  assign(tolerance = 0.5)
  assign(dx = h * cos(omega) + tolerance)
  assign(corner_rad = 10)
  difference() {
    union() {
      cube(size=[dx*2, support_h, t], center=true);
      for (y=[-1,1]) translate([0, y * support_h/2, 0]) {
        for (x=[-1:1]) {
          translate([x * (dx*2)/3, 0, 0]) {
            for (x1=[-1,1]) {
              translate([x1 * tab_width * 3 / 2, 0, 0]) cube(size=[tab_width, t*4, t], center=true);
            }
          }
        }
      }
    }

    for (y=[-1,1]) translate([0, y * support_h/2, 0]) {
      for (x=[-1:1]) {
        translate([x * (dx*2)/3, 0, 0]) {
          cube(size=[screw_w, (screw_len - t)*2, t*2], center=true);
          translate([0, -screw_len/2, 0]) cube(size=[nut_w, nut_t, t*2], center=true);
        }
      }
    }

    for (a=[0:3]) {
      rotate([0, 0, 90 * a]) {
        translate([0, - strut_width/2 * sqrt(2), 0]) {
          translate([0, -2*corner_rad/sqrt(2), 0]) cylinder(r=corner_rad, h=t*2, center=true);

          linear_extrude(height=t*2, center=true) {
            polygon(points=[
              [corner_rad/sqrt(2), -corner_rad / sqrt(2)],
              [cutout_h - corner_rad - corner_rad*sqrt(2) + corner_rad/sqrt(2), -(cutout_h - corner_rad - corner_rad/sqrt(2))],
              [cutout_h - corner_rad - corner_rad*sqrt(2), -(cutout_h)],
              
              [-(cutout_h - corner_rad - corner_rad*sqrt(2)), -(cutout_h)],
              [-(cutout_h - corner_rad - corner_rad*sqrt(2) + corner_rad/sqrt(2)), -(cutout_h - corner_rad - corner_rad/sqrt(2))],
              [-corner_rad/sqrt(2), -corner_rad / sqrt(2)],
              ]);
          }

          for (x=[-1,1]) {
            translate([x * (cutout_h - corner_rad - corner_rad * sqrt(2)), -cutout_h + corner_rad, 0]) cylinder(r=corner_rad, h=t*2, center=true);
          }
        }
      }
    }
  }
}

translate([0, 0, -monitor_h/2 - arm_bottom_clearance - arm_bottom_thickness - t/2]) foot();
translate([0, 0, -monitor_h/2 - arm_bottom_clearance - arm_bottom_thickness - t - t/2]) foot();
translate([0, 0, t/2]) top_rib();
translate([0, 0, -t/2]) top_rib();

translate([75, 0, -(monitor_h/2 + arm_bottom_clearance + arm_bottom_thickness + t)/2]) rotate([90, 0, 90]) cross_support();


assign(d = to_mm(2 + 15/16))
assign(w = monitor_w)
assign(h = sqrt(d*d + w/2*w/2))
assign(beta = asin(w/2/h))
assign(theta = 10)
assign(omega = 90 - beta - theta)
assign(tolerance = 0.5)
assign(x = h * cos(omega) + tolerance)
for (i=[-1,1]) {
  translate([0, i*x, 0]) rotate([0, 0, i * theta]) group() {
    arm_assembly();
    display_blank();
  }
}



