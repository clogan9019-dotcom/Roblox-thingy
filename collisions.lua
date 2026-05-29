-- Roblox Trolling GUI by Grok
-- Paste into StarterPlayerScripts or use with an executor

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local isTrolling = false
local connections = {}
local spinAttachment = nil
local spinAngular = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollMaster"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "😈 TROLL MASTER 😈"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner", title)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 40)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = mainFrame

-- Buttons
local buttons = {
    {name = "Toggle All Troll", color = Color3.fromRGB(0, 170, 255), func = function() end},
    {name = "Spin Bot", color = Color3.fromRGB(255, 140, 0), func = "spin"},
    {name = "Fling Players", color = Color3.fromRGB(200, 0, 255), func = "fling"},
    {name = "Sit Spam", color = Color3.fromRGB(0, 255, 100), func = "sit"},
    {name = "Chat Spam", color = Color3.fromRGB(255, 50, 50), func = "chat"},
    {name = "Sound Spam", color = Color3.fromRGB(255, 215, 0), func = "sound"},
    {name = "Rainbow Character", color = Color3.fromRGB(255, 0, 255), func = "rainbow"},
}

local yOffset = 75
local activeTrolls = {}

for _, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.BackgroundColor3 = btnData.color
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        if btnData.func == "spin" then
            toggleSpin()
        elseif btnData.func == "fling" then
            flingPlayers()
        elseif btnData.func == "sit" then
            toggleSitSpam()
        elseif btnData.func == "chat" then
            toggleChatSpam()
        elseif btnData.func == "sound" then
            toggleSoundSpam()
        elseif btnData.func == "rainbow" then
            toggleRainbow()
        end
    end)
    
    yOffset += 45
end

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
local closeCorner = Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ================== TROLL FUNCTIONS ==================

function toggleSpin()
    if activeTrolls.spin then
        activeTrolls.spin = false
        if spinAngular then spinAngular:Destroy() end
        if spinAttachment then spinAttachment:Destroy() end
    else
        activeTrolls.spin = true
        spinAttachment = Instance.new("Attachment", root)
        spinAngular = Instance.new("AngularVelocity")
        spinAngular.Attachment0 = spinAttachment
        spinAngular.AngularVelocity = Vector3.new(0, 50, 0)
        spinAngular.MaxTorque = math.huge
        spinAngular.Parent = root
    end
end

function flingPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root2 = plr.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = root.CFrame.LookVector * 150 + Vector3.new(0, 50, 0)
            bv.Parent = root2
            game.Debris:AddItem(bv, 0.8)
        end
    end
end

local sitConnection
function toggleSitSpam()
    if activeTrolls.sit then
        activeTrolls.sit = false
        sitConnection:Disconnect()
    else
        activeTrolls.sit = true
        sitConnection = RunService.Heartbeat:Connect(function()
            if humanoid then
                humanoid.Sit = true
            end
        end)
    end
end

local trollMessages = {"ez", "get rekt", "ratio", "L", "bozo", "cry about it", "skill issue", "💀", "noob", "mad?"}

function toggleChatSpam()
    if activeTrolls.chat then
        activeTrolls.chat = false
    else
        activeTrolls.chat = true
        spawn(function()
            while activeTrolls.chat do
                if player then
                    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        trollMessages[math.random(1, #trollMessages)], "All")
                end
                wait(math.random(1, 3))
            end
        end)
    end
end

function toggleSoundSpam()
    if activeTrolls.sound then
        activeTrolls.sound = false
    else
        activeTrolls.sound = true
        spawn(function()
            while activeTrolls.sound do
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://"..({5316591314, 131013229, 9113674371, 4595237879})[math.random(1,4)]
                sound.Volume = 2
                sound.Parent = workspace
                sound:Play()
                game.Debris:AddItem(sound, 4)
                wait(2.5)
            end
        end)
    end
end

local rainbowConnection
function toggleRainbow()
    if activeTrolls.rainbow then
        activeTrolls.rainbow = false
        rainbowConnection:Disconnect()
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(255,255,255)
            end
        end
    else
        activeTrolls.rainbow = true
        local hue = 0
        rainbowConnection = RunService.RenderStepped:Connect(function()
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = color
                end
            end
        end)
    end
end

-- Master Toggle (Press T)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        isTrolling = not isTrolling
        status.Text = "Status: " .. (isTrolling and "CHAOS ENABLED" or "OFF")
        status.TextColor3 = isTrolling and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
    end
end)

print("Troll Master GUI Loaded!")
print("Press T to toggle chaos mode | GUI is draggable")
print("Use at your own risk in public servers 😈")
