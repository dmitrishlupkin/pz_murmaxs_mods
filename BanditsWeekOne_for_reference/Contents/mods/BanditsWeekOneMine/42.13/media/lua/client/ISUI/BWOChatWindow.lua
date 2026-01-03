require "ISUI/ISPanelJoypad"

BWOChatPanel = ISPanelJoypad:derive("BWOChatPanel");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function BWOChatPanel:updateFan(n)

    self.fan = n

    if self.object:isActivated() then
        self.image5:setVisible(true)
        for i=1, 5 do
            if n < i then
                self.vents[i]:setVisible(true)
                self.ventsOn[i]:setVisible(false)
            else
                self.vents[i]:setVisible(false)
                self.ventsOn[i]:setVisible(true)
            end
        end
    else
        self.image5:setVisible(false)
        for i=1, 5 do
            self.vents[i]:setVisible(false)
            self.ventsOn[i]:setVisible(false)
        end
    end
end

function BWOChatPanel:initialise()
    ISPanelJoypad.initialise(self);

    self.textEntry = ISTextEntryBox:new("", (self:getWidth() - 200) / 2, 40, 200, 24)
	self.textEntry.font = UIFont.Small
    self.textEntry.backgroundColor.a = 0.1
	self.textEntry.onCommandEntered = BWOChatPanel.sendMessage 

    self:addChild(self.textEntry)

    self.cancel = ISButton:new((self:getWidth() - 100) / 2, 80, 100, 24, getText("UI_Cancel"), self, BWOChatPanel.onClick)
    self.cancel.internal = "CANCEL"
    self.cancel:initialise()
    self.cancel:instantiate()
    self.cancel.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.cancel)

    self:setHeight(self.cancel:getBottom() + 5)

    self:insertNewLineOfButtons(self.cancel)

    self.textEntry:focus()
end

function BWOChatPanel:destroy()
    UIManager.setShowPausedMessage(true);
    self:setVisible(false);
    self:removeFromUIManager();
end

function BWOChatPanel:sendMessage()
    local txt = self:getText()
    self:unfocus()
    UIManager.setShowPausedMessage(true);
    self.parent:setVisible(false);
    self.parent:removeFromUIManager();
    BWOChat.Say(txt)
end

function BWOChatPanel:onClick(button)

    if button.internal == "OK" then
        self:destroy();
    end

    if button.internal == "CANCEL" then
        self:destroy();
    end

    self:updateNow()
end

function BWOChatPanel:prerender()
    self.backgroundColor.a = 0.5
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    --[[
    self:drawRect(64, 40, 50, 30, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(64, 40, 50, 30, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    self:drawRect(160, 40, 70, 30, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(160, 40, 70, 30, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    ]]

    self:drawTextCentre("Say", self:getWidth()/2, 10, 1, 1, 1, 1, UIFont.Small);
end

function BWOChatPanel:render()
end

function BWOChatPanel:update()
end

function BWOChatPanel:updateNow()
end

--************************************************************************--
--** ISAlarmClockDialog:new
--**
--************************************************************************--
function BWOChatPanel:new(x, y, width, height, character)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.name = nil;
    o.backgroundColor = {r=0, g=0, b=0, a=0.5};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;

    local player = character:getPlayerNum()
    if y == 0 then
        o.y = (getPlayerScreenHeight(player) - height) / 2
        o:setY(o.y)
    end
    if x == 0 then
        o.x = (getPlayerScreenWidth(player) - width) / 2
        o:setX(o.x)
    end
    
    return o;
end

