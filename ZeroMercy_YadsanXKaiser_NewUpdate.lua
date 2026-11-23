--==================================================
-- YADSAN INTRO | LOOKISM THEME (Black / White / Taupe)
-- Pinwheel emblem built from 6 blades, 1 shaded (Daniel Park)
--==================================================
do
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	-- SETTINGS
	local DURATION = 6
	local WHITE = Color3.fromRGB(240, 240, 244)
	local TAUPE = Color3.fromRGB(150, 142, 126)
	local GREY = Color3.fromRGB(120, 120, 128)
	local BLACK = Color3.fromRGB(0, 0, 0)

	local old = PlayerGui:FindFirstChild("ALLIED_INTRO")
	if old then old:Destroy() end

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "ALLIED_INTRO"
	Gui.IgnoreGuiInset = true
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 999
	Gui.Parent = PlayerGui

	local BG = Instance.new("Frame")
	BG.Size = UDim2.fromScale(1, 1)
	BG.BackgroundColor3 = BLACK
	BG.BorderSizePixel = 0
	BG.Parent = Gui

	local function Tween(obj, t, props, repeatCount, style)
		local info = TweenInfo.new(t, style or Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, repeatCount or 0)
		local tw = TweenService:Create(obj, info, props)
		tw:Play()
		return tw
	end

	-- PORTAL (square, responsive)
	local Portal = Instance.new("Frame")
	Portal.AnchorPoint = Vector2.new(0.5, 0.5)
	Portal.Position = UDim2.fromScale(0.5, 0.4)
	Portal.BackgroundTransparency = 1
	Portal.Parent = BG

	local function Resize()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local v = cam.ViewportSize
		local d = math.floor(math.min(v.X, v.Y) * 0.55)
		Portal.Size = UDim2.fromOffset(d, d)
	end
	Resize()
	local vpConn
	if workspace.CurrentCamera then
		vpConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)
	end

	local function Bar(parent, x, y, w, h, rot, color)
		local f = Instance.new("Frame")
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Position = UDim2.fromScale(x, y)
		f.Size = UDim2.fromScale(w, h)
		f.Rotation = rot
		f.BackgroundColor3 = color
		f.BorderSizePixel = 0
		f.Parent = parent
		return f
	end

	-- OUTER RING (thin)
	local Ring = Instance.new("Frame")
	Ring.AnchorPoint = Vector2.new(0.5, 0.5)
	Ring.Position = UDim2.fromScale(0.5, 0.5)
	Ring.Size = UDim2.fromScale(1.15, 1.15)
	Ring.BackgroundTransparency = 1
	Ring.Parent = Portal
	Instance.new("UICorner", Ring).CornerRadius = UDim.new(1, 0)
	local RingStroke = Instance.new("UIStroke")
	RingStroke.Color = GREY
	RingStroke.Thickness = 1
	RingStroke.Transparency = 0.5
	RingStroke.Parent = Ring
	Tween(RingStroke, 1.8, { Transparency = 0.9 }, -1)

	-- EMBLEM: rotating layer holding 6 blades
	local Emblem = Instance.new("Frame")
	Emblem.AnchorPoint = Vector2.new(0.5, 0.5)
	Emblem.Position = UDim2.fromScale(0.5, 0.5)
	Emblem.Size = UDim2.fromScale(1, 1)
	Emblem.BackgroundTransparency = 1
	Emblem.Parent = Portal
	Tween(Emblem, 30, { Rotation = 360 }, -1, Enum.EasingStyle.Linear)

	local blades = {}
	for i = 1, 6 do
		local blade = Instance.new("Frame")
		blade.AnchorPoint = Vector2.new(0.5, 0.5)
		blade.Position = UDim2.fromScale(0.5, 0.5)
		blade.Size = UDim2.fromScale(1, 1)
		blade.BackgroundTransparency = 1
		blade.Rotation = (i - 1) * 60
		blade.Parent = Emblem

		local color = (i == 3) and TAUPE or WHITE -- Daniel's shaded segment

		-- shaft + sharp arrow head (swirled slightly off-center)
		Bar(blade, 0.55, 0.26, 0.075, 0.30, 0, color)
		Bar(blade, 0.52, 0.12, 0.060, 0.20, 38, color)
		Bar(blade, 0.60, 0.12, 0.060, 0.20, -22, color)
		-- dark gap line to separate blades
		Bar(blade, 0.50, 0.30, 0.012, 0.38, 0, BLACK)

		blades[i] = blade
		-- assemble animation start state
		blade.Size = UDim2.fromScale(0.2, 0.2)
		task.delay(0.12 * i, function()
			Tween(blade, 0.6, { Size = UDim2.fromScale(1, 1) }, 0, Enum.EasingStyle.Back)
		end)
	end

	-- gentle pulse on the whole emblem
	local scale = Instance.new("UIScale")
	scale.Parent = Emblem
	Tween(scale, 1.6, { Scale = 1.06 }, -1)

	-- TITLE
	local Title = Instance.new("TextLabel")
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.Position = UDim2.fromScale(0.5, 0.75)
	Title.Size = UDim2.fromScale(0.7, 0.085)
	Title.BackgroundTransparency = 1
	Title.Text = "Z E R O   M E R C Y   O N   T O P"
	Title.TextColor3 = WHITE
	Title.Font = Enum.Font.GothamBlack
	Title.TextScaled = true
	Title.TextTransparency = 1
	Title.Parent = BG

	local Subtitle = Instance.new("TextLabel")
	Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
	Subtitle.Position = UDim2.fromScale(0.5, 0.82)
	Subtitle.Size = UDim2.fromScale(0.6, 0.03)
	Subtitle.BackgroundTransparency = 1
	Subtitle.Text = "Y A D S A N   X   K A I S E R"
	Subtitle.TextColor3 = GREY
	Subtitle.Font = Enum.Font.GothamMedium
	Subtitle.TextScaled = true
	Subtitle.TextTransparency = 1
	Subtitle.Parent = BG

	local Status = Instance.new("TextLabel")
	Status.AnchorPoint = Vector2.new(0.5, 0.5)
	Status.Position = UDim2.fromScale(0.5, 0.88)
	Status.Size = UDim2.fromScale(0.6, 0.028)
	Status.BackgroundTransparency = 1
	Status.Text = "LOADING..."
	Status.TextColor3 = TAUPE
	Status.Font = Enum.Font.Gotham
	Status.TextScaled = true
	Status.Parent = BG

	-- PROGRESS BAR
	local BarBG = Instance.new("Frame")
	BarBG.AnchorPoint = Vector2.new(0.5, 0.5)
	BarBG.Position = UDim2.fromScale(0.5, 0.93)
	BarBG.Size = UDim2.fromScale(0.5, 0.007)
	BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
	BarBG.BorderSizePixel = 0
	BarBG.Parent = BG

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.fromScale(0, 1)
	Fill.BackgroundColor3 = WHITE
	Fill.BorderSizePixel = 0
	Fill.Parent = BarBG

	Tween(Title, 1.2, { TextTransparency = 0 })
	Tween(Subtitle, 1.6, { TextTransparency = 0 })
	Tween(Fill, DURATION, { Size = UDim2.fromScale(1, 1) }, 0, Enum.EasingStyle.Linear)

	local messages = {
		"LOADING...",
		"SIX FIGHTERS, ONE CREW",
		"EQUAL FOOTING, ONE GOAL",
		"ZERO MERCY ON TOP",
		"ALLIED READY",
	}
	for _, m in ipairs(messages) do
		Status.Text = m
		task.wait(DURATION / #messages)
	end

	-- FADE OUT
	for _, o in ipairs(Gui:GetDescendants()) do
		if o:IsA("GuiObject") then
			local p = { BackgroundTransparency = 1 }
			if o:IsA("TextLabel") then p.TextTransparency = 1 end
			Tween(o, 0.7, p)
		elseif o:IsA("UIStroke") then
			Tween(o, 0.7, { Transparency = 1 })
		end
	end

	task.wait(0.8)
	if vpConn then vpConn:Disconnect() end
	Gui:Destroy()
end

--[[
    ╔══════════════════════════════════╗
    ║        K A I S E R • P A P A      ║
    ║     Ultimate Dangerous Edition    ║
    ║         VIP • FINAL • FIXED       ║
    ╚══════════════════════════════════╝
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")

-- Purani GUI Cleanup
pcall(function()
	local old = parentGui:FindFirstChild("KaiserPapaxZM")
	if old then old:Destroy() end
end)

-- =====================================================
--              CHAT SEND (defined early)
-- =====================================================
local function sendChat(message)
	if not message or message == "" then return false end
	local sent = false
	pcall(function()
		local channels = TextChatService:FindFirstChild("TextChannels")
		if channels then
			local general = channels:FindFirstChild("RBXGeneral")
			if general then
				general:SendAsync(message)
				sent = true
			end
		end
	end)
	if sent then return true end

	pcall(function()
		local event = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if event then
			local sayMsg = event:FindFirstChild("SayMessageRequest")
			if sayMsg then
				sayMsg:FireServer(message, "All")
				sent = true
			end
		end
	end)
	return sent
end

-- ============ ScreenGui ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaiserPapaxZM"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- =====================================================
--              FLOATING SIDE BUTTON
-- =====================================================
local SideBtn = Instance.new("TextButton")
SideBtn.Name = "SideButton"
SideBtn.Size = UDim2.new(0, 150, 0, 45)
SideBtn.Position = UDim2.new(0, 20, 0.5, -22)
SideBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 255)
SideBtn.Text = "☠️ Kaiser Papa"
SideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SideBtn.Font = Enum.Font.GothamBold
SideBtn.TextSize = 15
SideBtn.BorderSizePixel = 0
SideBtn.Active = true
SideBtn.Parent = ScreenGui

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 10)
sideCorner.Parent = SideBtn

local sideStroke = Instance.new("UIStroke")
sideStroke.Color = Color3.fromRGB(200, 150, 255)
sideStroke.Thickness = 2
sideStroke.Parent = SideBtn

local sideGrad = Instance.new("UIGradient")
sideGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 200)),
}
sideGrad.Rotation = 45
sideGrad.Parent = SideBtn

