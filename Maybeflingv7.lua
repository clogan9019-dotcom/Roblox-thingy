-- Static Pusher (Stable Fling)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local userGui = lp:WaitForChild("PlayerGui")

local Enabled = false

-- GUI
local screenGui = Instance.new("ScreenGui", userGui)
screenGui.ResetOnSpawn = false
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0, 20, 0.5, 0)
btn.Text = "Pusher: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    btn.Text = Enabled and "Pusher: ON" or "Pusher: OFF"
    btn.BackgroundColor3 = Enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    
    -- Lock your physics to prevent tripping
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        local hum = lp.Character.Humanoid
        hum.PlatformStand = Enabled
        hum.WalkSpeed = Enabled and 0 or 16
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if Enabled and lp.Character then
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- 1. LOCK YOUR POSITION
            -- Set your velocity to 0 to ensure the game never trips you
            hrp.Velocity = Vector3.new(0, 0, 0)
            
            -- 2. DISABLE ALL COLLISION ON YOUR BODY EXCEPT ROOT
            -- This prevents floor friction from catching your legs
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = (v.Name == "HumanoidRootPart")
                end
            end
            
            -- 3. FORCE OTHER PLAYERS AWAY (Impulse Method)
            -- We don't teleport them, we find their position relative to us
            -- and push them slightly every frame. This feels more natural
            -- and less like a hard exploit.
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local trp = plr.Character.HumanoidRootPart
                    
                    -- Calculate vector between you and them
                    local diff = hrp.CFrame.LookVector
                    local dist = (trp.Position - hrp.Position).Magnitude
                    
                    if dist < 4 then -- Range: 4 studs
                        -- Apply a small impulse to their HRP away from you
                        local pushDir = hrp.CFrame.LookVector.Unit * 15
                        trp.Velocity = trp.Velocity + pushDir
                    end
                end
            end
        end
    end
end)

print("Static Pusher Loaded. Walk into people to shove them.")
