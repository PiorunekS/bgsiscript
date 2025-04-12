local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BubbleGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 500)
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
content.CanvasSize = UDim2.new(0, 0, 0, 500)
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
local autoUnlockAreas = createButton("Auto Unlock Areas", 445)
local goToZen = createButton("Go To World 'ZEN'", 485)

local autoSellEnabled = false
local autoBlowEnabled = false
local autoHatchEnabled = false
local autoClaimEnabled = false
local autoOpenMysteryBoxEnabled = false
local autoOpenGiantChestEnabled = false
local autoOpenVoidChestEnabled = false
local autoUnlockAreasEnabled = false
local autoClaimPlaytimeEnabled = false

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

local function moveToPosition(targetPosition, speed)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    local safeTargetPosition = Vector3.new(targetPosition.X, targetPosition.Y + 5, targetPosition.Z)

    local startPosition = humanoidRootPart.Position
    local distance = (startPosition - safeTargetPosition).Magnitude
    local duration = distance / speed

    local elapsedTime = 0
    while elapsedTime < duration do
        local newPosition = startPosition:Lerp(safeTargetPosition, elapsedTime / duration)
        humanoidRootPart.CFrame = CFrame.new(newPosition)
        elapsedTime = elapsedTime + game:GetService("RunService").Heartbeat:Wait()
    end

    humanoidRootPart.CFrame = CFrame.new(safeTargetPosition)
end

local rainbowEggPosition = Vector3.new(-36, 15972, 44)
local giantChestPosition = Vector3.new(10, 428, 151)
local voidChestPosition = Vector3.new(78, 10148, 52)
local unlockAreasPosition = Vector3.new(3, 15973, 45)
local zenPosition = "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn"

autoSell.MouseButton1Click:Connect(function()
    fireEvent("SellBubbleGum")
end)

autoBlow.MouseButton1Click:Connect(function()
    autoBlowEnabled = not autoBlowEnabled
    autoBlow.Text = autoBlowEnabled and "Stop Auto Blow" or "Auto Blow Bubble Gum"
    if autoBlowEnabled then
        coroutine.wrap(function()
            while autoBlowEnabled do
                fireEvent("BlowBubble")
                wait(1)
            end
        end)()
    end
end)

sellOnce.MouseButton1Click:Connect(function()
    fireEvent("SellBubble")
end)

autoSell.MouseButton1Click:Connect(function()
    autoSellEnabled = not autoSellEnabled
    autoSell.Text = autoSellEnabled and "Stop Auto Sell" or "Auto Sell Bubble Gum"
    if autoSellEnabled then
        coroutine.wrap(function()
            while autoSellEnabled do
                fireEvent("SellBubble")
                wait(2)
            end
        end)()
    end
end)

autoHatch.MouseButton1Click:Connect(function()
    autoHatchEnabled = not autoHatchEnabled
    autoHatch.Text = autoHatchEnabled and "Stop Auto Hatch" or "Auto Hatch Rainbow Egg"
    if autoHatchEnabled then
        coroutine.wrap(function()
            while autoHatchEnabled do
                moveToPosition(rainbowEggPosition, 2000)
                wait(2)
                fireEvent("HatchEgg", "Rainbow Egg", 1)
                wait(5)
            end
        end)()
    end
end)

autoOpenGiantChest.MouseButton1Click:Connect(function()
    autoOpenGiantChestEnabled = not autoOpenGiantChestEnabled
    autoOpenGiantChest.Text = autoOpenGiantChestEnabled and "Stop Auto Open GIANT Chest" or "Auto Open GIANT Chest"
    if autoOpenGiantChestEnabled then
        coroutine.wrap(function()
            while autoOpenGiantChestEnabled do
                moveToPosition(giantChestPosition, 100)
                wait(2)
                fireEvent("ClaimChest", "Giant Chest")
                wait(5)
            end
        end)()
    end
end)

autoOpenVoidChest.MouseButton1Click:Connect(function()
    autoOpenVoidChestEnabled = not autoOpenVoidChestEnabled
    autoOpenVoidChest.Text = autoOpenVoidChestEnabled and "Stop Auto Open VOID Chest" or "Auto Open VOID Chest"
    if autoOpenVoidChestEnabled then
        coroutine.wrap(function()
            while autoOpenVoidChestEnabled do
                moveToPosition(voidChestPosition, 2000)
                wait(2)
                fireEvent("ClaimChest", "Void Chest")
                wait(5)
            end
        end)()
    end
end)

autoUnlockAreas.MouseButton1Click:Connect(function()
    autoUnlockAreasEnabled = not autoUnlockAreasEnabled
    autoUnlockAreas.Text = autoUnlockAreasEnabled and "Stop Auto Unlock Areas" or "Auto Unlock Areas"
    if autoUnlockAreasEnabled then
        coroutine.wrap(function()
            while autoUnlockAreasEnabled do
                moveToPosition(unlockAreasPosition, 2000)
                wait(2)
                fireEvent("UnlockAreas")
                wait(5)
            end
        end)()
    end
end)

goToZen.MouseButton1Click:Connect(function()
    local args = {
        [1] = "Teleport",
        [2] = zenPosition
    }
    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer(unpack(args))
end)

claimPlaytime.MouseButton1Click:Connect(function()
    coroutine.wrap(function()
        for i = 1, 9 do
            local args = {
                [1] = "ClaimPlaytime",
                [2] = i
            }
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Function:InvokeServer(unpack(args))
            wait(10)  -- Wait for 10 seconds before claiming the next reward
        end
    end)()
end)

minimize.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
    minimize.Text = content.Visible and "-" or "+"
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
