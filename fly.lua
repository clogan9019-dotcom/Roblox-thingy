-- Flying Script with Toggle Button
-- Place this in StarterPlayerScripts or execute in executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Settings
local flySpeed = 50
local isFlying = false
local bodyGyro = nil
local bodyVelocity = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "FlyToggle"
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Fly: OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = toggleButton

-- Create Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 120, 0, 25)
speedLabel.Position = UDim2.new(0, 20, 0.5, 30)
speedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedLabel.BorderSizePixel = 0
speedLabel.Text = "Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = screenGui

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedLabel

-- Function to start flying
local function startFlying()
    if not character or not humanoidRootPart then return end
    
    isFlying = true
    
    -- Create BodyGyro for rotation stability
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 1000
    bodyGyro.D = 100
    bodyGyro.Parent = humanoidRootPart
    
    -- Create BodyVelocity for movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Disable default physics
    humanoid.PlatformStand = true
    
    -- Update button appearance
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    toggleButton.Text = "Fly: ON"
end

-- Function to stop flying
local function stopFlying()
    isFlying = false
    
    -- Remove body movers
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    -- Re-enable default physics
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    -- Update button appearance
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggleButton.Text = "Fly: OFF"
end

-- Toggle function
local function toggleFly()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
end

-- Button click event
toggleButton.MouseButton1Click:Connect(toggleFly)

-- Movement update loop
RunService.RenderStepped:Connect(function()
    if isFlying and bodyVelocity and bodyGyro and humanoidRootPart then
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Get movement input
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        -- Apply movement
        if moveDirection.Magnitude > 0 then
            bodyVelocity.Velocity = moveDirection.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Update rotation to face camera direction
        bodyGyro.CFrame = camera.CFrame
    end
end)

-- Speed control with scroll wheel
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.InputType.MouseWheel then
        flySpeed = math.clamp(flySpeed + (input.Position.Z * 10), 10, 200)
        speedLabel.Text = "Speed: " .. flySpeed
    end
end)

-- Keyboard toggle (press F to toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    -- Reset flying state on respawn
    if isFlying then
        isFlying = false
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        toggleButton.Text = "Fly: OFF"
    end
end)

print("Flying Script Loaded!")
print("Click the button or press F to toggle flying")
print("Use scroll wheel to adjust speed")
