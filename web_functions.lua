--[[
--  Changes:
--      - Added the 'Address' command
--      - The program closes the server, if it's not nil (out of memory error when the web_functions file was uploaded
--]]
mdns.register("airwack3000", {description = "Pimped-up AirWick 3000"})

if (srv ~= nil) then
	srv:close()
end
srv = net.createServer(net.TCP)
print("Server listening on port #"..SERVER_PORT)
srv:listen(SERVER_PORT,function(conn)
	conn:on("receive", function(conn, payload)
		print(payload) -- Print data from browser to serial terminal
    
		function esp_update()
			mcu_do=string.sub(payload,postparse[2]+1,#payload)
			separator_index = string.find(mcu_do, "&")
			print(mcu_do, ' ', separator_index)
			if (separator_index ~= nil) then
				if string.sub(mcu_do, 1, separator_index-1) == "Display+off" then
					displayOff()
				end
				if string.sub(mcu_do, 1, separator_index-1) == "Display+on" then
					displayOn()
				end
				if string.sub(mcu_do, 1, separator_index-1) == "Spray" then
					spray()
				end
                --Sending commands using airwack3000.local hostname takes too long,
                --so the NodeMCU sends its ip address.
                if string.sub(mcu_do, 1, separator_index-1) == "Address" then
					ip, subnet, gateway = wifi.sta.getip()
                    conn:send(ip)
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
		conn:on("sent", function(conn) conn:close() end)
	end)
end)

