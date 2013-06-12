t = 5.2; // lowes birch ply

monitor_w = to_mm(15 + 5/8);
monitor_h = to_mm(25 + 5/8);
monitor_total_d = to_mm(2 + 15/16);
monitor_square_part_d = to_mm(13/16);

monitor_vesa_mount_w = to_mm(4 + 15/16);
monitor_vesa_mount_h = to_mm(5 + 7/8);

vesa_plate_w = 120;
vesa_plate_h = 120;

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
    for (x=[-1,1], y=[-1,1]) {
      translate([x * 50, y * 50, 0]) cylinder(r=2, h=t*2, center=true, $fn=36);
    }
  }
}

module mounting_plate_2() {
  color([96/255, 96/255, 96/255])
  render()
  difference() {
    cube(size=[vesa_plate_w, vesa_plate_h, t], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * 50, y * 50, 0]) cylinder(r=4, h=t*2, center=true, $fn=36);
    }
  }
}

module vertical_arm() {
  assign(nut_t = 5)
  assign(nut_w = 7)
  assign(screw_len=15)
  assign(screw_w = 4)
  assign(tab_width = 20)
  assign(outside_gutter = 10)
  assign(display_height = monitor_h)
  assign(mounting_plate_dim = 100)
  assign(corner_rad = 30)
  assign(depth = 75)
  assign(bottom_thickness = 50)
  assign(bottom_depth = 250)
  assign(bottom_clearance = 10)
  render()
  difference() {
    union() {
      // tab into vesa plate
      translate([-3*t/2, 0, 0]) cube(size=[3*t, tab_width, t], center=true);

      // rounded top corner
      translate([depth - corner_rad, mounting_plate_dim/2 - corner_rad, 0]) 
        cylinder(r=corner_rad, h=t, center=true, $fn=72);
      translate([(depth - corner_rad)/2, mounting_plate_dim/2 - corner_rad, 0]) 
        cube(size=[(depth - corner_rad), (depth - (depth-corner_rad))*2, t], center=true);
      translate([depth/2, (mounting_plate_dim/2 - 2 * corner_rad), 0]) 
        cube(size=[depth, 2 * corner_rad, t], center=true);

      // main vertical portion
      translate([depth/2, -(display_height / 2 + bottom_thickness + bottom_clearance)/2, 0]) 
        cube(size=[depth, display_height / 2 + bottom_thickness + bottom_clearance, t], center=true);

      // curved-under portion
      translate([depth - (bottom_depth - corner_rad) / 2, -(display_height / 2 + bottom_thickness + bottom_clearance) + bottom_thickness/2, 0]) 
        cube(size=[bottom_depth - corner_rad, bottom_thickness, t], center=true);
      translate([depth - (bottom_depth - corner_rad), -(display_height / 2 + bottom_clearance + corner_rad), 0]) 
        intersection() {
          cylinder(r=corner_rad, h=t, center=true);
          translate([0, corner_rad/2, 0]) cube(size=[corner_rad*3, corner_rad, t*2], center=true);
        }
      translate([depth - bottom_depth + corner_rad/2, -(display_height/2 + bottom_clearance + bottom_thickness) + (bottom_thickness-corner_rad) / 2, 0]) 
        cube(size=[corner_rad, bottom_thickness - corner_rad, t], center=true);
    }
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
  translate([t/2, 0, 0]) rotate([90, 0, 90]) mounting_plate_1();
  translate([t + t/2, 0, 0]) rotate([90, 0, 90]) mounting_plate_1();
  translate([2*t + t/2, 0, 0]) rotate([90, 0, 90]) mounting_plate_2();

  translate([3*t, 0, 0]) rotate([90, 0, 0]) vertical_arm();
}

module foot() {
  assign(d = monitor_total_d)
  assign(w = monitor_w)
  assign(h = sqrt(d*d + w/2*w/2))
  assign(beta = asin(w/2/h))
  assign(theta = 10)
  assign(omega = 90 - beta - theta)
  assign(tolerance = 0.5)
  assign(x = h * cos(omega) + tolerance)
  assign(s = 50)
  assign(l = x)
  assign(r = (s*s + l * l) / 2 / s)
  cylinder(r=r, h=t, center=true);
}

assign(d = to_mm(2 + 15/16))
assign(w = monitor_w)
assign(h = sqrt(d*d + w/2*w/2))
assign(beta = asin(w/2/h))
assign(theta = 10)
assign(omega = 90 - beta - theta)
assign(tolerance = 0.5)
assign(x = h * cos(omega) + tolerance)
for (i=[-1,1]) {
  translate([0, i*x, 0]) rotate([0, 0, i * theta]) {
    arm_assembly();
    display_blank();
  }
}

translate([0, 0, -450]) foot();

