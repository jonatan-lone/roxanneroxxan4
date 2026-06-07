local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local espEnabled = false
local lockEnabled = true
local commandDown = false
local altDown = false
local notificationsEnabled = true
local shiftLockWasActive = false

local fov = 100
local lockStrength = 0.60
local maxLockDistance = 1000

local highlights = {}

local gui = Instance.new("ScreenGui")
gui.Name = "GlassNotify"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Name = "Stack"
holder.Size = UDim2.new(0, 300, 0, 220)
holder.Position = UDim2.new(1, -318, 1, -240)
holder.BackgroundTransparency = 1
holder.Parent = gui

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 8)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.VerticalAlignment = Enum.VerticalAlignment.Bottom
list.Parent = holder

local purpleSeq = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(98, 64, 255)),
	ColorSequenceKeypoint.new(0.22, Color3.fromRGB(150, 78, 255)),
	ColorSequenceKeypoint.new(0.48, Color3.fromRGB(220, 82, 255)),
	ColorSequenceKeypoint.new(0.72, Color3.fromRGB(170, 96, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(82, 142, 255))
})

local function notify(title, text, useAvatar)
	if not notificationsEnabled then return end

	local card = Instance.new("Frame")
	card.Size = UDim2.new(0, 300, 0, 60)
	card.Position = UDim2.new(0, 40, 0, 0)
	card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	card.BackgroundTransparency = 1
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.Parent = holder

	local scale = Instance.new("UIScale")
	scale.Scale = 0.96
	scale.Parent = card

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = card

	local blurLayer = Instance.new("Frame")
	blurLayer.Size = UDim2.new(1, 0, 1, 0)
	blurLayer.BackgroundColor3 = Color3.fromRGB(185, 180, 255)
	blurLayer.BackgroundTransparency = 0.76
	blurLayer.BorderSizePixel = 0
	blurLayer.ZIndex = 1
	blurLayer.Parent = card

	local blurCorner = Instance.new("UICorner")
	blurCorner.CornerRadius = UDim.new(0, 18)
	blurCorner.Parent = blurLayer

	local darkGlass = Instance.new("Frame")
	darkGlass.Size = UDim2.new(1, 0, 1, 0)
	darkGlass.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
	darkGlass.BackgroundTransparency = 0.36
	darkGlass.BorderSizePixel = 0
	darkGlass.ZIndex = 2
	darkGlass.Parent = card

	local darkCorner = Instance.new("UICorner")
	darkCorner.CornerRadius = UDim.new(0, 18)
	darkCorner.Parent = darkGlass

	local darkGrad = Instance.new("UIGradient")
	darkGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 28, 58)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(13, 11, 22)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 8))
	})
	darkGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(0.5, 0.28),
		NumberSequenceKeypoint.new(1, 0.42)
	})
	darkGrad.Rotation = 16
	darkGrad.Parent = darkGlass

	local shineTop = Instance.new("Frame")
	shineTop.Size = UDim2.new(1, -20, 0, 1)
	shineTop.Position = UDim2.new(0, 10, 0, 8)
	shineTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shineTop.BackgroundTransparency = 0.45
	shineTop.BorderSizePixel = 0
	shineTop.ZIndex = 4
	shineTop.Parent = card

	local shineCorner = Instance.new("UICorner")
	shineCorner.CornerRadius = UDim.new(1, 0)
	shineCorner.Parent = shineTop

	local shineGrad = Instance.new("UIGradient")
	shineGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.25, 0.12),
		NumberSequenceKeypoint.new(0.7, 0.55),
		NumberSequenceKeypoint.new(1, 1)
	})
	shineGrad.Parent = shineTop

	local sweep = Instance.new("Frame")
	sweep.Size = UDim2.new(0.35, 0, 1.5, 0)
	sweep.Position = UDim2.new(-0.45, 0, -0.25, 0)
	sweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sweep.BackgroundTransparency = 0.86
	sweep.BorderSizePixel = 0
	sweep.Rotation = -18
	sweep.ZIndex = 5
	sweep.Parent = card

	local sweepGrad = Instance.new("UIGradient")
	sweepGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.48, 0.06),
		NumberSequenceKeypoint.new(1, 1)
	})
	sweepGrad.Parent = sweep

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Transparency = 1
	stroke.Parent = card

	local strokeGrad = Instance.new("UIGradient")
	strokeGrad.Color = purpleSeq
	strokeGrad.Parent = stroke

	local innerStroke = Instance.new("Frame")
	innerStroke.Size = UDim2.new(1, -2, 1, -2)
	innerStroke.Position = UDim2.new(0, 1, 0, 1)
	innerStroke.BackgroundTransparency = 1
	innerStroke.ZIndex = 3
	innerStroke.Parent = card

	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(0, 17)
	innerCorner.Parent = innerStroke

	local innerUIStroke = Instance.new("UIStroke")
	innerUIStroke.Thickness = 1
	innerUIStroke.Color = Color3.fromRGB(255, 255, 255)
	innerUIStroke.Transparency = 0.84
	innerUIStroke.Parent = innerStroke

	local avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.new(0, 34, 0, 34)
	avatar.Position = UDim2.new(0, 17, 0, 13)
	avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	avatar.BackgroundTransparency = useAvatar and 0.82 or 1
	avatar.BorderSizePixel = 0
	avatar.ImageTransparency = 1
	avatar.ZIndex = 6
	avatar.Parent = card

	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(1, 0)
	avatarCorner.Parent = avatar

	local avatarStroke = Instance.new("UIStroke")
	avatarStroke.Thickness = 1
	avatarStroke.Transparency = useAvatar and 0.38 or 1
	avatarStroke.Color = Color3.fromRGB(220, 180, 255)
	avatarStroke.Parent = avatar

	if useAvatar then
		local img = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		avatar.Image = img
	end

	local left = useAvatar and 62 or 18

	local titleText = Instance.new("TextLabel")
	titleText.Size = UDim2.new(1, useAvatar and -78 or -34, 0, 22)
	titleText.Position = UDim2.new(0, left, 0, 10)
	titleText.BackgroundTransparency = 1
	titleText.Text = title
	titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleText.TextSize = 13
	titleText.Font = Enum.Font.GothamBold
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.TextYAlignment = Enum.TextYAlignment.Center
	titleText.TextTransparency = 1
	titleText.ZIndex = 6
	titleText.Parent = card

	local titleGrad = Instance.new("UIGradient")
	titleGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 210, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 120, 255))
	})
	titleGrad.Parent = titleText

	local bodyText = Instance.new("TextLabel")
	bodyText.Size = UDim2.new(1, useAvatar and -78 or -34, 0, 18)
	bodyText.Position = UDim2.new(0, left, 0, 31)
	bodyText.BackgroundTransparency = 1
	bodyText.Text = text
	bodyText.TextColor3 = Color3.fromRGB(205, 196, 220)
	bodyText.TextSize = 11
	bodyText.Font = Enum.Font.GothamMedium
	bodyText.TextXAlignment = Enum.TextXAlignment.Left
	bodyText.TextYAlignment = Enum.TextYAlignment.Center
	bodyText.TextTransparency = 1
	bodyText.ZIndex = 6
	bodyText.Parent = card

	local barBack = Instance.new("Frame")
	barBack.Size = UDim2.new(1, -26, 0, 2)
	barBack.Position = UDim2.new(0, 13, 1, -6)
	barBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	barBack.BackgroundTransparency = 0.86
	barBack.BorderSizePixel = 0
	barBack.ZIndex = 6
	barBack.Parent = card

	local barBackCorner = Instance.new("UICorner")
	barBackCorner.CornerRadius = UDim.new(1, 0)
	barBackCorner.Parent = barBack

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	bar.BackgroundTransparency = 1
	bar.BorderSizePixel = 0
	bar.ZIndex = 7
	bar.Parent = barBack

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	local barGrad = Instance.new("UIGradient")
	barGrad.Color = purpleSeq
	barGrad.Parent = bar

	TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0.72
	}):Play()

	TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()

	TweenService:Create(stroke, TweenInfo.new(0.16), {Transparency = 0.26}):Play()
	TweenService:Create(titleText, TweenInfo.new(0.16), {TextTransparency = 0}):Play()
	TweenService:Create(bodyText, TweenInfo.new(0.16), {TextTransparency = 0}):Play()
	TweenService:Create(bar, TweenInfo.new(0.16), {BackgroundTransparency = 0}):Play()

	if useAvatar then
		TweenService:Create(avatar, TweenInfo.new(0.16), {ImageTransparency = 0}):Play()
	end

	TweenService:Create(sweep, TweenInfo.new(0.62, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(1.1, 0, -0.25, 0)
	}):Play()

	TweenService:Create(strokeGrad, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
		Rotation = 360
	}):Play()

	TweenService:Create(barGrad, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
		Rotation = 360
	}):Play()

	TweenService:Create(bar, TweenInfo.new(1, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	}):Play()

	task.delay(1, function()
		if not card or not card.Parent then return end

		TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(0, 36, 0, 0),
			BackgroundTransparency = 1
		}):Play()

		TweenService:Create(scale, TweenInfo.new(0.18), {Scale = 0.96}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.12), {Transparency = 1}):Play()
		TweenService:Create(titleText, TweenInfo.new(0.12), {TextTransparency = 1}):Play()
		TweenService:Create(bodyText, TweenInfo.new(0.12), {TextTransparency = 1}):Play()
		TweenService:Create(avatar, TweenInfo.new(0.12), {ImageTransparency = 1}):Play()
		TweenService:Create(bar, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
		TweenService:Create(barBack, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()

		task.delay(0.2, function()
			if card then
				card:Destroy()
			end
		end)
	end)
end

local function getChar(player)
	return player.Character
end

local function getRoot(player)
	local char = getChar(player)
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHead(player)
	local char = getChar(player)
	return char and char:FindFirstChild("Head")
end

local function getHumanoid(player)
	local char = getChar(player)
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function isAlive(player)
	local hum = getHumanoid(player)
	return hum and hum.Health > 0
end

local function isShiftLockActive()
	return UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
end

local function addESP(player)
	if player == LP then return end
	if highlights[player] then highlights[player]:Destroy() end

	local char = getChar(player)
	if not char then return end

	local h = Instance.new("Highlight")
	h.Name = "BlackESP"
	h.FillColor = Color3.fromRGB(0, 0, 0)
	h.OutlineColor = Color3.fromRGB(0, 0, 0)
	h.FillTransparency = 0.25
	h.OutlineTransparency = 0
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Adornee = char
	h.Parent = char

	highlights[player] = h
end

local function removeESP(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end

local function enableESP()
	espEnabled = true

	for _, player in ipairs(Players:GetPlayers()) do
		addESP(player)
	end

	notify("ESP Enabled", "players visible", false)
end

local function disableESP()
	espEnabled = false

	for player in pairs(highlights) do
		removeESP(player)
	end

	notify("ESP Disabled", "visuals removed", false)
end

local function toggleESP()
	if espEnabled then
		disableESP()
	else
		enableESP()
	end
end

local function disableAll()
	disableESP()
	lockEnabled = false
	notify("Disabled", "esp and lock off", false)
end

local function getClosestTargetInFOV()
	local center = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
	local closestPlayer = nil
	local closestDistance = fov

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP and isAlive(player) then
			local root = getRoot(player)
			local head = getHead(player)

			if root and head then
				local distanceFromCamera = (root.Position - Cam.CFrame.Position).Magnitude

				if distanceFromCamera <= maxLockDistance then
					local screenPos, visible = Cam:WorldToViewportPoint(head.Position)

					if visible and screenPos.Z > 0 then
						local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude

						if screenDistance < closestDistance then
							closestDistance = screenDistance
							closestPlayer = player
						end
					end
				end
			end
		end
	end

	return closestPlayer
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.4)

		if espEnabled then
			addESP(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterAdded:Connect(function()
		task.wait(0.4)

		if espEnabled then
			addESP(player)
		end
	end)
end

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.LeftMeta or input.KeyCode == Enum.KeyCode.RightMeta then
		commandDown = true
	end

	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		altDown = true
	end

	if commandDown and input.KeyCode == Enum.KeyCode.C then
		toggleESP()
	end

	if commandDown and input.KeyCode == Enum.KeyCode.V then
		disableAll()
	end

	if altDown and input.KeyCode == Enum.KeyCode.E then
		toggleESP()
	end

	if altDown and input.KeyCode == Enum.KeyCode.Z then
		disableAll()
	end

	if altDown and input.KeyCode == Enum.KeyCode.C then
		notificationsEnabled = not notificationsEnabled

		if notificationsEnabled then
			notify("Notifications On", "glass enabled", false)
		end
	end

	if input.KeyCode == Enum.KeyCode.LeftBracket then
		fov = math.clamp(fov - 20, 40, 600)
		notify("FOV", "decreased to " .. tostring(fov), false)
	end

	if input.KeyCode == Enum.KeyCode.RightBracket then
		fov = math.clamp(fov + 20, 40, 600)
		notify("FOV", "increased to " .. tostring(fov), false)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftMeta or input.KeyCode == Enum.KeyCode.RightMeta then
		commandDown = false
	end

	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		altDown = false
	end
end)

task.delay(0.6, function()
	notify("Hi @" .. LP.Name, "welcome back g", true)
end)

RunService.RenderStepped:Connect(function()
	local shiftActive = isShiftLockActive()

	if shiftActive and not shiftLockWasActive then
		notify("Shiftlock Activated", "ready", false)
	end

	shiftLockWasActive = shiftActive

	if not lockEnabled then return end
	if not shiftActive then return end

	local target = getClosestTargetInFOV()
	if not target then return end

	local head = getHead(target)
	local root = getRoot(target)
	if not head or not root then return end

	local camPos = Cam.CFrame.Position
	local targetPos = head.Position + Vector3.new(0, 0.05, 0)
	local wanted = CFrame.new(camPos, targetPos)

	Cam.CFrame = Cam.CFrame:Lerp(wanted, lockStrength)
end)
