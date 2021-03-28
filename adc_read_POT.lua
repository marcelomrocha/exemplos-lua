timer = 0 -- seleciona o timer
intervalo = 500 -- em milis
vref = 3.3 -- tensao de referencia
vb = vref / 1024 -- volts por bit

function leADC()
    valor = adc.read(0) -- faz a leitura da porta analogica
    -- valor em bits
    print ("Bit = " ..valor .." Voltagem = " ..(vb * valor))
end

-- registra o timer
tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, leADC)