-- =====================================================
--              MAIN GUI FRAME
-- =====================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = Main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(180, 0, 255)
mainStroke.Thickness = 2.5
mainStroke.Parent = Main

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 15)
topCorner.Parent = TopBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 15)
topFix.Position = UDim2.new(0, 0, 1, -15)
topFix.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
topFix.BorderSizePixel = 0
topFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "☠️ KaiserPapaxZM Spammer VIP 🔥"
Title.TextColor3 = Color3.fromRGB(220, 100, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = TopBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseBtn

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(255, 100, 100)
closeStroke.Thickness = 2
closeStroke.Parent = CloseBtn

-- ===== Section: Targets =====
local TargetHeader = Instance.new("TextLabel")
TargetHeader.Size = UDim2.new(1, -30, 0, 20)
TargetHeader.Position = UDim2.new(0, 15, 0, 65)
TargetHeader.BackgroundTransparency = 1
TargetHeader.Text = "🎯 Select Targets (click to cycle):"
TargetHeader.TextColor3 = Color3.fromRGB(200, 180, 220)
TargetHeader.TextXAlignment = Enum.TextXAlignment.Left
TargetHeader.Font = Enum.Font.GothamBold
TargetHeader.TextSize = 13
TargetHeader.Parent = Main

local TargetFrame = Instance.new("Frame")
TargetFrame.Size = UDim2.new(1, -30, 0, 95)
TargetFrame.Position = UDim2.new(0, 15, 0, 90)
TargetFrame.BackgroundTransparency = 1
TargetFrame.Parent = Main

local targets = {nil, nil, nil, nil}
local targetButtons = {}

local function getAvailablePlayers()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(list, p)
		end
	end
	return list
end

for i = 1, 4 do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.5, -6, 0, 42)
	btn.Position = UDim2.new(((i-1) % 2) * 0.5, ((i-1) % 2) * 8, math.floor((i-1)/2) * 0.5, math.floor((i-1)/2) * 6)
	btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
	btn.Text = "Target " .. i .. ": Empty"
	btn.TextColor3 = Color3.fromRGB(180, 150, 200)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.BorderSizePixel = 0
	btn.Parent = TargetFrame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(80, 40, 120)
	s.Thickness = 1.5
	s.Parent = btn

	targetButtons[i] = btn

	btn.MouseButton1Click:Connect(function()
		local list = getAvailablePlayers()
		if #list == 0 then
			targets[i] = nil
			btn.Text = "Target " .. i .. ": Empty"
			return
		end
		local curIdx = 0
		if targets[i] then
			for idx, p in ipairs(list) do
				if p == targets[i] then curIdx = idx break end
			end
		end
		curIdx = curIdx + 1
		if curIdx > #list then
			targets[i] = nil
			btn.Text = "Target " .. i .. ": Empty"
			btn.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
			s.Color = Color3.fromRGB(80, 40, 120)
			btn.TextColor3 = Color3.fromRGB(180, 150, 200)
		else
			targets[i] = list[curIdx]
			btn.Text = "Target " .. i .. ": " .. list[curIdx].Name
			btn.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
			s.Color = Color3.fromRGB(220, 80, 255)
			btn.TextColor3 = Color3.fromRGB(255, 220, 255)
		end
	end)
