Item = {}
Item.__index = Item

setmetatable(Item, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:Init(...)
        return self
    end
})

function Item:Init(menu, text, textColor, disabledTextColor, bgColor, bgHoveredColor, opacity)
    self.parent = menu
    
    self.position = vector2(0, 0)
    
    self.height = 0.03

    self.text = Text(text)

    self.rightText = nil

    self.rightSprite = nil

    self.colors = {
        text                = textColor or Colors.White,
        disabledText        = disabledTextColor or Colors.LightGrey,
        background          = bgColor or Colors.DarkGrey,
        backgroundHovered   = bgHoveredColor or Colors.LightGrey,
        sprite              = textColor or Colors.White,
        disabledSprite      = disabledTextColor or Colors.LightGrey
    }
    self.opacity = opacity

    self.background = Rect(self.position, vector2(self.parent.width, self.height))

    self.OnClick = function() end
    self.OnRelease = function() end
    self.OnStartHover = function() end
    self.OnStopHover = function() end

    self.closeMenuOnClick = false

    self.enabled = true

    self.hovered = nil
end

function Item:Process(cursorPosition)
    local opacity = self.opacity
    local menuOverlapped = self.parent:IsOverlapped()
    if (menuOverlapped) then
        opacity = math.floor(opacity * 0.5)
    end
    self.background:Draw((self.hovered and self.enabled) and self.colors.backgroundHovered:Opacity(opacity) or self.colors.background:Opacity(opacity))

    if (self:IsOverlapped()) then
        return
    end
    
    if (self.enabled) then
        local hovered = self:InBounds(cursorPosition)
        if (hovered ~= self.hovered) then
            self.hovered = hovered

            if (self.hovered) then
                self:OnStartedHovering()
            else
                self:OnStoppedHovering()
            end
        end
    end

    local textOpacity = 255
    if (menuOverlapped) then
        textOpacity = 127
    end
    self.text:Draw(self.enabled and self.colors.text:Opacity(textOpacity) or self.colors.disabledText:Opacity(textOpacity))

    if (self.rightText) then
        self.rightText.position = self.position + vector2(self.parent.width - self.rightText:GetWidth() - 0.004, 0.003)

        self.rightText:Draw(self.enabled and self.colors.text:Opacity(textOpacity) or self.colors.disabledText:Opacity(textOpacity))
    end

    if (self.rightSprite) then
        self.rightSprite:Draw(self.enabled and self.colors.text:Opacity(textOpacity) or self.colors.disabledText:Opacity(textOpacity))
    end
end

function Item:IsOverlapped()
    for k, item in pairs(self.parent.items) do
        if (item.submenu ~= nil and item.submenu:Visible()) then
            for j, subItems in pairs(item.submenu.items) do
                if (subItems.submenu ~= nil and subItems.submenu:Visible()) then
                    for i, sub2Item in pairs(subItems.submenu.items) do
                        if (sub2Item:InBounds(self.position + vector2(self.parent.width, self.height) * 0.5)) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

function Item:OnStartedHovering()
    Citizen.CreateThread(function()
        self.OnStartHover()
    end)
end

function Item:OnStoppedHovering()
    Citizen.CreateThread(function()
        self.OnStopHover()
    end)
end

function Item:Clicked()
    if (not self.enabled) then
        return
    end
    
    Citizen.CreateThread(function()
        self.OnClick()
    end)
    
    if (self.closeMenuOnClick) then
        self.parent.pool:CloseAllMenus()
    end
end

function Item:Released()
    if (not self.enabled) then
        return
    end
    
    Citizen.CreateThread(function()
        self.OnRelease()
    end)
end

function Item:SetPosition(position)
    self.position = position
    self.background.position = self.position
    self.text.position = self.position + vector2(0.002, 0.003)

    if (self.rightSprite) then
        self.rightSprite:SetPosition(position + vector2(0.135, 0.0015))
    end
end

function Item:InBounds(position)
    return position.x >= self.position.x and position.y >= self.position.y and position.x < self.position.x + self.parent.width and position.y < self.position.y + self.height
end
