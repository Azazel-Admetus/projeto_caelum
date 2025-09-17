# Código Arduino - Robô Solum

Esta pasta contém o código do Arduino utilizado para controlar o robô Solum, incluindo motores e comunicação via Bluetooth com o app SolumBot. Todo o código pode ser adaptado para se adequar ao seu projeto.

## Arquivos
- `solum.ino` → Código principal que controla a locomoção e a interação do robô com o app.

## Funcionalidades
- Controle de motores DC para locomoção do robô.
- Comunicação Bluetooth com o app SolumBot.

## Conexões principais
- **Motores** → Conectados à ponte H.
- **Bluetooth HC-05** → Conectado ao Arduino via RX/TX.
- **Bateria** → Fornece energia ao Arduino e aos motores.
- **Observação:** Certifique-se de respeitar polaridade e tensão recomendadas.

## Configuração do Bluetooth
No código, o endereço MAC do módulo Bluetooth é especificado. Para usar outro módulo:
- Atualize o endereço MAC no código, ou
- Configure o app para se conectar ao módulo emparelhado.

## Observações importantes
- Ajuste parâmetros de velocidade e tempo no código conforme necessário.
- Teste o robô em superfície plana antes de aplicações mais complexas.
- O código é compatível com Arduino Uno, mas pode ser adaptado para outros modelos.
