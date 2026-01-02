require "TimedActions/ISBaseTimedAction"

ISWallpaperAction = ISBaseTimedAction:derive("ISWallpaperAction");

function ISWallpaperAction:isValid()
	return true;
end

function ISWallpaperAction:waitToStart()
    self.character:faceThisObject(self.thumpable)
    return self.character:shouldBeTurning()
end

function ISWallpaperAction:update()
    self.character:faceThisObject(self.thumpable)
    self.character:setMetabolicTarget(Metabolics.LightWork);
end

function ISWallpaperAction:start()
    self:setActionAnim(CharacterActionAnims.Paint)
    self:setOverrideHandModels("PaintBrush", nil)
    self.character:faceThisObject(self.thumpable)
    self.sound = self.character:playSound("Painting")
end

function ISWallpaperAction:serverStart()
    self.sprite = WallPaper[self.thumpable:getSprite():getProperties():get("PaintingType")][self.papering];
    self.wallType = self.thumpable:getSprite():getProperties():get("PaintingType");

    local props = self.thumpable:getSprite():getProperties()
    if props:has("WallN") or props:has("DoorWallN")  or props:has("WindowN") then
        self.sprite = WallPaper[self.thumpable:getSprite():getProperties():get("PaintingType")][self.papering .. "North"]
    end
    if props:has("WallNW") then
        self.sprite = WallPaper[self.thumpable:getSprite():getProperties():get("PaintingType")][self.papering .. "Corner"]
    end
    if not instanceof(self.thumpable, "IsoThumpable") then
        self.isThump = false;
    end
end

function ISWallpaperAction:stop()
    if self.sound then self.character:stopOrTriggerSound(self.sound) end
    ISBaseTimedAction.stop(self);
end

function ISWallpaperAction:perform()
    if self.sound then self.character:stopOrTriggerSound(self.sound) end
	self.thumpable:cleanWallBlood();
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISWallpaperAction:complete()
    if isServer() or not ISBuildMenu.cheat then
        if self.wallpaper then
            self.wallpaper:UseAndSync();
        end
        local paste = self.character:getInventory():getFirstTagRecurse(ItemTag.WALLPAPER_PASTE)
        if paste then
            paste:UseAndSync();
        end
    end

    if self.sprite then
        self.thumpable:setSpriteFromName(self.sprite);
        self.thumpable:transmitUpdatedSpriteToClients();
    end

    return true;
end

function ISWallpaperAction:getDuration()
    return 100;
end

function ISWallpaperAction:new(character, thumpable, wallpaper, papering)
    local o = ISBaseTimedAction.new(self, character)
	o.character = character;
	o.thumpable = thumpable;
	o.papering = papering;
	o.wallpaper = wallpaper;
	o.maxTime = o:getDuration();
    o.isThump = true;
    o.wallType = thumpable:getSprite():getProperties():get("PaintingType");
    o.sprite = WallPaper[thumpable:getSprite():getProperties():get("PaintingType")][papering]
    local props = thumpable:getSprite():getProperties()
    if props:has("WallN") or props:has("DoorWallN")  or props:has("WindowN") then
        o.sprite = WallPaper[thumpable:getSprite():getProperties():get("PaintingType")][papering .. "North"]
    end
    if props:has("WallNW") then
        o.sprite = WallPaper[thumpable:getSprite():getProperties():get("PaintingType")][papering .. "Corner"]
    end
    if not instanceof(thumpable, "IsoThumpable") then
        o.isThump = false;
    end
    if (not isMultiplayer() and ISBuildMenu.cheat) then o.maxTime = 1; end
    o.caloriesModifier = 4;
	return o;
end

