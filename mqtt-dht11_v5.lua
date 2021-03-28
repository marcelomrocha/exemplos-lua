broker="tccmrocha.ddns.net"
seconds = 10
deviceID = "tccmrocha/sala"
roomID = "2"
 
mqtt_dest = {}
mqtt_valu = {}
 
pin_DHT11 = 2 -- seta o pino do dht11

vref = 3.3 -- tensao de referencia
vb = vref / 1024 -- volts por bit

--load DHT11 module and read sensor
function ReadDHT11()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
    volt = adc.read(0) * vb -- faz a leitura da porta analogica
end
 
function mqttHandle(n)
    if mqtt_dest[1] ~= nil then
        print("MQTT publish " .. mqtt_dest[1] .. " payload " .. mqtt_valu[1])
        m:publish(deviceID .. "/" .. mqtt_dest[1], mqtt_valu[1], 0, 0, function()
            table.remove(mqtt_dest, 1)
            table.remove(mqtt_valu, 1)
        end)
    end
end
 
tmr.alarm(2, 1000, 1, function() mqttHandle(0); end)
 
m = mqtt.Client("ESP8266".. deviceID, 180, "user", "pass")

m:on("offline", function(con)
    ip = wifi.sta.getip()
    print ("Mqtt Reconnecting to " .. broker .. " from " .. ip)
    tmr.alarm(1, 10000, 0, function()
        m:connect(broker, 1883, 0, function(conn)
        print("Mqtt Connected to:" .. broker)
        end)
    end)
end)

m:lwt("/lwt", "ESP8266", 0, 0)
 
function mqttPublish(level)
    ReadDHT11()
    print("MQTT update")
 
    table.insert(mqtt_dest, "temperatura")
    table.insert(mqtt_valu, temp)
 
    table.insert(mqtt_dest, "humidade")
    table.insert(mqtt_valu, humi)

    table.insert(mqtt_dest, "voltagem")
    table.insert(mqtt_valu, volt)

    mqttHandle(0)


end
 
tmr.alarm(0, 1000, 1, function()
    if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
        tmr.stop(0)
        m:connect(broker, 1883, 0, function(conn)
            print("Mqtt Connected to:" .. broker)
            tmr.alarm(0, seconds*1000, 1, function() 
                mqttPublish(0) 
                end)
        end)
    end
end)
