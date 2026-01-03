require "MainScreen"

local mainScreenInstantiate = MainScreen.instantiate
local mainScreenGetAllUIs = MainScreen.getAllUIs

function MainScreen:instantiate()
    mainScreenInstantiate(self)

    if not self.inGame and not isDemo() then
        self.variantMain = VariantMain:new(0, 0, self:getWidth(), self:getHeight())

        self.variantMain:initialise()
        self.variantMain:setVisible(false)
        self.variantMain:setAnchorRight(true)
        self.variantMain:setAnchorLeft(true)
        self.variantMain:setAnchorBottom(true)
        self.variantMain:setAnchorTop(true)
        self.variantMain.backgroundColor = {r=0, g=0, b=0, a=0.8}
        self.variantMain.borderColor = {r=1, g=1, b=1, a=0.5}
        self:addChild(self.variantMain)
    

        local w = getCore():getScreenWidth();
	    local h = getCore():getScreenHeight();

        local uis = {
            { self.variantMain, 0.7, 0.8 },
        }
    
        for _,ui in ipairs(uis) do
            if ui[1] and ui[1].javaObject and instanceof(ui[1].javaObject, 'UIElement') then
                local width = w * ui[2]
                local height = h * ui[3]
                if w <= 1024 then
                    width = w * 0.95
                    height = h * 0.95
                end
                ui[1]:setWidth(width)
                ui[1]:setHeight(height)
                ui[1]:setX((w - width) / 2)
                ui[1]:setY((h - height) / 2)
                ui[1]:recalcSize()
            end
        end

        self.variantMain:create()
    end
end

function MainScreen:getAllUIs()
    local ret = mainScreenGetAllUIs(self)
    table.insert(ret, self.variantMain)
end
