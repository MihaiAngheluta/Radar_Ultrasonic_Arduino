//////////////////// Initializare /////////////////////
import processing.serial.*; 
import java.awt.event.KeyEvent; 
import java.io.IOException;

Serial myPort;
  
String Angle=""; // sirul de valori ale unghiului
String Distance=""; // sirul de valori ale distantei
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance; 
int counter=0;
int index2=0;
PFont orcFont;
///////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(750, 840); // dimensiunea radarului
  smooth();
  background(255, 120, 120);

 // myPort = new Serial(this,"COM5", 9600); // importare date de pe seriala COM6, 9600 baud
 // myPort.bufferUntil('.'); 
  orcFont = loadFont("OCRAExtended-30.vlw");
}
/////////////////////////////////////////////////////////////////////////////////////////////

//////////////// - Un fel de bucla principala - /////////////////
void draw() {
  fill(255, 120, 120);
  textFont(orcFont);
  noStroke();
  fill(0, 9); 
  rect(0, 0, width, height); 
  //background(80, 80, 80); 
  //fill(98, 245, 31); // green color - poate schimb culoarea

  drawRadar(); // sa apara radarul desenat
  drawLine(); // sa apara linia radarului
  drawObject(); // sa apara linia pentru obiectele detectate
  drawText(); // sa apara textul 
}
////////////////////////////////////////////////////////////////

