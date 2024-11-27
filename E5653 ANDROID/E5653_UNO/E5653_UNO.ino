#include "lcd.h"

#define MQ3 A0
#define MQ4 A1
#define PushButton 2
#define Relay 3

#include <ultrasonic.h>
ULTRASONIC U1;

int AndroidSendCount;
bool flag = false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  lcd.begin(16, 2);
  U1.begin(4, 5);

  pinMode(MQ3, INPUT);
  pinMode(MQ4, INPUT);
  pinMode(PushButton, INPUT_PULLUP);
  pinMode(Relay, OUTPUT);

  digitalWrite(Relay, LOW);

  lcd.clear();
  lcd.setCursor(0, 1);
  lcd.print(" Oil Lkge Dtctn");
  delay(2000);

}

void loop() {
  // put your main code here, to run repeatedly:
  if (flag == true) {
    flag = false;
    digitalWrite(Relay, LOW);
  }
  int cm = U1.ultra();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("lpg:" + String(analogRead(MQ3)));
  lcd.setCursor(8, 0);
  lcd.print("Mthn:" + String(analogRead(MQ4)));
  lcd.setCursor(0, 1);
  lcd.print("Level:" + String(cm));
  AndroidSendCount++;
  if (AndroidSendCount == 30) {
    AndroidSendCount = 0;
    //    int cm = U1.ultra();
    Serial.print("@" + String(analogRead(MQ3)) + "#" + "$" + String(analogRead(MQ4)) + "#");
    Serial.print("&" + String(cm) + "#");
  }
  if (digitalRead(PushButton) == 0) {
    flag = true;
    digitalWrite(Relay, HIGH);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Checking Leakage");
    lcd.setCursor(0, 1);
    lcd.print("Level:" + String(U1.ultra()));
    delay(2000);
    if (U1.ultra() > 30) {
      Serial.write("*System alert: Oil leak identified. Please investigate and resolve.#");
      lcd.clear();
      lcd.setCursor(0, 1);
      lcd.print("  Oil Leaking");
      delay(2000);
    }
    else {
//      Serial.write("*The oil container is securely sealed, ensuring no leakage.#");
      lcd.clear();
      lcd.setCursor(0, 1);
      lcd.print("Oil Not Leaking");
      delay(2000);
    }
  }
  delay(1000);
}
