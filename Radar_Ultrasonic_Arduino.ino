/////////////////////////////// - Initializare - /////////////////////////
#include <LiquidCrystal.h> // libraria pentru lcd
#include <Ultrasonic.h> // libraria pentru senzorul ultrasonic
 
#define TrigPin 11 
#define EchoPin 12
#define BuzzerPin 4
#define LedRosu 3
#define LedAlbastru 2
 
const int rs = 5, en = 6, d4 = 7, d5 = 8, d6 = 9, d7 = 10;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);
 
int IN1 = 18;
int IN2 = 17;
int IN3 = 16;
int IN4 = 15;

int sensor = 14;
int maxRot = 2048; //nr. maxim de rotatii pentru 0-360 grade
//float gradRot = 0.176; //motorul executa 0.175 grade pe o rotatie
int counter = 0; //se porneste de la pasul 0
//////////////////////////////////////////////////////////////////////////

///////////////// - Setarea porturilor ca intrare/iesire - ///////////////
void setup() {
    Serial.begin (9600); //porneste seriala cu o rata de 9600 biti/s
    pinMode(TrigPin, OUTPUT);
    pinMode(EchoPin, INPUT);
    pinMode(3, OUTPUT);
    pinMode(2, OUTPUT);

    pinMode(IN1, OUTPUT);
    pinMode(IN2, OUTPUT);
    pinMode(IN3, OUTPUT);
    pinMode(IN4, OUTPUT);
    pinMode(14, INPUT);    
}
///////////////////////////////////////////////////////////////////////////


///////////////////////// - Variabile pentru sensul de rotatie de inceput si resetarea pozitiei- //////////////////
  bool spin_direction = true; // false = right , true = left
  bool position_reset = false; //resetarea pozitiei este false pana in momentul detectarii senzorului Hall
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////// - Bucla continua - ////////////////////////////////////////////////
 void loop (){    
  if (!position_reset) //daca nu s-a setat pozitia de 0 grade
  {
    display_start(); //afiseaza titlul proiectului
  }
   else //altfel afiseaza distanta si gradele obiectelor detectate
  {
    digitalWrite(TrigPin, LOW); //scrie valoarea minima a lui trig
    delayMicroseconds(2); // 2 us
    digitalWrite(TrigPin, HIGH); //scrie valoarea maxima a lui trig
    delayMicroseconds(10); // 10us
    digitalWrite(TrigPin, LOW);

    ////////////////// - Calcule pentru distanta si grade - //////////////////////////
    long duration = pulseIn(EchoPin, HIGH); //viteza maxima a impulsului ecoului
    long distance = (duration*0.034) / 2; //calculeaza distanta
    //long degrees = gradRot * counter; //grade = gradul de rotatie * secventa
    long degrees = (360.0 * (counter / 2048.0)); 
    /////////////////////////////////////////////////////////////////////////////////
    
   if (!spin_direction) // daca s-a schimbat sensul de rotatie
    {
     degrees = 360 - degrees; //afiseaza gradele invers, adica de la 360 la 0 grade
     Serial.print(degrees);
     Serial.print(",");
     Serial.print(distance);
     Serial.print(".");
    }
     distance_display(distance, degrees); // altfel afiseaza distanta si gradele
     Serial.print(degrees);
     Serial.print(",");
     Serial.print(distance);
     Serial.print(".");
  } 
  
    if(!position_reset && sensor_detect())  //daca se detecteaza senzorul Hall si nu e schimbata pozitia 
    {
        counter = 0; // porneste de la rotatia 0 a motorului
        position_reset = true; // seteaza pozitia in acel punct
        stop_motor(); // opreste motorul in acel punct
        Serial.print(counter); // afiseaza punctul
        //Serial.println(" - Resetting position-"); // afiseaza textul "-Resetting position" pe seriala       
    }
        motor(spin_direction); //altfel, daca nu s-a detectat senzorul, invarte motorul
        counter = counter + 4; // executa cele 4 secvente ale motorului
        
    if (counter == maxRot) // daca motorul a ajuns la nr. maxim de rotatii adica la 1700 de pasi
    {
        delay(1000); // fa o pauza de 1 secunde dupa ce ai efectuat 1700 depasi
        counter = 0; // reseteaza nr. de pasi
        spin_direction = !spin_direction; //inverseaza sensul de roatatie
    }
 }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////// - Variabila pentru senzorul Hall - //////////////////////////////////////////////   
