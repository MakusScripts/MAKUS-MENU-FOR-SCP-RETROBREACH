--// MAKUS MENU
--// LocalScript -> StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================

local Settings = {
	Noclip = false,
	ESP = false,
	AimAssist = false,
	Speed = false,

	WalkSpeed = 32,

	AimFOV = 150,
	AimSmoothness = 0.15,

	MenuOpen = true,

	AdminOnly = false,

	Admins = {
		[123456789] = true -- твой UserId
	}
}

if Settings.AdminOnly and not Settings.Admins[LocalPlayer.UserId] then
	return
end

--==================================================
-- COLORS
--==================================================

local Colors = {
	Background = Color3.fromRGB(15, 15, 18),
	Panel = Color3.fromRGB(23, 23, 28),
	Button = Color3.fromRGB(32, 32, 39),
	ButtonHover = Color3.fromRGB(42, 42, 50),

	Red = Color3.fromRGB(220, 45, 55),
	Green = Color3.fromRGB(45, 180, 95),

	Text = Color3.fromRGB(245, 245, 248),
	Muted = Color3.fromRGB(145, 145, 155)
}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MakusMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(350, 455)
Main.Position = UDim2.new(0, 35, 0.5, -227)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 55, 65)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 70)
TopBar.BackgroundColor3 = Colors.Panel
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 5, 1, 0)
Accent.BackgroundColor3 = Colors.Red
Accent.BorderSizePixel = 0
Accent.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(22, 10)
Title.Size = UDim2.new(1, -70, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "MAKUS MENU"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.fromOffset(23, 38)
Subtitle.Size = UDim2.new(1, -70, 0, 20)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "F4 • Drag me anywhere • MUKUS MENU"
Subtitle.TextColor3 = Colors.Muted
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -45, 0, 17)
Close.BackgroundColor3 = Colors.Button
Close.Text = "—"
Close.TextColor3 = Colors.Text
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.AutoButtonColor = false
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

--==================================================
-- MOUSE / MENU STATE
--==================================================

local PreviousMouseBehavior = Enum.MouseBehavior.LockCenter
local PreviousMouseIcon = false

local function SetMenuState(open)

	Settings.MenuOpen = open
	Main.Visible = open

	if open then

		PreviousMouseBehavior = UserInputService.MouseBehavior
		PreviousMouseIcon = UserInputService.MouseIconEnabled

		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true

	else

		UserInputService.MouseBehavior = PreviousMouseBehavior
		UserInputService.MouseIconEnabled = PreviousMouseIcon
	end
end

Close.MouseButton1Click:Connect(function()
	SetMenuState(false)
end)

-- Small reopen button appears while the main panel is hidden.
local Reopen = Instance.new("TextButton")
Reopen.Name = "MUKUSReopen"
Reopen.Size = UDim2.fromOffset(48, 48)
Reopen.Position = UDim2.fromOffset(20, 120)
Reopen.BackgroundColor3 = Colors.Red
Reopen.BorderSizePixel = 0
Reopen.Text = "M"
Reopen.TextColor3 = Colors.Text
Reopen.Font = Enum.Font.GothamBold
Reopen.TextSize = 18
Reopen.Visible = false
Reopen.AutoButtonColor = false
Reopen.Parent = ScreenGui

local ReopenCorner = Instance.new("UICorner")
ReopenCorner.CornerRadius = UDim.new(1, 0)
ReopenCorner.Parent = Reopen

Reopen.MouseButton1Click:Connect(function()
	SetMenuState(true)
end)

local OriginalSetMenuState = SetMenuState
SetMenuState = function(open)
	OriginalSetMenuState(open)
	Reopen.Visible = not open
end


--==================================================
-- DRAGGING
--==================================================

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position
	end
end)

TopBar.InputEnded:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType == Enum.UserInputType.MouseMovement
		or Input.UserInputType == Enum.UserInputType.Touch then

		local Delta = Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,

			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(15, 82)
Content.Size = UDim2.new(1, -30, 1, -95)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Colors.Red
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 9)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

--==================================================
-- SECTION
--==================================================

local function CreateSection(Text)

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, 0, 0, 25)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = Colors.Muted
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 11
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Content

	return Label
end

--==================================================
-- TOGGLE
--==================================================

