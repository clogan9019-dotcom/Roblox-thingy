-- THERAPY REMOTE EXPLORER + DETAILED LOGGER
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui")
sg.Name = "RemoteLogger"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 720, 0, 480)
main.Position = UDim2.new(0.5, -360, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(80, 30, 100)
title.Text = "REMOTE EVENT EXPLORER + LOGGER"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
Instance.new("UICorner", title)

-- Left Side (Remotes)
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0.5, -10, 1, -50)
left.Position = UDim2.new(0, 5, 0, 45)
left.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", left)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)

-- Right Side (Logger)
local right = Instance.new("Frame", main)
right.Size = UDim2.new(0.5, -10, 1, -50)
right.Position = UDim2.new(0.5, 5, 0, 45)
right.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", right).CornerRadius = UDim.new(0, 8)

local logTitle = Instance.new("TextLabel", right)
logTitle.Size = UDim2.new(1, 0, 0, 30)
logTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
logTitle.Text = "LIVE LOG"
logTitle.TextColor3 = Color3.new(1,1,1)
logTitle.Font = Enum.Font.GothamBold

local logScroll = Instance.new("ScrollingFrame", right)
logScroll.Size = UDim2.new(1, -10, 1, -40)
logScroll.Position = UDim2.new(0, 5, 0, 35)
logScroll.BackgroundTransparency = 1
logScroll.ScrollBarThickness = 6

local logLayout = Instance.new("UIListLayout", logScroll)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Padding = UDim.new(0, 3)

-- Status Bar
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 1, -20)
status.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.Text = "Ready | Click remotes to test and log them"
status.Font = Enum.Font.Gotham
status.TextSize = 12

local function addLog(text, color)
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, -10, 0, 22)
    entry.BackgroundTransparency = 1
    entry.Text = "[" .. os.date("%H:%M:%S") .. "] " .. text
    entry.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.Font = Enum.Font.Code
    entry.TextSize = 13
    entry.Parent = logScroll
    logScroll.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y + 20)
    entry.LayoutOrder = -tick() -- Newest on top
end

local function createRemoteButton(remote)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = "  " .. remote.Name .. "  (" .. remote.ClassName .. ")"
    btn.TextColor3 = remote:IsA("RemoteFunction") and Color3.fromRGB(255, 180, 80) or Color3.fromRGB(100, 200, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = scroll
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        addLog("Clicked → " .. remote.Name .. " (" .. remote.ClassName .. ")", Color3.fromRGB(255, 255, 100))
        
        local argsList = {
            {"(no arguments)", {}},
            {"(true)", {true}},
            {"(false)", {false}},
            {"(player)", {player}},
            {"(character)", {player.Character}},
            {"('Test')", {"Test"}},
            {"(1)", {1}},
            {"(0)", {0}},
        }

        for _, test in ipairs(argsList) do
            task.spawn(function()
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(unpack(test[2]))
                        addLog("  Fired " .. remote.Name .. " with " .. test[1], Color3.fromRGB(120, 255, 120))
                    elseif remote:IsA("RemoteFunction") then
                        local result = remote:InvokeServer(unpack(test[2]))
                        addLog("  Invoked " .. remote.Name .. " with " .. test[1] .. " | Result: " .. tostring(result), Color3.fromRGB(100, 200, 255))
                    end
                end)
            end)
            task.wait(0.15) -- Small delay so we don't get rate limited
        end
    end)
end

-- Scan for all remotes
local function scanRemotes()
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local count = 0
    for _, container in pairs({game.ReplicatedStorage, workspace, player}) do
        for _, v in pairs(container:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                createRemoteButton(v)
                count += 1
            end
        end
    end
    
    addLog("Scan Complete - Found " .. count .. " remotes", Color3.fromRGB(80, 200, 255))
    scroll.CanvasSize = UDim2.new(0, 0, 0, count * 36)
end

-- Buttons
local refreshBtn = Instance.new("TextButton", main)
refreshBtn.Size = UDim2.new(0, 80, 0, 30)
refreshBtn.Position = UDim2.new(1, -85, 0, 8)
refreshBtn.Text = "Refresh"
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
refreshBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", refreshBtn)
refreshBtn.MouseButton1Click:Connect(scanRemotes)

local clearBtn = Instance.new("TextButton", main)
clearBtn.Size = UDim2.new(0, 80, 0, 30)
clearBtn.Position = UDim2.new(1, -170, 0, 8)
clearBtn.Text = "Clear Log"
clearBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
clearBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", clearBtn)
clearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(logScroll:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
    addLog("Log Cleared", Color3.fromRGB(255, 100, 100))
end)

-- Start
scanRemotes()
addLog("Remote Explorer Loaded - Click any remote to test it", Color3.fromRGB(100, 200, 255))
addLog("Tip: Look for names like Kill, Damage, GiveItem, PlaySound, etc.", Color3.fromRGB(180, 180, 180))
