//2 direita, 3 esquerda
// carrega a biblioteca AFMotor
#include <AFMotor.h>
#include <Servo.h>
#include <SimpleKalmanFilter.h>
SimpleKalmanFilter simpleKalmanFilter(2, 2, 0.1);
const long SERIAL_REFRESH_TIME = 10;
long refresh_time;
int cont=0;
Servo garra;//50 max aberta
            //150 max fechada
Servo giroGarra;
Servo punho;
Servo base;
Servo cotovelo; //0 frente
                //180 atrás
Servo braco; //0 frente
             //180 atrás
#define np 6
int posicao[np][5];
int movimento[5] = {posicao[0][0],posicao[0][1],posicao[0][2],posicao[0][3],posicao[0][4]};

// Define o motor2 ligado a conexao 2
AF_DCMotor motor2(2); 
// Define o motor2 ligado a conexao 3
AF_DCMotor motor3(3); 
int velocidade=0;
void setup()
{
  // Define a velocidade maxima para os motores 1 e 2 
  motor2.setSpeed(velocidade);
  motor3.setSpeed(velocidade);
  //Manipulador
  garra.attach(14);
  giroGarra.attach(15);
  punho.attach(16);
  cotovelo.attach(17);
  braco.attach(18);
  base.attach(19);

  
  
    //Posição 0 - Posição de descanso
  posicao[0][0] = 100; //Base
  posicao[0][1] = 120; //Braço
  posicao[0][2] = 50;   //Cotovelo
  posicao[0][3] = 0; //Punho
  posicao[0][4] = 80; //Giro Garra

  //Posição 1 - Posição frontal (Norte)
  posicao[1][0] = 80; //Base
  posicao[1][1] = 120; //Braço
  posicao[1][2] = 120;   //Cotovelo
  posicao[1][3] = 0; //Punho
  posicao[1][4] = 100; //Giro Garra
  //movimentaBraco(movimento);

  //Posição 2 - Posição lateral 1.0 (Leste)
  posicao[2][0] = 30; //Base
  posicao[2][1] = 120; //Braço
  posicao[2][2] = 110;   //Cotovelo
  posicao[2][3] = 50; //Punho
  posicao[2][4] = 100; //Giro Garra

  //Posição 3 - Posição lateral 1.1 (Leste)
  posicao[3][0] = 30; //Base
  posicao[3][1] = 120; //Braço
  posicao[3][2] = 150;   //Cotovelo
  posicao[3][3] = 50; //Punho
  posicao[3][4] = 100; //Giro Garra

    //Posição 4 - Posição lateral 1.0 (oeste)
  posicao[4][0] = 150; //Base
  posicao[4][1] = 120; //Braço
  posicao[4][2] = 110;   //Cotovelo
  posicao[4][3] = 50; //Punho
  posicao[4][4] = 100; //Giro Garra

  //Posição 5 - Posição lateral 1.1 (oeste)
  posicao[5][0] = 150; //Base
  posicao[5][1] = 120; //Braço
  posicao[5][2] = 150;   //Cotovelo
  posicao[5][3] = 50; //Punho
  posicao[5][4] = 100; //Giro Garra
  
  Serial.begin(9600);
}
 
void loop()
{
  delay(1000);
  Serial.print('p');
  Serial.println(2000);
  delay(2000);
//  motor2.run(RELEASE);
//  motor3.run(RELEASE); 

//Frente,direita,frente,esquerda,frente,esquerda,frente
  frente(2200); //8cm
  direita(800);//45°
//  movimenta(0,2,110,50);
//  movimenta(2,3,50,170);
//  movimenta(3,0,170,170);
  frente(2000);//30cm
  esquerda(600);//45°
  frente(2200);//15cm
  esquerda(600);//45°
  frente(800);//30cm
  direita(600);//45°
//  movimenta(0,5,170,50);
//  movimenta(5,4,50,110);
//  movimenta(4,0,110,110);
  frente(1600);//30cm
  esquerda(600);//45°
  frente(800);//15cm
//  
  motor2.run(RELEASE);
  motor3.run(RELEASE);
  Serial.print('p');
  Serial.println(1000);
  delay(100000);
}

