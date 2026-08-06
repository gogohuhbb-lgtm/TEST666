local XorixHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/gogohuhbb-lgtm/TEST666/refs/heads/main/Main.lua"))()

local Window = XorixHub:CreateWindow("XORIX HUB")

local MainTab     = Window:CreateTab("Main")
local CombatTab   = Window:CreateTab("Combat")
local VisualsTab  = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")
local MiscTab     = Window:CreateTab("Misc")

MainTab:CreateSection("Main Controls")

MainTab:CreateSlider("WalkSpeed Modifier", 16, 250, 16, function(value)
    -- Code here
end)

MainTab:CreateSlider("JumpPower Modifier", 50, 300, 50, function(value)
    -- Code here
end)

MainTab:CreateToggle("Infinite Jump Ability", false, function(state)
    -- Code here
end)

MainTab:CreateButton("Reset Character Position", function()
    -- Code here
end)

CombatTab:CreateSection("Combat Controls")

CombatTab:CreateToggle("Example Combat Toggle", false, function(state)
    -- Code here
end)

CombatTab:CreateSlider("Example Combat Slider", 1, 100, 50, function(value)
    -- Code here
end)

CombatTab:CreateButton("Example Combat Button", function()
    -- Code here
end)

VisualsTab:CreateSection("Visual Controls")

VisualsTab:CreateToggle("Example Visual Toggle", false, function(state)
    -- Code here
end)

VisualsTab:CreateSlider("Example Visual Slider", 1, 100, 50, function(value)
    -- Code here
end)

VisualsTab:CreateButton("Example Visual Button", function()
    -- Code here
end)

SettingsTab:CreateSection("Settings Configuration")

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

MiscTab:CreateSection("Misc Utilities")

MiscTab:CreateToggle("Example Misc Toggle", false, function(state)
    -- Code here
end)

MiscTab:CreateSlider("Example Misc Slider", 1, 100, 50, function(value)
    -- Code here
end)

MiscTab:CreateButton("Rejoin Server", function()
    -- Code here
end)
TeleportTab:CreateButton("Teleport To Spawn", function()

end)

ConfigTab:CreateSection("Menu Options")

ConfigTab:CreateButton("Destroy Menu UI", function()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XorixHub_UI") then
        game.Players.LocalPlayer.PlayerGui.XorixHub_UI:Destroy()
    end
end)    -- Code here
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
