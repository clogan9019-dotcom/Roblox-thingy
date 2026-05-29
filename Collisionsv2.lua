-- MIC UP COLLISION TOGGLER - FIXED VERSION
-- Run this after you fully join the game

local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer
local collisionEnabled = false
local guiVisible = true

-- Create Collision Group
pcall(function()
    PhysicsService:CreateCollisionGroup("MicUpStand")
    PhysicsService:CollisionGroupSetCollidable("MicUpStand", "MicUpStand", true)
end)

local function applyCollisions(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = "MicUpStand"
            part.CanCollide = true
        end
    end
end

local function removeCollisions(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = "Default"
            part.CanCollide = false
        end
    end
end

-- ================== GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CollisionFix"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui", 10)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
title.Text = "MIC UP COLLISION FIX"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 50)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(255, 70, 70)
status.Font = Enum.Font.GothamBold
status.TextSize = 16
status.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.8, 0, 0, 50)
toggle.Position = UDim2.new(0.1, 0, 0, 90)
toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggle.Text = "ENABLE COLLISIONS\n(Stand on heads)"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 15
toggle.Parent = frame

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

-- Toggle Logic
toggle.MouseButton1Click:Connect(function()
    collisionEnabled = not collisionEnabled
    
    if collisionEnabled then
        status.Text = "Status: COLLISIONS ENABLED"
        status.TextColor3 = Color3.fromRGB(0, 255, 100)
        toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        toggle.Text = "DISABLE COLLISIONS"
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then applyCollisions(plr.Character) end
        end
    else
        status.Text = "Status: OFF"
        status.TextColor3 = Color3.fromRGB(255, 70, 70)
        toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        toggle.Text = "ENABLE COLLISIONS\n(Stand on heads)"
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then removeCollisions(plr.Character) end
        end
    end
end)

print("✅ Collision script injected successfully")
print("If you still don't see the GUI, check your executor console for errors")

-- Hotkey (Press INSERT to toggle GUI visibility)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
        print("GUI visibility toggled: " .. tostring(guiVisible))
    end
end)
