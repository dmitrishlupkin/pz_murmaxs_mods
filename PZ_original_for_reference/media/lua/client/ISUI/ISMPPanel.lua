require "ISUI/ISPanel"

ISMPPanel = ISPanel:derive("ISMPPanel");

function ISMPPanel:render()
    ISPanel.render(self);
    if self.doStencilRender then
        self:clearStencilRect();
    end
end

function ISMPPanel:prerender()
    if self.doStencilRender then
        self:setStencilRect(1,1,self:getWidth()-2,self:getHeight()-2);
    end
    ISPanel.prerender(self);
end