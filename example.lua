-- Fetch Xorix Hub UI Library
local XorixHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/gogohuhbb-lgtm/TEST666/refs/heads/main/Main.lua"))()

-- 1. Create Main Window
local Window = XorixHub:CreateWindow("XORIX HUB") --name it or idfk

-- 2. Creates the tabs.
local MainTab     = Window:CreateTab("Main")
local CombatTab   = Window:CreateTab("Combat")
local VisualsTab  = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")
local MiscTab     = Window:CreateTab("Misc")

--TABS SECTION
MainTab:CreateSection("Main Section")
--Creates slider
MainTab:CreateSlider("WalkSpeed", 16, 250, 16, function(value) --the 16, 250, 16. 16 is the Start, 250 is the end and the another 16 is the minimum
    -- Code here
end)

MainTab:CreateSlider("JumpPower", 50, 300, 50, function(value)
    -- Code here
end)
--creates Toggles
MainTab:CreateToggle("Example Toggle", false, function(state)
    -- Code here
end)
--creates Buttons
MainTab:CreateButton("Example Button", function()
    -- Code here
end)


CombatTab:CreateSection("Combat Section")

CombatTab:CreateToggle("Example Combat Toggle", false, function(state)
    -- Code here
end)

CombatTab:CreateSlider("Example Combat Slider", 1, 100, 50, function(value)
    -- Code here
end)

CombatTab:CreateButton("Example Combat Button", function()
    -- Code here
end)

VisualsTab:CreateSection("Visuals Section")

VisualsTab:CreateToggle("Example Visual Toggle", false, function(state)
    -- Code here
end)

VisualsTab:CreateSlider("Example Visual Slider", 1, 100, 50, function(value)
    -- Code here
end)

VisualsTab:CreateButton("Example Visual Button", function()
    -- Code here
end)


SettingsTab:CreateSection("Settings Section")

SettingsTab:CreateToggle("Example Setting Toggle", false, function(state)
    -- Code here
end)

SettingsTab:CreateSlider("Example Setting Slider", 1, 100, 50, function(value)
    -- Code here
end)

SettingsTab:CreateButton("Unload UI", function()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XorixHub_UI") then
        game.Players.LocalPlayer.PlayerGui.XorixHub_UI:Destroy()
    end
end)


MiscTab:CreateSection("Misc Section")

MiscTab:CreateToggle("Example Misc Toggle", false, function(state)
    -- Code here
end)

MiscTab:CreateSlider("Example Misc Slider", 1, 100, 50, function(value)
    -- Code here
end)

MiscTab:CreateButton("Rejoin Server", function()
    -- Code here
end)
