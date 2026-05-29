-- Silent Touch Fling (Fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Fix: Define PlayerGui correctly
local playerGui = lp:WaitForChild("PlayerGui")

local FlingEnabled = false

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, 0)
toggleButton.Text = "Fling: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleButton

toggleButton.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    toggleButton.Text = FlingEnabled and "Fling: ON" or "Fling: OFF"
    toggleButton.BackgroundColor3 = FlingEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

-- The Physics Bypass Logic
RunService.Stepped:Connect(function()
    if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        
        -- Bypass collisions
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        -- Velocity Glitch
        local oldV = hrp.Velocity
        hrp.Velocity = Vector3.new(1000000, 1000000, 1000000)
        RunService.RenderStepped:Wait()
        hrp.Velocity = oldV
    end
end)

-- Spin Logic (Invisible Force)
task.spawn(function()
    while true do
        if FlingEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 5000, 0) 
        end
        task.wait()
    end
end)

print("Fixed Silent Fling Loaded!")
