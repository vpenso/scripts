#include "DHT.h"

#define SERIAL_BAUDRATE 9600
#define DHTPIN 8              // Connection pin of the Sensor
#define DHTTYPE DHT11         // Sensor type
#define DHT_READ_OK 0
#define DHT_READ_FAIL 1

float temperature;
float humidity;

DHT dht(DHTPIN, DHTTYPE);

int readDhtSensor(float* temperature, float* humidity) {
  *humidity = dht.readHumidity();
  *temperature = dht.readTemperature();
  if (*humidity == NAN || *temperature == NAN)
    return DHT_READ_FAIL;
  return DHT_READ_OK;
}

void setup() {
  Serial.begin(SERIAL_BAUDRATE);
  dht.begin();
}

void loop() {
  // Wait a few seconds between measurements.
  delay(2000);

  if (readDhtSensor(&temperature, &humidity) == DHT_READ_OK) {
    Serial.print("Humidity: ");
    Serial.print(humidity);
    Serial.print(" %\t");
    Serial.print("Temperature: ");
    Serial.print(temperature);
    Serial.print(" *C ");
  }
}