bool sensor_detect(){
    if (digitalRead(14) == HIGH) //daca senzorul Hall nu detecteaza magnetul 
       {return false;} //returneaza false, adica nu s-a detectat magnetul, deci invarte motorul normal
        else {return true;} //returneaza true, adica s-a detectat magnetul, deci porneste rotatia de la 0-360 grade
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////// - Oprire motor - ////////////////////
void stop_motor(){
  int IN1 = 18;
  int IN2 = 17;
  int IN3 = 16;
  int IN4 = 15;
  
  digitalWrite (IN1, LOW);
  digitalWrite (IN2, LOW);
  digitalWrite (IN3, LOW);
  digitalWrite (IN4, LOW);
  delay(1000); //tine-l oprit 1 secunda
}
/////////////////////////////////////////////////////


////////////////////// - Stabilirea sensului de rotatie (mai intai spre stanga, apoi spre dreapta - /////////////////
void motor(bool direction){
    if (direction) //daca numarul de rotatii este zero, motorul se roteste spre stanga
    {
      IN1 = 18;
      IN2 = 17;
      IN3 = 16;
      IN4 = 15;    
    }
    else  //altfel motorul se roteste spre dreapta
    {  
      IN1 = 15;
      IN2 = 16;
      IN3 = 17;
      IN4 = 18; 
    }
  ///// - Cele 4 secvente in care lucreaza motorul - ////////      
     digitalWrite(IN1, LOW); 
     digitalWrite(IN2, LOW);
     digitalWrite(IN3, LOW);
     digitalWrite(IN4, HIGH);
     delay(3);
  
     digitalWrite(IN1, LOW); 
     digitalWrite(IN2, LOW);
     digitalWrite(IN3, HIGH);
     digitalWrite(IN4, HIGH);
     delay(3);

     digitalWrite(IN1, LOW); 
     digitalWrite(IN2, LOW);
     digitalWrite(IN3, HIGH);
     digitalWrite(IN4, LOW);
     delay(3);
     
     digitalWrite(IN1, LOW); 
     digitalWrite(IN2, HIGH);
     digitalWrite(IN3, HIGH);
     digitalWrite(IN4, LOW);
     delay(3);
     
     digitalWrite(IN1, LOW); 
     digitalWrite(IN2, HIGH);
     digitalWrite(IN3, LOW);
     digitalWrite(IN4, LOW);
     delay(3);
     
     digitalWrite(IN1, HIGH); 
     digitalWrite(IN2, HIGH);
     digitalWrite(IN3, LOW);
     digitalWrite(IN4, LOW);
     delay(3);
     
     digitalWrite(IN1, HIGH); 
     digitalWrite(IN2, LOW);
     digitalWrite(IN3, LOW);
     digitalWrite(IN4, LOW);
     delay(3);
     
     digitalWrite(IN1, HIGH); 
     digitalWrite(IN2, LOW);
     digitalWrite(IN3, LOW);
     digitalWrite(IN4, HIGH);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////// - Secventa pentru detectarea obiectelor - ///////////// 
void distance_display(int distance, int deg){   
    if (distance <= 20){
        alarm();
        lcd.begin (16, 2);
        lcd.setCursor(0,0);
        lcd.print("Object Detected ");
        delay(1000);
        lcd.begin (16, 2);
        lcd.setCursor(0,0);
        lcd.print("Distance: ");
        lcd.print(distance);
        lcd.print(" cm");
        lcd.setCursor(0,1);
        lcd.print("Angle:   ");
        lcd.print(deg);
        lcd.print((char)223);
        Serial.println("Distance -    cm"); 
        Serial.print(distance);  
        Serial.println("Angle - ");
        Serial.print((char)223);
        Serial.print(deg);
        delay(1000); 
    } 
    else{
        lcd.begin (16, 2);
        lcd.setCursor(3,0);
        lcd.print("No Object");
        lcd.setCursor(4,1);
        lcd.print("Detected");
        digitalWrite(LedAlbastru, HIGH);
        digitalWrite(LedRosu,LOW);
    }
}
//////////////////////////////////////////////////////////////////////


////////////////////// - Alarma - ////////////////////////
void alarm(){
    tone(4, 500, 500);
    delay(2);
    digitalWrite(3, HIGH);
    digitalWrite(2, LOW);
    delay(50);
}
//////////////////////////////////////////////////////////


/////// - Afisare titlu la inceputul programului - //////
void display_start (){
    lcd.begin(16, 2);
    lcd.clear();
    lcd.begin (16, 2);
    lcd.setCursor(0,0);
    lcd.print("Radar Ultrasonic");
    lcd.setCursor(4,1);
    lcd.print("Arduino");
}
/////////////////////////////////////////////////////////
