-- MIC UP Collision Toggler - Stand On People's Heads
-- Executor Script | Toggle to enable/disable player collisions

local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local collisionEnabled = false
local collisionGroupName = "MicUpTrollCollide"

-- Create Collision Group
if not pcall(function()
    PhysicsService:CreateCollisionGroup(collisionGroupName)
end) then
    -- Group already exists
end

PhysicsService:CollisionGroupSetCollidable(collisionGroupName, collisionGroupName, true)

-- Apply collisions to a character
local function applyCollisions(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = collisionGroupName
            part.CanCollide = true
        end
    end
end

-- Remove collisions (return to normal Mic Up behavior)
local function removeCollisions(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = "Default"
            part.CanCollide = false
        end
    end
end

-- Apply to all current players
local function updateAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            if collisionEnabled then
                applyCollisions(plr.Character)
            else
                removeCollisions(plr.Character)
            end
        end
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CollisionTroll"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
title.Text = "MIC UP COLLISION TROLL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.85, 0, 0, 55)
toggleButton.Position = UDim2.new(0.075, 0, 0, 55)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.Text = "COLLISIONS: OFF\n(Click to Enable)"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = toggleButton

-- Toggle Function
local function toggleCollisions()
    collisionEnabled = not collisionEnabled
    
    if collisionEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        toggleButton.Text = "COLLISIONS: ON\nYou can now stand on heads"
        updateAllPlayers()
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        toggleButton.Text = "COLLISIONS: OFF\n(Click to Enable)"
        updateAllPlayers()
    end
end

toggleButton.MouseButton1Click:Connect(toggleCollisions)

-- Handle existing and new characters
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        wait(0.5)
        if collisionEnabled then
            applyCollisions(char)
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        plr.CharacterAdded:Connect(function(char)
            wait(0.5)
            if collisionEnabled then applyCollisions(char) end
        end)
        if collisionEnabled then
            applyCollisions(plr.Character)
        end
    end
end

player.CharacterAdded:Connect(function(char)
    wait(1)
    if collisionEnabled then
        applyCollisions(char)
    end
end)

-- Auto refresh every 5 seconds (in case of respawns)
RunService.Heartbeat:Connect(function()
    if collisionEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CollisionGroup ~= collisionGroupName then
                        part.CollisionGroup = collisionGroupName
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end)

print("MIC UP Collision Toggler Loaded")
print("Click the button to enable collisions and stand on people")
print("Works best when executed after joining the game")
