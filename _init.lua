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
	
		--t = {}
		--rh = {}
	
		-- Take three samples (unrolled loop)
		--rh[1], t[1] = am2320.read()
		--rh[2], t[2] = am2320.read()
		--rh[3], t[3] = am2320.read()
		
		--t_mean = ((t[1] + t[2] + t[3]) / 3) / 10
		--rh_mean = ((rh[1] + rh[2] + rh[3]) / 3) / 10
		
		rh_mean, t_mean = am2320.read()
		
		rh_mean = rh_mean / 10
		t_mean = t_mean / 10
		
		print("\n\tAM2320 - SAMPLED".."\n\t\Temperature: "..string.format("%s degrees C", t_mean).."\n\t\RH: "..string.format("%s%%", rh_mean))

		payload = "{ \"temp\":"..(t_mean)..", \"RH\":"..(rh_mean).." }"
		
		mqttd.publish("nodemcu/am2320", payload)
	else
	
		print("\n\tAM2320 - FAILED")
	end
end	

sample_tmr = tmr.create()
sample_tmr:register(30 * 1000, tmr.ALARM_AUTO, function (t) sample() end)
sample_tmr:start()