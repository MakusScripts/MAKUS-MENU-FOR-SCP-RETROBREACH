--// MUKUS MENU
--// SCP retroBreach - LocalScript -> StarterPlayer -> StarterPlayerScripts
--// UI / client utility panel for Studio testing

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

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
    Fullbright = false,
    Crosshair = true,

    WalkSpeed = 32,
    AimFOV = 150,
    AimSmoothness = 0.15,
    CameraFOV = 70,

    MenuOpen = false,
    Language = nil,

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
    Background = Color3.fromRGB(10, 11, 13),
    Panel = Color3.fromRGB(18, 19, 22),
    Panel2 = Color3.fromRGB(24, 25, 29),
    Button = Color3.fromRGB(31, 32, 37),
    ButtonHover = Color3.fromRGB(43, 44, 50),
    SCPBlack = Color3.fromRGB(5, 6, 7),
    Red = Color3.fromRGB(185, 28, 34),
    RedBright = Color3.fromRGB(225, 45, 55),
    Green = Color3.fromRGB(45, 180, 95),
    Amber = Color3.fromRGB(220, 170, 55),
    Text = Color3.fromRGB(245, 245, 248),
    Muted = Color3.fromRGB(145, 145, 155),
    DarkText = Color3.fromRGB(95, 97, 105)
}

--==================================================
-- LOCALIZATION
--==================================================

local Lang = {
    en = {
        title = "MUKUS MENU",
        subtitle = "SCP RETROBREACH // INTERNAL CLIENT",
        choose = "SELECT LANGUAGE",
        chooseHint = "Choose the interface language",
        russian = "RUSSIAN",
        english = "ENGLISH",
        player = "PLAYER",
        visual = "SURVEILLANCE",
        aim = "AIM CONTROL",
        teleport = "SCP // TELEPORT",
        terminal = "SCP COMMAND TERMINAL",
        noclip = "Noclip",
        noclipDesc = "Walk through walls and doors",
        speed = "Speed",
        speedDesc = "Use custom WalkSpeed",
        esp = "ESP + HP",
        espDesc = "Show players, names and health",
        aimAssist = "Aim Assist",
        aimDesc = "Right mouse • enemies only • visible targets",
        fullbright = "Fullbright",
        fullbrightDesc = "Maximize client lighting for dark areas",
        crosshair = "Crosshair",
        crosshairDesc = "Simple center reticle for orientation",
        speedValue = "WalkSpeed",
        speedHint = "Enter value: 1 - 250",
        set = "SET",
        commandPlaceholder = "help / noclip on / speed 32 / tp 173",
        execute = "EXEC",
        teleTitle = "QUICK LOCATIONS",
        tp173 = "SCP-173",
        tp049 = "SCP-049",
        tp106 = "SCP-106",
        tp914 = "SCP-914",
        tpClassD = "CLASS-D CELLS",
        tpGateA = "GATE A",
        tpArmory = "ARMORY",
        tpGateB = "GATE B",
        tpLCZ = "LCZ",
        tpHCZ = "HCZ",
        tpEZ = "EZ",
        hidden = "Location not found in this server",
        menuHint = "F4 • Drag panel • Right mouse = aim",
        unknown = "UNKNOWN COMMAND • TYPE help",
        help = "help | status | noclip on/off | esp on/off | aim on/off | speed on/off | speed 32 | fov 80 | fullbright on/off | crosshair on/off | tp 914/classd/gatea/armory | reset | rejoin",
        reset = "RESET EXECUTED",
        rejoin = "REJOINING...",
        fovUsage = "USAGE: fov 40-120",
        fovSet = "FOV SET: ",
        speedSet = "SPEED SET: ",
        tpUsage = "USAGE: tp 914 / classd / gatea / armory",
        tpOk = "TELEPORTED: ",
        tpFail = "TARGET NOT FOUND: ",
        status = "NC:%s ESP:%s AIM:%s SPD:%s FB:%s"
    },
    ru = {
        title = "MUKUS MENU",
        subtitle = "SCP RETROBREACH // ВНУТРЕННИЙ КЛИЕНТ",
        choose = "ВЫБЕРИТЕ ЯЗЫК",
        chooseHint = "Выберите язык интерфейса",
        russian = "РУССКИЙ",
        english = "АНГЛИЙСКИЙ",
        player = "ИГРОК",
        visual = "НАБЛЮДЕНИЕ",
        aim = "УПРАВЛЕНИЕ АИМ",
        teleport = "SCP // ТЕЛЕПОРТЫ",
        terminal = "КОМАНДНЫЙ ТЕРМИНАЛ SCP",
        noclip = "Ноклип",
        noclipDesc = "Проходить сквозь стены и двери",
        speed = "Скорость",
        speedDesc = "Использовать заданную скорость",
        esp = "ESP + HP",
        espDesc = "Показывать игроков, имена и здоровье",
        aimAssist = "Аим",
        aimDesc = "Правая кнопка • только враги • видимые цели",
        fullbright = "Фуллбрайт",
        fullbrightDesc = "Максимальное клиентское освещение",
        crosshair = "Прицел",
        crosshairDesc = "Простой прицел по центру экрана",
        speedValue = "Скорость ходьбы",
        speedHint = "Введите значение: 1 - 250",
        set = "УСТАН.",
        commandPlaceholder = "помощь / ноклип вкл / скорость 32 / тп 173",
        execute = "ВЫП",
        teleTitle = "БЫСТРЫЕ ТОЧКИ",
        tp173 = "SCP-173",
        tp049 = "SCP-049",
        tp106 = "SCP-106",
        tp914 = "SCP-914",
        tpClassD = "КАМЕРЫ CLASS-D",
        tpGateA = "ВОРОТА A",
        tpArmory = "ОРУЖЕЙНАЯ",
        tpGateB = "ВОРОТА B",
        tpLCZ = "LCZ",
        tpHCZ = "HCZ",
        tpEZ = "EZ",
        hidden = "Точка не найдена на этом сервере",
        menuHint = "F4 • Перетаскивание • ПКМ = аим",
        unknown = "НЕИЗВЕСТНАЯ КОМАНДА • ВВЕДИТЕ помощь",
        help = "помощь | статус | ноклип вкл/выкл | есп вкл/выкл | аим вкл/выкл | скорость вкл/выкл | скорость 32 | фов 80 | фуллбрайт вкл/выкл | прицел вкл/выкл | тп 914/классд/воротаа/оружейная | сброс | перезаход",
        reset = "СБРОС ВЫПОЛНЕН",
        rejoin = "ПЕРЕЗАХОД...",
        fovUsage = "ИСПОЛЬЗОВАНИЕ: фов 40-120",
        fovSet = "FOV УСТАНОВЛЕН: ",
        speedSet = "СКОРОСТЬ УСТАНОВЛЕНА: ",
        tpUsage = "ИСПОЛЬЗОВАНИЕ: тп 914 / классд / воротаа / оружейная",
        tpOk = "ТЕЛЕПОРТ: ",
        tpFail = "ТОЧКА НЕ НАЙДЕНА: ",
        status = "НОК:%s ESP:%s АИМ:%s СКР:%s FB:%s"
    }
}

