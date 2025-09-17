#include <SoftwareSerial.h>
//definindo onde está cada pino da ponte drive
const int IN1 = 8;
const int IN2 = 9;
const int IN3 = 11;
const int IN4 = 12;

// os pinos do módulo bluetooth agora
const int BT_RX = 10; 
const int BT_STATE = 7;
const int BT_TX = 6; // Esse não é usado, mas é necessário escrevermos para a biblioteca SoftwareSerial funcionar corretamente
SoftwareSerial BT(BT_RX, BT_TX);

//variáveis de controle
char comando;
bool sistemaLigado = true;
bool pilotoAutomatico = false;
unsigned long ultimaAcao = 0;

void setup(){
  //config dos pinos da ponte drive
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  //config do bluetooth
  pinMode(BT_STATE, INPUT);
  Serial.begin(9600);
  BT.begin(9600);
  pararMotores();
  Serial.println("Sistema iniciado.");

}

void loop(){
  if(BT.available() > 0){
    comando = BT.read();
    Serial.print("Recebido: ");
    Serial.println(comando);

    //controle do sistema
    if(comando == 'L'){ //ligar
      sistemaLigado = true;
      pararMotores();
    }
    else if (comando == 'D'){ //desligar
      sistemaLigado = false;
      pilotoAutomatico = false;
      pararMotores();
    }
    //controle do piloto automático
    else if (comando == 'A'){ //ativar
      if(sistemaLigado){
        pilotoAutomatico = true;
        ultimaAcao = millis();
      }
    }
    else if (comando == 'O'){
      pilotoAutomatico = false;
      pararMotores();
    }
    //aqui fazemos com que só consiga cotrolá-lo de forma manual se ele não estiver no piloto automático e se o sistema estiver ligado
    else if(sistemaLigado &&  !pilotoAutomatico){
      executarComando(comando);
    }
  }
  ///executa piloto automatico
  if(sistemaLigado && pilotoAutomatico){
    executarPilotoAutomatico();
  }
}


//funções auxiliares
void executarComando(char c){
  switch(c){
    case 'F': frente(); break;
    case 'B': tras(); break;
    case 'E': esquerda(); break;
    case 'R': direita(); break;
    case 'S': pararMotores(); break;
  }
}
void executarPilotoAutomatico(){
  if (millis() - ultimaAcao > 3000){
    ultimaAcao = millis();

    int acao = random(5);
    switch(acao){
      case 0: frente(); break;
      case 1: tras(); break;
      case 2: esquerda(); break;
      case 3: direita(); break;
      case 4: pararMotores(); break;
    }
  }
}
//funções para os motores
void frente(){
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}
void tras(){
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}
void esquerda(){
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}
void direita(){
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}
void pararMotores(){
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
}