end

-- ===== Prefix Section =====
local PrefixLabel = Instance.new("TextLabel")
PrefixLabel.Size = UDim2.new(0, 120, 0, 18)
PrefixLabel.Position = UDim2.new(0, 15, 0, 195)
PrefixLabel.BackgroundTransparency = 1
PrefixLabel.Text = "🏷️ Prefix Mode:"
PrefixLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
PrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
PrefixLabel.Font = Enum.Font.GothamBold
PrefixLabel.TextSize = 13
PrefixLabel.Parent = Main

local PrefixBox = Instance.new("TextBox")
PrefixBox.Size = UDim2.new(0, 100, 0, 32)
PrefixBox.Position = UDim2.new(0, 15, 0, 216)
PrefixBox.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
PrefixBox.BorderSizePixel = 0
PrefixBox.Text = "---"
PrefixBox.PlaceholderText = "Custom Prefix"
PrefixBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PrefixBox.Font = Enum.Font.GothamBold
PrefixBox.TextSize = 14
PrefixBox.ClearTextOnFocus = false
PrefixBox.Parent = Main

local prefixCorner = Instance.new("UICorner")
prefixCorner.CornerRadius = UDim.new(0, 8)
prefixCorner.Parent = PrefixBox

local prefixStroke = Instance.new("UIStroke")
prefixStroke.Color = Color3.fromRGB(80, 40, 120)
prefixStroke.Thickness = 1.5
prefixStroke.Parent = PrefixBox

