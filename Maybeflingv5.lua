-- Fly + NoClip + Fling (Selective Collision)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local FlyEnabled = false
local FlingPower = 1000 -- Lower power to stay under Anti-Cheat radar

-- GUI
local screenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0, 20, 0.5, 0)
btn.Text = "Fly-Fling: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    btn.Text = FlyEnabled and "Fly-Fling: ON" or "Fly-Fling: OFF"
    btn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    if lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid").PlatformStand = FlyEnabled
    end
end)

RunService.Heartbeat:Connect(function()
    if FlyEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- NOCLIP: Only for the map/floor
        -- We do this by setting CanCollide to false every frame
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        -- FLYING LOGIC
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        
        -- TELEPORT MOVEMENT (Bypasses physics floor friction)
        hrp.CFrame = hrp.CFrame + (moveDir * 2)

        -- THE FLING (The trick is to spin ONLY the root part)
        -- We use high rotation, but 0 move velocity to stay stable
        hrp.Velocity = Vector3.new(0, 0, 0) 
        hrp.RotVelocity = Vector3.new(0, 10000, 0) -- High spin hits others
        
        -- Push down slightly to stay "engaged" with their hitbox
        hrp.Velocity = Vector3.new(0, -50, 0) 
    end
end)

print("Fly-Noclip-Fling Loaded!")
