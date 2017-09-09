-- file: init.lua

local config = require("config")
local wireless = require("wireless")
local sntpd = require("sntpd")
local mqttd = require("mqttd")

wireless.start(config.WIFI)
sntpd.start(config.SNTP)
mqttd.start(config.MQTT)

i2c.setup(0, config.I2C.sda, config.I2C.scl, config.I2C.speed) 
am2320.setup()
	
function sample()
	
	if wireless.is_ready() == true and mqttd.is_ready() == true then
		
		rh, t = am2320.read()
		
		rh = rh / 10
		t = t / 10
		
		print("\n\tAM2320 - SAMPLED".."\n\t\Temperature: "..string.format("%s degrees C", t).."\n\t\RH: "..string.format("%s%%", rh))

		payload = "{ \"temp\":"..(t)..", \"RH\":"..(rh).." }"
		
		mqttd.publish("nodemcu/am2320", payload)
	else
	
		print("\n\tMQTT - Not Ready")
	end
end	

sample_tmr = tmr.create()
sample_tmr:register(30 * 1000, tmr.ALARM_AUTO, function (t) sample() end)
sample_tmr:start()
