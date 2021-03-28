print("Iniciando o NodeMcu em 5s....")
tmr.delay(5000000) -- microsegundos

--dofile("dht11_WEB_SERVER.lua")
dofile("firmware_node_sala.lua")