local function T(Key)
    local Current = Lang[Settings.Language or "en"] or Lang.en
    return Current[Key] or Key
end

local function IsRussian()
    return Settings.Language == "ru"
end

--==================================================
-- GUI HELPERS
--==================================================

local Aiming = false
local TeleportGrid
local TeleportGridFrame
local CommandBox

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MUKUS_MENU"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function AddCorner(Object, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius or 10)
    Corner.Parent = Object
    return Corner
end

local function AddStroke(Object, Color, Thickness, Transparency)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color
    Stroke.Thickness = Thickness or 1
    Stroke.Transparency = Transparency or 0
    Stroke.Parent = Object
    return Stroke
end

local function Tween(Object, Time, Properties, Style, Direction)
    local Info = TweenInfo.new(Time, Style or Enum.EasingStyle.Quad, Direction or Enum.EasingDirection.Out)
    local Track = TweenService:Create(Object, Info, Properties)
    Track:Play()
    return Track
end

--==================================================
-- LANGUAGE SELECTOR
--==================================================

local LanguageOverlay = Instance.new("Frame")
LanguageOverlay.Size = UDim2.fromScale(1, 1)
LanguageOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LanguageOverlay.BackgroundTransparency = 1
LanguageOverlay.Parent = ScreenGui

local LanguageCard = Instance.new("Frame")
LanguageCard.Size = UDim2.fromOffset(310, 205)
LanguageCard.AnchorPoint = Vector2.new(0.5, 0.5)
LanguageCard.Position = UDim2.fromScale(0.5, 0.5)
LanguageCard.BackgroundColor3 = Colors.Background
LanguageCard.BorderSizePixel = 0
LanguageCard.Parent = LanguageOverlay
AddCorner(LanguageCard, 14)
AddStroke(LanguageCard, Color3.fromRGB(70, 72, 80), 1, 0.1)

local LangAccent = Instance.new("Frame")
LangAccent.Size = UDim2.new(1, 0, 0, 4)
LangAccent.BackgroundColor3 = Colors.RedBright
LangAccent.BorderSizePixel = 0
LangAccent.Parent = LanguageCard

local LangTitle = Instance.new("TextLabel")
LangTitle.Position = UDim2.fromOffset(20, 20)
LangTitle.Size = UDim2.new(1, -40, 0, 28)
LangTitle.BackgroundTransparency = 1
LangTitle.Text = "MUKUS MENU"
LangTitle.TextColor3 = Colors.Text
LangTitle.Font = Enum.Font.GothamBold
LangTitle.TextSize = 20
LangTitle.Parent = LanguageCard

local LangSub = Instance.new("TextLabel")
LangSub.Position = UDim2.fromOffset(20, 50)
LangSub.Size = UDim2.new(1, -40, 0, 20)
LangSub.BackgroundTransparency = 1
LangSub.Text = "SELECT LANGUAGE / ВЫБЕРИТЕ ЯЗЫК"
LangSub.TextColor3 = Colors.Muted
LangSub.Font = Enum.Font.Code
LangSub.TextSize = 10
LangSub.Parent = LanguageCard

local LangHint = Instance.new("TextLabel")
LangHint.Position = UDim2.fromOffset(20, 76)
LangHint.Size = UDim2.new(1, -40, 0, 20)
LangHint.BackgroundTransparency = 1
LangHint.Text = "Choose the interface language"
LangHint.TextColor3 = Colors.DarkText
LangHint.Font = Enum.Font.Gotham
LangHint.TextSize = 11
LangHint.Parent = LanguageCard

