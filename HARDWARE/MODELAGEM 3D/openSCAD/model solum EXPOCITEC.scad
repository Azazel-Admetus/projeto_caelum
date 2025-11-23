// =========================
// Projeto Caelum - Montagem modular com encaixes
// Versão revisada: paredes agora têm TABS SUPERIORES
// =========================

// -------------------- CONFIG --------------------
wall = 2.5;
clearance = 0.4;
snap_gap = 0.2;

// Dimensões do corpo
body_x = 80;
body_y = 100;
body_z = 50;

// Cabeça
head_x = 50;
head_y = 40;
head_z = 40;

// Encaixes
tab_w = 12;
tab_h = 5;
tab_d = 3;

// Pinos da cabeça
peg_d = 6;
peg_h = 8;

// modos
view_mode =0;
// -------------------- HELPERS --------------------
function slot_len_for_wall_x() = body_x - 2*wall;
function slot_len_for_wall_y() = body_y - 2*wall;

// -------------------- BASE --------------------
module base_plate() {

    base_thickness = 4;
    pocket_depth = tab_h + 0.5;

    difference() {
        cube([body_x, body_y, base_thickness]);

        // front slot
        translate([wall + (slot_len_for_wall_x() - tab_w)/2, -0.01, 0])
            cube([tab_w + clearance, tab_d + 0.5, pocket_depth + 0.1]);

        // back slot
        translate([wall + (slot_len_for_wall_x() - tab_w)/2, body_y - (tab_d + 0.5) + 0.01, 0])
            cube([tab_w + clearance, tab_d + 0.5, pocket_depth + 0.1]);

        // left slot
        translate([-0.01, wall + (slot_len_for_wall_y() - tab_w)/2, 0])
            cube([tab_d + 0.5, tab_w + clearance, pocket_depth + 0.1]);

        // right slot
        translate([body_x - (tab_d + 0.5) + 0.01, wall + (slot_len_for_wall_y() - tab_w)/2, 0])
            cube([tab_d + 0.5, tab_w + clearance, pocket_depth + 0.1]);
    }
}

// -------------------- WALL FRONT/BACK --------------------
module wall_front_back() {

    height = body_z;
    width = body_x;
    thickness = wall;

    difference() {
        union() {
            // Corpo
            translate([0,0,tab_h])
                cube([width, thickness, height - tab_h]);

            // TAB inferior
            translate([(width - tab_w)/2, -tab_d, 0])
                cube([tab_w, tab_d, tab_h]);

            // TAB superior  (NOVO)
            translate([(width - tab_w)/2, -tab_d, height - tab_h])
                cube([tab_w, tab_d, tab_h]);
        }
    }
}

// -------------------- WALL LEFT/RIGHT --------------------
module wall_left_right() {

    height = body_z;
    width = body_y;
    thickness = wall;

    difference() {
        union() {
            translate([0,0,tab_h])
                cube([width, thickness, height - tab_h]);

            // TAB inferior
            translate([(width - tab_w)/2, -tab_d, 0])
                cube([tab_w, tab_d, tab_h]);

            // TAB superior (NOVO)
            translate([(width - tab_w)/2, -tab_d, height - tab_h])
                cube([tab_w, tab_d, tab_h]);
        }
    }
}

// -------------------- TOP PLATE --------------------
module top_plate() {

    top_thickness = 4;
    r_slot_len = tab_w + clearance + snap_gap;
    r_slot_depth = tab_d + 0.5;

    head_origin_x = (body_x - head_x) / 2;
    head_origin_y = (body_y - head_y) / 2;

