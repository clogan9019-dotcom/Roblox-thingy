-- Selective Collision Fling (The "No-Limb" Method)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local FlyEnabled = false

-- GUI
local screenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0, 20, 0.5, 0)
btn.Text = "Fly-Fling: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    btn.Text = FlyEnabled and "Fly-Fling: ON" or "Fly-Fling: OFF"
    btn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid").PlatformStand = FlyEnabled
    end
end)

RunService.Heartbeat:Connect(function()
    if FlyEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- THE FIX: Force EVERY part except the Root to be tiny and non-collidable
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
                if v.Name ~= "HumanoidRootPart" then
                    -- We don't delete them (that kills you), we just make them not exist for physics
                    v.Velocity = Vector3.new(0, 0, 0)
                    v.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end

        -- FLYING LOGIC (Using CFrame to avoid floor friction)
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        
        hrp.CFrame = hrp.CFrame + (moveDir * 1.5)

        -- THE FLING HIT
        -- Only the HumanoidRootPart gets the massive rotation
        hrp.Velocity = Vector3.new(0, -100, 0) -- Gentle push down to keep you on top of them
        hrp.RotVelocity = Vector3.new(0, 50000, 0) -- High spin for the hit
    end
end)

-- Prevent your camera from shaking
RunService.RenderStepped:Connect(function()
    if FlyEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end)
