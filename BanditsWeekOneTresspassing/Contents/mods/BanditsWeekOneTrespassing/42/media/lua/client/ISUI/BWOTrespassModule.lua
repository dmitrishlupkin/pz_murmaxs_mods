require "ISUI/ISPanel"
require "BWORooms"

BWOTrespassMoodle = ISPanel:derive("BWOTrespassMoodle")

local TEX_PATH = "media/ui/Moodles/128/trespassing.png"
local MOODLE_SIZE = 128
local MOODLE_OFFSET_X = 100
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

    if player:isOutside() then
        return false
    end

    local square = player:getSquare()
    if not square then
        return false
    end

    local room = square:getRoom()
    if not room then
        return false
    end

    if BWORooms and BWORooms.IsIntrusion then
        return BWORooms.IsIntrusion(room) == true
    end

    return false
end

local function updatePosition(panel)
    local playerIndex = panel.playerIndex
    local left = getPlayerScreenLeft(playerIndex)
    local top = getPlayerScreenTop(playerIndex)
    local width = getPlayerScreenWidth(playerIndex)
    local right = left + width

    panel:setX(left + (width - panel.width) / 2)
    --panel:setX(right - panel.width - MOODLE_OFFSET_X) -- Near moodles - interferes with them and their text descriptions
    panel:setY(top + 130)
end

function BWOTrespassMoodle:new(playerIndex)
    local o = ISPanel:new(0, 0, MOODLE_SIZE, MOODLE_SIZE)
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

    if visible then
        updatePosition(self)
    end

    self:setVisible(visible)
end

local function ensureMoodle(playerIndex)
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
Events.OnGameStart.Add(function()
    local players = getNumActivePlayers()
    for i = 0, players - 1 do
        ensureMoodle(i)
    end
end)

bwoLog("Start mod initialization")