import processing.serial.*;

Serial serial;
int ambiente;
int controle1=0;
boolean controle2=false;
boolean controle3=false;
int r=0;
void setup()
{
   fullScreen();
   //size(displayWidth,displayHeight);
   String porta = Serial.list()[0];
   serial = new Serial(this,porta,9600);
   //terceiro ambiente
   
   int[] m = new int[2];
   m[0]=1;//direita
   m[1]=2;//esquerda
   quadroInfoBraco();
   pun=punho[0];
   gar=garra[0];
   bas=base[0];
   giro=giroGarra[0];
}
float lbA=25.0;
float abA=5.0;
int nm = 19;//numero de movimentos
int largura = 1280;
int altura = 768;
int te;
float tb=0.0;
int contAng=0;
int x=0;
int c=0;
int giro=0;
int bas=0;
int pun=0;
int gar=0;
float angulo=0;
int somaP=0;
float[] vecGiro = new float[100];
float[] vecBase = new float[100];
float[] vecPunho = new float[100];
float[] vecGarra = new float[100];
char id='p';
String leitura="p2000";
int tempo=millis();
float vel=0.0,acel=0.0,dist=0.0,ang=0.0;
int cont=0;
float[] vecVel = new float[100];
float[] vecAcel = new float[100];
float[] vecAng = new float[100];
int[] garra = new int[2];
int[] giroGarra = new int[2];
int[] base = new int[4];
int[] punho = new int[2];
int[] pontoInicial = new int[2];
int[] pontoFinal = new int[2];
int[] posLobs = new int[10];
int[] posAobs = new int[10];
int[] obst = new int[10];
int[] larObs = new int[10];
int[] altObs = new int[10];
int[] corObst=new int[3];
int[] larTra=new int[10];
int[] altTra=new int[10];
int[] nTra=new int[10];
int contF=0;
int[] larObj=new int[2];
int[] altObj=new int[2];
int[] posCol=new int[2];
int[] posDep=new int[2];
int altMn=0;
int larMn=0;
int seq=0;
int frentes=0;
int contMB=0;
int maximoAng=0;
int contPonto=0;
boolean contrPonto=false;
int numeroObstaculo=0;
//int velAnt=0;
//para modificar o ambiente, modifique a variavel tm e acoes
void draw()
{   
   String[] acoes = new String[nm];
   acoes = amb2();//ambiente
   if(serial.available()>0)
   {
     leitura = serial.readStringUntil('\n');
     id = leitura.charAt(0);    
     if(id=='f'||id=='p'||id=='d'||id=='e'||id=='b'||id=='i')
     {
         controle2=false;
         controle3=false;
         x=0;
         te = Integer.parseInt(leitura.substring(1,leitura.length()-2));
         tempo=millis();
         if(id=='b')
         {
            contMB = contMB+1;
            controle3=true;
            
         }
         if(id=='f')
         {
            controle2=true;
            contF = contF+1;
            if(contF==frentes+1)
            {
               contF = 0; 
            }
         }
         controle1=1+controle1;
         if(contMB==7)
         {
            contMB=0; 
         }
         c=c+1;
         if(c==nm-1)
         {
            c=0; 
         }
         if(id=='i')
         {
             r=0;
             x=0;
             c=0;
             contMB=0;
             maximoAng=0;
             contAng=0;
             r=0;
             controle1=0;
             contF=0;
         }
     } 
   }
   if(controle1>=1)
   {
       if(controle1==1)
       {
          c=0; 
       }
       quadroGraficoChassi();
       quadroGraficoManipulador();
       quadroManipulador();
       quadroInfoChassi(leitura);
       gps();
       quadroChassi(id);
       if(id=='b')
       {
           quadroInfoBraco();
       }
       
       if(c>=0&&c<nm)
       {
           quadroProgresso(acoes,c);
       }
       
   }
   delay(1);
   
}
//___________________________________________________________Ambiente 1__________________________________________________________________________________________________
String[] amb1()
{
  String[] ac = new String[nm];
  ac[0]="Espera";
  ac[1]="Frente";
  ac[2]="Direita";
  ac[3]="Braço ponto segurança";
  ac[4]="Braço coleta";
  ac[5]="Braço descanso";
  ac[6]="Frente";
  ac[7]="Esquerda";
  ac[8]="Frente";
  ac[9]="Direita";
  ac[10]="Frente";
  ac[11]="Direita";
  ac[12]="Braço deposita";
  ac[13]="Braço ponto de segurança";
  ac[14]="Braço descanso";
  ac[15]="Frente";
  ac[16]="Esquerda";
  ac[17]="Frente";
  ac[18]="Espera";
  garra[0] = 100;//maximo de abertura neste ambiente
  garra[1] = 50;//maximo fechado neste ambiente
  maximoAng=120;
  frentes=6;
  giroGarra[0] = 100;
  giroGarra[1] = 20;
  base[0] = 100;
  base[1] = 20;//direita
  base[2] = 160;//esquerda
  punho[0] = 100;//segurança
  punho[1] = 20;//pegar
  pontoInicial[0]=70;
  pontoInicial[1]=70;
  pontoFinal[0]=780;
  pontoFinal[1]=360;
  numeroObstaculo=5;
  corObst[0]=0;
  corObst[1]=0;
  corObst[2]=255;
  //obstaculo 1
  obst[0]='r';
  larObs[0]=20;
  altObs[0]=140;
  posLobs[0]=330;
  posAobs[0]=80;
  //obstaculo 2
  obst[1]='r';
  larObs[1]=100;
  altObs[1]=20;
  posLobs[1]=350;
  posAobs[1]=80;
  //obstaculo 3
  obst[2]='r';
  larObs[2]=20;
  altObs[2]=140;
  posLobs[2]=450;
  posAobs[2]=80;
  //obstaculo 4
  obst[3]='r';
  larObs[3]=70;
  altObs[3]=70;
  posLobs[3]=100;
  posAobs[3]=300;
  //obstaculo 5
  obst[4]='r';
  larObs[4]=140;
  altObs[4]=20;
  posLobs[4]=600;
  posAobs[4]=280;
  //trajeto
  larTra[0]=70;
  altTra[0]=70;
  larTra[1]=300;
  altTra[1]=150;
  larTra[2]=300;
  altTra[2]=250;
  larTra[3]=590;
  altTra[3]=320;
  larTra[4]=650;
  altTra[4]=320;
  larTra[5]=720;
  altTra[5]=360;
  larTra[6]=780;
  altTra[6]=360;
  larObj[0]=-30;
  altObj[0]=30;
  larObj[1]=70;
  altObj[1]=10;

  posCol[0]=260;
  posCol[1]=170;
  posDep[0]=720;
  posDep[1]=330;
  return ac;
}
//___________________________________________________________Ambiente 2__________________________________________________________________________________________________
String[] amb2()
{
  String[] ac = new String[nm];
  ac[0]="Espera";
  ac[1]="Frente";
  ac[2]="Direita";
  ac[3]="Braço ponto segurança";
  ac[4]="Braço coleta";
  ac[5]="Braço descanso";
  ac[6]="Frente";
  ac[7]="Esquerda";
  ac[8]="Frente";
  ac[9]="Direita";
  ac[10]="Frente";
  ac[11]="Direita";
  ac[12]="Braço deposita";
  ac[13]="Braço ponto de segurança";
  ac[14]="Braço descanso";
  ac[15]="Frente";
  ac[16]="Esquerda";
  ac[17]="Frente";
  ac[18]="Espera";
  garra[0] = 100;//maximo de abertura neste ambiente
  garra[1] = 50;//maximo fechado neste ambiente
  maximoAng=120;
  frentes=6;
  giroGarra[0] = 100;
  giroGarra[1] = 20;
  base[0] = 100;
  base[1] = 20;//direita
  base[2] = 160;//esquerda
  punho[0] = 100;//segurança
  punho[1] = 20;//pegar
  pontoInicial[0]=70;
  pontoInicial[1]=70;
  pontoFinal[0]=780;
  pontoFinal[1]=360;
  numeroObstaculo=5;
  corObst[0]=0;
  corObst[1]=0;
  corObst[2]=255;
  //obstaculo 1
  obst[0]='r';
  larObs[0]=20;
  altObs[0]=140;
  posLobs[0]=330;
  posAobs[0]=80;
  //obstaculo 2
  obst[1]='r';
  larObs[1]=100;
  altObs[1]=20;
  posLobs[1]=350;
  posAobs[1]=80;
  //obstaculo 3
  obst[2]='r';
  larObs[2]=20;
  altObs[2]=140;
  posLobs[2]=450;
  posAobs[2]=80;
  //obstaculo 4
  obst[3]='r';
  larObs[3]=70;
  altObs[3]=70;
  posLobs[3]=100;
  posAobs[3]=300;
  //obstaculo 5
  obst[4]='r';
  larObs[4]=140;
  altObs[4]=20;
  posLobs[4]=600;
  posAobs[4]=280;
  //trajeto
  larTra[0]=70;
  altTra[0]=70;
  larTra[1]=300;
  altTra[1]=150;
  larTra[2]=300;
  altTra[2]=250;
  larTra[3]=590;
  altTra[3]=320;
  larTra[4]=650;
  altTra[4]=320;
  larTra[5]=720;
  altTra[5]=360;
  larTra[6]=780;
  altTra[6]=360;
  larObj[0]=-30;
  altObj[0]=30;
  larObj[1]=70;
  altObj[1]=10;

  posCol[0]=260;
  posCol[1]=170;
  posDep[0]=720;
  posDep[1]=330;
  return ac;
}
//___________________________________________________________Ambiente 3__________________________________________________________________________________________________
String[] amb3()
{
  String[] ac = new String[nm];
  ac[0]="Espera";
  ac[1]="Frente";
  ac[2]="Direita";
  ac[3]="Braço ponto segurança";
  ac[4]="Braço coleta";
  ac[5]="Braço descanso";
  ac[6]="Frente";
  ac[7]="Esquerda";
  ac[8]="Frente";
  ac[9]="Direita";
  ac[10]="Frente";
  ac[11]="Direita";
  ac[12]="Braço deposita";
  ac[13]="Braço ponto de segurança";
  ac[14]="Braço descanso";
  ac[15]="Frente";
  ac[16]="Esquerda";
  ac[17]="Frente";
  ac[18]="Espera";
  garra[0] = 100;//maximo de abertura neste ambiente
  garra[1] = 50;//maximo fechado neste ambiente
  maximoAng=120;
  frentes=6;
  giroGarra[0] = 100;
  giroGarra[1] = 20;
  base[0] = 100;
  base[1] = 20;//direita
  base[2] = 160;//esquerda
  punho[0] = 100;//segurança
  punho[1] = 20;//pegar
  pontoInicial[0]=70;
  pontoInicial[1]=70;
  pontoFinal[0]=780;
  pontoFinal[1]=360;
  numeroObstaculo=5;
  corObst[0]=0;
  corObst[1]=0;
  corObst[2]=255;
  //obstaculo 1
  obst[0]='r';
  larObs[0]=20;
  altObs[0]=140;
  posLobs[0]=330;
  posAobs[0]=80;
  //obstaculo 2
  obst[1]='r';
  larObs[1]=100;
  altObs[1]=20;
  posLobs[1]=350;
  posAobs[1]=80;
  //obstaculo 3
  obst[2]='r';
  larObs[2]=20;
  altObs[2]=140;
  posLobs[2]=450;
  posAobs[2]=80;
  //obstaculo 4
  obst[3]='r';
  larObs[3]=70;
  altObs[3]=70;
  posLobs[3]=100;
  posAobs[3]=300;
  //obstaculo 5
  obst[4]='r';
  larObs[4]=140;
  altObs[4]=20;
  posLobs[4]=600;
  posAobs[4]=280;
  //trajeto
  larTra[0]=70;
  altTra[0]=70;
  larTra[1]=300;
  altTra[1]=150;
  larTra[2]=300;
  altTra[2]=250;
  larTra[3]=590;
  altTra[3]=320;
  larTra[4]=650;
  altTra[4]=320;
  larTra[5]=720;
  altTra[5]=360;
  larTra[6]=780;
  altTra[6]=360;
  larObj[0]=-30;
  altObj[0]=30;
  larObj[1]=70;
  altObj[1]=10;

  posCol[0]=260;
  posCol[1]=170;
  posDep[0]=720;
  posDep[1]=330;
  return ac;
}
void gps()
{
    int t = millis()-tempo;
    int contP=0;
    int valor=0;
    int np[] = new int[100];
    int[] pi = new int[2];
    float[] xP = new float[1000];
    float[] yP = new float[1000];
    pi[0] = largura/4;
    pi[1] = altura/3;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],2*largura/3+107,2*altura/3);    
    //criando titulo
    fill(0);
    textSize(altura/30);
    text("Mapa",pi[0]+(2*largura/3+107)/2-40,pi[1]+30);
    strokeWeight(3);
    fill(112,128,144);
    rect(pi[0]+50,pi[1]+50,2*largura/3,2*altura/3-80);
    //cria ponto inicial e final
    if(contrPonto==false)
    {
        contPonto=contPonto+1;
        if(contPonto==15)
        {
           contrPonto=true; 
        }
    }
    else
    {       
        contPonto=contPonto-1;
        if(contPonto==0)
        {
            contrPonto=false;
        }
      
    }
    strokeWeight(1);
    stroke(255,50,50);
    ellipse(pi[0]+50+pontoInicial[0],pi[1]+pontoInicial[1]+50,30+contPonto,30+contPonto);
    strokeWeight(2);   
    ellipse(pi[0]+50+pontoInicial[0],pi[1]+pontoInicial[1]+50,20+contPonto,20+contPonto);
    fill(255,50,50);
    strokeWeight(3);
    ellipse(pi[0]+50+pontoInicial[0],pi[1]+pontoInicial[1]+50,10+contPonto,10+contPonto);
    
    fill(112,128,144);
    strokeWeight(1);
    stroke(50,205,50);
    ellipse(pi[0]+50+pontoFinal[0],pi[1]+pontoFinal[1]+50,30+contPonto,30+contPonto);
    strokeWeight(2);
    ellipse(pi[0]+50+pontoFinal[0],pi[1]+pontoFinal[1]+50,20+contPonto,20+contPonto);
    fill(50,205,50);
    stroke(50,205,50);
    strokeWeight(3);
    ellipse(pi[0]+50+pontoFinal[0],pi[1]+pontoFinal[1]+50,10+contPonto,10+contPonto);
    stroke(0);
    
    //coloca obstaculos
    strokeWeight(2);
    for(int i=0;i<numeroObstaculo;i++)
    {
      fill(corObst[0],corObst[1],corObst[2]);
      if(obst[i]=='r')
      {
          rect(pi[0]+50+posLobs[i],pi[1]+50+posAobs[i],larObs[i],altObs[i]);
      }
    }
    //coloca objetos
    //verificar se isso nao vai alterar outros ambientes!!!!!!!!!!!!!!!!!
    if(contPonto<8)
    {
        fill(105,105,105);
        if(contMB>0&&contMB<4)
        {
            fill(255,255,20);
        }
    }
    else
    {
        fill(0,0,255);
    }
    textSize(14);
    //escreve coleta e cria ponto de coleta
    text("Coleta",pi[0]+posCol[0]-10,50+pi[1]+posCol[1]);
    
    fill(112,128,144);
    strokeWeight(0.5);
    stroke(0,0,255);
    ellipse(pi[0]+50+posCol[0],pi[1]+posCol[1]+50,20+contPonto,20+contPonto);
    strokeWeight(1);   
    ellipse(pi[0]+50+posCol[0],pi[1]+posCol[1]+50,12+contPonto,12+contPonto);
    fill(0,0,255);
    strokeWeight(1.5);
    ellipse(pi[0]+50+posCol[0],pi[1]+posCol[1]+50,4+contPonto,4+contPonto);
    //escreve deposito e cria ponto de deposito
    if(contPonto<8)
    {
        fill(105,105,105);
        if(contMB>=4)
        {
            fill(255,255,20);
        }
    }
    else
    {
        fill(0,0,255);
    }
    text("Depósito",pi[0]+posDep[0]+70,pi[1]+posDep[1]+50);
    fill(112,128,144);
    strokeWeight(0.5);
    stroke(0,0,255);
    ellipse(pi[0]+50+posDep[0],pi[1]+posDep[1]+50,20+contPonto,20+contPonto);
    strokeWeight(1);   
    ellipse(pi[0]+50+posDep[0],pi[1]+posDep[1]+50,12+contPonto,12+contPonto);
    fill(0,0,255);
    strokeWeight(1.5);
    ellipse(pi[0]+50+posDep[0],pi[1]+posDep[1]+50,4+contPonto,4+contPonto);
    
    if(contMB<=2)
    {
      strokeWeight(3);
      fill(0,255,255);
      stroke(0,255,255);
      ellipse(pi[0]+50+posCol[0],pi[1]+50+posCol[1],5,5);
               
    }
    if(contMB>=5)
    {
       strokeWeight(3);
      fill(0,255,255);
      stroke(0,255,255);
      ellipse(pi[0]+50+posDep[0],pi[1]+50+posDep[1],5,5);
    }
    stroke(0);
    //monta trajeto
    //stroke(30,144,255);
    strokeWeight(4);
    for(int i=0;i<frentes;i++)
    {
      int calc = 6*int(sqrt(pow(larTra[i]-larTra[i+1],2)+pow(altTra[i]-altTra[i+1],2)))/40;
      for(int j=0;j<=calc;j++)
      {
          
          float x = lerp(larTra[i],larTra[i+1],j/float(calc));
          xP[contP] = x;
          float y = lerp(altTra[i],altTra[i+1],j/float(calc));
          yP[contP]=y;
          contP = contP+1;
          if(somaP>contP)
          {
              
              stroke(105,105,105);
          }
          else
          {
              stroke(30,144,255);
          }
          
          point(pi[0]+50+x,pi[1]+50+y);
          
      }
      np[i]=calc+1;
    }
    

    stroke(0);
    strokeWeight(6);
    ////cria ponto de controle
    if(controle2&&contF>0)
    {
       angulo = atan(float(altTra[contF]-altTra[contF-1])/float(larTra[contF]-larTra[contF-1]));
       seq = np[contF-1]*t/te;
       
    }
    
    for(int i=0;i<contF-1;i++)
    {
        valor=valor+np[i];
        
    }
    somaP=valor+seq;
    
    strokeWeight(6);
    point(pi[0]+50+xP[seq+valor],pi[1]+50+yP[seq+valor]);
    strokeWeight(20);
    strokeCap(SQUARE);
    
    //line(pi[0]+50+xP[seq+valor],pi[1]+50+yP[seq+valor],pi[0]+50+xP[seq+valor+1],pi[1]+50+yP[seq+valor+1]);
    translate(pi[0]+50+xP[seq+valor],pi[1]+50+yP[seq+valor]);
    rotate(angulo);
    //cria carro
    rect(0,0,20,10);
    //movimenta manipulador
    stroke(255);
    strokeWeight(2);
    fill(0);
    ellipse(10,5,10,10);
    strokeWeight(5);
    int difL=0;
    int difA=0;
    float lb=0.0;
    float ab=0.0;
    if(controle3)
    {
        tb=float(t)/float(te);
        
        switch(contMB)
        {
           case 1:
               difL=10+larObj[0]-10;
               difA=5+altObj[0]-5;
               lb=difL*tb+25;
               ab=difA*tb+5;
               if(tb>=1)
               {
                  lbA=lb;
                  abA=ab;
               }
               break;
           case 2:
           
               difL=larObj[0]-int(lbA);
               difA=altObj[0]-int(abA);
               lb=difL*tb+lbA;
               ab=difA*tb+abA;
               if(tb>=1)
               {
                  lbA=lb;
                  abA=ab;
               }
               break;
            case 3:
                difL=25-int(lbA);
                difA=5-int(abA);
                lb=difL*tb+lbA;
                ab=difA*tb+abA;
                if(tb>=1)
                 {
                    lbA=lb;
                    abA=ab;
                 }
                 stroke(0,255,255);
                 ellipse(lb,ab,5,5);
                 stroke(255);
                 break;
              case 4:
                 difL=larObj[1]-int(lbA);
                 difA=altObj[1]-int(abA);
                 lb=difL*tb+lbA;
                 ab=difA*tb+abA;
                 if(tb>=1)
                 {
                    lbA=lb;
                    abA=ab;
                 }
                 stroke(0,255,255);
                 ellipse(lb,ab,5,5);
                 stroke(255);
                 break;
              case 5:
                 difL=larObj[1]-10-int(lbA);
                 difA=altObj[1]-5-int(abA);
                 lb=difL*tb+lbA;
                 ab=difA*tb+abA;
                 if(tb>=1)
                 {
                    lbA=lb;
                    abA=ab;
                 }
                 break;
              case 6:
                 difL=25-int(lbA);
                 difA=5-int(abA);
                 lb=difL*tb+lbA;
                 ab=difA*tb+abA;
                 if(tb>=1)
                 {
                    lbA=lb;
                    abA=ab;
                 }
                 break;
                
        }
        
        line(10,5,lb,ab);
        strokeWeight(2);
    }
    else
    {
        line(10,5,25,5);
        if(contMB==3)
        {
            stroke(0,255,255);
            ellipse(25,5,5,5);
            stroke(255);
        }
    }
    
    //line(10,5,larObj[0],altObj[0]);
    rotate(-angulo);
    translate(-(pi[0]+50+xP[seq+valor]),-(pi[1]+50+yP[seq+valor]));
    strokeCap(ROUND);
    
    stroke(0);
}

