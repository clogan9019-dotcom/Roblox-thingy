-- THERAPY REMOTE EXPLORER + DATA EXPORTER
local player = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "RemoteExplorerV3"

-- Main UI
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 750, 0, 500)
main.Position = UDim2.new(0.5, -375, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
title.Text = "REMOTE DATA ANALYZER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
Instance.new("UICorner", title)

-- Left List (Remotes)
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.5, -15, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 100)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- Right Log (Info)
local logFrame = Instance.new("ScrollingFrame", main)
logFrame.Size = UDim2.new(0.5, -15, 1, -110)
logFrame.Position = UDim2.new(0.5, 5, 0, 100)
logFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
logFrame.ScrollBarThickness = 4
local logLayout = Instance.new("UIListLayout", logFrame)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- GET ALL DATA BUTTON (The one you asked for)
local exportBtn = Instance.new("TextButton", main)
exportBtn.Size = UDim2.new(0.97, 0, 0, 40)
exportBtn.Position = UDim2.new(0.015, 0, 0, 52)
exportBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
exportBtn.Text = "🔥 GET ALL REMOTE DATA FOR EXPORT 🔥"
exportBtn.TextColor3 = Color3.new(1,1,1)
exportBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", exportBtn)

local function addLog(text, color)
    local l = Instance.new("TextBox", logFrame) -- Using TextBox so you can copy the text
    l.Size = UDim2.new(1, -10, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = text
    l.ClearTextOnFocus = false
    l.ReadOnly = true
    l.TextColor3 = color or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    logFrame.CanvasSize = UDim2.new(0,0,0, logLayout.AbsoluteContentSize.Y)
end

-- Button Logic for "GET ALL DATA"
exportBtn.MouseButton1Click:Connect(function()
    addLog("--- FULL GAME REMOTE DUMP START ---", Color3.new(1, 1, 0))
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            count = count + 1
            local path = v:GetFullName()
            local parent = v.Parent.Name
            local info = string.format("[%d] Name: %s | Type: %s | Parent: %s", count, v.Name, v.ClassName, parent)
            addLog(info, Color3.new(0, 1, 1))
            print(path) -- Also prints to console for easier copying
        end
    end
    addLog("--- TOTAL REMOTES FOUND: " .. count .. " ---", Color3.new(1, 1, 0))
    addLog("Check your Executor Console (F9) to copy full paths!", Color3.new(1,0,1))
end)

-- Standard Scanner
local function scan()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Text = v.Name
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", b)
            
            b.MouseButton1Click:Connect(function()
                addLog("TESTING: " .. v.Name, Color3.new(1,0.5,0))
                pcall(function() v:FireServer("TestArg", 1, true, player.Character) end)
                addLog("Sent: String, Number, Boolean, LocalPlayer", Color3.new(0.5,1,0.5))
            end)
        end
    end
end

scan()
