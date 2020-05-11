import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float height_old = 0;
float height_new = 0;
float inByte = 0;
int BPM = 0;
int beat_old = 0;
int beats_length = 10;
float[] beats = new float[beats_length];  // Used to calculate average BPM
int beatIndex;
float threshold = 580.0;  //Threshold at which BPM calculation occurs
boolean belowThreshold = true;
PImage img;
int cd = 0;

void setup () {
  // set the window size:
  size(1000, 600);        
  // List all the available serial ports
  println(Serial.list());
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  //load image
  img = loadImage("heart.png");
  // set inital background:
  background(255);
}


void draw () {
  //Map and draw the line for new data point
  inByte = map(inByte, 0, 1023, 0, height);
  height_new = height - inByte; 
  if (cd == 1)
  {
    stroke(0, 0, 255);
  } else
  {
    stroke(255, 0, 0);
  }
  line(xPos - 1, height_old, xPos, height_new);
  height_old = height_new;

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(255);
  } else {
    // increment the horizontal position:
    xPos++;
  }
  fill(255);
  stroke(255);
  rect(10, 10, 250, 140);
  if (belowThreshold)
  {
    image(img, 30, 20, 130, 100);
  } else
  {
    image(img, 20, 10, 150, 120);
  }
  image(img, 30, 20, 130, 100);
  fill(0x00);
  textSize(30);
  if (BPM <= 500)
  {
    text("BPM: " + BPM, 30, 70);
  } else
  {
    text("BPM: ERROR", 30, 70);
  }
}


void serialEvent (Serial myPort) 
{
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) 
  {
    // trim off any whitespace:
    inString = trim(inString);
    // If leads off detection is true notify with blue line
    if (inString.equals("!")) 
    { 
      cd = 1;
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    // If the data is good let it through
    else 
    {
      cd = 0;
      inByte = float(inString); 

      // BPM calculation check
      if (inByte > threshold && belowThreshold == true)
      {
        calculateBPM();
        belowThreshold = false;
      } else if (inByte < threshold)
      {
        belowThreshold = true;
      }
    }
  }
}

void calculateBPM () 
{  
  int beat_new = millis();    // get the current millisecond
  int diff = beat_new - beat_old;    // find the time between the last two beats
  float currentBPM = 60000 / diff;    // convert to beats per minute
  beats[beatIndex] = currentBPM;  // store to array to convert the average
  BPM = int(currentBPM);

  float total = 0.0;
  for (int i = 0; i < beats_length; i++) {
    total += beats[i];
  }

  BPM = int(total / beats_length);
  beat_old = beat_new;
  beatIndex = (beatIndex + 1) % 10;  // cycle through the array instead of using FIFO queue
}
