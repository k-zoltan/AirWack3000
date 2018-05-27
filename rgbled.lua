function led(r, g, b)
    pwm.setduty(red, 1023-r)
    pwm.setduty(green, 1023-g)
    pwm.setduty(blue, 1023-b)
end

function randomColor()
    led(node.random(1023), node.random(1023), node.random(1023))
end

function startRandomLight(interval)
    mytimer = tmr.create()
    mytimer:register(interval*1000, tmr.ALARM_AUTO, randomColor)
    mytimer:start()
end

function ledOff()
    led(0,0,0)
    if mytimer ~= nil then
        mytimer:unregister()
    end
    mytimer = nil
end
