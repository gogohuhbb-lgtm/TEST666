local Majesty = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Performance Config
local Theme = {
	Main = Color3.fromRGB(12, 12, 14),
	Secondary = Color3.fromRGB(18, 18, 22),
	Accent = Color3.fromRGB(0, 255, 194),
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(160, 160, 170),
	Stroke = Color3.fromRGB(35, 35, 40),
	Font = Enum.Font.GothamMedium
}

-- Utility for memory management
local function Cleanup(obj)
	if not obj then return end
	if obj:IsA("RBXScriptConnection") then
		obj:Disconnect()
	elseif obj:IsA("Instance") then
		obj:Destroy()
	end
end

local function CreateTween(obj, info, goal)
	local tween = TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quad), goal)
	tween:Play()
	return tween
end

function Majesty:CreateWindow(title)
	local Window = {Tabs = {}, Connections = {}}
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Majesty_V2"
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 550, 0, 380)
	Main.Position = UDim2.new(0.5, -275, 0.5, -190)
	Main.BackgroundColor3 = Theme.Main
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
	local MainStroke = Instance.new("UIStroke", Main)
	MainStroke.Color = Theme.Stroke
	MainStroke.Thickness = 1.2

	-- Header
	local Header = Instance.new("Frame")
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.BackgroundTransparency = 1
	Header.Parent = Main
	
	local Title = Instance.new("TextLabel")
	Title.Text = title:upper()
	Title.Size = UDim2.new(1, -40, 1, 0)
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.TextColor3 = Theme.Text
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1
	Title.Parent = Header

	-- Tab Container
	local TabHolder = Instance.new("ScrollingFrame")
	TabHolder.Size = UDim2.new(0, 150, 1, -60)
	TabHolder.Position = UDim2.new(0, 10, 0, 50)
	TabHolder.BackgroundTransparency = 1
	TabHolder.ScrollBarThickness = 0
	TabHolder.Parent = Main
	local TabList = Instance.new("UIListLayout", TabHolder)
	TabList.Padding = UDim.new(0, 4)

	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, -180, 1, -60)
	Container.Position = UDim2.new(0, 170, 0, 50)
	Container.BackgroundTransparency = 1
	Container.Parent = Main

	-- Simple Dragging Logic (Optimized)
	local dragToggle, dragStart, startPos
	Header.InputBegan:Connect(function(input)
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

	Header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
	end)

	function Window:CreateTab(name)
		local Tab = {Elements = {}}
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 32)
		TabBtn.BackgroundColor3 = Theme.Secondary
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDark
		TabBtn.Font = Theme.Font
		TabBtn.TextSize = 12
		TabBtn.AutoButtonColor = false
		TabBtn.Parent = TabHolder
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = Container
		Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

		if #TabHolder:GetChildren() == 2 then -- First tab logic
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Accent
		end

		TabBtn.MouseButton1Click:Connect(function()
			for _, p in pairs(Container:GetChildren()) do p.Visible = false end
			for _, b in pairs(TabHolder:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Theme.TextDark end end
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Accent
		end)

		function Tab:CreateSection(name)
			local SectLabel = Instance.new("TextLabel")
			SectLabel.Text = name:upper()
			SectLabel.Size = UDim2.new(1, 0, 0, 20)
			SectLabel.BackgroundTransparency = 1
			SectLabel.TextColor3 = Theme.Accent
			SectLabel.Font = Enum.Font.GothamBold
			SectLabel.TextSize = 10
			SectLabel.Parent = Page
		end

		function Tab:CreateSlider(text, min, max, default, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, -10, 0, 45)
			SliderFrame.BackgroundColor3 = Theme.Secondary
			SliderFrame.Parent = Page
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

			local Label = Instance.new("TextLabel")
			Label.Text = "  " .. text
			Label.Size = UDim2.new(1, 0, 0, 25)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Theme.Text
			Label.Font = Theme.Font
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Text = tostring(default)
			ValueLabel.Size = UDim2.new(0, 40, 0, 25)
			ValueLabel.Position = UDim2.new(1, -45, 0, 0)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.TextColor3 = Theme.Accent
			ValueLabel.Font = Theme.Font
			ValueLabel.TextSize = 12
			ValueLabel.Parent = SliderFrame

			local BarBG = Instance.new("Frame")
			BarBG.Size = UDim2.new(1, -20, 0, 4)
			BarBG.Position = UDim2.new(0, 10, 1, -10)
			BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
			BarBG.Parent = SliderFrame
			Instance.new("UICorner", BarBG)

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			Bar.BackgroundColor3 = Theme.Accent
			Bar.Parent = BarBG
			Instance.new("UICorner", Bar)

			local dragging = false
			local function UpdateSlider()
				local percent = math.clamp((Mouse.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
				local val = math.floor(min + (max - min) * percent)
				Bar.Size = UDim2.new(percent, 0, 1, 0)
				ValueLabel.Text = tostring(val)
				callback(val)
			end

			SliderFrame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					UpdateSlider()
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					UpdateSlider()
				end
			end)
		end
		
		-- Helper for Toggles
		function Tab:CreateToggle(text, callback)
			local TglFrame = Instance.new("TextButton")
			TglFrame.Size = UDim2.new(1, -10, 0, 38)
			TglFrame.BackgroundColor3 = Theme.Secondary
			TglFrame.Text = "   " .. text
			TglFrame.TextColor3 = Theme.Text
			TglFrame.Font = Theme.Font
			TglFrame.TextSize = 13
			TglFrame.TextXAlignment = Enum.TextXAlignment.Left
			TglFrame.AutoButtonColor = false
			TglFrame.Parent = Page
			Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 8)

			local Box = Instance.new("Frame")
			Box.Size = UDim2.new(0, 34, 0, 18)
			Box.Position = UDim2.new(1, -44, 0.5, -9)
			Box.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			Box.Parent = TglFrame
			Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

			local Inner = Instance.new("Frame")
			Inner.Size = UDim2.new(0, 14, 0, 14)
			Inner.Position = UDim2.new(0, 2, 0.5, -7)
			Inner.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			Inner.Parent = Box
			Instance.new("UICorner", Inner).CornerRadius = UDim.new(1, 0)

			local enabled = false
			TglFrame.MouseButton1Click:Connect(function()
				enabled = not enabled
				CreateTween(Inner, 0.2, {Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
				CreateTween(Box, 0.2, {BackgroundColor3 = enabled and Theme.Accent or Color3.fromRGB(45, 45, 50)})
				callback(enabled)
			end)
		end

		function Tab:CreateButton(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 0, 38)
			Btn.BackgroundColor3 = Theme.Secondary
			Btn.Text = text
			Btn.TextColor3 = Theme.Text
			Btn.Font = Theme.Font
			Btn.TextSize = 13
			Btn.AutoButtonColor = false
			Btn.Parent = Page
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
			
			Btn.MouseButton1Click:Connect(function()
				callback()
				Btn.BackgroundColor3 = Theme.Accent
				task.wait(0.1)
				CreateTween(Btn, 0.2, {BackgroundColor3 = Theme.Secondary})
			end)
		end

		return Tab
	end

	return Window
end

return Majesty
