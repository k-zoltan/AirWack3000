--[[
--	Changes:
--		- Some variables were moved to constants.lua - 2018.05.27
--
--]]
spray_time = 30

--Is it spraying right now?
spraying = false

function initPins()
    gpio.mode(SPRAY_PIN, gpio.OUTPUT)
    gpio.write(SPRAY_PIN, gpio.LOW)
    pwm.setup(RED_PIN, 500, 1023)
    pwm.setup(GREEN_PIN, 500, 1023)
    pwm.setup(BLUE_PIN, 500, 1023)
    pwm.start(RED_PIN)
    pwm.start(GREEN_PIN)
    pwm.start(BLUE_PIN)
end

function on()
    gpio.write(SPRAY_PIN, gpio.HIGH)
end

function off()
    gpio.write(SPRAY_PIN, gpio.LOW)
    spraying = false
end

function spray()
    spraying = true
    local mytimer = tmr.create()
    on()
    mytimer:register(500, tmr.ALARM_SINGLE, off)
    mytimer:start()
end

--Local time as a string in 12:00:00 format
function getTime()
    tm = rtctime.epoch2cal(rtctime.get())
    tm["hour"] = tm["hour"] + TZ_OFFSET
    if tm["hour"] == 24 then
        tm["hour"] = 0
    end
    if tm["hour"] == 25 then
        tm["hour"] = 1
    end
    return string.format("%02d:%02d:%02d", tm["hour"], tm["min"], tm["sec"])
end
