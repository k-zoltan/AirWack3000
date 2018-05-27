mdns.register("airwack3000", {description = "AirWack FreschMacher 3000"})

-- server listens on 80, if data received, print data to console and send "hello world" back to caller
-- 30s time out for a inactive client
srv = net.createServer(net.TCP)

srv:listen(80,function(conn)
    conn:on("receive", function(conn, payload)
        print(payload) -- Print data from browser to serial terminal
    
        function esp_update()
            mcu_do=string.sub(payload,postparse[2]+1,#payload)
            separator_index = string.find(mcu_do, "&")
            print(mcu_do, ' ', separator_index)
            if separator_index ~= nil then
                if string.sub(mcu_do, 1, separator_index-1) == "Display+off" then
                    displayOff()
                end
                if string.sub(mcu_do, 1, separator_index-1) == "Display+on" then
                    displayOn()
                end
                if string.sub(mcu_do, 1, separator_index-1) == "Spray" then
                    spray()
                end
                if string.sub(mcu_do, 1, separator_index-1) == "RGB+off" then
                    ledOff()
                end
            end
            if string.sub(mcu_do, 1, separator_index-1) == "Set+spray+interval" then
                 interval = {string.find(payload,"spray_interval=")}
                 interv = string.sub(payload,interval[2]+1,#payload)
                 local separator = string.find(interv, "&")
                 value = string.sub(interv, 1, separator-1)
                 print(value)
                 setSprayInterval(value)
            end
            if string.sub(mcu_do, 1, separator_index-1) == "Set+RGB+interval" then
                 interval = {string.find(payload,"rgb_interval=")}
                 interv = string.sub(payload,interval[2]+1,#payload)
                 local separator = string.find(interv, "&")
                 value = string.sub(interv, 1, separator-1)
                 print(value)
                 startRandomLight(value)
            end
        end
        --parse position POST value from header
        postparse={string.find(payload,"mcu_do=")}
        if postparse[2]~=nil then esp_update()end
        -- CREATE WEBSITE --
        
        -- HTML Header Stuff
        --[[conn:send('HTTP/1.1 200 OK\n\n')
        conn:send('<!DOCTYPE HTML>\n')
        conn:send('<html>\n')
        conn:send('<head><meta  content="text/html; charset=utf-8">\n')
        conn:send('<title>AirWack 3000</title></head>\n')
        conn:send('<body style="background-color: #EEEEEE;"><h1>AirWack 3000</h1>\n')
        
        -- Buttons 
        conn:send('<form style="width: 250px; height: 300px; border: solid 2px black;" action="" method="POST">\n')
        conn:send('<label style="margin: 0px 15px 0px 15px;">AirWack Controls</label><div style="margin-top: 10px;" align="center">')
        conn:send('<input type="submit" name="mcu_do" value="Display off">\n')
        conn:send('<input type="submit" name="mcu_do" value="Display on">\n')
        conn:send('<input type="submit" name="mcu_do" value="Spray">\n</div>')
        conn:send('<label style="margin: 10px 15px 15px 15px;">Spraying interval</label>\n<div style="margin-top: 10px;" align="center">')
        conn:send('<input type="textbox" id="spray_interval" name="spray_interval" value="'..spray_interval..'">\n')
        conn:send('<input type="submit"  onClick="alert(\'Spray interval set to \'+document.getElementById(\'spray_interval\').value + \' minutes.\');" name="mcu_do" value="Set spray interval">\n')
        conn:send('</div></body></html>\n')
        ]]--
        conn:on("sent", function(conn) conn:close() end)
    end)
end)
