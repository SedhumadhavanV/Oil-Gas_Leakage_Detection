#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "E5653"
#define WIFI_PASSWORD "12345678"

// Insert Firebase project API Key
#define API_KEY "AIzaSyCDRZFPX4dchht4o_Ay_1gw39XkIaFmAF8"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://gasleakage-5ea04-default-rtdb.firebaseio.com/"

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

bool fromflag = false;
bool toflag = false;
bool locationflag = false;
bool percentflag = false;
bool tempflag = false;
bool vehiclestatusflag = false;


String from = "", To = "", LocationStatus = "accept", percent = "", Temperature = "", VehicleStatus = "accept";


void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  while (Serial.available() > 0)
  {
    char inchar = Serial.read();
    if (inchar == '*')
    {
      while (Serial.available() > 0)
      {
        char t = Serial.read();
        if (t == '#') {
          fromflag = true;
          Serial.println("alert:" + String(from));
          break;
        }
        from += t;
      }
    }
    if (inchar == '@')
    {
      while (Serial.available() > 0)
      {
        char h = Serial.read();
        if (h == '#') {
          toflag = true;
          Serial.println("lpg" + String(To));
          break;
        }
        To += h;
      }
    }
    if (inchar == '$')
    {
      while (Serial.available() > 0)
      {
        char l = Serial.read();

        if (l == '#') {
          percentflag = true;
          Serial.println("methane:" + String(percent));

          break;
        }
        percent += l;
      }
    }
    if (inchar == '&')
    {
      while (Serial.available() > 0)
      {
        char n = Serial.read();


        if (n == '#') {
          tempflag = true;
          Serial.println("level:" + String(Temperature));

          break;
        }
        Temperature += n;
      }
    }
    Serial.println();
  }

  if (fromflag == true) {
    locationflag = true;
  }
  //  if (percentflag == true && tempflag == true) {
  //    vehiclestatusflag = true;
  //  }

  //Serial.print("AAA");
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    // Write an Int number on the database path test/int
    //    Serial.println("PASSED");
    if (fromflag == true) {
      fromflag = false;
      if (Firebase.RTDB.setString(&fbdo, "Alert/value/message", from)) {
        Serial.println("PASSED  alert");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
        from = "";
      }
    }
    else {
      Serial.println("FAILED    alert");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    if (toflag == true) {
      toflag = false;
      if (Firebase.RTDB.setString(&fbdo, "monitoring/level/lpg", To)) {
        Serial.println("PASSED   lpg");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
        To = "";
      }
    }
    else {
      Serial.println("FAILED   lpg");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    if (locationflag == true) {
      locationflag = false;
      if (Firebase.RTDB.setString(&fbdo, "Alert/value/status", LocationStatus)) {
        Serial.println("PASSED  location Status");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
      }
    }
    else {
      Serial.println("FAILED    location status");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    if (percentflag == true) {
      percentflag = false;
      if (Firebase.RTDB.setString(&fbdo, "monitoring/level/methane", percent)) {
        Serial.println("PASSED   methane");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
        percent = "";
      }
    }
    else {
      Serial.println("FAILED     methane");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    //    if (vehiclestatusflag == true) {
    //      vehiclestatusflag = false;
    //      if (Firebase.RTDB.setString(&fbdo, "sensorvalue/values/status", VehicleStatus)) {
    //        Serial.println("PASSED   vehiclestatus");
    //        Serial.println("PATH: " + fbdo.dataPath());
    //        Serial.println("TYPE: " + fbdo.dataType());
    //      }
    //    }
    //    else {
    //      Serial.println("FAILED   vehiclestatus");
    //      Serial.println("REASON: " + fbdo.errorReason());
    //    }
    if (tempflag == true) {
      tempflag = false;
      if (Firebase.RTDB.setString(&fbdo, "oillevel/value/oil", Temperature)) {
        Serial.println("PASSED    level");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
        Temperature = "";
      }
    }
    else {
      Serial.println("FAILED   level");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
  delay(4000);
}