local function MakeLanguageButton(Text, Position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(125, 48)
    Button.Position = Position
    Button.BackgroundColor3 = Colors.Button
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.AutoButtonColor = false
    Button.Parent = LanguageCard
    AddCorner(Button, 9)
    AddStroke(Button, Color3.fromRGB(55, 56, 63), 1, 0.15)
    Button.MouseEnter:Connect(function()
        Tween(Button, 0.12, {BackgroundColor3 = Colors.ButtonHover})
    end)
    Button.MouseLeave:Connect(function()
        Tween(Button, 0.12, {BackgroundColor3 = Colors.Button})
    end)
    return Button
end

local RussianButton = MakeLanguageButton("РУССКИЙ", UDim2.fromOffset(20, 125))
local EnglishButton = MakeLanguageButton("ENGLISH", UDim2.fromOffset(165, 125))

--==================================================
-- MAIN PANEL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(390, 620)
Main.Position = UDim2.new(0, 35, 0.5, -310)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
AddCorner(Main, 14)
AddStroke(Main, Color3.fromRGB(55, 57, 65), 1, 0.1)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 74)
TopBar.BackgroundColor3 = Colors.Panel
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 5, 1, 0)
Accent.BackgroundColor3 = Colors.RedBright
Accent.BorderSizePixel = 0
Accent.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(22, 10)
Title.Size = UDim2.new(1, -70, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = T("title")
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.fromOffset(23, 40)
Subtitle.Size = UDim2.new(1, -70, 0, 20)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = T("subtitle")
Subtitle.TextColor3 = Colors.Muted
Subtitle.Font = Enum.Font.Code
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -45, 0, 19)
Close.BackgroundColor3 = Colors.Button
Close.Text = "×"
Close.TextColor3 = Colors.Text
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.AutoButtonColor = false
Close.Parent = TopBar
AddCorner(Close, 8)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -30, 0, 32)
TabBar.Position = UDim2.fromOffset(15, 75)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(15, 112)
Content.Size = UDim2.new(1, -30, 1, -127)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Colors.Red
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

local SectionRefs = {}
local RefreshTabs

local function CreateSection(Text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Colors.Muted
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content
    SectionRefs[Text] = Label
    return Label
end

local function CreateTab(Text, TargetText)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 72, 1, 0)
    Button.BackgroundColor3 = Colors.Button
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Text = Text
    Button.TextColor3 = Colors.Muted
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 9
    Button.Parent = TabBar
    AddCorner(Button, 8)
    Button.MouseEnter:Connect(function() Tween(Button, 0.1, {BackgroundColor3 = Colors.ButtonHover}) end)
    Button.MouseLeave:Connect(function() Tween(Button, 0.1, {BackgroundColor3 = Colors.Button}) end)
    Button.MouseButton1Click:Connect(function()
        local Section = SectionRefs[TargetText]
        if Section then
            Content.CanvasPosition = Vector2.new(0, math.max(0, Section.AbsolutePosition.Y - Content.AbsolutePosition.Y - 5))
        end
    end)
    return Button
end

local function CreateToggle(Name, Description, Callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 58)
    Button.BackgroundColor3 = Colors.Button
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Text = ""
    Button.Parent = Content
    AddCorner(Button, 10)

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Position = UDim2.fromOffset(15, 8)
    NameLabel.Size = UDim2.new(1, -85, 0, 22)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Name
    NameLabel.TextColor3 = Colors.Text
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Button

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Position = UDim2.fromOffset(15, 31)
    DescriptionLabel.Size = UDim2.new(1, -85, 0, 17)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Text = Description
    DescriptionLabel.TextColor3 = Colors.Muted
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextSize = 9
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.Parent = Button

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.fromOffset(38, 20)
    Indicator.Position = UDim2.new(1, -53, 0.5, -10)
    Indicator.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Button
    AddCorner(Indicator, 20)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.fromOffset(16, 16)
    Circle.Position = UDim2.fromOffset(2, 2)
    Circle.BackgroundColor3 = Color3.fromRGB(190, 190, 195)
    Circle.BorderSizePixel = 0
    Circle.Parent = Indicator
    AddCorner(Circle, 20)

    local Enabled = false

    local function Render(Value)
        Enabled = Value
        if Enabled then
            Button.BackgroundColor3 = Color3.fromRGB(38, 42, 40)
            Indicator.BackgroundColor3 = Colors.Green
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Tween(Circle, 0.12, {Position = UDim2.new(1, -18, 0, 2)})
        else
            Button.BackgroundColor3 = Colors.Button
            Indicator.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
            Circle.BackgroundColor3 = Color3.fromRGB(190, 190, 195)
            Tween(Circle, 0.12, {Position = UDim2.fromOffset(2, 2)})
        end
    end

    Button.MouseEnter:Connect(function()
        if not Enabled then
            Tween(Button, 0.1, {BackgroundColor3 = Colors.ButtonHover})
        end
    end)
    Button.MouseLeave:Connect(function()
        if not Enabled then
            Tween(Button, 0.1, {BackgroundColor3 = Colors.Button})
        end
    end)
    Button.MouseButton1Click:Connect(function()
        Render(not Enabled)
        Callback(Enabled)
    end)

    Button:SetAttribute("SetValue", false)
    Button:SetAttribute("GetValue", false)
    return Button
end

--==================================================
-- MOUSE / MENU STATE
--==================================================

local PreviousMouseBehavior = Enum.MouseBehavior.LockCenter
local PreviousMouseIcon = false

