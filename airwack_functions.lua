--Timezone offset
offset = 2
--Now stored in the rtcmem
spray_time = 30

--Is it spraying right now?
spraying = false

spray_pin = 5

--RGB LED pins
red = 4
green = 3
blue = 6

function initPins()
    gpio.mode(spray_pin, gpio.OUTPUT)
    gpio.write(spray_pin, gpio.LOW)
    pwm.setup(red, 500, 1023)
    pwm.setup(green, 500, 1023)
    pwm.setup(blue, 500, 1023)
    pwm.start(red)
    pwm.start(green)
    pwm.start(blue)
end

function on()
    gpio.write(spray_pin, gpio.HIGH)
end

function off()
    gpio.write(spray_pin, gpio.LOW)
    spraying = false
end

function spray()
    spraying = true
    local mytimer = tmr.create()
    on()
    mytimer:register(400, tmr.ALARM_SINGLE, off)
    mytimer:start()
end

--Local time as a string in 12:00:00 format
function getTime()
    tm = rtctime.epoch2cal(rtctime.get())
    tm["hour"] = tm["hour"] + offset
    if tm["hour"] == 24 then
        tm["hour"] = 0
    end
    if tm["hour"] == 25 then
        tm["hour"] = 1
    end
    return string.format("%02d:%02d:%02d", tm["hour"], tm["min"], tm["sec"])
end

--Debug stuff
--Date/time to the serial console only
function show_datetime()
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end
