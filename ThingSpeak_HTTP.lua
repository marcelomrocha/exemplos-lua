-- variaveis globais
pin_DHT11 = 2 -- porta do sensor

timer = 0 -- define o timer

intervalo = 5000 -- 5s

-- faz a primeira leitura 
status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11) 

-- variaveis locais
local timer = 1 -- define o timer
local intervalo = 15000 -- intervalo de atualizacao do thingspeak

-- conectando ao roteador
dofile("conectaWifi.lua")

function postThingSpeak()
    connout = net.createConnection(net.TCP, 0)
 
    connout:on("receive", 
        function(connout, payloadout)
            if (string.find(payloadout, "Status: 200 OK") ~= nil) then
                print("Posted OK");
            end
        end)
 
    connout:on("connection", 
        function(connout, payloadout)
            print ("Posting...");          
            connout:send("GET /update?api_key=RBAYI4C7T5VXHQTT&field1="..temp.."&field2="..humi
                .. " HTTP/1.1\r\n"
                .. "Host: api.thingspeak.com\r\n"
                .. "Connection: close\r\n"
                .. "Accept: */*\r\n"
                .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
                .. "\r\n")
        end)

 
    connout:connect(80,'api.thingspeak.com')
end

tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, 
    function() 
        postThingSpeak() -- envia os campos para o thingspeak
        le_Temp_Hum() -- faz outra leitura do sensor
    end)

-- funcao que le o sensor dht11
function le_Temp_Hum()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
    print ("Temperatura (C): "..temp.." , Humidade (%): "..humi)
end

