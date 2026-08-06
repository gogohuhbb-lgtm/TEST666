local Window = XorixHub:CreateWindow("XORIX HUB")

local PlayerTab   = Window:CreateTab("Player")
local FarmingTab  = Window:CreateTab("Farming")
local TeleportTab = Window:CreateTab("Teleports")
local ConfigTab   = Window:CreateTab("Config")

PlayerTab:CreateSection("Movement Controls")

PlayerTab:CreateSlider("WalkSpeed Modifier", 16, 250, 16, function(value)

end)

PlayerTab:CreateSlider("JumpPower Modifier", 50, 300, 50, function(value)

end)

PlayerTab:CreateToggle("Infinite Jump Ability", false, function(state)

end)

PlayerTab:CreateButton("Reset Character Position", function()

end)

FarmingTab:CreateSection("Automation Options")

FarmingTab:CreateToggle("Auto Collect Items", false, function(state)

end)

FarmingTab:CreateSlider("Collection Radius", 5, 100, 20, function(value)

end)

TeleportTab:CreateSection("Location Teleports")

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