local function SetMenuState(Open)
    Settings.MenuOpen = Open
    Main.Visible = Open

    if Open then
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

--==================================================
-- DRAGGING
--==================================================

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- ESP
--==================================================

local IsEnemy

local ESPObjects = {}

local function RemoveESP(Player)
    if not ESPObjects[Player] then return end
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
    if Player == LocalPlayer or not Settings.ESP then return end
    local Character = Player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Head = Character:FindFirstChild("Head")
    if not Humanoid or not Head then return end

    RemoveESP(Player)
    local Objects = {}

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "MUKUS_ESP"
    Highlight.FillColor = IsEnemy(Player) and Color3.fromRGB(255, 55, 55) or Color3.fromRGB(55, 150, 255)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.65
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Parent = Character
    table.insert(Objects, Highlight)

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "MUKUS_ESPInfo"
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
        local TeamText = IsEnemy(Player) and (IsRussian() and "ВРАГ" or "ENEMY") or (IsRussian() and "СОЮЗНИК" or "ALLY")
        Label.Text = Player.Name .. "\n" .. TeamText .. " • HP: " .. HP .. " / " .. MaxHP
        Highlight.FillColor = IsEnemy(Player) and Color3.fromRGB(255, 55, 55) or Color3.fromRGB(55, 150, 255)
    end)
    table.insert(Objects, Connection)
    ESPObjects[Player] = Objects
end

--==================================================
-- ENEMY DETECTION - TEAM SAFE AIM
--==================================================

local function GetFaction(Player)
    local Keys = {"Faction", "Team", "Role", "Class", "Group", "Side", "Alignment"}
    for _, Key in ipairs(Keys) do
        local Value = Player:GetAttribute(Key)
        if Value ~= nil then
            return tostring(Value):lower()
        end
    end

    local Character = Player.Character
    if Character then
        for _, Key in ipairs(Keys) do
            local Value = Character:GetAttribute(Key)
            if Value ~= nil then
                return tostring(Value):lower()
            end
        end
    end
    return nil
end

IsEnemy = function(Player)
    if Player == LocalPlayer then
        return false
    end

    -- Primary Roblox Teams check.
    if LocalPlayer.Team ~= nil and Player.Team ~= nil then
        return Player.Team ~= LocalPlayer.Team
    end

    -- Secondary TeamColor check for games that don't assign Team objects consistently.
    if LocalPlayer.TeamColor ~= nil and Player.TeamColor ~= nil then
        if LocalPlayer.TeamColor == Player.TeamColor then
            return false
        end
        return true
    end

    -- Retrobreach/custom role systems may expose faction/role attributes.
    local MyFaction = GetFaction(LocalPlayer)
    local TheirFaction = GetFaction(Player)
    if MyFaction and TheirFaction then
        return MyFaction ~= TheirFaction
    end

    -- If the game exposes no reliable faction information, do NOT aim at the player.
    -- This prevents accidental lock-on to allies.
    return false
end

--==================================================
-- AIM TARGETING
--==================================================

local function IsVisible(TargetCharacter, TargetPart)
    local Origin = Camera.CFrame.Position
    local Direction = TargetPart.Position - Origin
    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {LocalPlayer.Character}

    local Result = workspace:Raycast(Origin, Direction, Params)
    if not Result then
        return true
    end
    return Result.Instance:IsDescendantOf(TargetCharacter)
end

local function GetClosestEnemy()
    local ClosestPlayer = nil
    local ClosestDistance = Settings.AimFOV
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, Player in ipairs(Players:GetPlayers()) do
        if IsEnemy(Player) then
            local Character = Player.Character
            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local Head = Character:FindFirstChild("Head")
                if Humanoid and Head and Humanoid.Health > 0 then
                    local ScreenPosition, Visible = Camera:WorldToViewportPoint(Head.Position)
                    if Visible and IsVisible(Character, Head) then
                        local Distance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - Center).Magnitude
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
-- FOV + CROSSHAIR
--==================================================

local FOV = Instance.new("Frame")
FOV.Size = UDim2.fromOffset(Settings.AimFOV * 2, Settings.AimFOV * 2)
FOV.AnchorPoint = Vector2.new(0.5, 0.5)
FOV.Position = UDim2.fromScale(0.5, 0.5)
FOV.BackgroundTransparency = 1
FOV.Visible = false
FOV.Parent = ScreenGui
AddCorner(FOV, 1000)
AddStroke(FOV, Colors.RedBright, 1, 0.35)

local Crosshair = Instance.new("Frame")
Crosshair.Size = UDim2.fromOffset(16, 16)
Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
Crosshair.Position = UDim2.fromScale(0.5, 0.5)
Crosshair.BackgroundTransparency = 1
Crosshair.Visible = Settings.Crosshair
Crosshair.Parent = ScreenGui

for _, Data in ipairs({
    {Size = UDim2.fromOffset(2, 16), Position = UDim2.fromOffset(7, 0)},
    {Size = UDim2.fromOffset(16, 2), Position = UDim2.fromOffset(0, 7)}
}) do
    local Line = Instance.new("Frame")
    Line.Size = Data.Size
    Line.Position = Data.Position
    Line.BackgroundColor3 = Colors.RedBright
    Line.BorderSizePixel = 0
    Line.Parent = Crosshair
end

--==================================================
-- FULLBRIGHT
--==================================================

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

