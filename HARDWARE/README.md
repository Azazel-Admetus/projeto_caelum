# Hardware - Robô Solum

Esta pasta contém todos os arquivos relacionados à parte física do robô Solum, incluindo código do Arduino, modelos 3D e informações sobre peças utilizadas.

## Estrutura da pasta
hardware/
├── ARDUINO/ # Código do Arduino
│ ├── solum.ino
│ └── README.md
├── MODELAGEM 3D/ # Modelos 3D
│ ├── openSCAD/ # Código-fonte OpenSCAD
│ ├── STL/ # Arquivos STL prontos para impressão
│ └── README.md
├── IMAGENS/ # Fotos e renders
└── README.md # Este arquivo


## ARDUINO
- Contém o código necessário para controlar motores e comunicação Bluetooth com o app SolumBot.
- Para mais detalhes, veja `ARDUINO/README.md`.

## MODELAGEM 3D
- Código OpenSCAD (`MODELAGEM 3D/openSCAD/`) para gerar os modelos do robô.
- Arquivos STL prontos para impressão (`MODELAGEM 3D/STL/`).
- **Observação:** Os modelos ainda podem precisar de ajustes nas medidas antes da impressão.

## Peças utilizadas
- Motores DC
- Módulo Bluetooth HC-05
- Baterias de notebook
- Estrutura base impressa em 3D (PLA)
- Arduino Uno
- Ponte Drive modelo L298N

## Observações importantes
- Ajuste medidas e parâmetros antes de imprimir ou montar.
- Teste sempre as peças e conexões antes de operar o robô.
- As imagens da montagem e do modelo 3D serão adicionadas na pasta `IMAGENS/`.