local RandomPrefixBtn = Instance.new("TextButton")
RandomPrefixBtn.Size = UDim2.new(0, 130, 0, 32)
RandomPrefixBtn.Position = UDim2.new(0, 125, 0, 216)
RandomPrefixBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
RandomPrefixBtn.Text = "Prefix: CUSTOM"
RandomPrefixBtn.TextColor3 = Color3.fromRGB(220, 150, 255)
RandomPrefixBtn.Font = Enum.Font.GothamBold
RandomPrefixBtn.TextSize = 13
RandomPrefixBtn.BorderSizePixel = 0
RandomPrefixBtn.Parent = Main

local randCorner = Instance.new("UICorner")
randCorner.CornerRadius = UDim.new(0, 8)
randCorner.Parent = RandomPrefixBtn

local randStroke = Instance.new("UIStroke")
randStroke.Color = Color3.fromRGB(120, 60, 180)
randStroke.Thickness = 1.5
randStroke.Parent = RandomPrefixBtn

local isRandomPrefix = false
RandomPrefixBtn.MouseButton1Click:Connect(function()
	isRandomPrefix = not isRandomPrefix
	if isRandomPrefix then
		RandomPrefixBtn.Text = "Prefix: RANDOM"
		RandomPrefixBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 100)
		RandomPrefixBtn.TextColor3 = Color3.fromRGB(255, 150, 255)
		PrefixBox.Text = "RANDOM"
		PrefixBox.TextEditable = false
	else
		RandomPrefixBtn.Text = "Prefix: CUSTOM"
		RandomPrefixBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
		RandomPrefixBtn.TextColor3 = Color3.fromRGB(220, 150, 255)
		PrefixBox.Text = "---"
		PrefixBox.TextEditable = true
	end
end)

-- ===== Delay =====
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(0, 120, 0, 18)
DelayLabel.Position = UDim2.new(0, 275, 0, 195)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "⚡ Delay (sec):"
DelayLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Font = Enum.Font.GothamBold
DelayLabel.TextSize = 13
DelayLabel.Parent = Main

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(0, 100, 0, 32)
DelayBox.Position = UDim2.new(0, 275, 0, 216)
DelayBox.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
DelayBox.BorderSizePixel = 0
DelayBox.Text = "1"
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Font = Enum.Font.GothamBold
DelayBox.TextSize = 14
DelayBox.ClearTextOnFocus = false
DelayBox.Parent = Main

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 8)
delayCorner.Parent = DelayBox

local delayStroke = Instance.new("UIStroke")
delayStroke.Color = Color3.fromRGB(80, 40, 120)
delayStroke.Thickness = 1.5
delayStroke.Parent = DelayBox

-- ===== Start/Stop =====
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.5, -22, 0, 45)
StartBtn.Position = UDim2.new(0, 15, 0, 262)
StartBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
StartBtn.Text = "▶ START"
StartBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.TextSize = 16
StartBtn.BorderSizePixel = 0
StartBtn.Parent = Main

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 8)
startCorner.Parent = StartBtn

