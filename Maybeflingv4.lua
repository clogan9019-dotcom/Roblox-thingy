-- Ultimate Fly-Fling Hybrid (Mic Up Optimized)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local FlingEnabled = false
local FlySpeed = 50

-- GUI
local screenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 160, 0, 100)
frame.Position = UDim2.new(0, 20, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "Fling-Fly: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 30)
label.Position = UDim2.new(0, 0, 0, 60)
label.Text = "WASD to Fly | Touch to Kill"
label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
label.BackgroundTransparency = 1
label.TextSize = 12

toggle.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    toggle.Text = FlingEnabled and "Fling-Fly: ON" or "Fling-Fly: OFF"
    toggle.BackgroundColor3 = FlingEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid").PlatformStand = FlingEnabled
    end
end)

-- Flying + Flinging Logic
RunService.Heartbeat:Connect(function()
    if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- 1. Fly Movement
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end
        
        -- 2. No Collision (Stay Safe)
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        -- 3. The Magic: Apply MASSIVE Velocity for Flinging
        -- We set velocity to a huge number, but since we are controlling 
        -- the position via CFrame (flying), YOU won't fly away.
        hrp.Velocity = Vector3.new(9e9, 9e9, 9e9) 
        hrp.RotVelocity = Vector3.new(0, 9e9, 0)

        -- 4. Move your character based on Fly speed
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (moveDir.Unit * (FlySpeed/10))
        else
            -- Stay in place if not moving (Prevents drifting)
            hrp.CFrame = hrp.CFrame
        end
    end
end)

-- Visual Fix (Stops the shaking on your screen)
RunService.RenderStepped:Connect(function()
    if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end)

print("Ultimate Fly-Fling Loaded!")