local function SetFullbright(Value)
    Settings.Fullbright = Value
    if not Value then
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    end
end

--==================================================
-- TELEPORT SYSTEM
--==================================================

local TeleportAliases = {
    ["914"] = {"SCP-914", "SCP914", "914", "room914", "914Room", "Refiner"},
    ["classd"] = {"Class-D Cells", "ClassD", "Class-D", "Cells", "CellBlock", "ClassDCells", "Class D", "D-Class", "DClass"},
    ["gatea"] = {"Gate A", "GateA", "GATE_A", "gateaentrance", "Gate_A", "GateAEntrance"},
    ["armory"] = {"Armory", "Armoury", "Light Armory", "LightArmory", "Light Armoury", "WeaponRoom", "Weapons", "GunRoom", "SecurityArmory"}
}

local function NormalizeName(Text)
    return tostring(Text):lower():gsub("[^%w]", "")
end

local function FindTeleportTarget(Key)
    local Aliases = TeleportAliases[Key]
    if not Aliases then return nil end

    -- Exact child matches first.
    for _, Alias in ipairs(Aliases) do
        local Direct = workspace:FindFirstChild(Alias, true)
        if Direct and (Direct:IsA("BasePart") or Direct:IsA("Model") or Direct:IsA("Attachment")) then
            return Direct
        end
    end

    -- Normalized fallback for names such as SCP_173 / SCP 173.
    local NormalizedAliases = {}
    for _, Alias in ipairs(Aliases) do
        NormalizedAliases[NormalizeName(Alias)] = true
    end

    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("BasePart") or Object:IsA("Model") or Object:IsA("Attachment") then
            if NormalizedAliases[NormalizeName(Object.Name)] then
                return Object
            end
        end
    end

    return nil
end

local function GetTargetPosition(Target)
    if Target:IsA("Attachment") then
        return Target.WorldPosition
    elseif Target:IsA("BasePart") then
        return Target.Position
    elseif Target:IsA("Model") then
        return Target:GetPivot().Position
    end
end

local function FindSafeTeleportCFrame(Target)
    local BasePosition = GetTargetPosition(Target)
    if not BasePosition then return nil end

    -- Never drop the player inside a wall or below the map.
    -- Search a small ring around the landmark and raycast downward for floor.
    local Character = LocalPlayer.Character
    local Ignore = {Character}
    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = Ignore

    local Offsets = {
        Vector3.new(0, 8, 0), Vector3.new(5, 8, 0), Vector3.new(-5, 8, 0),
        Vector3.new(0, 8, 5), Vector3.new(0, 8, -5), Vector3.new(7, 8, 7),
        Vector3.new(-7, 8, 7), Vector3.new(7, 8, -7), Vector3.new(-7, 8, -7)
    }

    for _, Offset in ipairs(Offsets) do
        local Probe = BasePosition + Offset
        local Down = workspace:Raycast(Probe, Vector3.new(0, -30, 0), Params)
        if Down and Down.Instance and Down.Position.Y > workspace.FallenPartsDestroyHeight + 20 then
            local Floor = Down.Position + Vector3.new(0, 3.2, 0)
            local Forward = (BasePosition - Floor)
            Forward = Vector3.new(Forward.X, 0, Forward.Z)
            if Forward.Magnitude < 0.1 then Forward = Vector3.new(0, 0, -1) end
            Forward = Forward.Unit
            return CFrame.lookAt(Floor, Floor + Forward)
        end
    end

    -- Fallback: landmark position, but keep a safe vertical offset.
    return CFrame.new(BasePosition + Vector3.new(0, 5, 0))
end

local function TeleportTo(Key)
    local Target = FindTeleportTarget(Key)
    if not Target then
        return false, T("tpFail") .. Key .. " • " .. T("hidden")
    end

    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if not Character or not Root or not Humanoid then
        return false, T("tpFail") .. Key
    end

    local SafeCFrame = FindSafeTeleportCFrame(Target)
    if not SafeCFrame then
        return false, T("tpFail") .. Key
    end

    local OldAutoRotate = Humanoid.AutoRotate
    local OldVelocity = Root.AssemblyLinearVelocity
    local OldAngular = Root.AssemblyAngularVelocity

    Humanoid.AutoRotate = false
    Root.AssemblyLinearVelocity = Vector3.zero
    Root.AssemblyAngularVelocity = Vector3.zero

    -- Two short placement passes reduce the chance of spawning inside geometry.
    Character:PivotTo(SafeCFrame)
    task.wait()
    if Root.Parent then
        Root.AssemblyLinearVelocity = Vector3.zero
        Root.AssemblyAngularVelocity = Vector3.zero
        Character:PivotTo(SafeCFrame)
    end

    task.delay(0.15, function()
        if Humanoid.Parent then
            Humanoid.AutoRotate = OldAutoRotate
        end
    end)

    return true, T("tpOk") .. Key
end
--==================================================
-- SPEED CONTROL
--==================================================

local function ApplySpeed()
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = Settings.Speed and Settings.WalkSpeed or 16
    end
end

--==================================================
-- TELEPORT BUTTONS
--==================================================

--==================================================
-- COMMAND TERMINAL
--==================================================

CreateSection(T("terminal"))

local CommandFrame = Instance.new("Frame")
CommandFrame.Size = UDim2.new(1, 0, 0, 82)
CommandFrame.BackgroundColor3 = Colors.SCPBlack
CommandFrame.BorderSizePixel = 0
CommandFrame.Parent = Content
AddCorner(CommandFrame, 10)

