-- DO NOT EDIT THIS CONFIG, THIS IS JUST A TEMPLATE

local config = {}

config.clientMapEntityUpdateInterval = 4
config.serverMapEntityUpdateInterval = 2

config.clientCharacterUpdateInterval = 1
config.serverCharacterUpdateInterval = 1

config.clientGapUpdateInterval = 4
config.serverGapUpdateInterval = 4

config.poweredUpdateInterval = 4

config.clientItemHighPriority = {
"door", "doorwbuttons", "windoweddoorwbuttons", "windoweddoor", "hatchwbuttons", "sonartransducer", "divingsuit", "combatdivingsuit", "abyssdivingsuit", "pucs", "slipsuit",
"battery"}

config.serverItemHighPriority = {"battery"}


config.clientComponentPriority = {"Engine", "Pump", "Sonar", "Fabricator", "Deconstructor", "Reactor", "Turret", "Controller"}
config.serverComponentPriority = {"Engine", "Pump", "Sonar", "Fabricator", "Deconstructor", "Reactor", "Turret", "Controller"}

config.highPriorityCharacters = {"Human"}

config.serverHighPriorityHands = true
config.clientHighPriorityHands = true


config.allowSingleplayerPermanentConfigs = false

config.disableShadowCastingLights = false
config.disableDrawBehindSubsLights = false
config.hideInGameWires = false
config.hideInGameComponents = false

return config