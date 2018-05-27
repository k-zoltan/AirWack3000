function initI2C()
   local sda = 2 -- GPIO2
   local scl = 1 -- GPIO0
   local sla = 0x3c
   i2c.setup(0, sda, scl, i2c.SLOW)
   disp = u8g.ssd1306_128x64_i2c(sla)
end 

function initDisplay()
   disp:setFont(u8g.font_6x10)   
   --disp:setDefaultForegroundColor()   
end

function updateDisplay()
    disp:firstPage()
    repeat 
        disp:setScale2x2()
        disp:setColorIndex(1)
        disp:setFontPosTop()
        --print(getTime())
        disp:drawStr(9,-1,getTime())
        disp:undoScale()
        disp:setColorIndex(1)
        if spraying == false then
            disp:drawXBM( 0, 18, 128, 64, default_pic )
        else
            disp:drawXBM( 0, 18, 128, 64, spray_pic )
        end
    until disp:nextPage() == false
end

function loadImage()
    file.open("smile.MONO", "r")
    default_pic = file.read()
    file.close()
    
    file.open("pain.MONO", "r")
    spray_pic = file.read()
    file.close()
end

function displayOn()
    disp:sleepOff()
    displayTimer = tmr.create()
    displayTimer:register(500, tmr.ALARM_AUTO, updateDisplay)
    displayTimer:start()
    print("Display turned on.")
end

function displayOff()
    disp:sleepOn()
    displayTimer:stop()
    displayTimer = nil
    print("Display turned off.")
end

loadImage()
