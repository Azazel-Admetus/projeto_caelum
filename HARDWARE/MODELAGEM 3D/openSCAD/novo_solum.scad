body_x = 3; // é a largura
body_y = 5; //é a altura
body_z = 6; // é a profundidade

translate([0,0,3]) rotate([0, 90, 0])
    cube([body_x, body_y, body_z]);

head_x = 2; // largura
head_y = 3; // altura
head_z = 2; //profundidade

translate([0.5, 1, 3.1])
    cube([head_x, head_y, head_z]);
