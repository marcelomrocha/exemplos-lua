-- conecta ao wifi
-- conectando ao roteador
local timer = 6 -- seleciona o timer
local intervalo = 2000 -- define o intervalo

wifi.setmode(wifi.STATION) -- define o modo da conexao wifi
dofile("credenciais.lua") -- cria a tabela config com ssid e senha
wifi.sta.config(config) -- configura a conexao
print("Conectando ao wifi...")
tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() == nil
        then
            print("IP indisponivel, aguardando...")
        else
            print("Conectado, o IP é " .. wifi.sta.getip())
            tmr.unregister(timer) -- libera o timer
    end
end)
