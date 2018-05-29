--[[
--	Changes:
--		- Offset calculation was corrected. - 2018.05.27
--		
]]
--Cron jobs
--Read spray time from rtc memory if possible
function initSpraySchedule()
    --TODO:
	--Getting spray time from config file
	spray_time = 30
    setSprayTime(spray_time)
end
--Setting spraying time - in every m minutes: if m=15 --> 12:00, 12:15, 12:30 etc
function setSprayTime(m)
    if (minuteSchedule ~= nil) then
        minuteSchedule:unschedule()
        minuteSchedule = nil
    end
    minuteSchedule = cron.schedule("*/"..m.." * * * *", spray)
    spray_time = m
    --Cosmetic stuff: 1[st], 2[nd], 3[rd], 4[th].
    print("Spraying in every "..m.."th minute.")
end

function setOntime(hour, minute)
    --local time = utc time + offset
    hour = hour - offset
    if (hour < 0) then
        hour = (24 - hour) - 24
    end
    if (onchedule ~= nil) then
        onSchedule:unschedule()
        onSchedule = nil
    else
        onSchedule = cron.schedule(minute.." "..hour.." * * *",displayOn)
    end
    print("Display turns on at "..hour+offset..":"..minute)
end

function setOfftime(hour, minute)
    --local time = utc time + offset
    hour = hour - offset
    if (hour < 0) then
        hour = (24 - hour) - 24
    end
    if (offSchedule ~= nil) then
        offSchedule:unschedule()
        offSchedule = nil
    else
        offSchedule = cron.schedule(minute.." "..hour.." * * *",displayOff)
    end
    print("Display turns off at "..hour+offset..":"..minute)
end

function rgbOffTime(hour, minute)
    --local time = utc time + offset
    hour = hour - offset
    if (hour < 0) then
        hour = (24 - hour) - 24
    end
    if (rgbOffSchedule ~= nil) then
        rgbOffSchedule:unschedule()
        rgbOffSchedule = nil
    else
        rgbOffSchedule = cron.schedule(minute.." "..hour.." * * *",ledOff)
    end
    print("RGB LED turns off at "..hour+offset..":"..minute)
end

function rgbOnTime(hour, minute)
    --local time = utc time + offset
    hour = hour - offset
    if (hour < 0) then
        hour = (24 - hour) - 24
    end
    if (rgbOnSchedule ~= nil) then
        rgbOnSchedule:unschedule()
        rgbOnSchedule = nil
    else
        rgbOSchedule = cron.schedule(minute.." "..hour.." * * *",function() startRandomLight(2)end)
    end
    print("RGB LED turns on at "..hour+offset..":"..minute)
end    