local function CreateToggle(Name, Description, Callback)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, 0, 0, 58)
	Button.BackgroundColor3 = Colors.Button
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = false
	Button.Text = ""
	Button.Parent = Content

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Button

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Position = UDim2.fromOffset(15, 8)
	NameLabel.Size = UDim2.new(1, -80, 0, 22)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name
	NameLabel.TextColor3 = Colors.Text
	NameLabel.Font = Enum.Font.GothamSemibold
	NameLabel.TextSize = 14
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = Button

	local DescriptionLabel = Instance.new("TextLabel")
	DescriptionLabel.Position = UDim2.fromOffset(15, 31)
	DescriptionLabel.Size = UDim2.new(1, -80, 0, 17)
	DescriptionLabel.BackgroundTransparency = 1
	DescriptionLabel.Text = Description
	DescriptionLabel.TextColor3 = Colors.Muted
	DescriptionLabel.Font = Enum.Font.Gotham
	DescriptionLabel.TextSize = 10
	DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescriptionLabel.Parent = Button

	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.fromOffset(38, 20)
	Indicator.Position = UDim2.new(1, -53, 0.5, -10)
	Indicator.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
	Indicator.BorderSizePixel = 0
	Indicator.Parent = Button

	local IndicatorCorner = Instance.new("UICorner")
	IndicatorCorner.CornerRadius = UDim.new(1, 0)
	IndicatorCorner.Parent = Indicator

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.fromOffset(16, 16)
	Circle.Position = UDim2.fromOffset(2, 2)
	Circle.BackgroundColor3 = Color3.fromRGB(190, 190, 195)
	Circle.BorderSizePixel = 0
	Circle.Parent = Indicator

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local Enabled = false

	Button.MouseEnter:Connect(function()

		if not Enabled then
			Button.BackgroundColor3 = Colors.ButtonHover
		end
	end)

	Button.MouseLeave:Connect(function()

		if not Enabled then
			Button.BackgroundColor3 = Colors.Button
		end
	end)

	Button.MouseButton1Click:Connect(function()

		Enabled = not Enabled

		if Enabled then

			Button.BackgroundColor3 = Color3.fromRGB(38, 42, 40)
			Indicator.BackgroundColor3 = Colors.Green
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(1, -18, 0, 2)

		else

			Button.BackgroundColor3 = Colors.Button
			Indicator.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
			Circle.BackgroundColor3 = Color3.fromRGB(190, 190, 195)
			Circle.Position = UDim2.fromOffset(2, 2)

		end

		Callback(Enabled)
	end)

	return Button
end

--==================================================
-- PLAYER
--==================================================

CreateSection("PLAYER")

CreateToggle(
	"Noclip",
	"Walk through walls and doors",
	function(Value)
		Settings.Noclip = Value
	end
)

CreateToggle(
	"Speed",
	"Use custom WalkSpeed",
	function(Value)

		Settings.Speed = Value

		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then

			if Value then
				Humanoid.WalkSpeed = Settings.WalkSpeed
			else
				Humanoid.WalkSpeed = 16
			end
		end
	end
)

--==================================================
-- SPEED
--==================================================

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, 0, 0, 65)
SpeedFrame.BackgroundColor3 = Colors.Panel
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = Content

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 10)
SpeedCorner.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Position = UDim2.fromOffset(15, 9)
SpeedLabel.Size = UDim2.fromOffset(120, 20)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "WalkSpeed"
SpeedLabel.TextColor3 = Colors.Text
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedHint = Instance.new("TextLabel")
SpeedHint.Position = UDim2.fromOffset(15, 31)
SpeedHint.Size = UDim2.fromOffset(130, 18)
SpeedHint.BackgroundTransparency = 1
SpeedHint.Text = "Enter value: 1 - 250"
SpeedHint.TextColor3 = Colors.Muted
SpeedHint.Font = Enum.Font.Gotham
SpeedHint.TextSize = 10
SpeedHint.TextXAlignment = Enum.TextXAlignment.Left
SpeedHint.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.fromOffset(105, 38)
SpeedBox.Position = UDim2.new(1, -170, 0.5, -19)
SpeedBox.BackgroundColor3 = Colors.Button
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(Settings.WalkSpeed)
SpeedBox.PlaceholderText = "Speed"
SpeedBox.TextColor3 = Colors.Text
SpeedBox.PlaceholderColor3 = Colors.Muted
SpeedBox.Font = Enum.Font.GothamSemibold
SpeedBox.TextSize = 14
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = SpeedFrame

local SpeedBoxCorner = Instance.new("UICorner")
SpeedBoxCorner.CornerRadius = UDim.new(0, 8)
SpeedBoxCorner.Parent = SpeedBox

local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.fromOffset(50, 38)
ApplyButton.Position = UDim2.new(1, -58, 0.5, -19)
ApplyButton.BackgroundColor3 = Colors.Red
ApplyButton.BorderSizePixel = 0
ApplyButton.Text = "SET"
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Font = Enum.Font.GothamBold
ApplyButton.TextSize = 11
ApplyButton.Parent = SpeedFrame

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 8)
ApplyCorner.Parent = ApplyButton

