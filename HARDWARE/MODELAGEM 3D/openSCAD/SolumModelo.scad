// =====================
// CONFIGURAÇÕES GERAIS
// =====================
base_x = 197;
base_y = 195;
base_thickness = 5;

wall_thickness = 3;
wall_height = 50;

tamp_thickness = 3;

// Folgas para encaixe
snap_tolerance = 0.2;
head_snap_tolerance = 0.2;
base_snap_tolerance = 0.2;

// Dimensões dos dentes de encaixe
snap_width = 4;
snap_height = 3;
snap_depth = 2;

// Offset para dentes nas bordas
offset_long = 15;
offset_short = 15;

// =====================
// DIMENSÕES DA CABEÇA
// =====================
head_x = 50;
head_y = 50;
head_height = 40;
head_offset = 10;

head_snap_width = snap_width - 0.2;
head_snap_depth = wall_thickness - 0.2;
head_snap_height = tamp_thickness - 0.2;

// Olhos
eye_radius = 5;
eye_depth = 2;

// =====================
// DIMENSÕES DO ARDUINO UNO
// =====================
arduino_x = 54.01;  // 53.41 + 0.6mm
arduino_y = 75.59;  // 74.99 + 0.6mm
arduino_h = 5;
arduino_hole_r = 1.6;

arduino_pos_x = base_x - arduino_x - 2;
arduino_pos_y = 2;
arduino_pos_z = 1;
arduino_pos = [arduino_pos_x, arduino_pos_y, arduino_pos_z];

// =====================
// DIMENSÕES DO DRIVER L298N
// =====================
driver_x = 43.65;   // 43.05 + 0.6mm
driver_y = 43.60;   // 43.00 + 0.6mm
driver_h = 5;
driver_hole_r = 1.6;

driver_pos_x = base_x / 2 - driver_x / 2;
driver_pos_y = base_y - driver_y - 5;
driver_pos_z = 1;
driver_pos = [driver_pos_x, driver_pos_y, driver_pos_z];

// =====================
// DIMENSÕES DOS MOTORES DC CILÍNDRICOS AMARELOS (RB-130 OU EQUIVALENTE)
// =====================
motor_y = driver_pos_y - driver_y / 2; // continua alinhado com o centro do driver
motor_w = 30.0;    // largura: 19mm (diâmetro) + 3mm de folga total (1.5mm por lado)
motor_l = 50.0;    // comprimento: 37mm + 3mm de folga
motor_h = 5.0;     // profundidade = espessura da base

// =====================
// MODULOS DE ENCAIXE (SNAPS)
// =====================
module snap(pos=[0,0,0]) {
    translate([pos[0], pos[1], pos[2]])
        cube([snap_width - base_snap_tolerance, snap_depth - base_snap_tolerance, snap_height]);
}

module snap_head(pos=[0,0,0]) {
    translate([pos[0], pos[1], pos[2]])
        cube([head_snap_width - head_snap_tolerance, head_snap_depth - head_snap_tolerance, head_snap_height]);
}

// =====================
// SUPORTE PARA ARDUINO UNO
// =====================
module slot_arduino() {
    difference() {
        cube([arduino_x, arduino_y, arduino_h]);
    }
}