///////////////////////////////////////// - Calcul date importate de pe seriala - ///////////////////////////////////////
void serialEvent (Serial myPort) { 
  data = myPort.readStringUntil('.'); // citeste sirul de date pana la caracterul "."
  data = data.substring(0, data.length()-1);

  counter = data.indexOf(","); // identifica caracterul ","
  Angle= data.substring(0, counter); // valorile pentru unghi sunt cele la 0 pana la caracterul "," 
  Distance= data.substring(counter+1, data.length()); // valorile pentru distanta sunt cele de dupa "," si pana la "."

  iAngle = int(Angle);
  iDistance = int(Distance);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////// - Desenare Radar - ////////////////////////////////
void drawRadar() {
  pushMatrix(); // intrare in matrice pentru scriere
  translate(width/2, height/2); 
  noFill(); // definește culoarea interioară a formelor. 
  strokeWeight(2);
  stroke(25, 180, 230); //setam culoarea pentru conturului cercului

  // Se deseneaza cercurile radarului
  arc(0, 0, (width*0.22), (width*0.22), 0, TWO_PI);
  arc(0, 0, (width*0.45), (width*0.45), 0, TWO_PI);
  arc(0, 0, (width*0.66), (width*0.66), 0, TWO_PI);
  arc(0, 0, (width*0.88), (width*0.88), 0, TWO_PI); 
  //arc(0, 0, (width), (width), 0, TWO_PI);

  // Se deseanza liniile radarului
  line(-width/2.1, 0, width/2.1, 0);
  line(0, 0, (-width/2.1)*cos(radians(30)), (-width/2.1)*sin(radians(30)));
  line(0, 0, (-width/2.1)*cos(radians(60)), (-width/2.1)*sin(radians(60)));
  line(0, 0, (-width/2.1)*cos(radians(90)), (-width/2.1)*sin(radians(90)));
  line(0, 0, (-width/2.1)*cos(radians(120)), (-width/2.1)*sin(radians(120)));
  line(0, 0, (-width/2.1)*cos(radians(150)), (-width/2.1)*sin(radians(150)));
  line(0, 0, (-width/2.1)*cos(radians(180)), (-width/2.1)*sin(radians(180)));
  line(0, 0, (-width/2.1)*cos(radians(210)), (-width/2.1)*sin(radians(210)));
  line(0, 0, (-width/2.1)*cos(radians(240)), (-width/2.1)*sin(radians(240)));
  line(0, 0, (-width/2.1)*cos(radians(270)), (-width/2.1)*sin(radians(270)));
  line(0, 0, (-width/2.1)*cos(radians(300)), (-width/2.1)*sin(radians(300)));
  line(0, 0, (-width/2.1)*cos(radians(330)), (-width/2.1)*sin(radians(330)));
  line(0, 0, (-width/2.1)*cos(radians(360)), (-width/2.1)*sin(radians(360)));
  line((-width/2.1)*cos(radians(30)), 0, width/2.1, 0);
  popMatrix(); // iesire din matrice
} 
//////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////// - Desenare Linie Obiect - ///////////////////////////////////////////////////////////////////////////
void drawObject() {
  pushMatrix();
  translate(width/2, height/2);
  strokeWeight(20);
  stroke(255, 10, 10); // red color
  pixsDistance = ((iDistance*height*0.1)/10); //37.795275591
  
  if (iDistance<=50) {
 // line(-pixsDistance*sin(radians(iAngle)),pixsDistance*cos(radians(iAngle)),(height-height*0.505)*sin(radians(iAngle)), (height-height*0.505)*cos(radians(iAngle)));
  point (pixsDistance*sin(radians(iAngle)),pixsDistance*cos(radians(iAngle)));
}
  popMatrix();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////// - Desenare linie care se va plimba - //////////////////////////////
void drawLine() { 
  pushMatrix(); //intrare in matrice
  strokeWeight(10); //grosimea liniei 
  stroke(25, 180, 230); //blue color
  translate(width/2, height/2);
  line(0, 0, (height-height*0.505)*sin(radians(iAngle)), (height-height*0.505)*cos(radians(iAngle)));
 // line(0,0,(height-height*0.505)*sin(radians(iAngle)),-(height-height*0.505)*cos(radians(iAngle))); // draws the line according to the angle

  popMatrix(); //iesire din matrice
}
/////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////// - Scriere Text - ///////////////////////////////////////
void drawText() {
  pushMatrix();
  
  if (iDistance>=50) { // daca distanta >= 50
    noObject = "Out of Range"; // afisare "in afara intervalului"
  } else { // daca distanta <= 50
    noObject = "In Range"; // afisare "in interval"
  }

/////////////////// - Text pentru distanta "cm" - /////////////////
  fill(80, 80, 80); //culoare patratel in care sunt aratate masuratorile
  noStroke();
  rect(0, 0, width*0.28, height*0.13); // dimensiunea patratelului
  fill(25, 180, 230);
  textSize(10);
  
  text("10cm", width-width*0.38, height*0.49); // text cu 10 cm
  text("10cm", width-width*0.60, height*0.49); // text cu 10 cm
  text("10cm", width-width*0.49, height*0.39); // text cu 10 cm
  text("10cm", width-width*0.49, height*0.62); // text cu 10 cm
  
  text("20cm", width-width*0.27, height*0.49); // text cu 20 cm
  text("20cm", width-width*0.72, height*0.49); // text cu 20 cm
  text("20cm", width-width*0.49, height*0.29); // text cu 20 cm
  text("20cm", width-width*0.49, height*0.72); // text cu 20 cm
  
  text("30cm", width-width*0.16, height*0.49); // text cu 30 cm
  text("30cm", width-width*0.82, height*0.49); // text cu 30 cm
  text("30cm", width-width*0.49, height*0.20); // text cu 30 cm
  text("30cm", width-width*0.49, height*0.81); // text cu 30 cm

  text("40cm", width-width*0.05, height*0.49); // text cu 40 cm
  text("40cm", width-width*0.93, height*0.49); // text cu 40 cm
  text("40cm", width-width*0.49, height*0.10); // text cu 40 cm
  text("40cm", width-width*0.49, height*0.91); // text cu 40 cm  
 // text("50cm", width-width*0.07, height*0.49); // text cu 50 cm
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////// - Text pentru masuratori - ///////////////////////////////////////////////////////////////
  fill(25, 180, 230);
  textSize(16);
  text("Measurements: ", width*0.01, height*0.03);
  textSize(14);
  text("Object: " + noObject, width*0.01, height*0.06); 
  text("Angle: " + iAngle +" °", width*0.01, height*0.09); // afiseaza unghiul impreuna cu valorile importante exprimate in grade
  text("Distance: " + iDistance + " cm", width*0.01, height*0.12); // afiseaza distanta impreuna cu valorile importante exprimate in cm
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////// - Text pentru grade - ///////////////////////////////////////////////////////////
  textSize(25);
  fill(25, 180, 230);
  
  translate((width-width*0.1800)+width/2*cos(radians(150)), (height-height*(-0.2000))-width/2*sin(radians(150))); // locatia textului
  rotate(radians(360)); // textul este rotit la 360 grade
  text("360°/0°", 0, 0); // afiseaza 360/0 grade
  resetMatrix(); 
  
  translate((width-width*0.6994)+width/2*cos(radians(30)), (height-height*(-0.125))-width/2*sin(radians(30))); // locatia textului
  rotate(radians(360));
  text("30°", 0, 0); // afiseaza 30 grade
  resetMatrix();
  
  translate((width-width*0.500)+width/2*cos(radians(30)), (height-height*0.0374)-width/2*sin(radians(30))); // locatia textului
  rotate(-radians(360));
  text("60°", 0, 0); // afiseaza 60 grade
  resetMatrix();
  
  translate((width-width*0.022)+width/2*cos(radians(90)), (height-height*0.0830)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(-90));
  text("90°", 0, 0); // afiseaza 90 grade
  resetMatrix();
  
  translate((width-width*0.08500)+width/2*cos(radians(90)), (height-height*0.270)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(0));
  text("120°", 0, 0); // afiseaza 120 grade
  resetMatrix();
  
  translate((width-width*0.2590)+width/2*cos(radians(90)), (height-height*0.430)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(0));
  text("150°", 0, 0); // afiseaza 150 grade
  resetMatrix();
  
  translate((width-width*0.5490)+width/2*cos(radians(90)), (height-height*0.490)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(0));
  text("180°", 0, 0); // afiseaza 180 grade
  resetMatrix();

  translate((width-width*0.7690)+width/2*cos(radians(90)), (height-height*0.450)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(0));
  text("210°", 0, 0); // afiseaza 210 grade
  resetMatrix();

  translate((width-width*0.945)+width/2*cos(radians(90)), (height-height*0.24)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(60));
  text("240°", 0, 0); // afiseaza 240 grade
  resetMatrix();

  translate((width-width*0.980)+width/2*cos(radians(90)), (height-height*0.0200)-width/2*sin(radians(90))); // locatia textului
  rotate(-radians(90));
  text("270°", 0, 0); // afiseaza 270 grade
  resetMatrix();

  translate((width-width*0.5400)+width/2*cos(radians(150)), (height-height*0.0374)-width/2*sin(radians(150))); // locatia textului
  rotate(radians(360));
  text("300°", 0, 0); // afiseaza 300 grade
  resetMatrix();

  translate((width-width*0.3750)+width/2*cos(radians(150)), (height-height*(-0.125))-width/2*sin(radians(150))); // locatia textului
  rotate(radians(360));
  text("330°", 0, 0); // afiseaza 360 grade
  resetMatrix();
  popMatrix();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////