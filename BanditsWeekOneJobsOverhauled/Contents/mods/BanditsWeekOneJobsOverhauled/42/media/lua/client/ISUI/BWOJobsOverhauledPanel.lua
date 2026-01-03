require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"

BWOJobsOverhauledList = ISScrollingListBox:derive("BWOJobsOverhauledList")

function BWOJobsOverhauledList:onMouseDown(x, y)
    local row = self:rowAt(x, y)
    if row < 1 or row > #self.items then return end
    local item = self.items[row].item

    local iconSize = self.parentPanel.iconSize
    local indent = self.parentPanel.indent
    local iconX = indent * item.level
    if item.hasChildren and x >= iconX and x <= iconX + iconSize then
        self.parentPanel:toggleNode(item.nodeId)
        return
    end

    ISScrollingListBox.onMouseDown(self, x, y)
end

function BWOJobsOverhauledList:doDrawItem(y, item, alt)
    if item.height <= 0 then
        return y + item.height
    end
    if (y + self:getYScroll() + item.height < 0) or (y + self:getYScroll() >= self.height) then
        return y + item.height
    end

    local panel = self.parentPanel
    local indent = panel.indent
    local iconSize = panel.iconSize
    local iconX = indent * item.item.level

    if self.selected == item.index then
        self:drawSelection(0, y, self:getWidth(), item.height - 1)
    end

    if item.item.hasChildren then
        local tex = item.item.expanded and panel.arrowDown or panel.arrowRight
        if tex then
            self:drawTexture(tex, iconX, y + (item.height - iconSize) / 2, 1, 1, 1, 1)
        end
    elseif item.item.nodeType == "condition" and item.item.icon then
        if item.item.icon == "check" then
            self:drawText("✔", iconX + 2, y + 2, 0.2, 0.9, 0.2, 1, UIFont.Small)
        elseif item.item.icon == "cross" then
            self:drawText("✖", iconX + 2, y + 2, 0.9, 0.2, 0.2, 1, UIFont.Small)
        end
    end

    local textX = iconX + iconSize + 6
    local textColor = item.item.textColor or { r = 1, g = 1, b = 1, a = 1 }
    self:drawText(item.text, textX, y + 2, textColor.r, textColor.g, textColor.b, textColor.a, item.item.font)

    return y + item.height
end

BWOJobsOverhauledPanel = ISCollapsableWindow:derive("BWOJobsOverhauledPanel")

local function text(key)
    return getTextOrNull(key) or getText(key)
end

local function bwolog(message)
    if not BWOJobsOverhauled or not BWOJobsOverhauled.Debug then return end
    print("[BWOJobsOverhauled] " .. tostring(message))
end

function BWOJobsOverhauledPanel:initialise()
    bwolog("Panel initialise")
    ISCollapsableWindow.initialise(self)
end

function BWOJobsOverhauledPanel:createChildren()
    bwolog("Panel createChildren")
    ISCollapsableWindow.createChildren(self)

    self.indent = 20
    self.iconSize = 14
    self.arrowRight = getTexture("media/ui/ArrowRight.png")
    self.arrowDown = getTexture("media/ui/ArrowDown.png")
    self.nodeState = {}
    self.refreshCounter = 0

    local listY = self:titleBarHeight() + 10
    local list = BWOJobsOverhauledList:new(10, listY, self.width - 20, self.height - listY - 10)
    list:initialise()
    list:instantiate()
    list.parentPanel = self
    list.itemheight = getTextManager():getFontHeight(UIFont.Medium) + 6
    list.doDrawItem = BWOJobsOverhauledList.doDrawItem
    list.drawBorder = true
    list:setFont(UIFont.Medium)

    self:addChild(list)
    self.list = list

    self:setTitle(text("UI_BWO_JobsOverhauled_Title"))
end