local startStroke = Instance.new("UIStroke")
startStroke.Color = Color3.fromRGB(0, 255, 100)
startStroke.Thickness = 2
startStroke.Parent = StartBtn

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.5, -22, 0, 45)
StopBtn.Position = UDim2.new(0.5, 7, 0, 262)
StopBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
StopBtn.Text = "■ STOP"
StopBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
StopBtn.Font = Enum.Font.GothamBlack
StopBtn.TextSize = 16
StopBtn.BorderSizePixel = 0
StopBtn.Parent = Main

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = StopBtn

local stopStroke = Instance.new("UIStroke")
stopStroke.Color = Color3.fromRGB(255, 0, 0)
stopStroke.Thickness = 2
stopStroke.Parent = StopBtn

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 28)
Status.Position = UDim2.new(0, 15, 0, 318)
Status.BackgroundColor3 = Color3.fromRGB(20, 12, 30)
Status.BorderSizePixel = 0
Status.Text = "Status: Idle 💤"
Status.TextColor3 = Color3.fromRGB(180, 180, 200)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 13
Status.Parent = Main

local statCorner = Instance.new("UICorner")
statCorner.CornerRadius = UDim.new(0, 8)
statCorner.Parent = Status

-- =====================================================
--              GUI OPEN / CLOSE
-- =====================================================
local guiOpen = false
local targetSize = UDim2.new(0, 420, 0, 360)

local function openGUI()
	if guiOpen then return end
	guiOpen = true
	Main.Visible = true
	Main.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = targetSize }):Play()
end

local function closeGUI()
	if not guiOpen then return end
	guiOpen = false
	local tw = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
	tw:Play()
	tw.Completed:Connect(function() Main.Visible = false end)
end

-- SideBtn drag
local dragging, dragStart, startPos, moved = false, nil, nil, false

SideBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; moved = false; dragStart = input.Position; startPos = SideBtn.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then moved = true end
		SideBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if dragging and not moved then
			if guiOpen then closeGUI() else openGUI() end
		end
		dragging = false
	end
end)

CloseBtn.MouseButton1Click:Connect(closeGUI)

-- =====================================================
--              GLOW ANIMATIONS
-- =====================================================
task.spawn(function()
	while ScreenGui.Parent do
		TweenService:Create(startStroke, TweenInfo.new(1), {Transparency = 0.5}):Play()
		TweenService:Create(stopStroke, TweenInfo.new(1), {Transparency = 0.5}):Play()
		TweenService:Create(mainStroke, TweenInfo.new(1.5), {Transparency = 0.4}):Play()
		task.wait(1)
		if not ScreenGui.Parent then break end
		TweenService:Create(startStroke, TweenInfo.new(1), {Transparency = 0}):Play()
		TweenService:Create(stopStroke, TweenInfo.new(1), {Transparency = 0}):Play()
		TweenService:Create(mainStroke, TweenInfo.new(1.5), {Transparency = 0}):Play()
		task.wait(1)
	end
end)

