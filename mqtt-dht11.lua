timer = 1 -- define o numero do timer
intervalo = 5000 -- 2s
pin_DHT11 = 2 -- seta o pino do dht11

-- funcao callback que le o sensor
function le_Temp_Hum()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
    print("Temperatura em Celsius: "..temp.." Humidade: "..humi.."%")
end

-- init mqtt client without logins, keepalive timer 120s
m = mqtt.Client("clientid", 120)

-- init mqtt client with logins, keepalive timer 120sec
--m = mqtt.Client("clientid", 120, "user", "password")

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
--m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect("tccmrocha.ddns.net", 1883, 0, function(client)
  print("connected")

  client:publish("14194525/temp", temp, 0, 0, function(client) print("sent") end)
end,
function(client, reason)
  print("failed reason: " .. reason)
end)

  client:publish("14194525/humi", humi, 0, 0, function(client) print("sent") end,
function(client, reason)
  print("failed reason: " .. reason)
end)
   

m:close();
-- you can call m:connect again
