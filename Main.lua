local Majesty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local Theme = {
	Main = Color3.fromRGB(15, 15, 15),
	Secondary = Color3.fromRGB(20, 20, 20),
	Accent = Color3.fromRGB(0, 255, 194), -- Neon Mint
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(150, 150, 150),
	Font = Enum.Font.GothamSemibold
}

local function Tween(obj, info, goal)
	return TweenService:Create(obj, info, goal):Play()
end

function Majesty:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MajestyUI_" .. math.random(100, 999)
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ResetOnSpawn = false

	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 500, 0, 350)
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	MainFrame.BackgroundColor3 = Theme.Main
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = MainFrame

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(40, 40, 40)
	Stroke.Thickness = 1.5
	Stroke.Parent = MainFrame

	-- Top Bar (Title)
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = MainFrame

	local Title = Instance.new("TextLabel")
	Title.Text = title
	Title.Size = UDim2.new(1, -40, 1, 0)
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.TextColor3 = Theme.Text
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = Theme.Font
	Title.TextSize = 16
	Title.BackgroundTransparency = 1
	Title.Parent = TopBar

	-- Navigation Sidebar
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 140, 1, -50)
	Sidebar.Position = UDim2.new(0, 10, 0, 45)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 0
	Sidebar.Parent = MainFrame

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Padding = UDim.new(0, 5)
	SidebarLayout.Parent = Sidebar

	-- Content Area
	local ContentHolder = Instance.new("Frame")
	ContentHolder.Size = UDim2.new(1, -165, 1, -55)
	ContentHolder.Position = UDim2.new(0, 155, 0, 45)
	ContentHolder.BackgroundTransparency = 1
	ContentHolder.Parent = MainFrame

	-- Dragging Logic
	local Dragging, DragInput, DragStart, StartPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			DragStart = input.Position
			StartPos = MainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = input.Position - DragStart
			MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
	end)

	local Window = {}
	local FirstTab = true

	function Window:CreateTab(name)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 32)
		TabBtn.BackgroundColor3 = Theme.Secondary
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDark
		TabBtn.Font = Theme.Font
		TabBtn.TextSize = 13
		TabBtn.AutoButtonColor = false
		TabBtn.Parent = Sidebar
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = ContentHolder

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.Parent = Page

		if FirstTab then
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Accent
			FirstTab = false
		end

		TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(ContentHolder:GetChildren()) do v.Visible = false end
			for _, v in pairs(Sidebar:GetChildren()) do 
				if v:IsA("TextButton") then 
					Tween(v, TweenInfo.new(0.3), {TextColor3 = Theme.TextDark}) 
				end 
			end
			Page.Visible = true
			Tween(TabBtn, TweenInfo.new(0.3), {TextColor3 = Theme.Accent})
		end)

		local Tab = {}

		function Tab:CreateButton(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 0, 35)
			Btn.BackgroundColor3 = Theme.Secondary
			Btn.Text = "  " .. text
			Btn.TextColor3 = Theme.Text
			Btn.Font = Theme.Font
			Btn.TextSize = 14
			Btn.TextXAlignment = Enum.TextXAlignment.Left
			Btn.AutoButtonColor = false
			Btn.Parent = Page
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
			
			local StrokeBtn = Instance.new("UIStroke")
			StrokeBtn.Color = Color3.fromRGB(45, 45, 45)
			StrokeBtn.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			StrokeBtn.Parent = Btn

			Btn.MouseEnter:Connect(function() Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}) end)
			Btn.MouseLeave:Connect(function() Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}) end)
			
			Btn.MouseButton1Click:Connect(function()
				local Circle = Instance.new("Frame") -- Ripple Effect
				Circle.Size = UDim2.new(0,0,0,0)
				Circle.BackgroundColor3 = Color3.new(1,1,1)
				Circle.BackgroundTransparency = 0.8
				Circle.Shape = Enum.FrameShape.Circle -- Only works on certain versions, better use ImageLabel
				Circle.Parent = Btn
				callback()
			end)
		end

		function Tab:CreateToggle(text, callback)
			local TglFrame = Instance.new("Frame")
			TglFrame.Size = UDim2.new(1, -10, 0, 35)
			TglFrame.BackgroundColor3 = Theme.Secondary
			TglFrame.Parent = Page
			Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 8)

			local TglLabel = Instance.new("TextLabel")
			TglLabel.Text = "  " .. text
			TglLabel.Size = UDim2.new(1, 0, 1, 0)
			TglLabel.BackgroundTransparency = 1
			TglLabel.TextColor3 = Theme.Text
			TglLabel.Font = Theme.Font
			TglLabel.TextSize = 14
			TglLabel.TextXAlignment = Enum.TextXAlignment.Left
			TglLabel.Parent = TglFrame

			local TglBox = Instance.new("Frame")
			TglBox.Size = UDim2.new(0, 35, 0, 18)
			TglBox.Position = UDim2.new(1, -45, 0.5, -9)
			TglBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TglBox.Parent = TglFrame
			Instance.new("UICorner", TglBox).CornerRadius = UDim.new(1, 0)

			local Indicator = Instance.new("Frame")
			Indicator.Size = UDim2.new(0, 14, 0, 14)
			Indicator.Position = UDim2.new(0, 2, 0.5, -7)
			Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			Indicator.Parent = TglBox
			Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

			local Enabled = false
			local TglBtn = Instance.new("TextButton")
			TglBtn.Size = UDim2.new(1, 0, 1, 0)
			TglBtn.BackgroundTransparency = 1
			TglBtn.Text = ""
			TglBtn.Parent = TglFrame

			TglBtn.MouseButton1Click:Connect(function()
				Enabled = not Enabled
				local GoalPos = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				local GoalCol = Enabled and Theme.Accent or Color3.fromRGB(40, 40, 40)
				Tween(Indicator, TweenInfo.new(0.2), {Position = GoalPos})
				Tween(TglBox, TweenInfo.new(0.2), {BackgroundColor3 = GoalCol})
				callback(Enabled)
			end)
		end

		return Tab
	end

	return Window
end

return Majesty
