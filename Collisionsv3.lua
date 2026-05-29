-- MIC UP WALK FLING (Stealth / Natural Looking)
-- Collisions + Walk Fling combined

local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local collisionEnabled = true
local walkFlingEnabled = true
local flingStrength = 150   -- Increase this for stronger flings (recommended 120-250)

-- Create Collision Group
pcall(function()
    PhysicsService:CreateCollisionGroup("WalkFling")
    PhysicsService:CollisionGroupSetCollidable("WalkFling", "WalkFling", true)
end)

local function setCollisions(enabled)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CollisionGroup = enabled and "WalkFling" or "Default"
                    part.CanCollide = enabled
                end
            end
        end
    end
end

-- ================== GUI ==================
local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0.5, -130, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
title.Text = "MIC UP WALK FLING"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = frame

local colLabel = Instance.new("TextLabel")
colLabel.Size = UDim2.new(0.9, 0, 0, 25)
colLabel.Position = UDim2.new(0.05, 0, 0, 55)
colLabel.BackgroundTransparency = 1
colLabel.Text = "Collisions:"
colLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
colLabel.Font = Enum.Font.Gotham
colLabel.TextSize = 14
colLabel.Parent = frame

local colButton = Instance.new("TextButton")
colButton.Size = UDim2.new(0.9, 0, 0, 40)
colButton.Position = UDim2.new(0.05, 0, 0, 80)
colButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
colButton.Text = "COLLISIONS: ENABLED"
colButton.TextColor3 = Color3.new(1,1,1)
colButton.Font = Enum.Font.GothamBold
colButton.Parent = frame
Instance.new("UICorner", colButton).CornerRadius = UDim.new(0, 8)

local flingButton = Instance.new("TextButton")
flingButton.Size = UDim2.new(0.9, 0, 0, 40)
flingButton.Position = UDim2.new(0.05, 0, 0, 130)
flingButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
flingButton.Text = "WALK FLING: ENABLED"
flingButton.TextColor3 = Color3.new(1,1,1)
flingButton.Font = Enum.Font.GothamBold
flingButton.Parent = frame
Instance.new("UICorner", flingButton).CornerRadius = UDim.new(0, 8)

local strengthLabel = Instance.new("TextLabel")
strengthLabel.Position = UDim2.new(0.05, 0, 0, 180)
strengthLabel.Size = UDim2.new(0.9, 0, 0, 20)
strengthLabel.BackgroundTransparency = 1
strengthLabel.Text = "Fling Strength: " .. flingStrength
strengthLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
strengthLabel.Font = Enum.Font.Gotham
strengthLabel.TextSize = 13
strengthLabel.Parent = frame

-- Button Functions
colButton.MouseButton1Click:Connect(function()
    collisionEnabled = not collisionEnabled
    setCollisions(collisionEnabled)
    colButton.Text = collisionEnabled and "COLLISIONS: ENABLED" or "COLLISIONS: DISABLED"
    colButton.BackgroundColor3 = collisionEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

flingButton.MouseButton1Click:Connect(function()
    walkFlingEnabled = not walkFlingEnabled
    flingButton.Text = walkFlingEnabled and "WALK FLING: ENABLED" or "WALK FLING: DISABLED"
    flingButton.BackgroundColor3 = walkFlingEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

-- Main Walk Fling Loop (This is the stealthy part)
RunService.Heartbeat:Connect(function()
    if not walkFlingEnabled then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local root = player.Character.HumanoidRootPart
    local vel = root.Velocity

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local distance = (root.Position - targetRoot.Position).Magnitude

            if distance < 6 then -- Close enough to "bump" them
                -- Take network ownership + fling
                targetRoot:SetNetworkOwner(nil)
                
                local flingDirection = (root.Velocity.Unit * flingStrength) + Vector3.new(0, 45, 0)
                targetRoot.AssemblyLinearVelocity = flingDirection * 1.8
            end
        end
    end
end)

-- Auto apply collisions when players join
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if collisionEnabled then setCollisions(true) end
    end)
end)

print("MIC UP Walk Fling Loaded!")
print("Walk normally into players to fling them.")
print("Press INSERT to hide/show GUI")
