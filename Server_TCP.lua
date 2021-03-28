-- conectando ao roteador
dofile("conectaWifi.lua")

-- cria o servidor tcp
srv = net.createServer(net.TCP)

-- servidor passa a ouvir na porta 80 (porta padrao http)
srv:listen(80, 
    function(conn)
        conn:on("receive", 
            function(conn, payload)
                print(payload)
                conn:send("<h1>Hello, NodeMCU!!! WebServer Inutil....</h1>")
            end)
    conn:on("sent",
        function(conn) conn:close()
        end)
    end)