ApplyButton.MouseButton1Click:Connect(function()

	local Number = tonumber(SpeedBox.Text)

	if Number then

		Number = math.clamp(Number, 1, 250)

		Settings.WalkSpeed = Number
		SpeedBox.Text = tostring(Number)

		if Settings.Speed then

			local Character = LocalPlayer.Character
			local Humanoid =
				Character and Character:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				Humanoid.WalkSpeed = Number
			end
		end

	else
		SpeedBox.Text = tostring(Settings.WalkSpeed)
	end
end)

--==================================================
-- ESP
--==================================================

local ESPObjects = {}

local function RemoveESP(Player)

	if not ESPObjects[Player] then
		return
	end

	for _, Object in ipairs(ESPObjects[Player]) do

		if typeof(Object) == "RBXScriptConnection" then
			Object:Disconnect()

		elseif Object and Object.Destroy then
			Object:Destroy()
		end
	end

	ESPObjects[Player] = nil
end

local function CreateESP(Player)

	if Player == LocalPlayer then
		return
	end

	if not Settings.ESP then
		return
	end

	local Character = Player.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Head = Character:FindFirstChild("Head")

	if not Humanoid or not Head then
		return
	end

	RemoveESP(Player)

	local Objects = {}

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "MakusESP"
	Highlight.FillColor = Color3.fromRGB(255, 55, 55)
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = 0.65
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = Character

	table.insert(Objects, Highlight)

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "MakusESPInfo"
	Billboard.Size = UDim2.fromOffset(190, 45)
	Billboard.StudsOffset = Vector3.new(0, 3.2, 0)
	Billboard.AlwaysOnTop = true
	Billboard.Parent = Head

	table.insert(Objects, Billboard)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.fromScale(1, 1)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextStrokeTransparency = 0.3
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 13
	Label.Parent = Billboard

	table.insert(Objects, Label)

	local Connection

	Connection = RunService.RenderStepped:Connect(function()

		if not Character.Parent or not Settings.ESP then

			Connection:Disconnect()
			return
		end

		local HP = math.max(0, math.floor(Humanoid.Health))
		local MaxHP = math.floor(Humanoid.MaxHealth)

		Label.Text =
			Player.Name ..
			"\nHP: " ..
			HP ..
			" / " ..
			MaxHP
	end)

	table.insert(Objects, Connection)

	ESPObjects[Player] = Objects
end

--==================================================
-- RETROBREACH TELEPORTS
-- REAL MAP POINTS FROM THE USER'S LIVE MAP SCAN
--==================================================

local TPPoints = {
	["Class-D"] = {
		CFrame = CFrame.new(1450.7, 404.4, 1007.6),
		Description = "Class-D area"
	},

	["Armory"] = {
		CFrame = CFrame.new(1437.7, 399.5, 881.1),
		Description = "Lobby Armory"
	},

	["SCP-173 Area"] = {
		-- The scan exposed the real SCPInfo.173.Class-D point.
		-- This is the confirmed 173/Class-D area from the current map.
		CFrame = CFrame.new(1450.7, 404.4, 1007.6),
		Description = "SCP-173 / Class-D area"
	},

	["Gate A"] = {
		CFrame = CFrame.new(1484.7, 392.8, 921.1),
		Description = "Gate-A interior"
	},

	["Gate B / Escape"] = {
		CFrame = CFrame.new(1484.7, 397.0, 925.2),
		Description = "Gate-B / escape"
	}
}

local function TeleportToPoint(PointName)
	local Point = TPPoints[PointName]

	if not Point then
		warn("[MUKUS MENU] TP point missing: " .. tostring(PointName))
		return false
	end

	local Character = LocalPlayer.Character
	if not Character then
		warn("[MUKUS MENU] Character not found")
		return false
	end

	local Root = Character:FindFirstChild("HumanoidRootPart")
	if not Root then
		warn("[MUKUS MENU] HumanoidRootPart not found")
		return false
	end

	-- Direct teleport to the exact point obtained from the live map scan.
	-- No random target resolver and no safe-point rejection.
	Character:PivotTo(Point.CFrame)

	Root.AssemblyLinearVelocity = Vector3.zero
	Root.AssemblyAngularVelocity = Vector3.zero

	task.wait()

	if Root.Parent then
		Root.AssemblyLinearVelocity = Vector3.zero
		Root.AssemblyAngularVelocity = Vector3.zero
	end

	print("[MUKUS MENU] Teleported to " .. PointName)
	return true
