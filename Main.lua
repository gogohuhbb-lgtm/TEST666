local XorixHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Theme = {
    MainBG = Color3.fromRGB(10, 12, 16),
    SidebarBG = Color3.fromRGB(14, 17, 23),
    CardBG = Color3.fromRGB(18, 22, 30),
    AccentCyan = Color3.fromRGB(0, 229, 255),
    AccentGlow = Color3.fromRGB(0, 160, 200),
    TextMain = Color3.fromRGB(240, 245, 250),
    TextMuted = Color3.fromRGB(120, 135, 155),
    StrokeDark = Color3.fromRGB(28, 36, 48),
    IconID = "rbxassetid://114044975848151",
    ToggleIconID = "rbxassetid://110129510947911"
}

local function CreateTween(obj, duration, props, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, dir), props)
    tween:Play()
    return tween
end

function XorixHub:CreateWindow(titleText)
    titleText = titleText or "XORIX HUB"
    local Window = { CurrentTab = nil }

    if LocalPlayer.PlayerGui:FindFirstChild("XorixHub_UI") then
        LocalPlayer.PlayerGui.XorixHub_UI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XorixHub_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0.85, 0, 0.75, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.MainBG
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    local Constraint = Instance.new("UISizeConstraint", Main)
    Constraint.MinSize = Vector2.new(320, 260)
    Constraint.MaxSize = Vector2.new(620, 400)

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.AccentCyan
    MainStroke.Thickness = 1.8
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    task.spawn(function()
        while Main and Main.Parent do
            CreateTween(MainStroke, 1.8, {Color = Theme.AccentCyan, Thickness = 2})
            task.wait(1.8)
            CreateTween(MainStroke, 1.8, {Color = Theme.AccentGlow, Thickness = 1.2})
            task.wait(1.8)
        end
    end)

    local GlossReflection = Instance.new("Frame")
    GlossReflection.Name = "GlossReflection"
    GlossReflection.Size = UDim2.new(1, 0, 0.45, 0)
    GlossReflection.Position = UDim2.new(0, 0, 0, 0)
    GlossReflection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlossReflection.BorderSizePixel = 0
    GlossReflection.ZIndex = 10
    GlossReflection.Active = false
    GlossReflection.Parent = Main

    Instance.new("UICorner", GlossReflection).CornerRadius = UDim.new(0, 14)

    local GlossGradient = Instance.new("UIGradient", GlossReflection)
    GlossGradient.Rotation = 65
    GlossGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 229, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    GlossGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.93),
        NumberSequenceKeypoint.new(0.4, 0.96),
        NumberSequenceKeypoint.new(1, 1)
    })

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "OpenCloseToggle"
    ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Theme.SidebarBG
    ToggleBtn.Image = Theme.ToggleIconID
    ToggleBtn.ScaleType = Enum.ScaleType.Fit
    ToggleBtn.Parent = ScreenGui

    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ToggleStroke.Color = Theme.AccentCyan
    ToggleStroke.Thickness = 1.5

    local ToggleAspect = Instance.new("UIAspectRatioConstraint", ToggleBtn)
    ToggleAspect.AspectRatio = 1
    ToggleAspect.AspectType = Enum.AspectType.FitWithinMaxSize

    local toggleDragging, toggleDragStart, toggleStartPos
    local function updateToggleDrag(input)
        local delta = input.Position - toggleDragStart
        ToggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    end

    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragging = true
            toggleDragStart = input.Position
            toggleStartPos = ToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    toggleDragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateToggleDrag(input)
        end
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.ZIndex = 2
    Header.Parent = Main

    local HeaderDivider = Instance.new("Frame")
    HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
    HeaderDivider.Position = UDim2.new(0, 0, 1, -1)
    HeaderDivider.BackgroundColor3 = Theme.StrokeDark
    HeaderDivider.BorderSizePixel = 0
    HeaderDivider.ZIndex = 2
    HeaderDivider.Parent = Header

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0.68, 0, 0.68, 0)
    IconFrame.Position = UDim2.new(0, 10, 0.5, 0)
    IconFrame.AnchorPoint = Vector2.new(0, 0.5)
    IconFrame.BackgroundColor3 = Theme.CardBG
    IconFrame.ZIndex = 3
    IconFrame.Parent = Header
    Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)

    local IconAspect = Instance.new("UIAspectRatioConstraint", IconFrame)
    IconAspect.AspectRatio = 1
    IconAspect.AspectType = Enum.AspectType.FitWithinMaxSize
    IconAspect.DominantAxis = Enum.DominantAxis.Height

    local IconStroke = Instance.new("UIStroke", IconFrame)
    IconStroke.Color = Theme.AccentCyan
    IconStroke.Thickness = 1

    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "XorixIcon"
    IconImage.Size = UDim2.new(0.75, 0, 0.75, 0)
    IconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = Theme.IconID
    IconImage.ScaleType = Enum.ScaleType.Fit
    IconImage.ZIndex = 4
    IconImage.Parent = IconFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = titleText
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 54, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Theme.TextMain
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.ZIndex = 3
    TitleLabel.Parent = Header

    local dragging, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, -52)
    Sidebar.Position = UDim2.new(0, 0, 0, 52)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2
    Sidebar.Parent = Main

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.BackgroundColor3 = Theme.StrokeDark
    SidebarLine.BorderSizePixel = 0
    SidebarLine.ZIndex = 2
    SidebarLine.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ScrollingEnabled = true
    TabContainer.Active = true
    TabContainer.ZIndex = 3
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 6)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -130, 1, -52)
    ContentArea.Position = UDim2.new(0, 130, 0, 52)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ZIndex = 2
    ContentArea.Parent = Main

    function Window:CreateTab(tabName)
        local Tab = {}

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName .. "_TabBtn"
        TabBtn.Size = UDim2.new(0, 114, 0, 34)
        TabBtn.BackgroundColor3 = Theme.CardBG
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextMuted
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 3
        TabBtn.Parent = TabContainer

        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabGlowLine = Instance.new("Frame")
        TabGlowLine.Size = UDim2.new(0, 3, 0, 18)
        TabGlowLine.Position = UDim2.new(0, 3, 0.5, -9)
        TabGlowLine.BackgroundColor3 = Theme.AccentCyan
        TabGlowLine.BackgroundTransparency = 1
        TabGlowLine.ZIndex = 4
        TabGlowLine.Parent = TabBtn
        Instance.new("UICorner", TabGlowLine).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.AccentCyan
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollingEnabled = true
        Page.Active = true
        Page.ZIndex = 3
        Page.Parent = ContentArea

        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local PagePadding = Instance.new("UIPadding", Page)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, c in pairs(ContentArea:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    CreateTween(btn, 0.2, {TextColor3 = Theme.TextMuted, BackgroundTransparency = 1})
                    if btn:FindFirstChild("Frame") then
                        CreateTween(btn.Frame, 0.2, {BackgroundTransparency = 1})
                    end
                end
            end
            Page.Visible = true
            CreateTween(TabBtn, 0.2, {TextColor3 = Theme.AccentCyan, BackgroundTransparency = 0.9})
            CreateTween(TabGlowLine, 0.2, {BackgroundTransparency = 0})
        end)

        if Window.CurrentTab == nil then
            Window.CurrentTab = tabName
            Page.Visible = true
            TabBtn.TextColor3 = Theme.AccentCyan
            TabBtn.BackgroundTransparency = 0.9
            TabGlowLine.BackgroundTransparency = 0
        end

        function Tab:CreateSection(sectName)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 20)
            SecLabel.Text = string.upper(sectName)
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextColor3 = Theme.AccentCyan
            SecLabel.TextSize = 11
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.BackgroundTransparency = 1
            SecLabel.ZIndex = 3
            SecLabel.Parent = Page
        end

        function Tab:CreateButton(text, callback)
            callback = callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            Btn.BackgroundColor3 = Theme.CardBG
            Btn.Text = text
            Btn.TextColor3 = Theme.TextMain
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.AutoButtonColor = false
            Btn.ZIndex = 3
            Btn.Parent = Page

            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Btn)
            Stroke.Color = Theme.StrokeDark
            Stroke.Thickness = 1

            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    CreateTween(Btn, 0.1, {Size = UDim2.new(0.98, 0, 0, 36)})
                    CreateTween(Stroke, 0.1, {Color = Theme.AccentCyan})
                end
            end)

            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    CreateTween(Btn, 0.15, {Size = UDim2.new(1, 0, 0, 38)})
                    CreateTween(Stroke, 0.3, {Color = Theme.StrokeDark})
                end
            end)

            Btn.MouseButton1Click:Connect(function()
                task.spawn(callback)
            end)
        end

        function Tab:CreateToggle(text, defaultState, callback)
            local enabled = defaultState or false
            callback = callback or function() end

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
            ToggleBtn.BackgroundColor3 = Theme.CardBG
            ToggleBtn.Text = "  " .. text
            ToggleBtn.TextColor3 = Theme.TextMain
            ToggleBtn.Font = Enum.Font.GothamMedium
            ToggleBtn.TextSize = 13
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.ZIndex = 3
            ToggleBtn.Parent = Page

            Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", ToggleBtn)
            Stroke.Color = Theme.StrokeDark

            local SwitchTrack = Instance.new("Frame")
            SwitchTrack.Size = UDim2.new(0, 36, 0, 20)
            SwitchTrack.Position = UDim2.new(1, -46, 0.5, -10)
            SwitchTrack.BackgroundColor3 = enabled and Theme.AccentCyan or Color3.fromRGB(35, 42, 54)
            SwitchTrack.ZIndex = 4
            SwitchTrack.Parent = ToggleBtn
            Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Knob.BackgroundColor3 = Theme.TextMain
            Knob.ZIndex = 5
            Knob.Parent = SwitchTrack
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            ToggleBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                CreateTween(SwitchTrack, 0.2, {BackgroundColor3 = enabled and Theme.AccentCyan or Color3.fromRGB(35, 42, 54)})
                CreateTween(Knob, 0.2, {Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                task.spawn(callback, enabled)
            end)
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)
            callback = callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 48)
            SliderFrame.BackgroundColor3 = Theme.CardBG
            SliderFrame.ZIndex = 3
            SliderFrame.Parent = Page

            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", SliderFrame)
            Stroke.Color = Theme.StrokeDark

            local Label = Instance.new("TextLabel")
            Label.Text = "  " .. text
            Label.Size = UDim2.new(0.65, 0, 0, 24)
            Label.Font = Enum.Font.GothamMedium
            Label.TextColor3 = Theme.TextMain
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.ZIndex = 4
            Label.Parent = SliderFrame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Text = tostring(default)
            ValLabel.Size = UDim2.new(0.35, -12, 0, 24)
            ValLabel.Position = UDim2.new(0.65, 0, 0, 0)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextColor3 = Theme.AccentCyan
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.BackgroundTransparency = 1
            ValLabel.ZIndex = 4
            ValLabel.Parent = SliderFrame

            local TrackBG = Instance.new("Frame")
            TrackBG.Size = UDim2.new(1, -24, 0, 6)
            TrackBG.Position = UDim2.new(0, 12, 1, -12)
            TrackBG.BackgroundColor3 = Color3.fromRGB(35, 42, 54)
            TrackBG.ZIndex = 4
            TrackBG.Parent = SliderFrame
            Instance.new("UICorner", TrackBG)

            local TrackFill = Instance.new("Frame")
            TrackFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            TrackFill.BackgroundColor3 = Theme.AccentCyan
            TrackFill.ZIndex = 5
            TrackFill.Parent = TrackBG
            Instance.new("UICorner", TrackFill)

            local isSliding = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - TrackBG.AbsolutePosition.X) / TrackBG.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                ValLabel.Text = tostring(val)
                TrackFill.Size = UDim2.new(pos, 0, 1, 0)
                task.spawn(callback, val)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = false
                end
            end)
        end

        return Tab
    end

    return Window
