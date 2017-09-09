-- file : config.lua

local module = {}

-- WIFI
module.WIFI = {}
module.WIFI.ssid = "XXX"
module.WIFI.pwd = "XXX"

-- SNTP
module.SNTP = {}
module.SNTP.server = "ntp1.sp.se"
module.SNTP.period = 3600
module.SNTP.timeout = 5

-- MQTT
module.MQTT = {}
module.MQTT.host = "X.X.X.X"  
module.MQTT.port = 1883
module.MQTT.client_id = node.chipid()
module.MQTT.keepalive = 120
module.MQTT.user = "XXX" 
module.MQTT.pwd = "XXX"
module.MQTT.timeout = 5

-- SDA and SCL can be assigned freely to available GPIOs
module.I2C = {}
module.I2C.sda = 5 -- GPIO14
module.I2C.scl = 6 -- GPIO12
module.I2C.speed = i2c.SLOW -- 100 kHz
  
return module
