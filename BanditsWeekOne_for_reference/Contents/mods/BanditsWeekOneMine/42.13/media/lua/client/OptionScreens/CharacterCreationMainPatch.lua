require "CharacterCreationMain"

local UI_BORDER_SPACING = 10

-- local characterCreationMainOnOptionMouseDown = CharacterCreationMain.onOptionMouseDown

function CharacterCreationMain:onOptionMouseDown2(button, x, y)
    -- characterCreationMainOnOptionMouseDown(self, button, x, y)
    if button.internal == "VARIANT" then
        
        self:setVisible(false)
        self:initPlayer()
            if isClient() and getCore():getAccountUsed() then
                getCore():getAccountUsed():setPlayerFirstAndLastName(self.forenameEntry:getText() .. " " .. self.surnameEntry:getText())
                updateAccountToAccountList(getCore():getAccountUsed())
                getCore():setAccountUsed(nil)
            end

        if MainScreen.instance and (not MainScreen.instance.inGame) then
            local joypadData = JoypadState.getMainMenuJoypad() or CoopCharacterCreation.getJoypad()
            MainScreen.instance.variantMain:setVisible(true, joypadData)
        else
            CoopCharacterCreation.instance:accept()
        end
    end
end

local characterCreationMainCreate = CharacterCreationMain.create

function CharacterCreationMain:create()
    characterCreationMainCreate(self)
    
    self.playButton:setVisible(false)

    self.variantButton = ISButton:new(self.playButton:getX(), self.playButton:getY(), self.playButton:getWidth(), self.playButton:getHeight(), getText("UI_btn_next"), self, self.onOptionMouseDown2);
	self.variantButton.internal = "VARIANT";
	self.variantButton:initialise();
	self.variantButton:instantiate();
	self.variantButton:setAnchorLeft(false);
	self.variantButton:setAnchorRight(true);
	self.variantButton:setAnchorTop(false);
	self.variantButton:setAnchorBottom(true);
	self.variantButton:setEnable(true); -- sets the hard-coded border color
--	self.playButton.setJoypadFocused = self.setJoypadFocusedAButton
	self.variantButton:setSound("activate", "UIActivateButton")
	self.variantButton:enableAcceptColor()
	self:addChild(self.variantButton);

end


