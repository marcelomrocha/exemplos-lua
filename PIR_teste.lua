pino_pir = 5 -- seta o pino do PIR (Sensor de movimento)
gpio.mode(pino_pir, gpio.INPUT)

timer = 2 -- define o timer
led_pin = 0 -- define o a porta do led
gpio.mode(led_pin, gpio.OUTPUT) -- defino como porta de saida

function onOff()
    pir = gpio.read(pino_pir)
    print (pir)
    if pir == 0
    then
        gpio.write(led_pin, gpio.HIGH) -- acende o led
    else
        gpio.write(led_pin, gpio.LOW) -- apaga o led
    end
end

-- programa o timer 1 para a cada 1s chamar a funcao OnOff
tmr.alarm(timer, 10, tmr.ALARM_AUTO, onOff)

-- tipos de timer
-- tmr.ALARM_SINGLE (Dispara uma vez e nao precisa usar a funcao tmr.unregister()
-- tmr.ALARM_SEMI repete "manualmente" chamando tmr.start() para reiniciar
-- tmr.ALARM_AUTO repete automaticamente no intervalo determinado