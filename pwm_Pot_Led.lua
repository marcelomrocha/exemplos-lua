timer = 0 -- timer de 0 a 6
intervalo = 500 -- milis
pwm_pin = 1 -- define o pino pra usar como pwm
pwm.setup(pwm_pin, 512, 0) -- config. pino, freq. e duty
pwm.start(pwm_pin) -- ativa o sinal pwm
vref = 3.3 -- tensao de referencia
vb = vref / 1024 -- volts por bit

function trabalha()
    val = adc.read(0) -- le a porta analogica
    if val >= 1024 -- evita o "estouro" do duty
    then 
        val = 1023 -- valor maximo do duty
    end
    -- imprime o valor lido na porta adc(0)
    print ("Bit = " ..val .." Voltagem = " ..(vb * val))
    pwm.setduty(pwm_pin, val) -- seta o valor do duty
end

-- configura o timer
tmr.alarm(timer, intervalo, tmr.ALARM_AUTO, trabalha) 
