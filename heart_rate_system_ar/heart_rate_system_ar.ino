int lof_pin = 10;
int rof_pin = 11;
int sound_pin = 9;
int led_pin = 8;

int beat_pulse;

int threshold = 580;

void setup() {
  // initialize the serial communication:
  Serial.begin(9600);
  pinMode(lof_pin, INPUT); // Setup for leads off detection LO +
  pinMode(rof_pin, INPUT); // Setup for leads off detection LO -
  pinMode(sound_pin, OUTPUT);
  pinMode(led_pin, OUTPUT);


}

void loop() {

  //read sensor value
  beat_pulse = analogRead(A0);

  if ((digitalRead(10) == 1) || (digitalRead(11) == 1)) {
    Serial.println('!');
  }
  else {
    // send the value of analog input 0:
    Serial.println(beat_pulse);
    if (beat_pulse >= threshold)
    {
      digitalWrite(sound_pin, HIGH);
      digitalWrite(led_pin, HIGH);
    }
    else
    {
      digitalWrite(sound_pin, LOW);
      digitalWrite(led_pin, LOW);
    }
  }
  //Wait for a bit to keep serial data from saturating c
  //  Serial.println(analogRead(A0));
  delay(1);
}