// =====================
// SUPORTE PARA DRIVER L298N
// =====================
module slot_driver() {
    difference() {
        cube([driver_x, driver_y, driver_h]);
    }
}
module arduino_holes() {
    furo_offset = 4.2;
    translate([arduino_pos_x + furo_offset, arduino_pos_y + furo_offset, -1])
        cylinder(h=10, r=arduino_hole_r, $fn=30);
    translate([arduino_pos_x + arduino_x - furo_offset, arduino_pos_y + furo_offset, -1])
        cylinder(h=10, r=arduino_hole_r, $fn=30);
    translate([arduino_pos_x + furo_offset, arduino_pos_y + arduino_y - furo_offset, -1])
        cylinder(h=10, r=arduino_hole_r, $fn=30);
    translate([arduino_pos_x + arduino_x - furo_offset, arduino_pos_y + arduino_y - furo_offset, -1])
        cylinder(h=10, r=arduino_hole_r, $fn=30);
}
module driver_holes(){
    furo_offset = 7.5; 
    translate([driver_pos_x + furo_offset, driver_pos_y + furo_offset, -1]) 
        cylinder(h=10, r=driver_hole_r, $fn=30); 
    translate([driver_pos_x + driver_x - furo_offset, driver_pos_y + furo_offset, -1]) 
        cylinder(h=10, r=driver_hole_r, $fn=30); 
    translate([driver_pos_x + furo_offset, driver_pos_y + driver_y - furo_offset, -1]) 
        cylinder(h=10, r=driver_hole_r, $fn=30); 
    translate([driver_pos_x + driver_x - furo_offset, driver_pos_y + driver_y - furo_offset, -1]) 
        cylinder(h=10, r=driver_hole_r, $fn=30);
}

// =====================
// SUPORTE PARA SERVOS CONTÍNUOS
// =====================
module motor_slots() {
    translate([+5, motor_y, 1]) cube([motor_w, motor_l, motor_h]);
    translate([base_x - motor_w - 5, motor_y, 1]) cube([motor_w, motor_l, motor_h]);
}

// =====================
// BASE REMOVEL COM REBAIXOS, SUPORTES E ESTEIRA
// =====================
module removable_base() {
    difference() {
        cube([base_x, base_y, base_thickness]); // base sólida

        translate(arduino_pos) slot_arduino();
        translate(driver_pos) slot_driver();
        motor_slots();
        arduino_holes();// furos dos motores
        driver_holes(); //furos dos drivers
    }



    // --- DENTES DA BASE (mantidos) ---
    snap([offset_long, 0, base_thickness]);
    snap([base_x - offset_long - snap_width, 0, base_thickness]);
    snap([offset_long, base_y - snap_depth, base_thickness]);
    snap([base_x - offset_long - snap_width, base_y - snap_depth, base_thickness]);
}
// =====================
// PAREDES LATERAIS E TRASEIRA
// =====================
module upper_body() {
    // Frente
    difference() {
        cube([base_x, wall_thickness, wall_height]);
        translate([offset_long, 0, 0]) 
            cube([snap_width, wall_thickness, snap_height]);
        translate([base_x - offset_long - snap_width, 0, 0])        cube([snap_width, wall_thickness, snap_height]);
    }

    // Trás (lisa)
    difference() {
        translate([0, base_y - wall_thickness, 0])
            cube([base_x, wall_thickness, wall_height]);
        translate([offset_long, base_y - wall_thickness, 0])
            cube([snap_width, wall_thickness, snap_height]);
        translate([base_x - offset_long - snap_width, base_y - wall_thickness, 0])
            cube([snap_width, wall_thickness, snap_height]);
    }

// Esquerda (parede lateral esquerda com JANELA DE EXPOSIÇÃO DO MOTOR)
    difference() {
        cube([wall_thickness, base_y, wall_height]);
//        translate([0, offset_short, 0]) cube([wall_thickness,   snap_depth, snap_height]);
//        translate([0, base_y - offset_short - snap_depth, 0])   cube([wall_thickness, snap_depth, snap_height]);

        eixo_centro_y = motor_y + motor_l / 2;
        janela_largura = motor_w + 2;   // ← ALTERADO: 22 + 2 = 24mm
        janela_altura = wall_height -25;
        janela_profundidade = wall_thickness + 1;

        translate([0, eixo_centro_y - janela_largura / 2, 0])
            cube([janela_profundidade, janela_largura,          janela_altura]);
    }

// Direita — mesma alteração:
    difference() {
        translate([base_x - wall_thickness, 0, 0])
            cube([wall_thickness, base_y, wall_height]);
//        translate([base_x - wall_thickness, offset_short, 0]) cube  ([wall_thickness, snap_depth, snap_height]);
//        translate([base_x - wall_thickness, base_y - offset_short   - snap_depth, 0]) cube([wall_thickness, snap_depth,     snap_height]);

        eixo_centro_y = motor_y + motor_l / 2;
        janela_largura = motor_w + 2;   // ← ALTERADO: 24mm
        janela_altura = wall_height -25;
        janela_profundidade = wall_thickness + 1;

        translate([base_x - wall_thickness, eixo_centro_y -         janela_largura / 2, 0])
            cube([janela_profundidade, janela_largura,              janela_altura]);
    }
        // --- SUPORTES HORIZONTAIS PARA AS RODAS DE APOIO ---
    union() {
        // Roda 1 — frente
        translate([-10, 10, 5]) // X centralizado, Y=20, Z=0
            wheel_support_horizontal();

