-- Simple Fly Script
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local flying = true
local speed = 50

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = Vector3.zero
bv.Parent = hrp

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
bg.CFrame = hrp.CFrame
bg.Parent = hrp

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local controls = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    Shift = false
}

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.W then controls.W = true end
    if input.KeyCode == Enum.KeyCode.A then controls.A = true end
    if input.KeyCode == Enum.KeyCode.S then controls.S = true end
    if input.KeyCode == Enum.KeyCode.D then controls.D = true end
    if input.KeyCode == Enum.KeyCode.Space then controls.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then controls.Shift = true end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then controls.W = false end
    if input.KeyCode == Enum.KeyCode.A then controls.A = false end
    if input.KeyCode == Enum.KeyCode.S then controls.S = false end
    if input.KeyCode == Enum.KeyCode.D then controls.D = false end
    if input.KeyCode == Enum.KeyCode.Space then controls.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then controls.Shift = false end
end)

RunService.RenderStepped:Connect(function()
    if not flying then return end

    local moveDir = Vector3.zero

    if controls.W then moveDir += camera.CFrame.LookVector end
    if controls.S then moveDir -= camera.CFrame.LookVector end
    if controls.A then moveDir -= camera.CFrame.RightVector end
    if controls.D then moveDir += camera.CFrame.RightVector end
    if controls.Space then moveDir += Vector3.new(0,1,0) end
    if controls.Shift then moveDir -= Vector3.new(0,1,0) end

    if moveDir.Magnitude > 0 then
        bv.Velocity = moveDir.Unit * speed
    else
        bv.Velocity = Vector3.zero
    end

    bg.CFrame = camera.CFrame
end)
