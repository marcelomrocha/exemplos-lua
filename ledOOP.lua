led = {} -- tabela objeto led

function led:init (estado, pino) -- construtor da classe
    self.estado = estado
    self.pino = pino 
    gpio.mode(pino, gpio.OUTPUT)
end
    
function led:liga() -- metodo liga
    self.estado = true
    gpio.write(self.pino, gpio.HIGH)
end
    
function led:desliga() -- metodo desliga
    self.estado = false
    gpio.write(self.pino, gpio.LOW)
end