end

local function CreateTeleportButton(Name, Description, PointName)
	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, 0, 0, 58)
	Button.BackgroundColor3 = Colors.Button
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = false
	Button.Text = ""
	Button.Parent = Content

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Button

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Position = UDim2.fromOffset(15, 8)
	NameLabel.Size = UDim2.new(1, -90, 0, 22)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name
	NameLabel.TextColor3 = Colors.Text
	NameLabel.Font = Enum.Font.GothamSemibold
	NameLabel.TextSize = 14
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = Button

	local DescriptionLabel = Instance.new("TextLabel")
	DescriptionLabel.Position = UDim2.fromOffset(15, 31)
	DescriptionLabel.Size = UDim2.new(1, -90, 0, 17)
	DescriptionLabel.BackgroundTransparency = 1
	DescriptionLabel.Text = Description
	DescriptionLabel.TextColor3 = Colors.Muted
	DescriptionLabel.Font = Enum.Font.Gotham
	DescriptionLabel.TextSize = 10
	DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescriptionLabel.Parent = Button

	local TPLabel = Instance.new("TextLabel")
	TPLabel.Size = UDim2.fromOffset(52, 28)
	TPLabel.Position = UDim2.new(1, -65, 0.5, -14)
	TPLabel.BackgroundColor3 = Colors.Red
	TPLabel.Text = "TP"
	TPLabel.TextColor3 = Color3.new(1, 1, 1)
	TPLabel.Font = Enum.Font.GothamBold
	TPLabel.TextSize = 12
	TPLabel.Parent = Button

	local TPCorner = Instance.new("UICorner")
	TPCorner.CornerRadius = UDim.new(0, 7)
	TPCorner.Parent = TPLabel

	Button.MouseEnter:Connect(function()
		Button.BackgroundColor3 = Colors.ButtonHover
	end)

	Button.MouseLeave:Connect(function()
		Button.BackgroundColor3 = Colors.Button
	end)

	Button.MouseButton1Click:Connect(function()
		TeleportToPoint(PointName)
	end)

	return Button
end

CreateSection("TELEPORTS / RETROBREACH")

CreateTeleportButton(
	"Class-D",
	"Direct TP • current map point",
	"Class-D"
)

CreateTeleportButton(
	"Armory",
	"Direct TP • Lobby Armory",
	"Armory"
)

CreateTeleportButton(
	"SCP-173 Area",
	"Direct TP • confirmed 173/Class-D point",
	"SCP-173 Area"
)

CreateTeleportButton(
	"Gate A",
	"Direct TP • Gate-A interior",
	"Gate A"
)

CreateTeleportButton(
	"Gate B / Escape",
	"Direct TP • escape route",
	"Gate B / Escape"
)

-- Medkits are intentionally not assigned a fake coordinate.
-- The live scan did not return a medical/medkit object, so adding one
-- here would recreate the old "point not found"/wrong destination problem.

--==================================================
-- VISUAL
--==================================================

CreateSection("VISUAL / AIM")

CreateToggle(
	"ESP + HP",
	"Show players, names and health",
	function(Value)

		Settings.ESP = Value

		for _, Player in ipairs(Players:GetPlayers()) do

			if Player ~= LocalPlayer then

				if Value then
					CreateESP(Player)
				else
					RemoveESP(Player)
				end
			end
		end
	end
)

--==================================================
-- ENEMY CHECK
--==================================================

local function IsEnemy(Player)

	if Player == LocalPlayer then
		return false
	end

	-- Если команды используются
	if LocalPlayer.Team ~= nil and Player.Team ~= nil then

		return Player.Team ~= LocalPlayer.Team
	end

	-- Если у игры пока нет Teams,
	-- игроки считаются потенциальными врагами.
	return true
end

--==================================================
-- AIM TARGET
--==================================================

local function IsVisible(TargetCharacter, TargetPart)

	local Origin = Camera.CFrame.Position
	local Direction = TargetPart.Position - Origin

	local Params = RaycastParams.new()

	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.FilterDescendantsInstances = {
		LocalPlayer.Character
	}

	local Result = workspace:Raycast(
		Origin,
		Direction,
		Params
	)

	if not Result then
		return true
	end

	return Result.Instance:IsDescendantOf(TargetCharacter)
end

