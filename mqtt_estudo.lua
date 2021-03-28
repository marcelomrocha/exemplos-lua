gpio.mode(0, gpio.OUTPUT)
gpio.write(0, gpio.LOW)
-- init mqtt client without logins, keepalive timer 120s
-- m = mqtt.Client("clientid", 120)
pwm_pin = 1 -- define o pino pra usar como pwm
pwm.setup(pwm_pin, 512, 0) -- config. pino, freq. e duty
pwm.start(pwm_pin)
-- init mqtt client with logins, keepalive timer 120sec

pin_DHT11 = 2 -- seta o pino do dht11

function leDHT11()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
end

m = mqtt.Client("node-sala", 120, "marcelo", "mrbf8051")

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)

m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on(
    "message", 
    function(client, topic, data) 
        print (topic .. data)
        if topic == "tccmrocha/sala/luz" and data == "liga" then
            gpio.write(0, gpio.HIGH)
        end
        if topic == "tccmrocha/sala/luz" and data == "desliga" then
            gpio.write(0, gpio.LOW)
        end
        if topic == "tccmrocha/sala/luz/intensidade" then
            pwm.setduty(pwm_pin, data)
        end
        if topic == "tccmrocha/all/pergunta" and data == "ping" then
            m:publish("tccmrocha/all/resposta/sala", "OnLine", 0, 0, function() print("NodeMCU-Sala-OnLine") end)
        end
        
        
    end
)

-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect(
    "tccmrocha.ddns.net", 
    1883, 
    0, 
    function(client)
        print("connected")
  -- Calling subscribe/publish only makes sense once the connection
  -- was successfully established. You can do that either here in the
  -- 'connect' callback or you need to otherwise make sure the
  -- connection was established (e.g. tracking connection status or in
  -- m:on("connect", function)).

  -- subscribe topic with qos = 0
        client:subscribe("tccmrocha/sala/luz", 0, function(client) print("subscribe success") end)
        client:subscribe("tccmrocha/sala/luz/intensidade", 0, function(client) print("subscribe success") end)
        client:subscribe("tccmrocha/all/pergunta", 0, function(client) print("subscribe success") end)
    end,
    function(client, reason)
     print("failed reason: " .. reason)
    end
)


tmr.alarm(
    1, 
    5000, 
    tmr.ALARM_AUTO, 
    function()
    leDHT11()
    m:publish("tccmrocha/sala/temperatura", temp, 0, 0, function()
            print("Publish temperatura: "..temp)
        end)
    end
)

tmr.alarm(
    2, 
    6000, 
    tmr.ALARM_AUTO, 
    function()
    m:publish("tccmrocha/sala/humidade", humi, 0, 0, function()
            print("Publish humidade: "..humi)
        end)
    end
)
m:close();
-- you can call m:connect again