local CommandTitle = Instance.new("TextLabel")
CommandTitle.Position = UDim2.fromOffset(15, 8)
CommandTitle.Size = UDim2.new(1, -30, 0, 18)
CommandTitle.BackgroundTransparency = 1
CommandTitle.Text = T("terminal")
CommandTitle.TextColor3 = Colors.Amber
CommandTitle.Font = Enum.Font.Code
CommandTitle.TextSize = 11
CommandTitle.TextXAlignment = Enum.TextXAlignment.Left
CommandTitle.Parent = CommandFrame

local CommandBox = Instance.new("TextBox")
CommandBox.Size = UDim2.new(1, -78, 0, 36)
CommandBox.Position = UDim2.fromOffset(15, 34)
CommandBox.BackgroundColor3 = Colors.Button
CommandBox.BorderSizePixel = 0
CommandBox.Text = ""
CommandBox.PlaceholderText = T("commandPlaceholder")
CommandBox.TextColor3 = Colors.Text
CommandBox.PlaceholderColor3 = Colors.Muted
CommandBox.Font = Enum.Font.Code
CommandBox.TextSize = 11
CommandBox.ClearTextOnFocus = false
CommandBox.Parent = CommandFrame
AddCorner(CommandBox, 7)

local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Size = UDim2.fromOffset(50, 36)
ExecuteButton.Position = UDim2.new(1, -57, 0, 34)
ExecuteButton.BackgroundColor3 = Colors.Red
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Text = T("execute")
ExecuteButton.TextColor3 = Colors.Text
ExecuteButton.Font = Enum.Font.Code
ExecuteButton.TextSize = 10
ExecuteButton.Parent = CommandFrame
AddCorner(ExecuteButton, 7)

--==================================================
-- PLAYER CONTROLS
--==================================================

CreateSection(T("player"))

CreateToggle(T("noclip"), T("noclipDesc"), function(Value)
    Settings.Noclip = Value
end)

CreateToggle(T("speed"), T("speedDesc"), function(Value)
    Settings.Speed = Value
    ApplySpeed()
end)

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, 0, 0, 65)
SpeedFrame.BackgroundColor3 = Colors.Panel2
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = Content
AddCorner(SpeedFrame, 10)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Position = UDim2.fromOffset(15, 9)
SpeedLabel.Size = UDim2.fromOffset(150, 20)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = T("speedValue")
SpeedLabel.TextColor3 = Colors.Text
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedHint = Instance.new("TextLabel")
SpeedHint.Position = UDim2.fromOffset(15, 31)
SpeedHint.Size = UDim2.fromOffset(150, 18)
SpeedHint.BackgroundTransparency = 1
SpeedHint.Text = T("speedHint")
SpeedHint.TextColor3 = Colors.Muted
SpeedHint.Font = Enum.Font.Gotham
SpeedHint.TextSize = 9
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
AddCorner(SpeedBox, 8)

local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.fromOffset(50, 38)
ApplyButton.Position = UDim2.new(1, -58, 0.5, -19)
ApplyButton.BackgroundColor3 = Colors.Red
ApplyButton.BorderSizePixel = 0
ApplyButton.Text = T("set")
ApplyButton.TextColor3 = Colors.Text
ApplyButton.Font = Enum.Font.GothamBold
ApplyButton.TextSize = 10
ApplyButton.Parent = SpeedFrame
AddCorner(ApplyButton, 8)

ApplyButton.MouseButton1Click:Connect(function()
    local Number = tonumber(SpeedBox.Text)
    if Number then
        Settings.WalkSpeed = math.clamp(Number, 1, 250)
        SpeedBox.Text = tostring(Settings.WalkSpeed)
        if Settings.Speed then ApplySpeed() end
    else
        SpeedBox.Text = tostring(Settings.WalkSpeed)
    end
end)

--==================================================
-- SURVEILLANCE / AIM
--==================================================

CreateSection(T("visual"))

CreateToggle(T("esp"), T("espDesc"), function(Value)
    Settings.ESP = Value
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            if Value then CreateESP(Player) else RemoveESP(Player) end
        end
    end
end)

CreateToggle(T("fullbright"), T("fullbrightDesc"), function(Value)
    SetFullbright(Value)
end)

CreateToggle(T("crosshair"), T("crosshairDesc"), function(Value)
    Settings.Crosshair = Value
    Crosshair.Visible = Value
end)

CreateSection(T("aim"))

CreateToggle(T("aimAssist"), T("aimDesc"), function(Value)
    Settings.AimAssist = Value
end)

--==================================================
-- TELEPORT UI
--==================================================

CreateSection(T("teleport"))

TeleportGridFrame = Instance.new("Frame")
TeleportGridFrame.Size = UDim2.new(1, 0, 0, 174)
TeleportGridFrame.BackgroundTransparency = 1
TeleportGridFrame.Parent = Content

TeleportGrid = Instance.new("UIGridLayout")
TeleportGrid.CellSize = UDim2.new(0.5, -4, 0, 38)
TeleportGrid.CellPadding = UDim2.fromOffset(8, 6)
TeleportGrid.SortOrder = Enum.SortOrder.LayoutOrder
TeleportGrid.Parent = TeleportGridFrame