-- =====================================================
--              ROASTS & PREFIX POOL
-- =====================================================
local roasts = {
	"%s - SYSTEM ALERT: PAPA KAISER HAS ENTERED ⚡",
	"%s - ALL HAIL THE KING 👑",
	"%s - THE WOLF IS OUT OF HIS DEN 🐺",
	"%s - TMKXXX MAIN BULLET TRAIN 🚄",
	"%s - TMKXXX MAIN GALAXY 🌌",
	"%s - PAPA KAISER IS BACK ☠️",
	"%s - TBKXXX MAIN TRAFFIC LIGHT 🚦",
	"%s - TBKXXX MAIN BLACK HOLE 🌑",
	"%s - KAISER BUILT DIFFERENT 🗿",
	"%s - TMKXXX MAIN SUPERNOVA 💥",
	"%s - TBKXXX KA WIFI SIGNAL WEAK 📶",
	"%s - THE FINAL BOSS HAS ARRIVED 🎮",
	"%s - ZERO MERCY ACTIVATED ☠️",
	"%s - PAPA KAISER OWNS THIS DIMENSION 🌌",
	"%s - REMEMBER THE NAME: PAPA KAISER 👑",
	"%s - 🔥✨ tmx GODZILA POWER SONIC BEEM UNLEASHED 100% MAXIMUM DESTRUCTION OVERLOAD 🔥✨",
    "%s - 😝☄️ tmx SUPER ULTRA BRAZIL TIGER GORILLA PUNCH COMING THROUGH WITH UNSTOPPABLE JUNGLE FURY RAGE 😝☄️",
    "%s - ✨☀️ tmx SUPER MEGA POWER WAVE TSUNAMI BLAST ACTIVATED ACROSS THE ENTIRE SERVER DIMENSION ✨☀️",
    "%s - 🔥👾 tmx ULTIMATE BEAST MODE ACTIVATED: GODZILA ROAR COMBINED WITH TIGER SPEED AND GORILLA SMASH 🔥👾",
    "%s - ☀️☄️ tmx ULTIMATE SONIC BEEM DESTRUCTION RAY BURNING DOWN EVERYTHING IN SIGHT ☀️☄️",
    "%s - 🔮😝 tmx BRAZIL TIGER HYPER DRIFT KICK MEETS GORILLA EARTHQUAKE SMASH COMBO OF DOOM 🔮😝",
    "%s - ✨🔥 tmx MEGA POWER WAVE IS OVERWHELMING THE ENTIRE SERVER WITH TIDAL WAVE TSUNAMI ENERGY ✨🔥",
    "%s - 👾🎍 tmx WARNING: GODZILA POWER IS COMPLETELY UNSTOPPABLE IN THE CHAT ROOM RIGHT NOW 👾🎍",
    "%s - 🔥😝 tmx GORILLA PUNCH EARTHQUAKE SHAKE CAUSING MASSIVE DAMAGE EVERYWHERE 🔥😝",
    "%s - ✨🎐 tmx SONIC BEEM CHARGING UP TO MAXIMUM OVERDRIVE POWER LEVEL INFINITE LIGHTNING SPEED ✨🎐",
    "%s - ☀️👾 tmx BRAZIL TIGER JUNGLE FURY SAVAGE ATTACK SWEEPING AWAY ALL OPPONENTS IN THE ARENA ☀️👾",
    "%s - 🔮☄️ tmx MEGA POWER WAVE WASHING AWAY EVERY SINGLE PLAYER WITH AN OCEANIC TSUNAMI STORM 🔮☄️",
    "%s - 🔥✨ tmx GODZILA ATOMIC BREATH READY TO FIRE ACROSS THE SKIES BRINGING TOTAL ANNIHILATION 🔥✨",
    "%s - 😝☀️ tmx ULTRA SUPER SAIYAN GORILLA RAGE UNLEASHED WITH PRIMAL INSTINCT 😝☀️",
    "%s - 🎐🔮 tmx SONIC BEEM SPEED OF LIGHT BEATDOWN LEAVING ONLY ELECTRIC SPARKS IN THE AIR 🎐🔮",
    "%s - ☄️👾 tmx BRAZIL TIGER CLAW SLASH OF DOOM CUTTING THROUGH DIMENSIONS WITH HYPER PRECISION ☄️👾",
    "%s - ✨🔥 tmx SUPER MEGA POWER WAVE TSUNAMI STORM CRASHING INTO THE MAIN GATES WITH FORCE ✨🔥",
    "%s - 😝🎐 tmx GODZILA VS GORILLA ULTIMATE CLASH OF THE TITANS BATTLE OF THE CENTURY 😝🎐",
    "%s - 🔥🔮 tmx SONIC BEEM THUNDERSTORM STRIKE SHATTERING THE SOUND BARRIER 🔥🔮",
    "%s - 🎍✨ tmx BRAZIL TIGER HYPER DRIFT KICK DRIFTING ACROSS THE MAP AT LIGHTNING SPEED 🎍✨",
    "%s - ☀️☄️ tmx MEGA POWER WAVE MAXIMUM OVERDRIVE TIDAL WAVE ENERGY SURGE ACTIVATED ☀️☄️",
    "%s - 🔥👾 tmx ULTIMATE GODZILA TAIL WHIP DESTRUCTION LEVEL 9999 ACTIVATED IN THE SECTOR 🔥👾",
    "%s - ✨🎐 tmx GORILLA CHEST BEAT SOUNDWAVE BLAST SHAKING THE FOUNDATIONS OF THE EARTH ✨🎐",
    "%s - ☀️☄️ tmx SONIC BEEM HYPER LASER BEAM MELTING EVERYTHING IN ITS PATH ☀️☄️",
    "%s - 👾🔥 tmx BRAZIL TIGER SAVAGE BITE ATTACK OF THE JUNGLE KINGDOM LORDS 👾🔥",
    "%s - 🎐🎍 tmx SUPER MEGA POWER WAVE OCEAN CRASH TIDAL WAVE DELUGE SWEEPING THE MAP CLEAN 🎐🎍",
    "%s - 😝🔮 tmx GODZILA KING OF THE MONSTERS ROAR ECHOING ACROSS THE ENTIRE UNIVERSE 😝🔮",
    "%s - 🔥👾 tmx GORILLA SMASH GROUND ZERO IMPACT CRATER CREATION PROTOCOL ONLINE 🔥👾",
    "%s - ☀️🎐 tmx SONIC BEEM LIGHTNING SPEED DASH ACROSS ALL SERVERS ☀️🎐",
    "%s - 🔮😝 tmx BRAZIL TIGER JUNGLE KING DOMINATION REIGNING SUPREME OVER EVERYONE 🔮😝",
    "%s - ✨☄️ tmx MEGA POWER WAVE TIDAL WAVE ONSLAUGHT SWEEPING AWAY ALL DEFENSES ✨☄️",
    "%s - 🔥👾 tmx ULTIMATE GODZILA HEAT RAY MELTDOWN CAUSING VOLCANIC ERUPTIONS EVERYWHERE 🔥👾",
    "%s - 🔥✨ tmx GODZILA POWER SONIC BEEM UNLEASHED 100% MAXIMUM DESTRUCTION OVERLOAD 🔥✨",
    "%s - 😝☄️ tmx SUPER ULTRA BRAZIL TIGER GORILLA PUNCH COMING THROUGH WITH UNSTOPPABLE JUNGLE FURY RAGE 😝☄️",
    "%s - ✨☀️ tmx SUPER MEGA POWER WAVE TSUNAMI BLAST ACTIVATED ACROSS THE ENTIRE SERVER DIMENSION ✨☀️",
	
}