function BWOJobsOverhauledPanel:toggleNode(nodeId)
    bwolog("Toggle node " .. tostring(nodeId))
    self.nodeState[nodeId] = not self.nodeState[nodeId]
    self:refreshList()
end

function BWOJobsOverhauledPanel:refreshList()
    bwolog("Refreshing jobs list")
    self.list:clear()

    local player = getSpecificPlayer(self.playerNum)
    if not player then
        bwolog("No player for jobs list")
        return
    end

    local jobs = BWOJobsOverhauled.GetJobs(player)
    for _, job in ipairs(jobs) do
        local jobNodeId = "job:" .. job.id
        local jobExpanded = self.nodeState[jobNodeId]
        if jobExpanded == nil then
            jobExpanded = true
            self.nodeState[jobNodeId] = true
        end

        local jobItem = {
            nodeId = jobNodeId,
            nodeType = "job",
            level = 0,
            hasChildren = true,
            expanded = jobExpanded,
            textColor = { r = 0.2, g = 0.9, b = 0.2, a = 1 },
            font = UIFont.Large,
        }
        local jobHeight = getTextManager():getFontHeight(UIFont.Large) + 6
        self.list:addItem(job.text, jobItem).height = jobHeight

        if jobExpanded then
            for _, task in ipairs(job.tasks) do
                local taskNodeId = jobNodeId .. ":task:" .. task.id
                local taskExpanded = self.nodeState[taskNodeId]
                if taskExpanded == nil then
                    taskExpanded = true
                    self.nodeState[taskNodeId] = true
                end

                local taskItem = {
                    nodeId = taskNodeId,
                    nodeType = "task",
                    level = 1,
                    hasChildren = true,
                    expanded = taskExpanded,
                    font = UIFont.Medium,
                }
                local taskHeight = getTextManager():getFontHeight(UIFont.Medium) + 6
                self.list:addItem(task.text, taskItem).height = taskHeight

                if taskExpanded then
                    for _, condition in ipairs(task.conditions) do
                        local conditionMet = condition.check and condition.check() or false
                        local conditionText = condition.text
                        if condition.getStatusText then
                            local statusText = condition.getStatusText()
                            if statusText and statusText ~= "" then
                                conditionText = string.format("%s (%s)", conditionText, statusText)
                            end
                        end
                        local icon = nil
                        if condition.isLongTerm then
                            icon = conditionMet and "check" or "cross"
                        end
                        local conditionItem = {
                            nodeId = taskNodeId .. ":cond:" .. condition.id,
                            nodeType = "condition",
                            level = 2,
                            hasChildren = false,
                            met = conditionMet,
                            icon = icon,
                            font = UIFont.Smallest,
                        }
                        local conditionHeight = getTextManager():getFontHeight(UIFont.Smallest) + 6
                        self.list:addItem(conditionText, conditionItem).height = conditionHeight
                    end
                end
            end
        end
    end
end

function BWOJobsOverhauledPanel:update()
    ISCollapsableWindow.update(self)
    self.refreshCounter = self.refreshCounter + 1
    if self.refreshCounter >= 30 then
        self.refreshCounter = 0
        if self:getIsVisible() then
            bwolog("Auto-refreshing visible panel")
            self:refreshList()
        end
    end
end

function BWOJobsOverhauledPanel:onResize()
    bwolog("Panel resized")
    ISCollapsableWindow.onResize(self)
    if self.list then
        local listY = self:titleBarHeight() + 10
        self.list:setX(10)
        self.list:setY(listY)
        self.list:setWidth(self.width - 20)
        self.list:setHeight(self.height - listY - 10)
    end
end

function BWOJobsOverhauledPanel:close()
    bwolog("Panel close requested")
    self:setVisible(false)
end

function BWOJobsOverhauledPanel:new(x, y, width, height, playerNum)
    bwolog("Panel new at x=" .. tostring(x) .. " y=" .. tostring(y))
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum
    o.resizable = true
    o.pin = true
    return o
end
