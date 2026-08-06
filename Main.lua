local XorixHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Theme: Cyberpunk Neon Dark (Uiverse.io Inspired)
local Theme = {
    MainBG = Color3.fromRGB(10, 12, 16),
    SidebarBG = Color3.fromRGB(14, 17, 23),
    CardBG = Color3.fromRGB(18, 22, 30),
    AccentCyan = Color3.fromRGB(0, 229, 255),       -- Vibrant Neon Cyan
    AccentGlow = Color3.fromRGB(0, 160, 200),
    TextMain = Color3.fromRGB(240, 245, 250),
    TextMuted = Color3.fromRGB(120, 135, 155),
    StrokeDark = Color3.fromRGB(28, 36, 48),
    IconID = "rbxassetid://114044975848151"
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

    -- Clean up previous instance
    if LocalPlayer.PlayerGui:FindFirstChild("XorixHub_UI") then
        LocalPlayer.PlayerGui.XorixHub_UI:Destroy()
    end

    -- ScreenGui Setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XorixHub_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main Container Frame (Responsive)
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0.85, 0, 0.75, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.MainBG
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    -- Screen Size Constraints for Mobile & Desktop
    local Constraint = Instance.new("UISizeConstraint", Main)
    Constraint.MinSize = Vector2.new(320, 260)
    Constraint.MaxSize = Vector2.new(620, 400)

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- Pulsating Neon Glow Stroke (Uiverse Style)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.AccentCyan
    MainStroke.Thickness = 1.8

    task.spawn(function()
        while Main and Main.Parent do
            CreateTween(MainStroke, 1.8, {Color = Theme.AccentCyan, Thickness = 2})
            task.wait(1.8)
            CreateTween(MainStroke, 1.8, {Color = Theme.AccentGlow, Thickness = 1.2})
            task.wait(1.8)
        end
    end)

    -- Header Bar
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundColor3 = Theme.SidebarBG
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local HeaderDivider = Instance.new("Frame")
    HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
    HeaderDivider.Position = UDim2.new(0, 0, 1, -1)
    HeaderDivider.BackgroundColor3 = Theme.StrokeDark
    HeaderDivider.BorderSizePixel = 0
    HeaderDivider.Parent = Header

    -- Icon Container (Glowing Frame)
    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 36, 0, 36)
    IconFrame.Position = UDim2.new(0, 10, 0.5, -18)
    IconFrame.BackgroundColor3 = Theme.CardBG
    IconFrame.Parent = Header
    Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)

    local IconStroke = Instance.new("UIStroke", IconFrame)
    IconStroke.Color = Theme.AccentCyan
    IconStroke.Thickness = 1

    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "XorixIcon"
    IconImage.Size = UDim2.new(0, 26, 0, 26)
    IconImage.Position = UDim2.new(0.5, -13, 0.5, -13)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = Theme.IconID
    IconImage.ScaleType = Enum.ScaleType.Fit
    IconImage.Parent = IconFrame

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = titleText
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 54, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Theme.TextMain
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    -- Mobile & Mouse Dragging Logic
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

    -- Sidebar Area
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, -52)
    Sidebar.Position = UDim2.new(0, 0, 0, 52)
    Sidebar.BackgroundColor3 = Theme.SidebarBG
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.BackgroundColor3 = Theme.StrokeDark
    SidebarLine.BorderSizePixel = 0
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
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 6)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Main Content Display Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -130, 1, -52)
    ContentArea.Position = UDim2.new(0, 130, 0, 52)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = Main

    -- Tab Creator
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
        TabBtn.Parent = TabContainer

        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabGlowLine = Instance.new("Frame")
        TabGlowLine.Size = UDim2.new(0, 3, 0, 18)
        TabGlowLine.Position = UDim2.new(0, 3, 0.5, -9)
        TabGlowLine.BackgroundColor3 = Theme.AccentCyan
        TabGlowLine.BackgroundTransparency = 1
        TabGlowLine.Parent = TabBtn
        Instance.new("UICorner", TabGlowLine).CornerRadius = UDim.new(1, 0)

        -- Scrollable Page for tab elements
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
        Page.Parent = ContentArea

        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local PagePadding = Instance.new("UIPadding", Page)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)

        -- Tab Selection Action
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

        -- Select First Tab by Default
        if Window.CurrentTab == nil then
            Window.CurrentTab = tabName
            Page.Visible = true
            TabBtn.TextColor3 = Theme.AccentCyan
            TabBtn.BackgroundTransparency = 0.9
            TabGlowLine.BackgroundTransparency = 0
        end

        -- Section Label
        function Tab:CreateSection(sectName)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 20)
            SecLabel.Text = string.upper(sectName)
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextColor3 = Theme.AccentCyan
            SecLabel.TextSize = 11
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.BackgroundTransparency = 1
            SecLabel.Parent = Page
        end

        -- Button Element (Uiverse Cyber Touch Scale)
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
            Btn.Parent = Page

            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Btn)
            Stroke.Color = Theme.StrokeDark
            Stroke.Thickness = 1

            -- Touch / Click Recoil Animation
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

        -- Toggle Element
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
            ToggleBtn.Parent = Page

            Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", ToggleBtn)
            Stroke.Color = Theme.StrokeDark

            local SwitchTrack = Instance.new("Frame")
            SwitchTrack.Size = UDim2.new(0, 36, 0, 20)
            SwitchTrack.Position = UDim2.new(1, -46, 0.5, -10)
            SwitchTrack.BackgroundColor3 = enabled and Theme.AccentCyan or Color3.fromRGB(35, 42, 54)
            SwitchTrack.Parent = ToggleBtn
            Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Knob.BackgroundColor3 = Theme.TextMain
            Knob.Parent = SwitchTrack
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            ToggleBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                CreateTween(SwitchTrack, 0.2, {BackgroundColor3 = enabled and Theme.AccentCyan or Color3.fromRGB(35, 42, 54)})
                CreateTween(Knob, 0.2, {Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                task.spawn(callback, enabled)
            end)
        end

        -- Slider Element (Touch & Drag Responsive)
        function Tab:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)
            callback = callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 48)
            SliderFrame.BackgroundColor3 = Theme.CardBG
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
            ValLabel.Parent = SliderFrame

            local TrackBG = Instance.new("Frame")
            TrackBG.Size = UDim2.new(1, -24, 0, 6)
            TrackBG.Position = UDim2.new(0, 12, 1, -12)
            TrackBG.BackgroundColor3 = Color3.fromRGB(35, 42, 54)
            TrackBG.Parent = SliderFrame
            Instance.new("UICorner", TrackBG)

            local TrackFill = Instance.new("Frame")
            TrackFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            TrackFill.BackgroundColor3 = Theme.AccentCyan
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

return XorixHub    SidebarLine.BackgroundColor3 = Theme.Stroke
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
