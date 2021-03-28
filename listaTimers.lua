tipos = {} -- tabela com os tipos de timer
tipos[0] = "tmr.ALARM_SINGLE"
tipos[1] = "tmr.ALARM_AUTO"
tipos[2] = "tmr.ALARM_SEMI"
tipos[4] = "xxxxxx" -- nao registrado

print("-----------------------------------------------")
print("Timer\tOn\t\tTipo")

for t = 0, 6 do

    on, tipo = tmr.state(t)
    -- on pode ter 3 estados
    -- nil = timer nao esta registrado
    -- true = ligado e registrado
    -- false = desligado porem registrado
    if on == nil
        then
            on = "Nao"
            tipo = 4
        elseif on == true 
            then on = "Sim"
        else on = "Nao"
    end
    
    print(t.."\t\t"..on.."\t\t"..tipos[tipo])
   
end

print("-----------------------------------------------")
