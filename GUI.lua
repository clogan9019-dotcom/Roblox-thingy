-- Full Player Hub GUI
-- Place in StarterPlayerScripts or execute in executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ============================================
-- STATES
-- ============================================
local states = {
    fly = false,
    noclip = false,
    infiniteJump = false,
    speed = false,
    highJump = false,
    antiGravity = false,
    invisible = false,
    spin = false,
    bunnyHop = false,
    rainbow = false,
}

local flySpeed = 50
local walkSpeed = 50
local jumpPower = 150
local spinSpeed = 10
local bodyGyro = nil
local bodyVelocity = nil
local defaultWalkSpeed = 16
local defaultJumpPower = 50
local menuOpen = true

-- ============================================
-- GUI CREATION
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix bottom corners of title bar
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ Player Hub"
titleText.TextColor3 = Color3.fromRGB(130, 180, 255)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Scroll Frame for buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ButtonContainer"
scrollFrame.Size = UDim2.new(1, -20, 1, -55)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(130, 180, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- ============================================
-- BUTTON CREATION FUNCTION
-- ============================================
local buttons = {}

local function createToggleButton(name, icon, description, layoutOrder)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = name .. "Frame"
    buttonFrame.Size = UDim2.new(1, 0, 0, 55)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = layoutOrder
    buttonFrame.Parent = scrollFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = buttonFrame

    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 10, 0.5, -17)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 22
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Parent = buttonFrame

    -- Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 50, 0, 7)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = buttonFrame

    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.6, 0, 0, 15)
    descLabel.Position = UDim2.new(0, 50, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = buttonFrame

    -- Toggle Button
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 26)
    toggleBg.Position = UDim2.new(1, -65, 0.5, -13)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = buttonFrame

    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(1, 0)
    toggleBgCorner.Parent = toggleBg

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle

    -- Click detection
    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = buttonFrame

    buttons[name] = {
        frame = buttonFrame,
        toggleBg = toggleBg,
        toggleCircle = toggleCircle,
        clickButton = clickButton,
        active = false
    }

    return clickButton
end

local function updateToggleVisual(name, active)
    local btn = buttons[name]
    if not btn then return end

    btn.active = active
    if active then
        btn.toggleBg.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        btn.toggleCircle.Position = UDim2.new(1, -23, 0.5, -10)
        btn.toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        btn.toggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
        btn.toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- ============================================
-- CREATE SLIDER FUNCTION
-- ============================================
local function createSlider(name, icon, description, min, max, default, layoutOrder, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 70)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.LayoutOrder = layoutOrder
    sliderFrame.Parent = scrollFrame

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 8)
    sCorner.Parent = sliderFrame

    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 0, 20)
    iconLabel.Position = UDim2.new(0, 10, 0, 8)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Parent = sliderFrame

    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 45, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = sliderFrame

    -- Value Label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(130, 180, 255)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame

    -- Slider Background
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 0, 45)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg

    -- Slider Fill
    local fillPercent = (default - min) / (max - min)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(130, 180, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    -- Slider Knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(fillPercent, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = sliderBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    -- Slider Input
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 0, 30)
    sliderButton.Position = UDim2.new(0, 0, 0, 35)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.ZIndex = 3
    sliderButton.Parent = sliderFrame

    local dragging = false

    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.InputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.InputType.MouseMovement then
            local absolutePos = sliderBg.AbsolutePosition.X
            local absoluteSize = sliderBg.AbsoluteSize.X
            local mouseX = input.Position.X

            local percent = math.clamp((mouseX - absolutePos) / absoluteSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)

            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -8, 0.5, -8)
            valueLabel.Text = tostring(value)

            if callback then
                callback(value)
            end
        end
    end)

    return sliderFrame
end

-- ============================================
-- CREATE ALL BUTTONS
-- ============================================

-- Section Header
local function createHeader(text, order)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 25)
    header.BackgroundTransparency = 1
    header.Text = text
    header.TextColor3 = Color3.fromRGB(130, 180, 255)
    header.TextSize = 13
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = order
    header.Parent = scrollFrame
end

createHeader("— MOVEMENT —", 1)

