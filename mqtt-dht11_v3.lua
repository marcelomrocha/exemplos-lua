timer = 1 -- define o numero do timer
intervalo = 10000 -- 2s
pin_DHT11 = 2 -- seta o pino do dht11

vref = 3.3 -- tensao de referencia
vb = vref / 1024 -- volts por bit

status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
adc_valor = adc.read(0) * vb -- faz a leitura da porta analogica
    
function le_Temp_Hum()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
    adc_valor = adc.read(0) * vb -- faz a leitura da porta analogica
    conecta_m_temp()
end


MQTT_BROKER = "tccmrocha.ddns.net"
MQTT_PORT   = 1883

-----------------------------------------------------------------------
m_temp = mqtt.Client("clientid1", 120)

    m_temp:on(
        "connect",
        function(client)
            print ("temp connected") 
            client:publish(
                    "14194525/temperatura",
                    temp,
                    0,
                    0,
                    function ()
                        print("Temp. enviada...")
                    end
                )
 ------------------------------------------
            print ("humi connected") 
            client:publish(
                    "14194525/humidade",
                    humi,
                    0,
                    0,
                    function ()
                        print("humi. enviada...")
                    end
                )
--------------------------------------------
            print ("adc connected") 
            client:publish(
                    "14194525/voltagem",
                    adc_valor,
                    0,
                    0,
                    function ()
                        print("adc. enviada...")
                        m_temp:close()
                    end
                )
        end)
    
    m_temp:on(
        "offline",
        function(client) print ("temp offline") end)

    -- on publish message receive event
    m_temp:on(
        "message",
        function(client, topic, data) 
            print(topic .. ":" ) 
            if data ~= nil then
                print(data)
            end
        end)

function conecta_m_temp()  
    m_temp:connect(
        MQTT_BROKER, 
        MQTT_PORT,
        0,
        nil,
        function(client, reason) print("failed reason: " .. reason) end
    )
end



-- registra o timer
tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, le_Temp_Hum)

