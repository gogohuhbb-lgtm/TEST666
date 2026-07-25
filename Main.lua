local Majesty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Visual Configuration
local Theme = {
    Main = Color3.fromRGB(11, 11, 14),
    Sidebar = Color3.fromRGB(15, 15, 18),
    Section = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(0, 255, 194),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(140, 140, 150),
    Stroke = Color3.fromRGB(40, 40, 45),
    Font = Enum.Font.GothamMedium
}

local function CreateTween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

function Majesty:CreateWindow(title)
    local Window = {CurrentTab = nil}
    
    -- Cleanup existing UI
    if LocalPlayer.PlayerGui:FindFirstChild("Majesty_V2") then
        LocalPlayer.PlayerGui.Majesty_V2:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Majesty_V2"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 520, 0, 360)
    Main.Position = UDim2.new(0.5, -260, 0.5, -180)
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Stroke
    MainStroke.Thickness = 1.2

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local SidebarLine = Instance.new("Frame") -- Visual separation
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.BackgroundColor3 = Theme.Stroke
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Text = title:upper()
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.TextColor3 = Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Content Area
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -150, 1, -10)
    ContentHolder.Position = UDim2.new(0, 145, 0, 5)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = Main

    -- Dragging functionality (Optimized)
    local dragToggle, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
    end)

    function Window:CreateTab(name)
        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 120, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.TextDark
        TabBtn.Font = Theme.Font
        TabBtn.TextSize = 13
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.Parent = ContentHolder
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then CreateTween(v, 0.2, {TextColor3 = Theme.TextDark, BackgroundTransparency = 1}) end
            end
            Page.Visible = true
            CreateTween(TabBtn, 0.2, {TextColor3 = Theme.Accent, BackgroundTransparency = 0.95})
        end)

        -- Default Tab
        if Window.CurrentTab == nil then
            Window.CurrentTab = name
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Accent
            TabBtn.BackgroundTransparency = 0.95
        end

        function Tab:CreateSection(sectName)
            local Label = Instance.new("TextLabel")
            Label.Text = sectName:upper()
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.TextColor3 = Theme.Accent
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 10
            Label.BackgroundTransparency = 1
            Label.Parent = Page
        end

        function Tab:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 36)
            Btn.BackgroundColor3 = Theme.Section
            Btn.Text = text
            Btn.TextColor3 = Theme.Text
            Btn.Font = Theme.Font
            Btn.TextSize = 13
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", Btn).Color = Theme.Stroke

            Btn.MouseButton1Click:Connect(function()
                task.spawn(callback)
                Btn.BackgroundColor3 = Theme.Accent
                CreateTween(Btn, 0.3, {BackgroundColor3 = Theme.Section})
            end)
        end

        function Tab:CreateToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -10, 0, 36)
            Tgl.BackgroundColor3 = Theme.Section
            Tgl.Text = "   " .. text
            Tgl.TextColor3 = Theme.Text
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Font = Theme.Font
            Tgl.TextSize = 13
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)
            
            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 32, 0, 16)
            Box.Position = UDim2.new(1, -42, 0.5, -8)
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Box.Parent = Tgl
            Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 12, 0, 12)
            Dot.Position = UDim2.new(0, 2, 0.5, -6)
            Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Dot.Parent = Box
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local enabled = false
            Tgl.MouseButton1Click:Connect(function()
                enabled = not enabled
                CreateTween(Dot, 0.2, {Position = enabled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
                CreateTween(Box, 0.2, {BackgroundColor3 = enabled and Theme.Accent or Color3.fromRGB(40, 40, 45)})
                task.spawn(callback, enabled)
            end)
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 45)
            SliderFrame.BackgroundColor3 = Theme.Section
            SliderFrame.Parent = Page
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Text = "   " .. text
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.TextColor3 = Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Theme.Font
            Label.TextSize = 13
            Label.BackgroundTransparency = 1
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(default)
            ValueLabel.Size = UDim2.new(0, 40, 0, 25)
            ValueLabel.Position = UDim2.new(1, -45, 0, 0)
            ValueLabel.TextColor3 = Theme.Accent
            ValueLabel.Font = Theme.Font
            ValueLabel.TextSize = 12
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Parent = SliderFrame

            local BarBG = Instance.new("TextButton") -- Button for easy clicking
            BarBG.Text = ""
            BarBG.Size = UDim2.new(1, -20, 0, 4)
            BarBG.Position = UDim2.new(0, 10, 1, -12)
            BarBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            BarBG.Parent = SliderFrame
            Instance.new("UICorner", BarBG)

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Bar.BackgroundColor3 = Theme.Accent
            Bar.Parent = BarBG
            Instance.new("UICorner", Bar)

            local function Update()
                local percent = math.clamp((Mouse.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * percent)
                ValueLabel.Text = tostring(val)
                Bar.Size = UDim2.new(percent, 0, 1, 0)
                task.spawn(callback, val)
            end

            local dragging = false
            BarBG.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            RunService.RenderStepped:Connect(function() if dragging then Update() end end)
        end

        return Tab
    end
    
    return Window
end

return Majesty 