local flyBtn = createToggleButton("Fly", "✈️", "Fly around the map freely", 2)
local noclipBtn = createToggleButton("NoClip", "👻", "Walk through walls and objects", 3)
local speedBtn = createToggleButton("Speed", "⚡", "Increase your walk speed", 4)
local highJumpBtn = createToggleButton("High Jump", "🦘", "Jump extremely high", 5)
local infJumpBtn = createToggleButton("Infinite Jump", "🔄", "Jump unlimited times in air", 6)
local antiGravBtn = createToggleButton("Anti-Gravity", "🌙", "Low gravity moon mode", 7)
local bunnyHopBtn = createToggleButton("Bunny Hop", "🐇", "Auto hop while moving", 8)

createHeader("— SLIDERS —", 9)

createSlider("Fly Speed", "✈️", "Adjust fly speed", 10, 200, 50, 10, function(value)
    flySpeed = value
end)

createSlider("Walk Speed", "⚡", "Adjust walk speed", 16, 200, 50, 11, function(value)
    walkSpeed = value
    if states.speed and humanoid then
        humanoid.WalkSpeed = value
    end
end)

createSlider("Jump Power", "🦘", "Adjust jump power", 50, 500, 150, 12, function(value)
    jumpPower = value
    if states.highJump and humanoid then
        humanoid.JumpPower = value
    end
end)

createSlider("Spin Speed", "🌀", "Adjust spin speed", 1, 50, 10, 13, function(value)
    spinSpeed = value
end)

createHeader("— VISUAL —", 14)

local invisBtn = createToggleButton("Invisible", "👁️", "Become invisible to others", 15)
local spinBtn = createToggleButton("Spin", "🌀", "Spin your character around", 16)
local rainbowBtn = createToggleButton("Rainbow", "🌈", "Rainbow colored character", 17)

-- ============================================
-- FLY FUNCTIONS
-- ============================================
local function startFlying()
    states.fly = true
    updateToggleVisual("Fly", true)

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 1000
    bodyGyro.D = 100
    bodyGyro.Parent = humanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart

    humanoid.PlatformStand = true
end

local function stopFlying()
    states.fly = false
    updateToggleVisual("Fly", false)

    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if humanoid then humanoid.PlatformStand = false end
end

-- ============================================
-- NOCLIP FUNCTION
-- ============================================
local noclipConnection = nil