void quadroManipulador()
{
    int[] pi = new int[2];
    pi[0] = 0;
    pi[1] = 2*altura/3;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/4,altura/3);    
    //criando titulo
    fill(0);
    textSize(altura/30);
    text("Manipulador",pi[0]+70,pi[1]+30);
    //Cria base giratoria
    fill(0);
    ellipse(150,altura-100,70,10);
    ellipse(150,altura-40,70,10);
    line(115,altura-100,115,altura-40);
    line(185,altura-100,185,altura-40);
    //criando movimento da base
    strokeWeight(2);
    for(int i=0;i<50;i++)
    {
      if((150+bas+5*i)>115&&(150+bas+5*i)<185)
      {
        line(150+bas+5*i,altura-100,150+bas+5*i,altura-40);
      }
    }
    for(int i=0;i<50;i++)
    {
        if((150+bas-5*i)>115&&(150+bas-5*i)<185)
        {
          line(150+bas-5*i,altura-100,150+bas-5*i,altura-40);
        }
    }
    //cria link 1
    strokeWeight(40);
    line(150,altura-115,bas-90+150,altura-180);
    strokeWeight(3);
    stroke(0,0,205);
    line(150,altura-115,bas-90+150,altura-180);
    ellipse(150,altura-115,10,8);
    stroke(0);
    //link 2 (punho)
    strokeWeight(40);
    line(bas-90+150,altura-180,1.25*bas-90+150,altura-pun-40);
    strokeWeight(3);
    stroke(0,0,205);
    line(bas-90+150,altura-180,1.25*bas-90+150,altura-pun-40);
    ellipse(bas-90+150,altura-180,10,8);
    stroke(0);
    //link 3 giro da garra
    stroke(112,128,144);
    strokeWeight(10);
    ellipse(1.25*bas-90+150,altura-pun-40,10,8);
    line(1.25*bas-90+150,altura-pun-40,2*(bas-90)+150+100-giro*0.8,altura-pun-40-(100-giro)*0.2);
    line(1.25*bas-90+150,altura-pun-40,(bas-90)+150+giro*0.8,altura-pun-40+(150-giro)*0.2);
    strokeWeight(2);
    stroke(176,196,222);
    line(1.25*bas-90+150,altura-pun-40,2*(bas-90)+150+100-giro*0.8,altura-pun-40-(100-giro)*0.2);
    line(1.25*bas-90+150,altura-pun-40,(bas-90)+150+giro*0.8,altura-pun-40+(150-giro)*0.2);
    //link 4 garra
    
    stroke(0);
    strokeWeight(5);
    
    
}
void quadroInfoBraco()
{
    int t=millis()-tempo;    
    int[] pi = new int[2];
    pi[0] = largura/5;
    pi[1] = 0;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/5,altura/3);
    //criando titulo
    fill(0);
    textSize(altura/30);
    text("Info Manipulador",pi[0]+30,pi[1]+30);
    textSize(altura/42);
    text("Garra: ",pi[0]+30,pi[1]+70);
    text("Giro Garra: ",pi[0]+30,pi[1]+110);
    text("Ang. Base: ",pi[0]+30,pi[1]+150);
    text("Ang. punho: ",pi[0]+30,pi[1]+190);
    switch(contMB-1)
    {
       case 0://move base,giro e garra|| punho mantem
         
         if(t<(2*te/3))
         {
           giro =calculaAng(giroGarra[1],giroGarra[0]);
           bas = calculaAng(base[0],base[1]);
         }
         else
         {
           gar=calculaAngG(garra[1],garra[0]);
         }         
         break;
       case 1://move punho e garra || base e giro mantem
         
         if(t<(2*te/3))
         {
           pun=calculaAng(punho[0],punho[1]);
           
         }
         else
         {
           gar=calculaAngG(garra[0],garra[1]);
           
         }         
         break;
       case 2://garra nao move ||giro, base e punho movem se preciso
         
         if(t<(2*te/3))
         {
           pun=calculaAng(punho[1],90);
           bas=calculaAng(base[1],90);
           giro=calculaAng(giroGarra[0],90);
         }
         break;
       case 3://todos movem
         if(t<(2*te/3))
         {
           pun=calculaAng(90,punho[1]);
           bas=calculaAng(90,base[2]);
           giro=calculaAng(90,giroGarra[0]);
         }
         else
         {
           gar=calculaAngG(garra[1],garra[0]);
         } 
         break;
       case 4://punho move||base, giro e garra não
         if(t<(2*te/3))
         {
           pun=calculaAng(punho[1],punho[0]);
         }
         break;
       case 5://todos movem
         if(t<(2*te/3))
         {
           pun=calculaAng(punho[0],90);
           bas=calculaAng(base[2],90);
           giro=calculaAng(giroGarra[0],90);          
         }
         else
         {
           gar=calculaAngG(garra[1],garra[0]);
         } 
         break;           
    }    
    text(gar,pi[0]+150,pi[1]+70);
    text(giro,pi[0]+150,pi[1]+110);
    text(bas,pi[0]+150,pi[1]+150);
    text(pun,pi[0]+150,pi[1]+190);
    if(cont<100)
    {
        vecPunho[cont]=pun;
        vecGiro[cont]=giro;
        vecBase[cont]=bas;
        vecGarra[cont]=gar;
    }
    else
    {
         for(int i = 0;i<100;i++)
         {
              if(i<99)
              {
                  vecPunho[i]=vecPunho[i+1];
                  vecGiro[i]=vecGiro[i+1];
                  vecBase[i]=vecBase[i+1];
                  vecGarra[i]=vecGarra[i+1];
              }
              else
              {
                  vecPunho[i]=pun;
                  vecGiro[i]=giro;
                  vecBase[i]=bas;
                  vecGarra[i]=gar;
              }
         }
    }
}
int calculaAng(int i,int f)
{
    int t=millis()-tempo;
    int resposta=0;
    resposta = t*(f-i)/(2*te/3)+i;   
    return resposta;
}
int calculaAngG(int i,int f)
{
    int t=millis()-tempo;
    int resposta=0;
    resposta = (t-2*te/3)*(f-i)/(te/3)+i;   
    return resposta;
}
void quadroProgresso(String[] ac,int c)
{
    
    int t = millis()-tempo;
    int p=0;
    if(te>0)
    {
        p = t*100/te;
    }
    if(p>100)
    {
       p=100; 
    }
    int[] pi = new int[2];
    pi[0] = 2*largura/5;
    pi[1] = 0;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/5,altura/3);
    //criando titulo
    fill(0);
    textSize(altura/30);
    text("Progresso",pi[0]+80,pi[1]+30);
    textSize(altura/40);
    if(ac[c]!=null)
    {
        text(ac[c],pi[0]+130-ac[c].length()*4.8,pi[1]+120);
        //constroi barra
        rect(pi[0]+30,pi[1]+170,200,35,20);
        fill(0,255,0);
        rect(pi[0]+32.5,pi[1]+172,198*p/100,30,20);
        if(p<55)
        {
            fill(255);
        }
        else
        {
            fill(0); 
        }
        textSize(14);
        text(p,pi[0]+120,pi[1]+190);
    }
    fill(0);
}
void quadroGraficoManipulador()
{
    int[] pi = new int[2];
    pi[0] = 4*largura/5;
    pi[1] = 0;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/5,altura/3);
    //criando titulo
    fill(0);
    textSize(altura/40);
    text("Grafico Manipulador",pi[0]+35,pi[1]+30);
    criaGrid(pi[0],pi[1]);
    strokeWeight(1.5);
    int l  = (4*largura/5+20)+12;
    for(int i=0;i<99;i++)
    {
        stroke(255,0,0);
        line(l+i*2.02,20+altura/4-vecGarra[i]+10,l+(i+1)*2.02,20+altura/4-vecGarra[i+1]+10);
        
        stroke(0,100,0);
        line(l+i*2.02,20+altura/4-vecPunho[i]+10,l+(i+1)*2.02,20+altura/4-vecPunho[i+1]+10);
        
        stroke(0,0,255);
        line(l+i*2.02,20+altura/4-vecGiro[i]+10,l+(i+1)*2.02,20+altura/4-vecGiro[i+1]+10);
        
        stroke(199,21,133);
        line(l+i*2.02,20+altura/4-vecBase[i]+10,l+(i+1)*2.02,20+altura/4-vecBase[i+1]+10);
    }
    textSize(12);
    fill(255,0,0);
    text("Garra",pi[0]+50,20+altura/4-vecGarra[20]+7);
    text(int(vecGarra[0]),pi[0]+12,20+altura/4-vecGarra[0]+10);
    fill(0,100,0);
    text("Punho",pi[0]+100,20+altura/4-vecPunho[40]+7);
    text(int(vecPunho[0]),pi[0]+12,20+altura/4-vecPunho[0]+10);
    fill(0,0,255);
    text("Giro",pi[0]+150,20+altura/4-vecGiro[60]+7);
    text(int(vecGiro[0]),pi[0]+12,20+altura/4-vecGiro[0]+10);
    fill(199,21,133);
    text("Base",pi[0]+200,20+altura/4-vecBase[80]+7);
    text(int(vecBase[0]),pi[0]+12,20+altura/4-vecBase[0]+10);
    strokeWeight(5);
    stroke(0);
}
void quadroGraficoChassi()
{
    int[] pi = new int[2];
    pi[0] = 3*largura/5;
    pi[1] = 0;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/5,altura/3);
    //criando titulo
    fill(0);
    textSize(altura/40);
    text("Grafico Chassi",pi[0]+60,pi[1]+30);
    int l  = (3*largura/5+20)+12;
    
    criaGrid(pi[0],pi[1]);
    strokeWeight(1.5);
    for(int i=0;i<99;i++)
    {
        stroke(255,0,0);
        line(l+i*2.02,altura/6-vecVel[i]*3+10,l+(i+1)*2.02,altura/6-vecVel[i+1]*3+10);
        
        stroke(0,100,0);
        line(l+i*2.02,altura/6-vecAcel[i]*1.2+10,l+(i+1)*2.02,altura/6-vecAcel[i+1]*1.2+10);
        
        stroke(0,0,255);
        line(l+i*2.02,altura/6-vecAng[i]*1.5+10,l+(i+1)*2.02,altura/6-vecAng[i+1]*1.5+10);
    }
    textSize(12);
    fill(255,0,0);
    text("Vel.",pi[0]+50,altura/6-vecVel[20]*3+7);
    text(int(vecVel[0]),pi[0]+12,altura/6-vecVel[0]*3+10);
    fill(0,100,0);
    text("Acel.",pi[0]+100,altura/6-vecAcel[47]*1.2+7);
    text(int(vecAcel[0]),pi[0]+12,altura/6-vecAcel[0]*1.2+10);
    fill(0,0,255);
    text("Ang.",pi[0]+150,altura/6-vecAng[70]*1.5+7);
    if(vecAng[0]>0)
    {
        text(int(vecAng[0]),pi[0]+12,altura/6-vecAng[0]*1.5+10);
    }
    else
    {
        text(int(vecAng[0]),pi[0]+6,altura/6-vecAng[0]*1.5+10);
    }    
    stroke(0);
    strokeWeight(5);   
}
void criaGrid(int l,int a)
{
    strokeWeight(3);
    fill(211,211,211);
    rect(l+30,a+40,largura/6-10,altura/4);
    strokeWeight(1);
    stroke(169,169,169);
    for(int i=0;i<21;i++)
    {
       line(l+35+i*10,a+42,l+35+i*10,a+230);
       line(l+32,a+42+i*9.5,l+231,a+42+i*9.5);
    }
    fill(0);
}
void quadroInfoChassi(String info)
{
    int t = millis()-tempo;
    
    int ta = 600/45;
    int[] pi = new int[2];
    pi[0] = 0;
    pi[1] = 0;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/5,altura/3);
    //criando titulo
    fill(0);
    textSize(altura/30);
    text("Info Chassi",pi[0]+60,pi[1]+30);
    //escrevendo informações estaticas
    textSize(altura/42);
    text("Velocidade: ",pi[0]+30,pi[1]+70);
    text("Aceleração: ",pi[0]+30,pi[1]+110);
    text("Dist. Perc. : ",pi[0]+30,pi[1]+150);
    text("Angulação : ",pi[0]+30,pi[1]+190);    
    switch(info.charAt(0))
    {
       case 100:
         vel=0.0;
         acel=0.0;
         ang = t/ta;
         break;
       case 101:
         vel=0.0;
         acel=0.0;
         ang = -t/ta;
         break;
       case 102:
         if(t<=200||t>=te-200)
         {
             vel = 0.02*(100*(float)t/200);
             
         }
         else
         {
             vel = 15.0; 
         }
         acel = 75-vel*5;
         dist = 0.034*vel*t/1000 + dist;
         break;
       case 112:
         vel=0.0;
         acel=0.0;
         break;
    }
    if(cont<100)
    {
        vecVel[cont]=vel;
        vecAcel[cont]=acel;
        vecAng[cont]=ang;
    }
    else
    {
         for(int i = 0;i<100;i++)
         {
              if(i<99)
              {
                  vecVel[i] = vecVel[i+1];
                  vecAcel[i]=vecAcel[i+1];
                  vecAng[i]=vecAng[i+1];
              }
              else
              {
                  vecVel[i] = vel; 
                  vecAcel[i] = acel;
                  vecAng[i] = ang;
              }
         }
    }
    cont=cont+1;
    text(nf(vel,2,2)+" cm/s",pi[0]+140,pi[1]+70);
    if(int(acel)<0)
    {
        text(nf(acel,2,2)+ " cm/s²",pi[0]+130,pi[1]+110);
    }
    else
    {
        text(nf(acel,2,2)+ " cm/s²",pi[0]+140,pi[1]+110);
    }
    text(nf(dist,1,2)+" cm",pi[0]+140,pi[1]+150);
    text(nf(ang,1,2)+ "°",pi[0]+140,pi[1]+190); 
}
void quadroChassi(int direcao)
{
    
    int[] corMotor1 = new int[3];
    int[] corMotor2 = new int[3];
    int[] pi = new int[2];
    int d1=0,d2=0;//direção dos motores
    pi[0] = 0;
    pi[1] = altura/3;
    //criando retangulo
    strokeWeight(5);
    fill(214,220,228);
    rect(pi[0],pi[1],largura/4,altura/3);    
    //criando titulo
    fill(0);
    textSize(altura/30);
    text("Chassi",pi[0]+120,pi[1]+30);
    switch(direcao)
    {
       case 100:
         d1=1;
         d2=2;
         break;
       case 101:
         d1=2;
         d2=1;
         break;
       case 102://os dois motores estao trabalhando para frente
         d1=2;
         d2=d1;
         break;
       case 112:
       case 105:  
         d1=0;
         d2=d1;
         break;
    }
    //criando carro
    fill(235,199,158);
    strokeWeight(3); 
    //Criação das bases
    rect(pi[0]+70,pi[1]+180,largura/4-140,10,30);
    rect(pi[0]+70,pi[1]+130,largura/4-140,10,30);
    //criação dos motores
    //motor esquerda
    corMotor1 = corMotores(d1);
    fill(corMotor1[0],corMotor1[1],corMotor1[2]);
    rect(pi[0]+75,pi[1]+150,30,30);//base do motor 1
    fill(255);
    strokeWeight(1); 
    rect(pi[0]+75,pi[1]+150+12,-10,5);//eixo 1    
    //motor direita
    corMotor2 = corMotores(d2);
    strokeWeight(3); 
    fill(corMotor2[0],corMotor2[1],corMotor2[2]);
    rect(pi[0]+70+largura/4-140-35,pi[1]+150,30,30);//base do motor 2
    fill(255);
    strokeWeight(1); 
    rect(pi[0]+70+largura/4-140-35+30,pi[1]+150+12,10,5);//eixo 2
    
    //println(procExecucao());
    
    
    //criação das rodas
    strokeWeight(3); 
    fill(168,168,168);
    rect(pi[0]+75-10-30,pi[1]+100,30,120);
    rect(pi[0]+largura/4-75+10,pi[1]+100,30,120);
    //desenho dos pneus
    //pneu direita
    fill(0,0,0);
    
    if(d1==2)
    {
      pneuFrente(pi[0],pi[1],35); //pneu direita      
    }
    if(d1==1)
    {
      pneuTras(pi[0],pi[1],35);
    }
    if(d2==2)
    {
      pneuFrente(pi[0],pi[1],largura/4-65);//pneu esquerda
    }
    if(d2==1)
    {
      pneuTras(pi[0],pi[1],largura/4-65);//pneu esquerda
    }
    if(d1==d2&&d1==0)
    {
       for(int i=0;i<13;i++)
       {
         line(pi[0]+35,pi[1]+100+10*i,pi[0]+65,pi[1]+100+10*i);
         line(pi[0]+largura/4-65,pi[1]+100+10*i,pi[0]+largura/4-35,pi[1]+100+10*i);
       }
    }
    fill(255,255,0);
    rect(pi[0]+20,pi[1]+altura/3-25,15,15);
    fill(0);
    textSize(16);
    text("Parado",pi[0]+40,pi[1]+altura/3-11);
    fill(255,0,0);
    rect(pi[0]+130,pi[1]+altura/3-25,15,15);
    fill(0);
    text("Trás",pi[0]+150,pi[1]+altura/3-11);
    fill(0,255,0);
    rect(pi[0]+230,pi[1]+altura/3-25,15,15);
    fill(0);
    text("Frente",pi[0]+250,pi[1]+altura/3-11);
}
void pneuFrente(int l1,int a1,int v)
{  
  int linhaPneu = a1+x+100;
  x=x+1;
  for(int i=0;i<20;i++)
  {
      if((linhaPneu+10*i)>(a1+100) && (linhaPneu+10*i)<(a1+220))
      {
          line(l1+v,(linhaPneu+10*i),l1+v+30,(linhaPneu+10*i));
      }
  }
  for(int i=0;i<20;i++)
  {
      if((linhaPneu-10*i)>(a1+100) && (linhaPneu-10*i)<(a1+220))
      {
          line(l1+v,(linhaPneu-10*i),l1+v+30,(linhaPneu-10*i));
      }
  }
  //delay(1);
    
}
void pneuTras(int l1,int a1,int v)
{
  int linhaPneu = a1-x+220;
  x=x+1;
  for(int i=0;i<20;i++)
  {
      if((linhaPneu+10*i)>(a1+100) && (linhaPneu+10*i)<(a1+220))
      {
          line(l1+v,(linhaPneu+10*i),l1+v+30,(linhaPneu+10*i));
      }
  }
  for(int i=0;i<20;i++)
  {
      if((linhaPneu-10*i)>(a1+100) && (linhaPneu-10*i)<(a1+220))
      {
          line(l1+v,(linhaPneu-10*i),l1+v+30,(linhaPneu-10*i));
      }
  }
  //delay(1);
}
int[] corMotores(int direcao)
{
    int[] resp = new int[3];
    switch(direcao)
    {
       case 2:
         resp[0] = 0;
         resp[1] = 255;
         resp[2] = 0;
         break;
       case 1:
         resp[0] = 255;
         resp[1] = 0;
         resp[2] = 0;
         break;
       case 0:
         resp[0] = 255;
         resp[1] = 255;
         resp[2] = 0;
         break;
    }
    return resp;
}