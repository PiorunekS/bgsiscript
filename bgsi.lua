local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BubbleGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Text = "Bubble Gum Controller"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -60, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Parent = frame

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame
content.CanvasSize = UDim2.new(0, 0, 0, 500) -- Adjusted for scrollable space
content.ScrollBarThickness = 10

local function createButton(text, posY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = content
    return button
end

-- Buttons
local sellOnce = createButton("Sell Bubble Gum", 5)
local autoSell = createButton("Auto Sell Bubble Gum", 45)
local autoBlow = createButton("Auto Blow Bubble Gum", 85)
local hatchOnce = createButton("Hatch Rainbow Egg", 125)
local autoHatch = createButton("Auto Hatch Rainbow Egg", 165)
local claimPlaytime = createButton("Claim Playtime Reward", 205)
local autoClaimAll = createButton("Auto Claim All Rewards", 245)
local autoOpenMysteryBox = createButton("Auto Open Mystery Box", 285)
local openMysteryBox = createButton("Open Mystery Box", 325)
local autoOpenGiantChest = createButton("Auto Open GIANT Chest", 365)
local autoOpenVoidChest = createButton("Auto Open VOID Chest", 405)

-- Toggles
local autoSellEnabled = false
local autoBlowEnabled = false
local autoHatchEnabled = false
local autoClaimEnabled = false
local autoOpenMysteryBoxEnabled = false
local autoOpenGiantChestEnabled = false
local autoOpenVoidChestEnabled = false

-- Remote FireServer
local function fireEvent(...)

    local args = {...}
    local remote = game:GetService("ReplicatedStorage")
        :WaitForChild("Shared")
        :WaitForChild("Framework")
        :WaitForChild("Network")
        :WaitForChild("Remote")
        :WaitForChild("Event")
    remote:FireServer(unpack(args))
end

-- Remote InvokeServer
local function invokeFunction(...)

    local args = {...}
    local func = game:GetService("ReplicatedStorage")
        :WaitForChild("Shared")
        :WaitForChild("Framework")
        :WaitForChild("Network")
        :WaitForChild("Remote")
        :WaitForChild("Function")
    func:InvokeServer(unpack(args))
end

-- Function to slowly move the character to the target position with variable speed
local function moveToPosition(targetPosition, speed)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    -- Ensure we're checking for a safe position, slightly above the target Y to avoid falling into terrain
    local safeTargetPosition = Vector3.new(targetPosition.X, targetPosition.Y + 5, targetPosition.Z)

    -- Move smoothly to the target position with the given speed
    local startPosition = humanoidRootPart.Position
    local distance = (startPosition - safeTargetPosition).Magnitude
    local duration = distance / speed  -- Calculate time based on distance and speed

    -- Perform the smooth movement by updating the position over time
    local elapsedTime = 0
    while elapsedTime < duration do
        local newPosition = startPosition:Lerp(safeTargetPosition, elapsedTime / duration)
        humanoidRootPart.CFrame = CFrame.new(newPosition)
        elapsedTime = elapsedTime + game:GetService("RunService").Heartbeat:Wait()  -- Wait until the next frame for smoother movement
    end

    -- Ensure the character ends at the target position
    humanoidRootPart.CFrame = CFrame.new(safeTargetPosition)
end

-- Rainbow Egg Position (where the character should move to for hatching)
local rainbowEggPosition = Vector3.new(-36, 15972, 44)

-- GIANT Chest Position (where the character should move to)
local giantChestPosition = Vector3.new(10, 428, 151)

-- Void Chest Position (where the character should move to)
local voidChestPosition = Vector3.new(78, 10148, 52)

-- Auto Hatch Rainbow Egg (with smooth flying to the target position at 2000x speed)
autoHatch.MouseButton1Click:Connect(function()
    autoHatchEnabled = not autoHatchEnabled
    autoHatch.Text = autoHatchEnabled and "Stop Auto Hatch" or "Auto Hatch Rainbow Egg"
    if autoHatchEnabled then
        coroutine.wrap(function()
            while autoHatchEnabled do
                -- Move the player smoothly to the rainbow egg position and hatch it at 2000x speed
                moveToPosition(rainbowEggPosition, 2000)  -- 2000 speed (2000x speed)
                wait(2)  -- Ensure the player has arrived before interacting with the egg
                fireEvent("HatchEgg", "Rainbow Egg", 1)
                wait(5)  -- Wait for the next hatch
            end
        end)()
    end
end)

-- GIANT Chest Auto Opening logic (with smooth flying to the target position at 100x speed)
autoOpenGiantChest.MouseButton1Click:Connect(function()
    autoOpenGiantChestEnabled = not autoOpenGiantChestEnabled
    autoOpenGiantChest.Text = autoOpenGiantChestEnabled and "Stop Auto Open GIANT Chest" or "Auto Open GIANT Chest"
    if autoOpenGiantChestEnabled then
        coroutine.wrap(function()
            while autoOpenGiantChestEnabled do
                -- Move the player smoothly to the giant chest position and open it at 100x speed
                moveToPosition(giantChestPosition, 50)  -- 50 speed (100x speed)
                wait(2)  -- Ensure the player has arrived before interacting with the chest
                fireEvent("ClaimChest", "Giant Chest")
                wait(5)  -- Wait for the next interaction
            end
        end)()
    end
end)

-- Void Chest Auto Opening logic (with smooth flying to the target position at 2000x speed)
autoOpenVoidChest.MouseButton1Click:Connect(function()
    autoOpenVoidChestEnabled = not autoOpenVoidChestEnabled
    autoOpenVoidChest.Text = autoOpenVoidChestEnabled and "Stop Auto Open VOID Chest" or "Auto Open VOID Chest"
    if autoOpenVoidChestEnabled then
        coroutine.wrap(function()
            while autoOpenVoidChestEnabled do
                -- Move the player smoothly to the void chest position and open it at 2000x speed
                moveToPosition(voidChestPosition, 1000)  -- 1000 speed (2000x speed)
                wait(2)  -- Ensure the player has arrived before interacting with the chest
                fireEvent("ClaimChest", "Void Chest")
                wait(5)  -- Wait for the next interaction
            end
        end)()
    end
end)

-- Other button functionalities here (not modified) ...

minimize.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
    minimize.Text = content.Visible and "-" or "+"
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
