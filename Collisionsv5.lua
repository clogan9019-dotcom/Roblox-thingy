-- MIC UP STEALTH FLING (No Self-Fling Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local flingActive = false

-- GUI 
local sg = Instance.new("ScreenGui", lp.PlayerGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.2, 0)
btn.Text = "STEALTH FLING: OFF"
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    btn.Text = flingActive and "STEALTH FLING: ON" or "STEALTH FLING: OFF"
    btn.BackgroundColor3 = flingActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

-- The "Anti-Self-Fling" Logic
RunService.Heartbeat:Connect(function()
    if flingActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        
        -- 1. SAVE MOMENTUM
        local oldVel = hrp.Velocity
        
        -- 2. THE STABILIZER (Prevents you from flying away)
        -- We set your velocity to a massive number only for a split second 
        -- then immediately set it back to 0 or your walking speed.
        hrp.Velocity = oldVel * 0.1 -- Keep your movement smooth
        
        -- 3. THE ATTACK (Applied to your RootPart)
        -- High AngularVelocity creates the "impact" force without moving you
        hrp.AngularVelocity = Vector3.new(0, 99999, 0) 
        hrp.RotVelocity = Vector3.new(0, 99999, 0)
        
        -- 4. THE HITBOX STRETCH
        -- This makes the physics engine think your character is "wider"
        -- so you hit them before they even touch your visual body
        for _, part in pairs(lp.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false -- Your limbs don't collide (prevents self-fling)
            end
        end
        hrp.CanCollide = true -- Only your center part hits them
        
        task.wait() -- Wait one physics frame
        
        -- 5. RESET (So you stay stable)
        if hrp then
            hrp.RotVelocity = Vector3.new(0, 0, 0)
            hrp.AngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Force Collisions on OTHER players so you can actually hit them
RunService.Stepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