local function startNoclip()
    states.noclip = true
    updateToggleVisual("NoClip", true)

    noclipConnection = RunService.Stepped:Connect(function()
        if states.noclip and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoclip()
    states.noclip = false
    updateToggleVisual("NoClip", false)

    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ============================================
-- SPEED FUNCTION
-- ============================================
local function toggleSpeed()
    states.speed = not states.speed
    updateToggleVisual("Speed", states.speed)

    if states.speed then
        humanoid.WalkSpeed = walkSpeed
    else
        humanoid.WalkSpeed = defaultWalkSpeed
    end
end

-- ============================================
-- HIGH JUMP FUNCTION
-- ============================================
local function toggleHighJump()
    states.highJump = not states.highJump
    updateToggleVisual("High Jump", states.highJump)

    if states.highJump then
        humanoid.JumpPower = jumpPower
    else
        humanoid.JumpPower = defaultJumpPower
    end
end

-- ============================================
-- INFINITE JUMP FUNCTION
-- ============================================
local infJumpConnection = nil

local function toggleInfiniteJump()
    states.infiniteJump = not states.infiniteJump
    updateToggleVisual("Infinite Jump", states.infiniteJump)

    if states.infiniteJump then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            if states.infiniteJump and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end

-- ============================================
-- ANTI-GRAVITY FUNCTION
-- ============================================
local gravityDefault = workspace.Gravity

local function toggleAntiGravity()
    states.antiGravity = not states.antiGravity
    updateToggleVisual("Anti-Gravity", states.antiGravity)

    if states.antiGravity then
        workspace.Gravity = 40
    else
        workspace.Gravity = gravityDefault
    end
end

-- ============================================
-- BUNNY HOP FUNCTION
-- ============================================
local bunnyConnection = nil

local function toggleBunnyHop()
    states.bunnyHop = not states.bunnyHop
    updateToggleVisual("Bunny Hop", states.bunnyHop)

    if states.bunnyHop then
        bunnyConnection = RunService.Heartbeat:Connect(function()
            if states.bunnyHop and humanoid then
                if humanoid.MoveDirection.Magnitude > 0 then
                    if humanoid.FloorMaterial ~= Enum.Material.Air then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    else
        if bunnyConnection then
            bunnyConnection:Disconnect()
            bunnyConnection = nil
        end
    end
end

-- ============================================
-- INVISIBLE FUNCTION
-- ============================================
local function toggleInvisible()
    states.invisible = not states.invisible
    updateToggleVisual("Invisible", states.invisible)

    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = states.invisible and 1 or 0
            elseif part:IsA("Decal") then
                part.Transparency = states.invisible and 1 or 0
            end
        end
    end
end

-- ============================================
-- SPIN FUNCTION
-- ============================================
local spinConnection = nil

local function toggleSpin()
    states.spin = not states.spin
    updateToggleVisual("Spin", states.spin)

    if states.spin then
        spinConnection = RunService.Heartbeat:Connect(function()
            if states.spin and humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end)
    else
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
    end
end

-- ============================================
-- RAINBOW FUNCTION
-- ============================================
local rainbowConnection = nil
local hue = 0

local function toggleRainbow()
    states.rainbow = not states.rainbow
    updateToggleVisual("Rainbow", states.rainbow)

    if states.rainbow then
        rainbowConnection = RunService.Heartbeat:Connect(function()
            if states.rainbow and character then
                hue = (hue + 0.005) % 1
                local color = Color3.fromHSV(hue, 1, 1)

                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Color = color
                    end
                end
            end
        end)
    else
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
    end
end

-- ============================================
-- CONNECT BUTTON EVENTS
-- ============================================
flyBtn.MouseButton1Click:Connect(function()
    if states.fly then stopFlying() else startFlying() end
end)

noclipBtn.MouseButton1Click:Connect(function()
    if states.noclip then stopNoclip() else startNoclip() end
end)

speedBtn.MouseButton1Click:Connect(toggleSpeed)
highJumpBtn.MouseButton1Click:Connect(toggleHighJump)
infJumpBtn.MouseButton1Click:Connect(toggleInfiniteJump)
antiGravBtn.MouseButton1Click:Connect(toggleAntiGravity)
bunnyHopBtn.MouseButton1Click:Connect(toggleBunnyHop)
invisBtn.MouseButton1Click:Connect(toggleInvisible)
spinBtn.MouseButton1Click:Connect(toggleSpin)
rainbowBtn.MouseButton1Click:Connect(toggleRainbow)

-- ============================================
-- FLY MOVEMENT LOOP
-- ============================================
RunService.RenderStepped:Connect(function()
    if states.fly and bodyVelocity and bodyGyro and humanoidRootPart then
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end

        bodyGyro.CFrame = camera.CFrame
    end
end)

-- ============================================
-- MINIMIZE / MAXIMIZE
-- ============================================
minimizeBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    scrollFrame.Visible = menuOpen

    if menuOpen then
        mainFrame.Size = UDim2.new(0, 300, 0, 500)
        minimizeBtn.Text = "—"
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 45)
        minimizeBtn.Text = "+"
    end
end)

-- ============================================
-- RIGHT SHIFT TO TOGGLE MENU VISIBILITY
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- ============================================
-- HANDLE CHARACTER RESPAWN
-- ============================================
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")

    -- Reset all states
    for key, _ in pairs(states) do
        states[key] = false
    end

    for name, _ in pairs(buttons) do
        updateToggleVisual(name, false)
    end

    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    if bunnyConnection then bunnyConnection:Disconnect() bunnyConnection = nil end
    if spinConnection then spinConnection:Disconnect() spinConnection = nil end
    if rainbowConnection then rainbowConnection:Disconnect() rainbowConnection = nil end

    workspace.Gravity = gravityDefault
end)

-- ============================================
-- STARTUP
-- ============================================
print("============================================")
print("⚡ Player Hub Loaded Successfully!")
print("============================================")
print("Press RIGHT SHIFT to show/hide menu")
print("Click the — button to minimize")
print("Drag the title bar to move the menu")
print("============================================")
