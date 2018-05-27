sntp.sync("84.2.44.19", nil, nil, 1)

dofile("airwack_functions.lua")
dofile("display_functions.lua")
dofile("cron_functions.lua")
dofile("web_functions.lua")
dofile("rgbled.lua")

initPins()
initI2C()
initDisplay()
displayOn()
initSpraySchedule()
setOntime(5, 0)
setOfftime(23, 50)
rgbOnTime(5, 50)
rgbOffTime(23, 30)