local function CreateTeleportButton(Text, Key)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.5, -4, 0, 38)
    Button.BackgroundColor3 = Colors.Button
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 10
    Button.AutoButtonColor = false
    Button.Parent = TeleportGridFrame
    AddCorner(Button, 8)
    Button.MouseEnter:Connect(function() Tween(Button, 0.1, {BackgroundColor3 = Colors.ButtonHover}) end)
    Button.MouseLeave:Connect(function() Tween(Button, 0.1, {BackgroundColor3 = Colors.Button}) end)
    Button.MouseButton1Click:Connect(function()
        local Ok, Message = TeleportTo(Key)
        CommandBox.Text = Message
        Tween(Button, 0.08, {BackgroundColor3 = Ok and Colors.Green or Colors.Red})
        task.delay(0.18, function()
            if Button.Parent then Tween(Button, 0.12, {BackgroundColor3 = Colors.Button}) end
        end)
    end)
    return Button
end


CreateTeleportButton(T("tp914"), "914")
CreateTeleportButton(T("tpClassD"), "classd")
CreateTeleportButton(T("tpGateA"), "gatea")
CreateTeleportButton(T("tpArmory"), "armory")

--==================================================
-- NAVIGATION TABS
--==================================================

RefreshTabs = function()
    for _, Child in ipairs(TabBar:GetChildren()) do
        if Child:IsA("TextButton") then Child:Destroy() end
    end
    CreateTab(IsRU() and "ИГРОК" or "PLAYER", T("player"))
    CreateTab(IsRU() and "ВИЗУАЛ" or "VISUAL", T("visual"))
    CreateTab(IsRU() and "АИМ" or "AIM", T("aim"))
    CreateTab(IsRU() and "ТЕЛЕПОРТ" or "TP", T("teleport"))
    CreateTab(IsRU() and "ТЕРМИНАЛ" or "TERM", T("terminal"))
end

--==================================================
-- COMMANDS
--==================================================

local function NormalizeCommand(Text)
    Text = tostring(Text):lower()
    Text = Text:gsub("ё", "е")
    return Text
end

local function IsOn(Value)
    return Value == "on" or Value == "1" or Value == "true" or Value == "вкл" or Value == "включить"
end

local function IsOff(Value)
    return Value == "off" or Value == "0" or Value == "false" or Value == "выкл" or Value == "выключить"
end

local CommandAliases = {
    help = {"help", "commands", "cmd", "помощь", "команды", "справка"},
    status = {"status", "статус"},
    noclip = {"noclip", "ноклип", "ноуклип"},
    esp = {"esp", "есп"},
    aim = {"aim", "aimassist", "аим", "аимассист"},
    speed = {"speed", "скорость"},
    fov = {"fov", "фов"},
    fullbright = {"fullbright", "фуллбрайт", "свет"},
    crosshair = {"crosshair", "прицел"},
    tp = {"tp", "teleport", "телепорт", "тп"},
    reset = {"reset", "сброс", "респавн"},
    rejoin = {"rejoin", "перезаход", "перезайти", "реконнект"}
}

local function CanonicalCommand(Command)
    for Canonical, Aliases in pairs(CommandAliases) do
        for _, Alias in ipairs(Aliases) do
            if Command == Alias then
                return Canonical
            end
        end
    end
    return Command
end

local function SetFeature(Feature, Enabled)
    if Feature == "noclip" then
        Settings.Noclip = Enabled
    elseif Feature == "esp" then
        Settings.ESP = Enabled
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                if Enabled then CreateESP(Player) else RemoveESP(Player) end
            end
        end
    elseif Feature == "aim" then
        Settings.AimAssist = Enabled
    elseif Feature == "speed" then
        Settings.Speed = Enabled
        ApplySpeed()
    elseif Feature == "fullbright" then
        SetFullbright(Enabled)
    elseif Feature == "crosshair" then
        Settings.Crosshair = Enabled
        Crosshair.Visible = Enabled
    end
end

local function ExecuteCommand(Raw)
    -- Both Russian and English command aliases are accepted; the selected language controls displayed help/text.
    local Parts = string.split(NormalizeCommand(Raw), " ")
    local Command = CanonicalCommand(Parts[1] or "")
    local Value = Parts[2]

    if Command == "" then
        return
    elseif Command == "help" then
        CommandBox.Text = T("help")
    elseif Command == "status" then
        CommandBox.Text = string.format(T("status"), tostring(Settings.Noclip), tostring(Settings.ESP), tostring(Settings.AimAssist), tostring(Settings.Speed), tostring(Settings.Fullbright))
    elseif Command == "reset" then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid.Health = 0 end
        CommandBox.Text = T("reset")
    elseif Command == "rejoin" then
        CommandBox.Text = T("rejoin")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    elseif Command == "fov" then
        local Number = tonumber(Value)
        if Number then
            Settings.CameraFOV = math.clamp(Number, 40, 120)
            Camera.FieldOfView = Settings.CameraFOV
            CommandBox.Text = T("fovSet") .. Settings.CameraFOV
        else
            CommandBox.Text = T("fovUsage")
        end
    elseif Command == "speed" and tonumber(Value) then
        Settings.WalkSpeed = math.clamp(tonumber(Value), 1, 250)
        Settings.Speed = true
        SpeedBox.Text = tostring(Settings.WalkSpeed)
        ApplySpeed()
        CommandBox.Text = T("speedSet") .. Settings.WalkSpeed
    elseif Command == "tp" then
        if not Value then
            CommandBox.Text = T("tpUsage")
            return
        end
        local Key = NormalizeCommand(Value)
        local TPMap = {
            ["914"] = "914", ["classd"] = "classd", ["классд"] = "classd", ["class-d"] = "classd",
            ["gatea"] = "gatea", ["воротаа"] = "gatea", ["gate-a"] = "gatea",
            ["armory"] = "armory", ["armoury"] = "armory", ["оружейная"] = "armory", ["оружейка"] = "armory"
        }
        local TeleportKey = TPMap[Key]
        if not TeleportKey then
            CommandBox.Text = T("tpUsage")
            return
        end
        local _, Message = TeleportTo(TeleportKey)
        CommandBox.Text = Message
    else
        if IsOn(Value) or IsOff(Value) then
            SetFeature(Command, IsOn(Value))
            CommandBox.Text = string.upper(Command) .. " " .. string.upper(Value)
        else
            CommandBox.Text = T("unknown")
        end
    end
