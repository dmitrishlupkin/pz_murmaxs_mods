require "ISUI/ISEmoteRadialMenu"


local actionEmote = ISEmoteRadialMenu.emote

function ISEmoteRadialMenu:emote(emote)
    actionEmote(self, emote)
    triggerEvent("OnEmote", self.character, emote)
end