local randomPrefixes = {
	"---", "@@@", "_", ":o_O:", "(!)", "🔥", "💀", "😈", "[Kaiser Papa]",
	">>", "★彡", "⚡", "☠️", "_____Pro", "______", "____Pro",
	"👑", "😹", "¥¥¥", "\\\\", "$$", "×", "▬▬", "★★★", "▓▓▓",
	"›››", "=>", ":", ";", "!", "©", "®", "™", "卍", "☯",
	"ZM ON TOP", "P R O", "____", "___Pro___", "🅿🆁🅾",
}

local usedIdx = {}

local function pickRoast()
	if #usedIdx >= #roasts then usedIdx = {} end
	local available = {}
	for i = 1, #roasts do
		local used = false
		for _, u in ipairs(usedIdx) do
			if u == i then used = true break end
		end
		if not used then table.insert(available, i) end
	end
	local idx = available[math.random(1, #available)]
	table.insert(usedIdx, idx)
	return roasts[idx]
end

-- =====================================================
--              SPAM LOGIC
-- =====================================================
local spamming = false
local spamThread = nil
local msgCount = 0

local function getActiveTargets()
	local list = {}
	for i = 1, 4 do
		if targets[i] and targets[i].Parent then table.insert(list, targets[i]) end
	end
	return list
end

local function startSpam()
	if spamming then return end
	local active = getActiveTargets()
	if #active == 0 then
		Status.Text = "Status: ❌ Select at least 1 target!"
		Status.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end

	spamming = true
	usedIdx = {}
	msgCount = 0
	Status.Text = "Status: 🔥 Spamming " .. #active .. " target(s)..."
	Status.TextColor3 = Color3.fromRGB(120, 255, 140)

	spamThread = task.spawn(function()
		while spamming do
			local activeList = getActiveTargets()
			if #activeList == 0 then
				spamming = false
				Status.Text = "Status: ❌ No targets left!"
				Status.TextColor3 = Color3.fromRGB(255, 100, 100)
				break
			end

			local target = activeList[math.random(1, #activeList)]
			local roastTemplate = pickRoast()

			local finalPrefix = ""
			if isRandomPrefix then
				finalPrefix = randomPrefixes[math.random(1, #randomPrefixes)] .. " "
			else
				local customP = PrefixBox.Text
				if customP ~= "" and customP ~= "RANDOM" then
					finalPrefix = customP .. " "
				end
			end

			local msg = finalPrefix .. string.format(roastTemplate, target.Name)
			sendChat(msg)
			msgCount = msgCount + 1

			local delay = tonumber(DelayBox.Text) or 1
			if delay < 0.5 then delay = 0.5 end
			task.wait(delay)
		end
	end)
end

local function stopSpam()
	if not spamming then return end
	spamming = false
	Status.Text = "Status: ⏹ Stopped | Sent: " .. msgCount
	Status.TextColor3 = Color3.fromRGB(255, 160, 160)
	if spamThread then
		pcall(function() task.cancel(spamThread) end)
		spamThread = nil
	end
end

StartBtn.MouseButton1Click:Connect(startSpam)
StopBtn.MouseButton1Click:Connect(stopSpam)

-- =====================================================
--        LOCAL PLAYER VIP NAME TAG (KAISERxZM ON TOP)
-- =====================================================
local function createLocalNameTag(char)
	local head = char:WaitForChild("Head", 10)
	if not head then return end
	local old = head:FindFirstChild("YadsanLocalTag")
	if old then old:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "YadsanLocalTag"
	billboard.Size = UDim2.new(0, 340, 0, 72)
	billboard.StudsOffset = Vector3.new(0, 3.6, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(8, 0, 16)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
	}
	grad.Rotation = 45
	grad.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 200, 0)
	stroke.Thickness = 2.5
	stroke.Parent = frame

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = "☠️ KAISER X ZM ON TOP! 👑"
	lbl.TextColor3 = Color3.fromRGB(255, 230, 100)
	lbl.Font = Enum.Font.GothamBlack
	lbl.TextScaled = true
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(80, 0, 140)
	lbl.Parent = frame

	task.spawn(function()
		while billboard.Parent do
			TweenService:Create(stroke, TweenInfo.new(1.5), {Color = Color3.fromRGB(255, 100, 255)}):Play()
			task.wait(1.5)
			if not billboard.Parent then break end
			TweenService:Create(stroke, TweenInfo.new(1.5), {Color = Color3.fromRGB(255, 200, 0)}):Play()
			task.wait(1.5)
		end
	end)
end

if LocalPlayer.Character then createLocalNameTag(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(createLocalNameTag)

-- =====================================================
--        OTHER PLAYERS JOIN NOTIFICATION
-- =====================================================
local function createJoinNotification(plr)
	plr.CharacterAdded:Connect(function(char)
		local head = char:WaitForChild("Head", 10)
		if head then
			local billboard = Instance.new("BillboardGui")
			billboard.Size = UDim2.new(0, 250, 0, 60)
			billboard.StudsOffset = Vector3.new(0, 3.5, 0)
			billboard.AlwaysOnTop = true
			billboard.Parent = head

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundTransparency = 0.3
			frame.BackgroundColor3 = Color3.fromRGB(20, 5, 30)
			frame.Parent = billboard

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 10)
			corner.Parent = frame

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(255, 30, 80)
			stroke.Thickness = 2
			stroke.Parent = frame

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = "🔥 KAISER PAPA SPAMMER 🔥\nWelcome " .. plr.Name .. " 💀"
			lbl.TextColor3 = Color3.fromRGB(255, 100, 150)
			lbl.Font = Enum.Font.GothamBlack
			lbl.TextScaled = true
			lbl.TextStrokeTransparency = 0
			lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			lbl.Parent = frame

			task.delay(4, function()
				if not billboard.Parent then return end
				local tween = TweenService:Create(frame, TweenInfo.new(1), {BackgroundTransparency = 1})
				local tween2 = TweenService:Create(lbl, TweenInfo.new(1), {TextTransparency = 1, TextStrokeTransparency = 1})
				tween:Play()
				tween2:Play()
				tween.Completed:Connect(function()
					billboard:Destroy()
				end)
			end)
		end
	end)
end

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then createJoinNotification(plr) end
end
Players.PlayerAdded:Connect(function(plr)
	if plr ~= LocalPlayer then createJoinNotification(plr) end
end)

-- Hover effects
local function addHover(btn, normal, hover)
	btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hover}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normal}):Play() end)
end

addHover(StartBtn, Color3.fromRGB(20, 80, 40), Color3.fromRGB(30, 120, 60))
addHover(StopBtn, Color3.fromRGB(80, 20, 20), Color3.fromRGB(120, 30, 30))
addHover(CloseBtn, Color3.fromRGB(255, 30, 60), Color3.fromRGB(255, 80, 100))

SideBtn.MouseEnter:Connect(function() TweenService:Create(SideBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 90, 255)}):Play() end)
SideBtn.MouseLeave:Connect(function() TweenService:Create(SideBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 60, 255)}):Play() end)

-- =====================================================
--        AUTO LOAD MESSAGE (Sent by LocalPlayer)
-- =====================================================
task.spawn(function()
	task.wait(3)
	local loadMsg = " JAMES-LEE 😈 SPAMMER HAS LOADED ZERO MERCY ON TOP ☠️🏴 MADE BY Yadsan_GodVerse 🔥"
	for attempt = 1, 5 do
		if sendChat(loadMsg) then
			break
		end
		task.wait(1)
	end
end)

task.wait(0.3)
openGUI()