    difference() {
        cube([body_x, body_y, top_thickness]);

        // front slot
        translate([wall + (slot_len_for_wall_x() - tab_w)/2 - snap_gap/2, 0, -0.01])
            cube([r_slot_len, r_slot_depth, top_thickness + 0.02]);

        // back slot
        translate([wall + (slot_len_for_wall_x() - tab_w)/2 - snap_gap/2,
                   body_y - r_slot_depth + 0.01, -0.01])
            cube([r_slot_len, r_slot_depth, top_thickness + 0.02]);

        // left slot
        translate([0,
                   wall + (slot_len_for_wall_y() - tab_w)/2 - snap_gap/2, -0.01])
            cube([r_slot_depth, r_slot_len, top_thickness + 0.02]);

        // right slot
        translate([body_x - r_slot_depth + 0.01,
                   wall + (slot_len_for_wall_y() - tab_w)/2 - snap_gap/2, -0.01])
            cube([r_slot_depth, r_slot_len, top_thickness + 0.02]);

        // ----------------------
        // FUROS PARA A CABEÇA
        // ----------------------

        hole_d = peg_d + clearance;
        hole_depth = peg_h + 1;
        inset = 6;

        hx1 = head_origin_x + inset + peg_d/2;
        hy1 = head_origin_y + inset + peg_d/2;

        hx2 = head_origin_x + head_x - inset - peg_d/2;
        hy2 = head_origin_y + inset + peg_d/2;

        hx3 = head_origin_x + inset + peg_d/2;
        hy3 = head_origin_y + head_y - inset - peg_d/2;

        hx4 = head_origin_x + head_x - inset - peg_d/2;
        hy4 = head_origin_y + head_y - inset - peg_d/2;

        translate([hx1, hy1, -0.01]) cylinder(h=hole_depth, r=hole_d/2, $fn=32);
        translate([hx2, hy2, -0.01]) cylinder(h=hole_depth, r=hole_d/2, $fn=32);
        translate([hx3, hy3, -0.01]) cylinder(h=hole_depth, r=hole_d/2, $fn=32);
        translate([hx4, hy4, -0.01]) cylinder(h=hole_depth, r=hole_d/2, $fn=32);
    }
}

// -------------------- HEAD --------------------
module head_unit() {

    head_wall = 2.5;

    difference() {
        cube([head_x, head_y, head_z]);

        translate([head_wall, head_wall, head_wall])
            cube([head_x - 2*head_wall, head_y - 2*head_wall, head_z - 2*head_wall]);

        eye_r = 6;

        // Olho esquerdo
        translate([head_x*0.25, head_wall/2, head_z*0.6])
            rotate([90,0,0]) cylinder(h=head_y+3, r=eye_r, $fn=48);

        // Olho direito
        translate([head_x*0.75, head_wall/2, head_z*0.6])

            rotate([90,0,0]) cylinder(h=head_y+3, r=eye_r, $fn=48);
    }

    inset = 6;

    translate([inset + peg_d/2, inset + peg_d/2, -peg_h])
        cylinder(h=peg_h, r=peg_d/2, $fn=32);

    translate([head_x - inset - peg_d/2, inset + peg_d/2, -peg_h])
        cylinder(h=peg_h, r=peg_d/2, $fn=32);

    translate([inset + peg_d/2, head_y - inset - peg_d/2, -peg_h])
        cylinder(h=peg_h, r=peg_d/2, $fn=32);

    translate([head_x - inset - peg_d/2, head_y - inset - peg_d/2, -peg_h])
        cylinder(h=peg_h, r=peg_d/2, $fn=32);
}

// -------------------- ASSEMBLY --------------------
module assembly() {
    base_plate();

    translate([0,-wall,4]) wall_front_back();
    translate([0,body_y-wall+wall,4]) wall_front_back();

    translate([-wall,0,4]) rotate([0,0,90]) wall_left_right();
    translate([body_x-wall+wall,0,4]) rotate([0,0,90]) wall_left_right();

    top_z = 4 + body_z;

    translate([0,0,top_z]) top_plate();

    translate([(body_x-head_x)/2, (body_y-head_y)/2, top_z]) head_unit();
}

// -------------------- EXPLODED --------------------
module exploded() {
    gap = 10;

    translate([0,0,0]) base_plate();
    translate([0, body_y + gap, 0]) wall_front_back();
    translate([body_x + gap, body_y + gap, 0]) wall_front_back();

    translate([body_x + gap, 0, 0]) rotate([0,0,90]) wall_left_right();
    translate([body_x + gap, -body_y - gap, 0]) rotate([0,0,90]) wall_left_right();

    translate([0, 2*(body_y + gap), 0]) top_plate();
    translate([0, 2*(body_y + gap) + 10, 0]) head_unit();
}

// -------------------- VIEW MODES --------------------
if (view_mode == 0) assembly();
if (view_mode == 1) base_plate();
if (view_mode == 2) wall_front_back();
if (view_mode == 3) rotate([0,0,90]) wall_left_right();
if (view_mode == 4) top_plate();
if (view_mode == 5) head_unit();
if (view_mode == 6) exploded();
