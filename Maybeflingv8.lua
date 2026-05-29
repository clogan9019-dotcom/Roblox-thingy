-- Ghost Part Fling (No Character Modification)
-- A separate invisible part does all the work
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local FlingEnabled = false

-- GUI
local screenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0, 20, 0.5, -25)
btn.Text = "Ghost Fling: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    btn.Text = FlingEnabled and "Ghost Fling: ON" or "Ghost Fling: OFF"
    btn.BackgroundColor3 = FlingEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
end)

-- Create the ghost part (THIS is what flings people)
local ghostPart = Instance.new("Part")
ghostPart.Size = Vector3.new(5, 5, 5)
ghostPart.Transparency = 1 -- Invisible
ghostPart.CanCollide = true
ghostPart.Anchored = false
ghostPart.Massless = true
ghostPart.Parent = workspace

-- Attach to you with a WeldConstraint
local function attachGhost()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = lp.Character.HumanoidRootPart
        weld.Part1 = ghostPart
        weld.Parent = ghostPart
    end
end

-- Your character is NOT modified at all
-- Only the ghost part spins and flings
RunService.Heartbeat:Connect(function()
    if FlingEnabled and ghostPart then
        -- Spin the ghost part at max speed
        ghostPart.RotVelocity = Vector3.new(0, 9e9, 0)
    else
        if ghostPart then
            ghostPart.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Make sure it stays attached
RunService.RenderStepped:Connect(function()
    if FlingEnabled then
        attachGhost()
    end
end)

-- Handle respawn
lp.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if FlingEnabled then attachGhost() end
end)

print("Ghost Part Fling Loaded!")
