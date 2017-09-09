-- file: mqttd.lua

local module = {}

module.MQTT_DISCONNECTED = 0
module.MQTT_CONNECTED = 1
module.MQTT_FAILED = 2

local m = nil

local host = nil
local port = nil
local timeout = nil

local publish_ack = nil

local state = module.MQTT_DISCONNECTED

function module.is_ready()

	return state == module.MQTT_CONNECTED
end

function module.start(mqtt_cfg)

	host = mqtt_cfg.host
	port = mqtt_cfg.port
	timeout = mqtt_cfg.timeout
	
	publish_ack = 0

	-- init mqtt client with logins and keepalive timer
	m = mqtt.Client(mqtt_cfg.client_id, mqtt_cfg.keepalive, mqtt_cfg.user, mqtt_cfg.pwd)
	
	module.connect()
end

function module.connect()

	m:connect(host, port,
	function(client)
		print("\n\tMQTT - CONNECTED")
		state = module.MQTT_CONNECTED
	end,
	function(client, reason)
		print("\n\tMQTT - FAILED\n\tReason: "..reason)
		state = module.MQTT_FAILED
		tmr.create():alarm(timeout * 1000, tmr.ALARM_SINGLE, module.connect)
	end)
end

function module.disconnect()

	if m:close() == true then
	
		state = module.MQTT_DISCONNECTED
	else
		state = module.MQTT_FAILED
	end
	
	return state
end

function module.publish(topic, data)

	-- publish a message with data = hello, QoS = 0, retain = 1
	m:publish(topic, data, 0, 1,
	function(client)
		-- increment ACK counter
		publish_ack = publish_ack + 1
		print("\n\tMQTT - PUBACK")
	end)
end

return module