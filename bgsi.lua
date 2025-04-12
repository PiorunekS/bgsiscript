local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BubbleGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 420)
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

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame


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
local autoCollectGems = createButton("Auto Collect Gems", 285)


local autoSellEnabled = false
local autoBlowEnabled = false
local autoHatchEnabled = false
local autoClaimEnabled = false
local autoCollectGemsEnabled = false


local targetPosition = Vector3.new(-36, 15972, 45)
local autoHatchOriginalCFrame


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


local function openEgg()
	local originalCFrame = player.Character.HumanoidRootPart.CFrame
	player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
	wait(2)
	fireEvent("HatchEgg", "Rainbow Egg", 1)
	wait(5)
	player.Character.HumanoidRootPart.CFrame = originalCFrame
end

local function startAutoHatch()
	autoHatchOriginalCFrame = player.Character.HumanoidRootPart.CFrame
	player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
	wait(2)

	coroutine.wrap(function()
		while autoHatchEnabled do
			fireEvent("HatchEgg", "Rainbow Egg", 1)
			wait(5)
		end

		if autoHatchOriginalCFrame then
			player.Character.HumanoidRootPart.CFrame = autoHatchOriginalCFrame
		end
	end)()
end


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

hatchOnce.MouseButton1Click:Connect(function()
	openEgg()
end)

autoHatch.MouseButton1Click:Connect(function()
	autoHatchEnabled = not autoHatchEnabled
	autoHatch.Text = autoHatchEnabled and "Stop Auto Hatch" or "Auto Hatch Rainbow Egg"
	if autoHatchEnabled then
		startAutoHatch()
	end
end)

claimPlaytime.MouseButton1Click:Connect(function()
	for i = 1, 9 do
		invokeFunction("ClaimPlaytime", i)
		wait(0.5)
	end
end)

autoClaimAll.MouseButton1Click:Connect(function()
	autoClaimEnabled = not autoClaimEnabled
	autoClaimAll.Text = autoClaimEnabled and "Stop Auto Claim" or "Auto Claim All Rewards"
	if autoClaimEnabled then
		coroutine.wrap(function()
			while autoClaimEnabled do
				for i = 1, 9 do
					invokeFunction("ClaimPlaytime", i)
					wait(0.5)
				end
				wait(10)
			end
		end)()
	end
end)

autoCollectGems.MouseButton1Click:Connect(function()
	autoCollectGemsEnabled = not autoCollectGemsEnabled
	autoCollectGems.Text = autoCollectGemsEnabled and "Stop Collect Gems" or "Auto Collect Gems"

	if autoCollectGemsEnabled then
		coroutine.wrap(function()
			while autoCollectGemsEnabled do
				local args = {
					[1] = "6d6d72aa-0831-4877-9d8b-c9c00a4ee35d"
				}
				game:GetService("ReplicatedStorage").Remotes.Pickups.CollectPickup:FireServer(unpack(args))
				wait(2)
			end
		end)()
	end
end)

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	minimize.Text = minimized and "+" or "-"
end)


close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)