void tras(int tempo)
{
  Serial.print("t");
  Serial.println(tempo);
  // Aciona o motor 2 no sentido anti-horario
  motor2.run(BACKWARD); 
  // Aciona o motor 3 no sentido horario
  motor3.run(FORWARD); 
 
  // Aguarda 5 segundos
  kalman(tempo);


}
void frente(int tempo)
{
  Serial.print("f");
  Serial.println(tempo);
  // Aciona o motor 2 no sentido horario
  motor2.run(FORWARD);
  // Aciona o motor 1 no sentido anti-horario
  motor3.run(BACKWARD);
 
  // Aguarda 5 segundos
  kalman(tempo);
  

}
void direita(int tempo)
{
  Serial.print("d");
  Serial.println(tempo);
  motor2.run(BACKWARD);
  motor3.run(BACKWARD); 
  kalman(tempo);

}

void esquerda(int tempo)
{
  Serial.print("e");
  Serial.println(tempo);
  motor2.run(FORWARD);
  motor3.run(FORWARD);
  kalman(tempo);

}
void movimenta(int pi, int pf,int gi,int gf)
{
  int maximo = defineMaximoAngulo(pi,pf);
  Serial.print('b');
  Serial.println(2000+1000+maximo*30+abs(gf-gi)*30);
  for(int i=0;i<maximo;i++)
  {
      geraMovimento(0,posicao[pi][0],posicao[pf][0],i,maximo);
      geraMovimento(1,posicao[pi][1],posicao[pf][1],i,maximo);
      geraMovimento(2,posicao[pi][2],posicao[pf][2],i,maximo);
      geraMovimento(3,posicao[pi][3],posicao[pf][3],i,maximo);
      geraMovimento(4,posicao[pi][4],posicao[pf][4],i,maximo);
      movimentaBraco(movimento);  
  }
  delay(2000);
  for(int i=0;i<abs(gf-gi);i++)
  {
    garra.write(i*(gf-gi)/abs(gf-gi)+gi);
    delay(30);
  }
  delay(1000);
}
void geraMovimento(int i, int pi, int pf, int m,int maximo)
{
  int resultado = 0; 
  resultado = m*(pf-pi)/(maximo) + pi; 
  movimento[i]= resultado;
}
int defineMaximoAngulo(int pi, int pf)
{
  int maximo = 0;
  for(int i=0;i<5;i++)
  {
      int diferenca = abs(posicao[pf][i] - posicao[pi][i]);
      if(diferenca>maximo)
      {
        maximo = diferenca;
      }
  }
  return maximo;
}

void movimentaBraco(int elo[5])
{
  base.write(elo[0]);
  braco.write(elo[1]);
  cotovelo.write(elo[2]);
  punho.write(elo[3]);
  giroGarra.write(elo[4]);
  delay(30);
}
void kalman(int tempo)
{
  float resp=0.0;
  int t=0;
  while(t<=tempo)
  {
    if(cont==tempo)
    {
      cont=0;
    }
    int x = 100*cont/(tempo);
    float real_value = 0.0115*pow(x,4)-0.3501*pow(x,3)+2.9764*pow(x,2)-3.0589*x+0.1742;
    cont++;
    float measured_value = real_value + random(-100,100)/100.0;
    float valorEstimado = simpleKalmanFilter.updateEstimate(measured_value);
    if (millis() > refresh_time) {
      resp = valorEstimado*220.0/32.5;
      if(resp>=220)
      {
        resp=220.0;
      }
      refresh_time = millis() + SERIAL_REFRESH_TIME;
    }
    motor2.setSpeed(int(resp));
    motor3.setSpeed(int(resp));
    Serial.println();
    Serial.print("resp: ");
    Serial.println(resp);
    //delay(1);
    t=t+10;
  }
}