        // Roda 2 — centro
        translate([-10, 60, 5]) // Y=97.5
            wheel_support_horizontal();

        // Roda 3 — trás (antes do motor)
        translate([-10, 110, 5]) // Y=175 (195 - 20)
            wheel_support_horizontal();
        //do outro lado
        translate([195, 10, 5]) // X centralizado, Y=20, Z=0
            wheel_support_horizontal();

        // Roda 2 — centro
        translate([195, 60, 5]) // Y=97.5
            wheel_support_horizontal();

        // Roda 3 — trás (antes do motor)
        translate([195, 110, 5]) // Y=175 (195 - 20)
            wheel_support_horizontal();
    }
}

// =====================
// TAMPA SUPERIOR
// =====================
module top_lid() {
    head_origin_x = (base_x - head_x)/2;
    head_origin_y = (base_y - head_y)/2;

    difference() {
        translate([0, 0, wall_height])
            cube([base_x, base_y, tamp_thickness]);

        // Furos para os dentes da cabeça
        translate([head_origin_x + head_offset, head_origin_y, wall_height])
            cube([head_snap_width - head_snap_tolerance, head_snap_depth - head_snap_tolerance, tamp_thickness + 0.1]);
        translate([head_origin_x + head_x - head_offset - head_snap_width, head_origin_y, wall_height])
            cube([head_snap_width - head_snap_tolerance, head_snap_depth - head_snap_tolerance, tamp_thickness + 0.1]);

        translate([head_origin_x + head_offset, head_origin_y + head_y - head_snap_depth, wall_height])
            cube([head_snap_width - head_snap_tolerance, head_snap_depth - head_snap_tolerance, tamp_thickness + 0.1]);
        translate([head_origin_x + head_x - head_offset - head_snap_width, head_origin_y + head_y - head_snap_depth, wall_height])
            cube([head_snap_width - head_snap_tolerance, head_snap_depth - head_snap_tolerance, tamp_thickness + 0.1]);

        translate([head_origin_x, head_origin_y + head_offset, wall_height])
            cube([head_snap_depth - head_snap_tolerance, head_snap_width - head_snap_tolerance, tamp_thickness + 0.1]);
        translate([head_origin_x, head_origin_y + head_y - head_offset - head_snap_height, wall_height])
            cube([head_snap_depth - head_snap_tolerance, head_snap_width - head_snap_tolerance, tamp_thickness + 0.1]);

        translate([head_origin_x + head_x - head_snap_depth, head_origin_y + head_offset, wall_height])
            cube([head_snap_depth - head_snap_tolerance, head_snap_width - head_snap_tolerance, tamp_thickness + 0.1]);
        translate([head_origin_x + head_x - head_snap_depth, head_origin_y + head_y - head_offset - head_snap_height, wall_height])
            cube([head_snap_depth - head_snap_tolerance, head_snap_width - head_snap_tolerance, tamp_thickness + 0.1]);

        // --- FURO PARA O BOTÃO RETANGULAR ---
        push_button_recess();
    }
}

