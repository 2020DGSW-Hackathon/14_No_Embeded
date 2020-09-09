
#include <SPI.h>
#include <Ethernet.h>
#include <ArduinoJson.h>
#include <DHT.h>
#include <LiquidCrystal_I2C.h>
#define DHTPin 7 // 온습도 data pin
#define DHTTYPE DHT11 // DHT11시리즈 select.

#define ledPin 8 // led핀

#define SDA A4 // LCD SDA핀
#define SCL A5 // LCD SCL핀

#define gasPin A0

DHT dht(DHTPin, DHTTYPE);

LiquidCrystal_I2C lcd(0x27, 20, 4);

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

char server[] = "192.168.43.240";    // name address for Google (using DNS)
IPAddress ip(192, 168, 137, 1);
IPAddress myDns(8, 8, 4, 4);

EthernetClient client;
char receive = 0;

extern volatile unsigned long timer0_millis;

int humi = dht.readHumidity();;
int temp = dht.readTemperature();
int gas = 0;

int p_humi = 0;
int p_temp = 0;
int p_gas = 0;

void getData () {
  if (receive == 1) return;
  if (client.connect(server, 3000)) {
    Serial.print("connected to ");
    Serial.println(client.remoteIP());
    // Make a HTTP request:
    client.println("GET /datas HTTP/1.1");
    client.println("Host: 192.168.43.240");
    client.println("Connection: close");
    client.println();
    receive = 1;
  }
}
void updateData() {
  const size_t capacity = JSON_OBJECT_SIZE(3);
  DynamicJsonDocument doc(capacity);
  doc["temp"] = temp;
  doc["hum"] = humi;
  doc["gas"] = gas;
  if (client.connect(server, 3000)) {
    Serial.println("Connected to " + String(client.remoteIP()));
    client.println("POST /updatedata HTTP/1.0");
    client.println("Host: 192.168.43.240");
    client.println("User-Agent: Arduino/1.0");
    client.println("Content-Type: application/json;charset=UTF-8");
    client.print("Content-Length: ");
    client.println(measureJson(doc));
    client.println("Conenction: close");
    client.println();
    serializeJson(doc, client);
    Serial.println("OK");
  } else {
    Serial.println("OOPS Some error...");
  }
}
void sendData(double temp, double hum, double gas) {
  const size_t capacity = JSON_OBJECT_SIZE(3);
  DynamicJsonDocument doc(capacity);
  doc["temp"] = temp;
  doc["hum"] = hum;
  doc["gas"] = gas;
  if (client.connect(server, 3000)) {
    Serial.println("Connected to " + String(client.remoteIP()));
    client.println("POST /datas/add HTTP/1.0");
    client.println("Host: 192.168.43.240");
    client.println("User-Agent: Arduino/1.0");
    client.println("Content-Type: application/json;charset=UTF-8");
    client.print("Content-Length: ");
    client.println(measureJson(doc));
    client.println("Conenction: close");
    client.println();
    serializeJson(doc, client);
    Serial.println("Send data to server~!");
  } else {
    Serial.println("OOPS Some error...");
  }
}

void setup() {
  Serial.begin(9600);
  while (!Serial);
  Serial.println("Initialization....");
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    if (Ethernet.hardwareStatus() == EthernetNoHardware) {
      Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
      while (true) {
        delay(1);
      }
    }
    if (Ethernet.linkStatus() == LinkOFF) {
      Serial.println("Ethernet cable is not connected.");
    }
    Ethernet.begin(mac, ip, myDns);
  } else {
    Serial.print("  DHCP assigned IP ");
    Serial.println(Ethernet.localIP());
  }
  
  // give the Ethernet shield a second to initialize:
  delay(1000);
  pinMode(ledPin  , OUTPUT);
  lcd.begin();
  lcd.backlight();
  lcd.clear();
  //    sendData(23, 12, 1);

  //  sendData(10, 10, 10);
  getData();
}
unsigned long current_millis_update_hum = 0;
unsigned long previous_millis_update_hum = 0;

unsigned long current_millis_upload = 0;
unsigned long previous_millis_upload = 0;
unsigned long cnt = 1000 * 60 * 60 * 24;


void loop() {
  current_millis_update_hum = current_millis_upload = millis();
  //  int len = client.available();
  //  if (receive == 1 && len > 0) {
  //    byte buf[80];
  //    if (len > 80) len = 80;
  //    client.read(buf, len);
  //    Serial.write(buf, len);
  //  }
  //  if (!client.connected()) receive = 0;
  if ((millis() / 1000.0) >  (60 * 60 * 24)) // Millis overflow calculate
  {
    timer0_millis = 0;
    current_millis_update_hum = 0;
    previous_millis_update_hum = 0;
    current_millis_upload = 0;
    previous_millis_upload = 0;
  }
  if (current_millis_update_hum - previous_millis_update_hum > 1000) {
    previous_millis_update_hum = current_millis_update_hum;
    digitalWrite(SDA, HIGH);
    //=====================================================
    //온습도
    humi = dht.readHumidity();
    temp = dht.readTemperature();
    gas = analogRead(gasPin);
    if(humi > p_humi) {
      p_humi = humi;
      sendData(temp, humi, gas);
    }
    if(temp > p_temp) {
      p_temp = temp;
      sendData(temp, humi, gas);
    }
    if(gas > p_gas) {
      p_gas = gas;
      sendData(temp, humi, gas);
    }
    if (gas > 600 || temp > 40) {
      ledOn();
    } else {
      ledOff();
    }
    //=====================================================
    lcd.clear();
    printGas();
    printTemp();
    printHum();
    //=====================================================
    updateData();
    Serial.print("습도");
    Serial.println(humi);

    Serial.print("온도:");
    Serial.println(temp);

    Serial.println();
    Serial.print("남은 시간 : ");
    Serial.println(30000 - current_millis_upload - previous_millis_upload);
    Serial.print("Current millis : ");
    Serial.println(millis());
    //=====================================================
    
  }
  if (current_millis_upload - previous_millis_upload > 30000) {
    previous_millis_upload = current_millis_upload;
    sendData(temp, humi, gas);
  }

}
void printHum() { // 습도 값 출력
  lcd.setCursor(8, 1);
  lcd.print("Humi:");
  lcd.setCursor(13, 1);
  lcd.print(humi);

}

void printTemp() {// 온도 값 출력
  lcd.setCursor(0, 1);
  lcd.print("temp:");
  lcd.setCursor(5, 1);
  lcd.print(temp);
}

int printGas() { // gas 값 출력
  lcd.setCursor(0, 0);
  lcd.print("Gas:");
  lcd.print(gas);
  Serial.println(analogRead(gasPin));
  return gas;
}
void ledOn() {
  digitalWrite(ledPin, HIGH);
}

void ledOff() {
  digitalWrite(ledPin, LOW);
}