local function GetClosestEnemy()

	local ClosestPlayer = nil
	local ClosestDistance = Settings.AimFOV

	local Center = Vector2.new(
		Camera.ViewportSize.X / 2,
		Camera.ViewportSize.Y / 2
	)

	for _, Player in ipairs(Players:GetPlayers()) do

		if IsEnemy(Player) then

			local Character = Player.Character

			if Character then

				local Humanoid =
					Character:FindFirstChildOfClass("Humanoid")

				local Head =
					Character:FindFirstChild("Head")

				if Humanoid
					and Head
					and Humanoid.Health > 0 then

					local ScreenPosition, Visible =
						Camera:WorldToViewportPoint(
							Head.Position
						)

					if Visible
						and IsVisible(Character, Head) then

						local Distance =
							(
								Vector2.new(
									ScreenPosition.X,
									ScreenPosition.Y
								)
								- Center
							).Magnitude

						if Distance < ClosestDistance then

							ClosestDistance = Distance
							ClosestPlayer = Player
						end
					end
				end
			end
		end
	end

	return ClosestPlayer
end

--==================================================
-- AIM ASSIST
--==================================================

CreateToggle(
	"Aim Assist",
	"Right mouse • enemies only • no walls",
	function(Value)
		Settings.AimAssist = Value
	end
)

--==================================================
-- FOV
--==================================================

local FOV = Instance.new("Frame")

FOV.Size = UDim2.fromOffset(
	Settings.AimFOV * 2,
	Settings.AimFOV * 2
)

FOV.AnchorPoint = Vector2.new(0.5, 0.5)
FOV.Position = UDim2.fromScale(0.5, 0.5)
FOV.BackgroundTransparency = 1
FOV.Visible = false
FOV.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOV

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Colors.Red
FOVStroke.Transparency = 0.35
FOVStroke.Thickness = 1
FOVStroke.Parent = FOV

--==================================================
-- AIM RIGHT MOUSE
--==================================================

local Aiming = false

UserInputService.InputBegan:Connect(function(Input, Processed)

	if Processed then
		return
	end

	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Aiming = true
	end
end)

UserInputService.InputEnded:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Aiming = false
	end
end)

--==================================================
-- MAIN LOOP
--==================================================

RunService.RenderStepped:Connect(function()

	-- Noclip
	if Settings.Noclip then

		local Character = LocalPlayer.Character

		if Character then

			for _, Part in ipairs(Character:GetDescendants()) do

				if Part:IsA("BasePart") then
					Part.CanCollide = false
				end
			end
		end
	end

	-- Speed
	if Settings.Speed then

		local Character = LocalPlayer.Character

		local Humanoid =
			Character and
			Character:FindFirstChildOfClass("Humanoid")

		if Humanoid
			and Humanoid.WalkSpeed ~= Settings.WalkSpeed then

			Humanoid.WalkSpeed = Settings.WalkSpeed
		end
	end

	-- FOV
	FOV.Visible =
		Settings.AimAssist
		and not Settings.MenuOpen

	-- Aim
	if Settings.AimAssist
		and Aiming
		and not Settings.MenuOpen then

		local Target = GetClosestEnemy()

		if Target and Target.Character then

			local Head =
				Target.Character:FindFirstChild("Head")

			if Head then

				local TargetCFrame =
					CFrame.lookAt(
						Camera.CFrame.Position,
						Head.Position
					)

				Camera.CFrame =
					Camera.CFrame:Lerp(
						TargetCFrame,
						Settings.AimSmoothness
					)
			end
		end
	end
end)

--==================================================
-- F4 MENU
--==================================================

UserInputService.InputBegan:Connect(function(Input, Processed)

	if Processed then
		return
	end

	if Input.KeyCode == Enum.KeyCode.F4 then

		SetMenuState(
			not Settings.MenuOpen
		)
	end
end)

--==================================================
-- RESPAWN
--==================================================

LocalPlayer.CharacterAdded:Connect(function(Character)

	local Humanoid =
		Character:WaitForChild("Humanoid")

	task.wait(0.2)

	if Settings.Speed then
		Humanoid.WalkSpeed = Settings.WalkSpeed
	end
end)

--==================================================
-- PLAYER ESP SETUP
--==================================================

Players.PlayerAdded:Connect(function(Player)

	Player.CharacterAdded:Connect(function()

		task.wait(0.5)

		if Settings.ESP then
			CreateESP(Player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(Player)
	RemoveESP(Player)
end)

for _, Player in ipairs(Players:GetPlayers()) do

	if Player ~= LocalPlayer then

		Player.CharacterAdded:Connect(function()

			task.wait(0.5)

			if Settings.ESP then
				CreateESP(Player)
			end
		end)
	end
end

--==================================================
-- START WITH MENU OPEN
--==================================================

SetMenuState(true)
