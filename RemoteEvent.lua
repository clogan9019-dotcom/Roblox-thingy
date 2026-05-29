-- REMOTE EVENT EXPLORER & TESTER
local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "RemoteExplorer"

-- Main Frame
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 350, 0, 400)
frame.Position = UDim2.new(0.5, -175, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.Text = "REMOTE EVENT BROWSER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title)

-- Scrolling list for Remotes
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- Tooltip/Status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 1, 0)
status.BackgroundColor3 = Color3.fromRGB(0,0,0)
status.Text = "Click a button to FireServer()"
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.TextSize = 12

-- Function to create the buttons
local function createRemoteButton(remote)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = "  " .. remote.Name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    -- Detect if it's an Event or a Function
    if remote:IsA("RemoteFunction") then
        btn.TextColor3 = Color3.fromRGB(255, 200, 100) -- Orange for functions
    end

    btn.MouseButton1Click:Connect(function()
        status.Text = "Fired: " .. remote.Name
        
        -- Attempt to fire with common "Testing" arguments
        -- Some remotes need a target, some need 'true', some need a string
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer()
                remote:FireServer(true)
                remote:FireServer(player.Character)
                remote:FireServer("Test")
            elseif remote:IsA("RemoteFunction") then
                -- RemoteFunctions are harder because they expect a return
                task.spawn(function() remote:InvokeServer() end)
            end
        end)
        
        -- Visual feedback
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        task.wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end)
end

-- Scan Function
local function refreshList()
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local found = 0
    -- Search ReplicatedStorage and Workspace (common places for remotes)
    local locations = {game:GetService("ReplicatedStorage"), workspace, game:GetService("Players")}
    
    for _, location in pairs(locations) do
        for _, v in pairs(location:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                createRemoteButton(v)
                found = found + 1
            end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, found * 40)
    status.Text = "Found " .. found .. " Remotes"
end

refreshList()

-- Refresh Button
local ref = Instance.new("TextButton", frame)
ref.Size = UDim2.new(0, 60, 0, 30)
ref.Position = UDim2.new(1, -65, 0, 5)
ref.Text = "REFRESH"
ref.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ref.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ref)
ref.MouseButton1Click:Connect(refreshList)
