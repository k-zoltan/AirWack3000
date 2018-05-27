--[[
--	CHANGES:
--		- initI2C(): local variables moved to constants.lua	- 2018.05.27.
--		- displayOn(): Destroys the timer before creating a new one --> no duplicate timers
--]]

function initI2C()
   i2c.setup(0, SDA_PIN, SCL_PIN, i2c.SLOW)
   disp = u8g.ssd1306_128x64_i2c(DISP_ADDRESS)
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
    if (displayTimer == nil) then
		displayTimer:stop()
		displayTimer = nil
	end
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