end

local Window = XorixHub:CreateWindow("XORIX HUB")

local MainTab     = Window:CreateTab("Main")
local CombatTab   = Window:CreateTab("Combat")
local VisualsTab  = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")
local MiscTab     = Window:CreateTab("Misc")

MainTab:CreateSection("Main Section")

MainTab:CreateSlider("WalkSpeed", 16, 250, 16, function(value)

end)

MainTab:CreateSlider("JumpPower", 50, 300, 50, function(value)

end)

MainTab:CreateToggle("Example Toggle", false, function(state)

end)

MainTab:CreateButton("Example Button", function()

end)

CombatTab:CreateSection("Combat Section")

CombatTab:CreateToggle("Example Combat Toggle", false, function(state)

end)

CombatTab:CreateSlider("Example Combat Slider", 1, 100, 50, function(value)

end)

CombatTab:CreateButton("Example Combat Button", function()

end)

VisualsTab:CreateSection("Visuals Section")

VisualsTab:CreateToggle("Example Visual Toggle", false, function(state)

end)

VisualsTab:CreateSlider("Example Visual Slider", 1, 100, 50, function(value)

end)

VisualsTab:CreateButton("Example Visual Button", function()

end)

SettingsTab:CreateSection("Settings Section")

SettingsTab:CreateToggle("Example Setting Toggle", false, function(state)

end)

SettingsTab:CreateSlider("Example Setting Slider", 1, 100, 50, function(value)

end)

SettingsTab:CreateButton("Unload UI", function()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XorixHub_UI") then
        game.Players.LocalPlayer.PlayerGui.XorixHub_UI:Destroy()
    end
end)

MiscTab:CreateSection("Misc Section")

MiscTab:CreateToggle("Example Misc Toggle", false, function(state)

end)

MiscTab:CreateSlider("Example Misc Slider", 1, 100, 50, function(value)

end)

MiscTab:CreateButton("Rejoin Server", function()

end)