end

ExecuteButton.MouseButton1Click:Connect(function()
    ExecuteCommand(CommandBox.Text)
end)

CommandBox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        ExecuteCommand(CommandBox.Text)
    end
end)

--==================================================
-- RESPAWN / PLAYERS
--==================================================

LocalPlayer.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    task.wait(0.2)
    if Settings.Speed then Humanoid.WalkSpeed = Settings.WalkSpeed end
end)

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Settings.ESP then CreateESP(Player) end
    end)
end)

Players.PlayerRemoving:Connect(function(Player)
    RemoveESP(Player)
end)

for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        Player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Settings.ESP then CreateESP(Player) end
        end)
    end
end

--==================================================
-- MAIN LOOP
--==================================================

RunService.RenderStepped:Connect(function()
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

    if Settings.Speed then
        ApplySpeed()
    end

    FOV.Visible = Settings.AimAssist and not Settings.MenuOpen
    Crosshair.Visible = Settings.Crosshair

    if Settings.Fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end

    if Settings.AimAssist and not Settings.MenuOpen and Aiming then
        local Target = GetClosestEnemy()
        if Target and Target.Character then
            local Head = Target.Character:FindFirstChild("Head")
            if Head then
                local TargetCFrame = CFrame.lookAt(Camera.CFrame.Position, Head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, Settings.AimSmoothness)
            end
        end
    end
end)

--==================================================
-- AIM INPUT
--==================================================

Aiming = false

UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
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
-- F4
--==================================================

UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then return end
    if Input.KeyCode == Enum.KeyCode.F4 and Settings.Language then
        SetMenuState(not Settings.MenuOpen)
    end
end)

--==================================================
-- LANGUAGE APPLY
--==================================================

local function ApplyLanguage()
    Title.Text = T("title")
    Subtitle.Text = T("subtitle")
    CommandTitle.Text = T("terminal")
    CommandBox.PlaceholderText = T("commandPlaceholder")
    ExecuteButton.Text = T("execute")
    SpeedLabel.Text = T("speedValue")
    SpeedHint.Text = T("speedHint")
    ApplyButton.Text = T("set")

    -- Controls are created before the language is selected. Translate them by
    -- matching their initial English text against the localization table.
    local Reverse = {}
    for Key, Value in pairs(Lang.en) do
        if type(Value) == "string" then
            Reverse[Value] = Key
        end
    end

    for _, Object in ipairs(Content:GetDescendants()) do
        if Object:IsA("TextLabel") or Object:IsA("TextButton") then
            local Key = Object:GetAttribute("LangKey")
            if Key then
                Object.Text = T(Key)
            else
                local FoundKey = Reverse[Object.Text]
                if FoundKey then
                    Object.Text = T(FoundKey)
                end
            end
        end
    end
end

-- Mark static labels with language keys.
-- The controls were created with localized text already; the selector is shown only once,
-- so rebuilding the whole panel is unnecessary for the initial language choice.

local function FinishLanguageSelection(Code)
    Settings.Language = Code
    ApplyLanguage()

    Tween(LanguageCard, 0.18, {Size = UDim2.fromOffset(260, 170), BackgroundTransparency = 0.05})
    task.wait(0.12)
    Tween(LanguageOverlay, 0.25, {BackgroundTransparency = 1})
    Tween(LanguageCard, 0.25, {Position = UDim2.fromScale(0.5, 0.54)})
    task.wait(0.25)
    LanguageOverlay.Visible = false

    Main.Position = UDim2.new(0, 35, 0.5, -300)
    Main.Visible = true
    Main.BackgroundTransparency = 1
    Tween(Main, 0.3, {BackgroundTransparency = 0})
    task.wait(0.3)
    SetMenuState(true)
end

RussianButton.MouseButton1Click:Connect(function()
    FinishLanguageSelection("ru")
end)

EnglishButton.MouseButton1Click:Connect(function()
    FinishLanguageSelection("en")
end)

--==================================================
-- STARTUP ANIMATION
--==================================================

LanguageOverlay.Visible = true
Tween(LanguageOverlay, 0.25, {BackgroundTransparency = 0.22})
LanguageCard.Size = UDim2.fromOffset(270, 180)
LanguageCard.BackgroundTransparency = 0.08
Tween(LanguageCard, 0.35, {Size = UDim2.fromOffset(310, 205), BackgroundTransparency = 0})

--==================================================
-- END
--==================================================
