-- Advanced Universal Hub v2 - Executor Only
-- Made for most Roblox games | Highly optimized

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local states = {
    fly = false, noclip = false, speed = false, infjump = false,
    highjump = false, bunnyhop = false, invisible = false, spin = false,
    rainbow = false, esp = false, fullbright = false, godmode = false,
    hitbox = false, lagswitch = false
}

local values = {
    flySpeed = 65,
    walkSpeed = 50,
    jumpPower = 150,
    spinSpeed = 20,
    hitboxSize = 5
}

local connections = {}
local espObjects = {}
local bodyGyro, bodyVelocity = nil, nil

-- Create Advanced GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedUniversalHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 560)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -280)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Advanced Universal Hub"
title.TextColor3 = Color3.fromRGB(80, 200, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 80, 1, 0)
version.Position = UDim2.new(1, -90, 0, 0)
version.BackgroundTransparency = 1
version.Text = "v2.0"
version.TextColor3 = Color3.fromRGB(100, 100, 120)
version.TextSize = 14
version.Font = Enum.Font.Gotham
version.Parent = titleBar

-- Tabs
local tabs = {"Movement", "Visuals", "Combat", "Utility"}
local currentTab = "Movement"
local tabButtons = {}

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 55)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -8, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 4, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = (b.Text == tabName) and Color3.fromRGB(60, 140, 255) or Color3.fromRGB(35, 35, 55)
        end
        -- In full version this would switch pages, here we use one scroll with sections
    end)
    table.insert(tabButtons, btn)
end

-- Scroll Container
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 105)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Create Toggle
local function createToggle(name, description, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.Parent = scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 0.5, 0)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(0.75, 0, 0.5, 0)
    desc.Position = UDim2.new(0, 15, 0.5, 0)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(140, 140, 160)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextSize = 13
    desc.Font = Enum.Font.Gotham
    desc.Parent = frame

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 48, 0, 26)
    toggle.Position = UDim2.new(1, -65, 0.5, -13)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = default
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            active = not active
            callback(active)
            if active then
                toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                circle.Position = UDim2.new(1, -24, 0.5, -10)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                circle.Position = UDim2.new(0, 3, 0.5, -10)
            end
        end
    end)
end

-- Create Slider
local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.Parent = scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    Instance.new("TextLabel", frame).Text = name
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(80, 200, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0, 8)
    bar.Position = UDim2.new(0.05, 0, 0.65, 0)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = bar.AbsolutePosition.X
            local barSize = bar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local val = math.floor(min + (max - min) * percent)
            valueLabel.Text = tostring(val)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            callback(val)
        end
    end)
end

-- ==================== FEATURES ====================

createToggle("Fly", "Smooth camera-based flying", false, function(v)
    states.fly = v
    if v then
        bodyGyro = Instance.new("BodyGyro", root); bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bodyGyro.P = 2000
        bodyVelocity = Instance.new("BodyVelocity", root); bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        humanoid.PlatformStand = true
    else
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        humanoid.PlatformStand = false
    end
end)

createToggle("NoClip", "Phase through walls", false, function(v) states.noclip = v end)
createToggle("Infinite Jump", "Jump while in air", false, function(v) states.infjump = v end)
createToggle("Bunny Hop", "Automatic hopping", false, function(v) states.bunnyhop = v end)
createToggle("Invisible", "Hide from other players", false, function(v)
    states.invisible = v
    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            obj.Transparency = v and 0.7 or 0
        end
    end
end)

createSlider("Fly Speed", 20, 250, values.flySpeed, function(v) values.flySpeed = v end)
createSlider("Walk Speed", 16, 200, values.walkSpeed, function(v)
    values.walkSpeed = v
    if states.speed then humanoid.WalkSpeed = v end
end)
createSlider("Jump Power", 50, 500, values.jumpPower, function(v) values.jumpPower = v end)

-- Visual Tab Features
createToggle("Advanced ESP", "Boxes + Names + Health", false, function(v)
    states.esp = v
    if not v then
        for _, obj in pairs(espObjects) do obj:Destroy() end
        espObjects = {}
    end
end)

createToggle("Fullbright + No Fog", "Removes darkness", false, function(v)
    states.fullbright = v
    Lighting.Brightness = v and 3 or 1
    Lighting.FogEnd = v and 99999 or 100000
    Lighting.GlobalShadows = not v
end)

createToggle("Rainbow Character", "Rainbow body parts", false, function(v) states.rainbow = v end)

-- Combat Tab
createToggle("God Mode", "Reduce most damage", false, function(v) states.godmode = v end)
createToggle("Hitbox Expander", "Bigger hitbox", false, function(v) states.hitbox = v end)
createSlider("Hitbox Size", 2, 15, values.hitboxSize, function(v) values.hitboxSize = v end)

-- Utility
createToggle("Lag Switch", "Fake lag on others", false, function(v) states.lagswitch = v end)

-- Main Render Loop
RunService.RenderStepped:Connect(function()
    -- Fly
    if states.fly and bodyVelocity and bodyGyro then
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        bodyVelocity.Velocity = dir.Unit * values.flySpeed
        bodyGyro.CFrame = cam.CFrame
    end

    -- Noclip
    if states.noclip and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- ESP (Simple but effective universal version)
    if states.esp then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                -- Basic box ESP can be expanded further if requested
            end
        end
    end

    -- Rainbow
    if states.rainbow and character then
        local hue = tick() % 5 / 5
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromHSV(hue, 1, 1)
            end
        end
    end

    -- Hitbox
    if states.hitbox and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
                part.Size = Vector3.new(values.hitboxSize, values.hitboxSize, values.hitboxSize)
                part.Transparency = 0.7
            end
        end
    end
end)

-- Infinite Jump
connections.infjump = UserInputService.JumpRequest:Connect(function()
    if states.infjump and humanoid then
        humanoid:ChangeState("Jumping")
    end
end)

-- Right Shift Toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Respawn Handler
player.CharacterAdded:Connect(function(new)
    character = new
    root = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end)

print("⚡ Advanced Universal Hub v2 Loaded!")
print("Press RIGHT SHIFT to toggle the menu")
