require "ISUI/ISPanel"

BWOTrespassMoodle = ISPanel:derive("BWOTrespassMoodle")

local TEX_PATH = "media/ui/Moodles/32/trespassing.png"
local moodleInstances = {}

BWOTrespass = BWOTrespass or {}
BWOTrespass.DEBUG = true --BWOItemTags.DEBUG or false

local function bwoLog(msg)
    if not BWOTrespass.DEBUG then return end
    print("[BWOTrespass] " .. tostring(msg))
end

local function isTrespassing(player)
    if not player then
        return false
    end

    if player.isTrespassing then
        return player:isTrespassing()
    end

    return false
end

local function updatePosition(panel)
    local playerIndex = panel.playerIndex
    local left = getPlayerScreenLeft(playerIndex)
    local top = getPlayerScreenTop(playerIndex)
    local width = getPlayerScreenWidth(playerIndex)
    local right = left + width

    panel:setX(right - panel.width - 10)
    panel:setY(top + 160)
end

function BWOTrespassMoodle:new(playerIndex)
    local size = 32
    local o = ISPanel:new(0, 0, size, size)
    setmetatable(o, self)
    self.__index = self

    o.playerIndex = playerIndex
    o.texture = getTexture(TEX_PATH)
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    o.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    o:setVisible(false)

    return o
end

function BWOTrespassMoodle:prerender()
    ISPanel.prerender(self)

    if self.texture then
        self:drawTextureScaled(self.texture, 0, 0, self.width, self.height, 1)
    end
end

function BWOTrespassMoodle:update()
    ISPanel.update(self)

    local player = getSpecificPlayer(self.playerIndex)
    local visible = isTrespassing(player)
	bwoLog("update. visible:"..tostring(visible) .." player:".. tostring(player))

    if visible then
        updatePosition(self)
    end

    self:setVisible(visible)
end

local function ensureMoodle(playerIndex)
	bwoLog("ensureMoodle started")
    if moodleInstances[playerIndex] then
        return
    end

    local moodle = BWOTrespassMoodle:new(playerIndex)
    moodle:initialise()
    moodle:addToUIManager()
    moodleInstances[playerIndex] = moodle
	bwoLog("Moodle ensured")
end

Events.OnCreatePlayer.Add(ensureMoodle)