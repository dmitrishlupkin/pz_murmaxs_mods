ISFilmingToolsUI = ISCollapsableWindow:derive("ISFilmingToolsUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 20
local BUTTON_HGT = FONT_HGT_SMALL + 6
local BUTTON_HGT_BIG = FONT_HGT_SMALL + 20


function ISFilmingToolsUI:initialise()
	ISCollapsableWindow.initialise(self);

    local y = 90;
    self.muteUiSound_btn = ISButton:new(5, y, self:getWidth() - 10, BUTTON_HGT_BIG, "Mute UI Sound", self, ISFilmingToolsUI.onClick);
    self.muteUiSound_btn.internal = "MUTE_UI_SOUND";
    self.muteUiSound_btn:initialise();
    self.muteUiSound_btn:instantiate();
    self:addChild(self.muteUiSound_btn);
    y = y + BUTTON_HGT + 25;

    self.cutaway_btn = ISButton:new(5, y, self:getWidth() - 10, BUTTON_HGT_BIG, "Disable Cutaway", self, ISFilmingToolsUI.onClick);
    self.cutaway_btn.internal = "CUTAWAY";
    self.cutaway_btn:initialise();
    self.cutaway_btn:instantiate();
    self:addChild(self.cutaway_btn);
    y = y + BUTTON_HGT + 25;

    self.no_lighting_btn = ISButton:new(5, y, self:getWidth() - 10, BUTTON_HGT_BIG, "Remove Area Shadows", self, ISFilmingToolsUI.onClick);
    self.no_lighting_btn.internal = "NO_LIGHTING";
    self.no_lighting_btn:initialise();
    self.no_lighting_btn:instantiate();
    self:addChild(self.no_lighting_btn);
    y = y + BUTTON_HGT + 25;

    self.no_fade_btn = ISButton:new(5, y, self:getWidth() - 10, BUTTON_HGT_BIG, "Disable Fading", self, ISFilmingToolsUI.onClick);
    self.no_fade_btn.internal = "NO_FADE";
    self.no_fade_btn:initialise();
    self.no_fade_btn:instantiate();
    self:addChild(self.no_fade_btn);
    y = y + BUTTON_HGT + 25;

    self.no_highlight_container_btn = ISButton:new(5, y, self:getWidth() - 10, BUTTON_HGT_BIG, "Disable Selected Container Highlight", self, ISFilmingToolsUI.onClick);
    self.no_highlight_container_btn.internal = "NO_HIGHLIGHT_CONTAINER";
    self.no_highlight_container_btn:initialise();
    self.no_highlight_container_btn:instantiate();
    self:addChild(self.no_highlight_container_btn);
    y = y + BUTTON_HGT + 25;

    y = y + 80;
    self.no_btn = ISButton:new(5, y, self:getWidth() - 10, BUTTON_HGT, getText("UI_Close"), self, ISFilmingToolsUI.onClick);
    self.no_btn.internal = "CLOSE";
    self.no_btn:initialise();
    self.no_btn:instantiate();
    self.no_btn:enableCancelColor()
    self:addChild(self.no_btn);

    self:setHeight(self.no_btn:getY() + BUTTON_HGT + 20);

	self:bringToTop();
end

function ISFilmingToolsUI:update()
end

function ISFilmingToolsUI:destroy()
    self:setVisible(false);
    self:removeFromUIManager();
    ISFilmingToolsUI.instance = nil;
end

function ISFilmingToolsUI:onClick(button)
	if button.internal == "CLOSE" then
		self:destroy();
		return;
	end
    if button.internal == "MUTE_UI_SOUND" then
        getSoundManager():setUiSoundMuted(not getSoundManager():isUiSoundMuted())
        return;
    end
    if button.internal == "CUTAWAY" then
        getDebugOptions():setBoolean("Terrain.RenderTiles.Cutaway", not getDebugOptions():getBoolean("Terrain.RenderTiles.Cutaway"));
        return;
    end
    if button.internal == "NO_LIGHTING" then
        getDebugOptions():setBoolean("FBORenderChunk.NoLighting", not getDebugOptions():getBoolean("FBORenderChunk.NoLighting"));
        return;
    end
    if button.internal == "NO_FADE" then
        getDebugOptions():setBoolean("Terrain.RenderTiles.ForceFullAlpha", not getDebugOptions():getBoolean("Terrain.RenderTiles.ForceFullAlpha"));
        return;
    end
    if button.internal == "NO_HIGHLIGHT_CONTAINER" then
        getDebugOptions():setBoolean("Terrain.RenderTiles.RenderContainerHighlight", not getDebugOptions():getBoolean("Terrain.RenderTiles.RenderContainerHighlight"));
        return;
    end
end

function ISFilmingToolsUI:prerender()
    ISCollapsableWindow.prerender(self);

	self:drawTextCentre(getText("IGUI_DebugContext_FilmingTools"), self:getWidth() / 2, UI_BORDER_SPACING+1, 1, 1, 1, 1, UIFont.NewLarge);

	self:updateButtons();
end

function ISFilmingToolsUI:updateButtons()
    self.muteUiSound_btn.title = "Mute UI Sound";
    self.cutaway_btn.title = "Disable Cutaway";
    self.no_lighting_btn.title = "Remove Area Shadows";
    self.no_fade_btn.title = "Disable Fading";
    self.no_highlight_container_btn.title = "Disable Selected Container Highlight";

    if getSoundManager():isUiSoundMuted() then
        self.muteUiSound_btn.title = "Unmute UI Sound";
    end
    if not getDebugOptions():getBoolean("Terrain.RenderTiles.Cutaway") then
        self.cutaway_btn.title = "Enable Cutaway";
    end
    if getDebugOptions():getBoolean("FBORenderChunk.NoLighting") then
        self.no_lighting_btn.title = "Add Area Shadows";
    end
    if getDebugOptions():getBoolean("Terrain.RenderTiles.ForceFullAlpha") then
        self.no_fade_btn.title = "Enable Fading";
    end
    if not getDebugOptions():getBoolean("Terrain.RenderTiles.RenderContainerHighlight") then
        self.no_highlight_container_btn.title = "Enable Selected Container Highlight";
    end

    local maxWidth = 0;
    for label, slider in pairs(self.labels) do
        if label:getWidth() + label:getX() > maxWidth then
            maxWidth = label:getWidth() + label:getX();
        end
    end

    for label, slider in pairs(self.labels) do
        slider:setX(maxWidth + 10)
        slider:setWidth(self:getWidth() - maxWidth - 15)
    end
end

function ISFilmingToolsUI:render()
    ISCollapsableWindow.render(self);
end

ISFilmingToolsUI.onKeyPressed = function(key)
    if isDebugEnabled() and Keyboard.KEY_V == key and (Keyboard.isKeyDown(Keyboard.KEY_LSHIFT) or Keyboard.isKeyDown(Keyboard.KEY_RSHIFT)) then
        DebugContextMenu.onFilmingToolsUI(getPlayer());
    end
end

function ISFilmingToolsUI:onKeyRelease(key)
    if Keyboard.KEY_ESCAPE == key and ISFilmingToolsUI.instance then
        ISFilmingToolsUI.instance:setVisible(false);
    end
end

function ISFilmingToolsUI:isKeyConsumed(key)
    return key == Keyboard.KEY_ESCAPE
end

function ISFilmingToolsUI:new(x, y, width, height, player)
	local o = {}
	o = ISCollapsableWindow:new(x, y, width, height);
	setmetatable(o, self)
	self.__index = self
	if y == 0 then
		o.y = getCore():getScreenHeight() / 2 - (height / 2)
		o:setY(o.y)
	end
	if x == 0 then
        o.x = getCore():getScreenWidth() / 2 - (width / 2)
		o:setX(o.x)
	end
	o.width = width;
	o.height = height;
	o.anchorLeft = true;
	o.anchorRight = true;
	o.anchorTop = true;
	o.anchorBottom = true;
    o.labels = {};
	o.player = player;
    o:setWantKeyEvents(true)
    ISFilmingToolsUI.instance = o;
	return o;
end

local function OnGameStart()
    Events.OnKeyPressed.Add(ISFilmingToolsUI.onKeyPressed);
end

Events.OnGameStart.Add(OnGameStart)
