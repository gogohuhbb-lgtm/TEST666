-- Fetch Majesty V2 UI Library
local Majesty = loadstring(game:HttpGet("https://raw.githubusercontent.com/gogohuhbb-lgtm/TEST666/refs/heads/main/Main.lua"))()

-- 1. Create Window
local Window = Majesty:CreateWindow("MAJESTY V2 | Combat Pro")

-- 2. Create Tabs
local MainTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

-- 3. Add Elements to Combat
MainTab:CreateSection("Killer Cheats")
MainTab:CreateButton("Kill All Players", function()
    print("Executing Kill All...")
end)

MainTab:CreateToggle("Auto-Farm Coins", function(state)
    print("Auto-farm is now:", state)
end)

MainTab:CreateSection("Movement")
MainTab:CreateSlider("WalkSpeed", 16, 250, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

-- 4. Add Elements to Visuals
VisualsTab:CreateSection("Player ESP")
VisualsTab:CreateToggle("Enable Tracers", function(state)
    print("Tracers:", state)
end)

VisualsTab:CreateSlider("ESP Distance", 50, 5000, 1000, function(v)
    print("Distance set to:", v)
end)

-- 5. Add Elements to Settings
SettingsTab:CreateButton("Unload UI", function()
    game.Players.LocalPlayer.PlayerGui.Majesty_V2:Destroy()
end)

print("Majesty UI Successfully Loaded!")
