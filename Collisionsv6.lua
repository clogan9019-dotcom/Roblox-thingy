-- MIC UP ULTIMATE STEALTH FLING
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local flingActive = false

-- GUI
local sg = Instance.new("ScreenGui", lp.PlayerGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.1, 0)
btn.Text = "ACTIVATE FLING"
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

-- Anchor to stop YOU from flying away
local bg = Instance.new("BodyGroup") -- Dummy object to hold values

btn.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    btn.Text = flingActive and "FLING ON (TOUCH THEM)" or "ACTIVATE FLING"
    btn.BackgroundColor3 = flingActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
end)

RunService.Heartbeat:Connect(function()
    if flingActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- PREVENT SELF FLING: Force your velocity to stay low for movement
        -- but spike it for collisions
        local oldVel = hrp.Velocity
        
        -- THE ATTACK: Extreme vibration (Simulates a massive impact)
        -- We flicker the velocity between 0 and 5000 every heartbeat
        hrp.Velocity = Vector3.new(0, 5000, 0) 
        
        -- This part makes you "Solid" to others
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                -- Increase friction so they don't just slide off you
                part.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end
        end

        RunService.RenderStepped:Wait()
        
        -- Immediately snap your velocity back so you don't fly up
        hrp.Velocity = oldVel
    end
end)

-- COLLISION BYPASS: This forces the server to recognize you hitting them
RunService.Stepped:Connect(function()
    if lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    -- This is the secret: making their parts massless on your screen
                    -- helps your computer "win" the physics calculation
                    part.Massless = true 
                end
            end
        end
    end
end)
