--==================================================
-- ALLIED INTRO v2 | emblem traced from the real photo
-- 6 sharp blades (rotated copies), 1 taupe = Daniel Park
--==================================================
do
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local DURATION = 6
	local WHITE = Color3.fromRGB(246, 246, 246)
	local TAUPE = Color3.fromRGB(148, 140, 124)
	local GREY = Color3.fromRGB(120, 120, 128)

	-- Daniel's blade polygon (pixel coords traced from the photo); center = (205, 363)
	local BLADE = { {320, 279}, {280, 320}, {275, 275}, {246, 358}, {219, 379}, {284, 373} }
	local CX, CY, R = 205, 363, 160

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
	BG.BackgroundColor3 = Color3.new(0, 0, 0)
	BG.BorderSizePixel = 0
	BG.Parent = Gui

	local function Tween(obj, t, props, repeatCount, style, dir)
		local info = TweenInfo.new(t, style or Enum.EasingStyle.Sine, dir or Enum.EasingDirection.InOut, repeatCount or 0)
		local tw = TweenService:Create(obj, info, props)
		tw:Play()
		return tw
	end

	-- fills any polygon with thin horizontal rows (UI has no polygons)
	local function FillPoly(parent, pts, color, step)
		local minY, maxY = math.huge, -math.huge
		for _, p in ipairs(pts) do
			minY = math.min(minY, p[2])
			maxY = math.max(maxY, p[2])
		end
		local n = #pts
		local y = minY
		while y < maxY do
			local yy = y + step / 2
			local xs = {}
			for i = 1, n do
				local a, b = pts[i], pts[i % n + 1]
				if (a[2] <= yy and b[2] > yy) or (b[2] <= yy and a[2] > yy) then
					table.insert(xs, a[1] + (yy - a[2]) / (b[2] - a[2]) * (b[1] - a[1]))
				end
			end
			table.sort(xs)
			for j = 1, #xs - 1, 2 do
				local x0, x1 = xs[j], xs[j + 1]
				local row = Instance.new("Frame")
				row.BorderSizePixel = 0
				row.BackgroundColor3 = color
				row.AnchorPoint = Vector2.new(0.5, 0.5)
				row.Position = UDim2.fromScale(((x0 + x1) / 2 - CX) / (2 * R) + 0.5, (yy - CY) / (2 * R) + 0.5)
				row.Size = UDim2.fromScale((x1 - x0) / (2 * R), (step + 0.9) / (2 * R))
				row.Parent = parent
			end
			y = y + step
		end
	end

	-- EMBLEM (square, responsive)
	local Holder = Instance.new("Frame")
	Holder.AnchorPoint = Vector2.new(0.5, 0.5)
	Holder.Position = UDim2.fromScale(0.5, 0.42)
	Holder.BackgroundTransparency = 1
	Holder.Parent = BG

	local function Resize()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local v = cam.ViewportSize
		local d = math.floor(math.min(v.X, v.Y) * 0.62)
		Holder.Size = UDim2.fromOffset(d, d)
	end
	Resize()
	local vpConn
	if workspace.CurrentCamera then
		vpConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)
	end

	local Emblem = Instance.new("Frame")
	Emblem.AnchorPoint = Vector2.new(0.5, 0.5)
	Emblem.Position = UDim2.fromScale(0.5, 0.5)
	Emblem.Size = UDim2.fromScale(1, 1)
	Emblem.BackgroundTransparency = 1
	Emblem.Parent = Holder

	for i = 0, 5 do
		local blade = Instance.new("Frame")
		blade.AnchorPoint = Vector2.new(0.5, 0.5)
		blade.Position = UDim2.fromScale(0.5, 0.5)
		blade.Size = UDim2.fromScale(1, 1)
		blade.BackgroundTransparency = 1
		blade.Rotation = i * 60 - 50
		blade.Parent = Emblem
		FillPoly(blade, BLADE, (i == 0) and TAUPE or WHITE, 1.5)

		local sc = Instance.new("UIScale")
		sc.Scale = 0.01
		sc.Parent = blade
		task.delay(0.15 * i, function()
			Tween(sc, 0.7, { Scale = 1 }, 0, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			Tween(blade, 0.7, { Rotation = i * 60 }, 0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		end)
	end

	-- slow spin + breathing pulse
	Tween(Emblem, 40, { Rotation = 360 }, -1, Enum.EasingStyle.Linear)
	local pulse = Instance.new("UIScale")
	pulse.Parent = Emblem
	task.delay(1.2, function()
		Tween(pulse, 1.6, { Scale = 1.05 }, -1)
	end)

	-- TEXT
	local function Label(text, y, h, font, color)
		local l = Instance.new("TextLabel")
		l.AnchorPoint = Vector2.new(0.5, 0.5)
		l.Position = UDim2.fromScale(0.5, y)
		l.Size = UDim2.fromScale(0.7, h)
		l.BackgroundTransparency = 1
		l.Text = text
		l.TextColor3 = color
		l.Font = font
		l.TextScaled = true
		l.TextTransparency = 1
		l.Parent = BG
		return l
	end
	local Title = Label("A L L I E D", 0.76, 0.08, Enum.Font.GothamBlack, WHITE)
	local Sub = Label("Z E R O   M E R C Y   O N   T O P   •   Y A D S A N   X   K A I S E R", 0.83, 0.028, Enum.Font.GothamMedium, GREY)
	local Status = Label("LOADING...", 0.885, 0.026, Enum.Font.Gotham, TAUPE)
	Tween(Title, 1.2, { TextTransparency = 0 })
	Tween(Sub, 1.6, { TextTransparency = 0 })
	Tween(Status, 0.8, { TextTransparency = 0 })

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
	Tween(Fill, DURATION, { Size = UDim2.fromScale(1, 1) }, 0, Enum.EasingStyle.Linear)

	local messages = { "LOADING...", "SIX FIGHTERS, ONE CREW", "EQUAL FOOTING, ONE GOAL", "ZERO MERCY ON TOP", "ALLIED READY" }
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
		end
	end
	task.wait(0.8)
	if vpConn then vpConn:Disconnect() end
	Gui:Destroy()
end