// =====================
// REBAIXO PARA BOTÃO PUSH BUTTON LATCHING (RETANGULAR)
// =====================
module push_button_recess() {
    button_len = 14;   // comprimento do botão (medido)
    button_wid = 9;    // largura do botão (medido)
    recess_depth = 4;  // profundidade do rebaixo

    hole_len = button_len + 1.0;
    hole_wid = button_wid + 1.0;

    // Posição: canto inferior esquerdo, um pouco pra frente
    translate([15 - hole_len/2, 70, wall_height])
        cube([hole_len, hole_wid, recess_depth]);
}

// =====================
// CABEÇA DO ROBÔ
// =====================
module head() {
    head_origin_x = (base_x - head_x)/2;
    head_origin_y = (base_y - head_y)/2;
    head_origin_z = wall_height + tamp_thickness;

    // Corpo da cabeça
    translate([head_origin_x, head_origin_y, head_origin_z])
        cube([head_x, head_y, head_height]);

// --- DENTES DA CABEÇA ---
// Frente
translate([head_origin_x + head_offset, head_origin_y, wall_height])
    cube([head_snap_width, head_snap_depth, head_snap_height]);
translate([head_origin_x + head_x - head_offset - head_snap_width, head_origin_y, wall_height])
    cube([head_snap_width, head_snap_depth, head_snap_height]);

// Trás
translate([head_origin_x + head_offset, head_origin_y + head_y - head_snap_depth, wall_height])
    cube([head_snap_width, head_snap_depth, head_snap_height]);
translate([head_origin_x + head_x - head_offset - head_snap_width, head_origin_y + head_y - head_snap_depth, wall_height])
    cube([head_snap_width, head_snap_depth, head_snap_height]);

// Lado esquerdo
translate([head_origin_x, head_origin_y + head_offset, wall_height])
    cube([head_snap_depth, head_snap_width, head_snap_height]);
translate([head_origin_x, head_origin_y + head_y - head_offset - head_snap_height, wall_height])
    cube([head_snap_depth, head_snap_width, head_snap_height]);

// Lado direito
translate([head_origin_x + head_x - head_snap_depth, head_origin_y + head_offset, wall_height])
    cube([head_snap_depth, head_snap_width, head_snap_height]);
translate([head_origin_x + head_x - head_snap_depth, head_origin_y + head_y - head_offset - head_snap_height, wall_height])
    cube([head_snap_depth, head_snap_width, head_snap_height]);

    // --- OLHOS ---
    eye_left_y = head_origin_y + head_y * 0.25;
    eye_right_y = head_origin_y + head_y * 0.75;
    eye_z = head_origin_z + head_height * 0.7;

    translate([head_origin_x + head_x, eye_left_y, eye_z])
        rotate([0, 90, 0]) cylinder(h=eye_depth, r=eye_radius, $fn=60);

    translate([head_origin_x + head_x, eye_right_y, eye_z])
        rotate([0, 90, 0]) cylinder(h=eye_depth, r=eye_radius, $fn=60);
}

// =====================
// SUPORTE HORIZONTAL PARA RODA DE APOIO
// =====================
module wheel_support_horizontal() {
    support_diameter = 6.2;
    support_length = 12;     // ← Agora é o comprimento do cilindro (horizontal)
    support_height = 5;      // ← Espessura do suporte (altura acima do chão)
    hole_r = 1.5;

    // Cilindro horizontal (deitado)
    rotate([90, 00, 90])       // ← Rotaciona 90° em X → deixa o cilindro deitado!
        cylinder(h=support_length, r=support_diameter/2, $fn=30);
}
// =====================
// MONTAGEM FINAL
// =====================
module inverted_body() {
    total_height = wall_height + tamp_thickness; // altura total do corpo + tampa
    
    translate([0, 0, total_height])
        rotate([180, 0, 0])
            union() {
                upper_body();
                top_lid();
            };
}


union() {
    removable_base();
    upper_body();
    top_lid();
    head();
    //inverted_body(); pode usar essa função com cada peça para virar ela de ponta cabeça a fim de melhorar o processo de impressão
}