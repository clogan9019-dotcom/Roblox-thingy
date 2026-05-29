-- Silent Touch Fling (Universal / Mic Up)
-- Controls: Click the button to toggle. 
-- Walk into someone to fling them.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local FlingEnabled = false

-- GUI Creation
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "FlingGui"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, 0)
toggleButton.Text = "Fling: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", toggleButton)

toggleButton.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    toggleButton.Text = FlingEnabled and "Fling: ON" or "Fling: OFF"
    toggleButton.BackgroundColor3 = FlingEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

-- The Physics Bypass Logic
RunService.Stepped:Connect(function()
    if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        
        -- Make your character non-collidable so you don't fling yourself
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        -- This is the "Grip" part. We set a massive velocity 
        -- but keep it centered on your character so it looks like you're just walking.
        local oldVelocity = hrp.Velocity
        hrp.Velocity = Vector3.new(1000000, 1000000, 1000000) -- Massive force to bypass no-collision
        
        RunService.RenderStepped:Wait() -- Wait a tiny fraction
        hrp.Velocity = oldVelocity -- Reset it immediately so you don't fly away
    end
end)

-- Ensure we stay near the player to "touch" them
task.spawn(function()
    while true do
        if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            -- This makes the server think your "hitbox" is much more aggressive
            lp.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 5000, 0) 
        end
        task.wait()
    end
end)

print("Silent Fling Loaded. Walk into players to launch them.")
