-- Create the main frame
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "FlyGUI"
flyGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 50)
mainFrame.Position = UDim2.new(0.5, -75, 0.95, -25)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 1, 1)
mainFrame.Parent = flyGui

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.Text = "Toggle Fly"
toggleButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

-- Variable to track fly state
local flying = false
local flyVelocity = Instance.new("BodyVelocity")

-- Function to toggle flying
local function toggleFly()
    if flying then
        flying = false
        toggleButton.Text = "Toggle Fly"
        
        -- Disable flying
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        local bodyVelocity = game.Players.LocalPlayer.Character:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    else
        flying = true
        toggleButton.Text = "Flying Enabled"
        
        -- Enable flying
        flyVelocity.MaxForce = Vector3.new(1000, 1000, 1000)
        flyVelocity.Velocity = Vector3.new(0, 50, 0)
        flyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        
        -- Connect input to adjust velocity
        local inputBeganFunc, inputEndedFunc

        inputBeganFunc = function(inputObject)
            if flying then
                if inputObject.KeyCode == Enum.KeyCode.W then
                    flyVelocity.Velocity = Vector3.new(0, 50, -100)
                elseif inputObject.KeyCode == Enum.KeyCode.S then
                    flyVelocity.Velocity = Vector3.new(0, 50, 100)
                elseif inputObject.KeyCode == Enum.KeyCode.A then
                    flyVelocity.Velocity = Vector3.new(-100, 50, 0)
                elseif inputObject.KeyCode == Enum.KeyCode.D then
                    flyVelocity.Velocity = Vector3.new(100, 50, 0)
                end
            end
        end

        inputEndedFunc = function(inputObject)
            if flying then
                if inputObject.KeyCode == Enum.KeyCode.W or inputObject.KeyCode == Enum.KeyCode.S or inputObject.KeyCode == Enum.KeyCode.A or inputObject.KeyCode == Enum.KeyCode.D then
                    flyVelocity.Velocity = Vector3.new(0, 50, 0)
                end
            end
        end

        game:GetService("UserInputService").InputBegan:Connect(inputBeganFunc)
        game:GetService("UserInputService").InputEnded:Connect(inputEndedFunc)
    end
end

-- Connect the toggle button to the function
toggleButton.MouseButton1Click:Connect(toggleFly)
