-- Silent Touch Fling (Self-Safe Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")

local FlingEnabled = false

-- GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.ResetOnSpawn = false
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, 0)
toggleButton.Text = "Fling: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Instance.new("UICorner", toggleButton)

toggleButton.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    toggleButton.Text = FlingEnabled and "Fling: ON" or "Fling: OFF"
    toggleButton.BackgroundColor3 = FlingEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

-- Power settings
local flingPower = 500000 -- Lowered slightly to be more stable

RunService.Stepped:Connect(function()
    if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- Disable ALL collisions for yourself so you don't hit the floor and launch
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        -- The "Fling" Force
        -- We use a slightly more stable directional force
        hrp.Velocity = Vector3.new(flingPower, flingPower, flingPower)
        
        -- High speed rotation (the actual part that hits others)
        hrp.RotVelocity = Vector3.new(0, flingPower, 0)
    end
end)

-- Anti-Fling Self (Forces you to stay at your walk position)
RunService.PostSimulation:Connect(function()
    if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        -- This resets your velocity every frame AFTER the physics hit
        -- This prevents YOU from flying away while keeping the "hit" active
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
end)

print("Safe Fling Loaded. If you still fly, try jumping once.")
