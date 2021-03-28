timer = 1 -- define o numero do timer
intervalo = 2000 -- 2s
pin_DHT11 = 2 -- seta o pino do dht11

-- funcao callback que le o sensor
function le_Temp_Hum()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
    print("Temperatura em Celsius: "..temp.." Humidade: "..humi.."%")
end

-- registra o timer
tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, le_Temp_Hum)


