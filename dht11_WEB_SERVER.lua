-- variaveis globais
pin_DHT11 = 2 -- porta do sensor

-- faz uma primeira leitura
status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)

-- var locais
local timer = 0 -- seta o timer
local intervalo = 5000 -- intervalo de leituras do sensor

-- conectando ao roteador
dofile("conectaWifi.lua")

-- cria o servidor tcp
srv = net.createServer(net.TCP)
srv:listen(80, 
    function(conn)
        conn:on("receive", 
            function(conn, payload)
                print(payload)
                conn:send('<head><META HTTP-EQUIV="refresh" CONTENT="5"></head>'
                          .."<h1>Esta&ccedil&atildeo do tempo - NodeMcu</h1>"
                          .."<h2>Temperatura: "..temp.." &degC <br>Humidade: "..humi.."%</h2>"
                          )
            end)
        conn:on("sent",
            function(conn) 
                print ("Enviou..")
                conn:close()
            end)
    end)

-- funcao que le o sensor dht11
function le_Temp_Hum()
    status,temp,humi,temp_decimal,humi_decimal = dht.read11(pin_DHT11)
    print ("Temperatura (C): "..temp.." , Humidade (%): "..humi)
end

-- registra o timer
tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, le_Temp_Hum)
