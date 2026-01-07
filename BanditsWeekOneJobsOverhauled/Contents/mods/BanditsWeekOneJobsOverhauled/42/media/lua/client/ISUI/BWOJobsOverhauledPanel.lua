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

    if item.item.backColor then
        local bg = item.item.backColor
        self:drawRect(0, y, self:getWidth(), item.height - 1, bg.a or 0.15, bg.r or 0, bg.g or 0, bg.b or 0)
    end

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
    local lines = item.item.lines
    if lines and #lines > 0 then
        local font = item.item.font or self.font
        local lineH = item.item.lineHeight or getTextManager():getFontHeight(font)
        for i = 1, #lines do
            self:drawText(lines[i], textX, y + 2 + (i - 1) * lineH, textColor.r, textColor.g, textColor.b, textColor.a, font)
        end
    else
        self:drawText(item.text, textX, y + 2, textColor.r, textColor.g, textColor.b, textColor.a, item.item.font)
    end

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

local function wrapTextLines(text, font, maxWidth)
    if not text or text == "" then
        return { "" }
    end
    local tm = getTextManager()
    if not tm or not tm.MeasureStringX then
        return { text }
    end
    local lines = {}
    for rawLine in string.gmatch(text, "([^\n]+)") do
        local line = ""
        for word in string.gmatch(rawLine, "%S+") do
            local candidate = line == "" and word or (line .. " " .. word)
            if tm:MeasureStringX(font, candidate) <= maxWidth then
                line = candidate
            else
                if line ~= "" then
                    table.insert(lines, line)
                end
                if tm:MeasureStringX(font, word) <= maxWidth then
                    line = word
                else
                    local chunk = ""
                    for i = 1, #word do
                        local ch = word:sub(i, i)
                        local test = chunk .. ch
                        if tm:MeasureStringX(font, test) > maxWidth and chunk ~= "" then
                            table.insert(lines, chunk)
                            chunk = ch
                        else
                            chunk = test
                        end
                    end
                    line = chunk
                end
            end
        end
        if line ~= "" then
            table.insert(lines, line)
        end
    end
    if #lines == 0 then
        table.insert(lines, text)
    end
    return lines
end

local function applyWrappedText(panel, listItem, text)
    if not panel or not listItem or not panel.list then return end
    local item = listItem.item or {}
    local font = item.font or panel.list.font or UIFont.Medium
    local iconX = panel.indent * (item.level or 0)
    local textX = iconX + panel.iconSize + 6
    local maxWidth = panel.list:getWidth() - textX - 10
    if maxWidth < 20 then maxWidth = 20 end
    local lines = wrapTextLines(text, font, maxWidth)
    item.lines = lines
    item.lineHeight = getTextManager():getFontHeight(font)
    listItem.item = item
    local height = (#lines * item.lineHeight) + 6
    local minHeight = panel.iconSize + 6
    if height < minHeight then
        height = minHeight
    end
    listItem.height = height
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
        local jobListItem = self.list:addItem(job.text, jobItem)
        applyWrappedText(self, jobListItem, job.text)

        if jobExpanded then
            for _, task in ipairs(job.tasks) do
                local taskNodeId = jobNodeId .. ":task:" .. task.id
                local taskExpanded = self.nodeState[taskNodeId]
                if taskExpanded == nil then
                    taskExpanded = true
                    self.nodeState[taskNodeId] = true
                end

                local shouldSkip = task.hideOnComplete and BWOJobsOverhauled.ShouldHideTask
                    and BWOJobsOverhauled.ShouldHideTask(player, task.id, task.highlightSeconds or 5)

                if not shouldSkip then
                    local taskItem = {
                        nodeId = taskNodeId,
                        nodeType = "task",
                        level = 1,
                        hasChildren = true,
                        expanded = taskExpanded,
                        font = UIFont.Medium,
                    }
                    local taskComplete = BWOJobsOverhauled.IsTaskComplete and BWOJobsOverhauled.IsTaskComplete(player, task.id)
                    local taskFailed = BWOJobsOverhauled.IsTaskFailed and BWOJobsOverhauled.IsTaskFailed(player, task.id)
                    if taskFailed then
                        taskItem.textColor = { r = 0.9, g = 0.2, b = 0.2, a = 1 }
                    elseif taskComplete then
                        taskItem.textColor = { r = 0.2, g = 0.9, b = 0.2, a = 1 }
                    end
                    if task.hideOnComplete and BWOJobsOverhauled.ShouldHighlightTask and BWOJobsOverhauled.ShouldHighlightTask(player, task.id, task.highlightSeconds or 5) then
                        taskItem.backColor = { r = 0.1, g = 0.6, b = 0.1, a = 0.25 }
                    end
                    local taskListItem = self.list:addItem(task.text, taskItem)
                    applyWrappedText(self, taskListItem, task.text)

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
                            if condition.isLongTerm then
                                conditionItem.textColor = conditionMet and { r = 0.2, g = 0.9, b = 0.2, a = 1 } or { r = 0.9, g = 0.2, b = 0.2, a = 1 }
                                conditionItem.backColor = conditionMet and { r = 0.1, g = 0.4, b = 0.1, a = 0.15 } or { r = 0.4, g = 0.1, b = 0.1, a = 0.12 }
                            end
                            local conditionListItem = self.list:addItem(conditionText, conditionItem)
                            applyWrappedText(self, conditionListItem, conditionText)
                        end
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
        self:refreshList()
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
