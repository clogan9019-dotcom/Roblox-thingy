-- MIC UP EXECUTOR FLING (Works for others to see)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local flingActive = false

-- GUI
local sg = Instance.new("ScreenGui", lp.PlayerGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.5, -25)
btn.Text = "FLING: OFF"
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

btn.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    btn.Text = flingActive and "FLING: ON" or "FLING: OFF"
    btn.BackgroundColor3 = flingActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- THE EXPLOIT
RunService.Heartbeat:Connect(function()
    if flingActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- Save original velocity to keep movement looking "normal"
        local oldV = hrp.Velocity
        
        -- 1. Spin the character invisibly fast (The Engine Destroyer)
        -- This makes your hitbox "hit" them thousands of times per second
        hrp.RotVelocity = Vector3.new(0, 5000, 0) 
        
        -- 2. Micro-Teleport (The "Force" glitch)
        -- We move you forward and back 0.01 studs instantly. 
        -- To the server, you look still. To physics, you are a vibrating wrecking ball.
        hrp.Velocity = Vector3.new(500, 500, 500)
        
        RunService.RenderStepped:Wait()
        
        -- Reset so you don't actually fly away yourself
        hrp.Velocity = oldV
    end
end)

-- Collision Enabler (Must stay on for this to work)
RunService.Stepped:Connect(function()
    if lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    -- Force collisions on others too
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
