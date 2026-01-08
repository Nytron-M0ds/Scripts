--[[
    NYTRON MODS - Steal a Brainrot V3
    UI Compacta | Checkbox | Sem Emoji | Logo Custom
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Config
local NYTRON = {
    Key = "NYTRON-INFINITO",
    LogoID = "rbxassetid://123456789", -- Placeholder, usaremos decal
    
    Settings = {
        ESP_XRay = false,
        ESP_Names = false,
        ESP_Distance = false,
        ESP_Tracers = false,
        ESP_Self = false,
        Speed_Run = false,
        Speed_Jump = false,
        Speed_Both = false,
        SpeedValue = 50,
        JumpValue = 120,
    },
    
    Colors = {
        Green = Color3.fromRGB(0, 255, 100),
        GreenDark = Color3.fromRGB(0, 200, 80),
        Dark = Color3.fromRGB(18, 18, 22),
        Card = Color3.fromRGB(25, 25, 30),
        CardLight = Color3.fromRGB(35, 35, 42),
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(140, 140, 140),
        GrayDark = Color3.fromRGB(80, 80, 80),
        Red = Color3.fromRGB(255, 80, 80),
    }
}

-- Limpar GUI anterior
if CoreGui:FindFirstChild("NYTRON") then
    CoreGui:FindFirstChild("NYTRON"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NYTRON_ESP"
ESPFolder.Parent = CoreGui

-- Funções auxiliares
local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quart), props):Play()
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
end

local function Stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or NYTRON.Colors.Green
    s.Thickness = thick or 1
    s.Parent = parent
end

-- ============================================
-- NOTIFICAÇÃO SIMPLES
-- ============================================
local function Notify(text, color)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 250, 0, 45)
    n.Position = UDim2.new(0.5, -125, 0, -50)
    n.BackgroundColor3 = NYTRON.Colors.Card
    n.Parent = ScreenGui
    Corner(n, 8)
    Stroke(n, color or NYTRON.Colors.Green, 2)
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -16, 1, 0)
    t.Position = UDim2.new(0, 8, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color or NYTRON.Colors.Green
    t.TextSize = 14
    t.Font = Enum.Font.GothamMedium
    t.Parent = n
    
    Tween(n, {Position = UDim2.new(0.5, -125, 0, 15)}, 0.4)
    task.delay(2.5, function()
        Tween(n, {Position = UDim2.new(0.5, -125, 0, -50)}, 0.4)
        task.wait(0.4)
        n:Destroy()
    end)
end

-- ============================================
-- TELA DE LOGIN
-- ============================================
local LoginFrame = Instance.new("Frame")
LoginFrame.Name = "Login"
LoginFrame.Size = UDim2.new(1, 0, 1, 0)
LoginFrame.BackgroundColor3 = NYTRON.Colors.Dark
LoginFrame.Parent = ScreenGui

local LoginCard = Instance.new("Frame")
LoginCard.Size = UDim2.new(0, 280, 0, 220)
LoginCard.Position = UDim2.new(0.5, -140, 0.5, -110)
LoginCard.BackgroundColor3 = NYTRON.Colors.Card
LoginCard.Parent = LoginFrame
Corner(LoginCard, 12)
Stroke(LoginCard, NYTRON.Colors.Green, 2)

-- Cadeado
local Lock = Instance.new("TextLabel")
Lock.Size = UDim2.new(1, 0, 0, 50)
Lock.Position = UDim2.new(0, 0, 0, 20)
Lock.BackgroundTransparency = 1
Lock.Text = "🔒"
Lock.TextSize = 40
Lock.Parent = LoginCard

-- Titulo
local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, 0, 0, 25)
LoginTitle.Position = UDim2.new(0, 0, 0, 75)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "NYTRON MODS"
LoginTitle.TextColor3 = NYTRON.Colors.Green
LoginTitle.TextSize = 18
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.Parent = LoginCard

-- Input
local InputBox = Instance.new("Frame")
InputBox.Size = UDim2.new(0, 240, 0, 40)
InputBox.Position = UDim2.new(0.5, -120, 0, 115)
InputBox.BackgroundColor3 = NYTRON.Colors.Dark
InputBox.Parent = LoginCard
Corner(InputBox, 8)

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -16, 1, 0)
KeyInput.Position = UDim2.new(0, 8, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Key aqui"
KeyInput.PlaceholderColor3 = NYTRON.Colors.GrayDark
KeyInput.TextColor3 = NYTRON.Colors.White
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = InputBox

-- Botão Login
local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(0, 240, 0, 38)
LoginBtn.Position = UDim2.new(0.5, -120, 0, 165)
LoginBtn.BackgroundColor3 = NYTRON.Colors.Green
LoginBtn.Text = "ENTRAR"
LoginBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
LoginBtn.TextSize = 14
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.Parent = LoginCard
Corner(LoginBtn, 8)

-- ============================================
-- BOTÃO FLUTUANTE COM LOGO
-- ============================================
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Name = "Float"
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 12, 0.5, -25)
FloatBtn.BackgroundColor3 = NYTRON.Colors.Card
FloatBtn.Visible = false
FloatBtn.Image = "rbxassetid://0" -- Placeholder
FloatBtn.Parent = ScreenGui
Corner(FloatBtn, 25)
Stroke(FloatBtn, NYTRON.Colors.Green, 2)

-- Logo N como fallback
local LogoN = Instance.new("TextLabel")
LogoN.Size = UDim2.new(1, 0, 1, 0)
LogoN.BackgroundTransparency = 1
LogoN.Text = "N"
LogoN.TextColor3 = NYTRON.Colors.Green
LogoN.TextSize = 24
LogoN.Font = Enum.Font.GothamBlack
LogoN.Parent = FloatBtn

-- Draggable
local dragging, dragStart, startPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatBtn.Position
    end
end)
FloatBtn.InputEnded:Connect(function(input)
    dragging = false
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        FloatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============================================
-- PAINEL PRINCIPAL COMPACTO
-- ============================================
local MainPanel = Instance.new("Frame")
MainPanel.Name = "Panel"
MainPanel.Size = UDim2.new(0, 320, 0, 300)
MainPanel.Position = UDim2.new(0.5, -160, 0.5, -150)
MainPanel.BackgroundColor3 = NYTRON.Colors.Dark
MainPanel.Visible = false
MainPanel.Parent = ScreenGui
Corner(MainPanel, 10)
Stroke(MainPanel, NYTRON.Colors.Green, 2)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = NYTRON.Colors.Card
Header.Parent = MainPanel
Corner(Header, 10)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 15)
HeaderFix.Position = UDim2.new(0, 0, 1, -15)
HeaderFix.BackgroundColor3 = NYTRON.Colors.Card
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NYTRON - Steal a Brainrot"
Title.TextColor3 = NYTRON.Colors.Green
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = NYTRON.Colors.CardLight
CloseBtn.Text = "X"
CloseBtn.TextColor3 = NYTRON.Colors.Gray
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
Corner(CloseBtn, 6)

-- Tabs Container
local TabsBar = Instance.new("Frame")
TabsBar.Size = UDim2.new(1, -16, 0, 32)
TabsBar.Position = UDim2.new(0, 8, 0, 48)
TabsBar.BackgroundColor3 = NYTRON.Colors.Card
TabsBar.Parent = MainPanel
Corner(TabsBar, 6)

-- Content Container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -95)
Content.Position = UDim2.new(0, 8, 0, 88)
Content.BackgroundColor3 = NYTRON.Colors.Card
Content.ClipsDescendants = true
Content.Parent = MainPanel
Corner(Content, 8)

-- ============================================
-- SISTEMA DE ABAS
-- ============================================
local Tabs = {}
local TabContents = {}
local CurrentTab = nil

local function CreateTabButton(name, index, total)
    local width = 1 / total
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(width, -4, 1, -6)
    btn.Position = UDim2.new(width * (index - 1), 2, 0, 3)
    btn.BackgroundColor3 = NYTRON.Colors.CardLight
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = NYTRON.Colors.Gray
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = TabsBar
    Corner(btn, 5)
    
    Tabs[name] = btn
    return btn
end

local function CreateTabContent(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = name
    scroll.Size = UDim2.new(1, -12, 1, -12)
    scroll.Position = UDim2.new(0, 6, 0, 6)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = NYTRON.Colors.Green
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = false
    scroll.Parent = Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
    end)
    
    TabContents[name] = scroll
    return scroll
end

local function SwitchTab(name)
    for n, btn in pairs(Tabs) do
        if n == name then
            btn.BackgroundTransparency = 0
            btn.BackgroundColor3 = NYTRON.Colors.Green
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            TabContents[n].Visible = true
        else
            btn.BackgroundTransparency = 1
            btn.TextColor3 = NYTRON.Colors.Gray
            TabContents[n].Visible = false
        end
    end
    CurrentTab = name
end

-- Criar abas
CreateTabButton("ESP", 1, 4)
CreateTabButton("Speed", 2, 4)
CreateTabButton("TP", 3, 4)
CreateTabButton("Config", 4, 4)

CreateTabContent("ESP")
CreateTabContent("Speed")
CreateTabContent("TP")
CreateTabContent("Config")

for name, btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

SwitchTab("ESP")

-- ============================================
-- CRIAR CHECKBOX
-- ============================================
local function CreateCheckbox(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = NYTRON.Colors.CardLight
    frame.Parent = parent
    Corner(frame, 6)
    
    local check = Instance.new("Frame")
    check.Size = UDim2.new(0, 18, 0, 18)
    check.Position = UDim2.new(0, 10, 0.5, -9)
    check.BackgroundColor3 = NYTRON.Colors.Dark
    check.Parent = frame
    Corner(check, 4)
    Stroke(check, NYTRON.Colors.GrayDark, 1)
    
    local checkMark = Instance.new("TextLabel")
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.BackgroundTransparency = 1
    checkMark.Text = ""
    checkMark.TextColor3 = NYTRON.Colors.Green
    checkMark.TextSize = 14
    checkMark.Font = Enum.Font.GothamBold
    checkMark.Parent = check
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 38, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = NYTRON.Colors.White
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local checked = default or false
    
    local function Update()
        if checked then
            check.BackgroundColor3 = NYTRON.Colors.Green
            checkMark.Text = "✓"
            checkMark.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            check.BackgroundColor3 = NYTRON.Colors.Dark
            checkMark.Text = ""
        end
    end
    
    Update()
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            checked = not checked
            Update()
            if callback then callback(checked) end
        end
    end)
    
    return frame
end

-- ============================================
-- CRIAR BOTÃO
-- ============================================
local function CreateBtn(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = NYTRON.Colors.CardLight
    btn.Text = text
    btn.TextColor3 = NYTRON.Colors.White
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = parent
    Corner(btn, 6)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = NYTRON.Colors.Green, TextColor3 = Color3.fromRGB(0,0,0)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = NYTRON.Colors.CardLight, TextColor3 = NYTRON.Colors.White}, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return btn
end

-- ============================================
-- FUNÇÕES ESP
-- ============================================
local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

local function CreateSelfLaser()
    if not Character or not HumanoidRootPart then return end
    
    -- Encontrar base/spawn
    local basePos = Vector3.new(0, 5, 0)
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn") or Workspace:FindFirstChild("Base")
    if spawn and spawn:IsA("BasePart") then
        basePos = spawn.Position
    end
    
    -- Criar parte invisível na base
    local basePart = Instance.new("Part")
    basePart.Name = "NYTRON_Base"
    basePart.Size = Vector3.new(1, 1, 1)
    basePart.Position = basePos
    basePart.Anchored = true
    basePart.CanCollide = false
    basePart.Transparency = 1
    basePart.Parent = ESPFolder
    
    -- Attachments
    local att0 = Instance.new("Attachment")
    att0.Parent = HumanoidRootPart
    
    local att1 = Instance.new("Attachment")
    att1.Parent = basePart
    
    -- LASER VERDE FORTE
    local beam = Instance.new("Beam")
    beam.Name = "SelfLaser"
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(NYTRON.Colors.Green)
    beam.Width0 = 2
    beam.Width1 = 2
    beam.FaceCamera = true
    beam.Brightness = 3
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Transparency = NumberSequence.new(0)
    beam.Parent = ESPFolder
    
    -- Highlight em mim
    local hl = Instance.new("Highlight")
    hl.Name = "SelfHighlight"
    hl.Adornee = Character
    hl.FillColor = NYTRON.Colors.Green
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = ESPFolder
end

local function CreateTargetESP(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.HumanoidRootPart
    
    if NYTRON.Settings.ESP_XRay then
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_" .. target.Name
        hl.Adornee = target
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = NYTRON.Colors.Green
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = ESPFolder
    end
    
    if NYTRON.Settings.ESP_Names or NYTRON.Settings.ESP_Distance then
        local bb = Instance.new("BillboardGui")
        bb.Name = "BB_" .. target.Name
        bb.Adornee = hrp
        bb.Size = UDim2.new(0, 100, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = ESPFolder
        
        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, 0, 0.5, 0)
        nameL.BackgroundTransparency = 1
        nameL.Text = NYTRON.Settings.ESP_Names and target.Name or ""
        nameL.TextColor3 = NYTRON.Colors.Green
        nameL.TextSize = 13
        nameL.Font = Enum.Font.GothamBold
        nameL.TextStrokeTransparency = 0.5
        nameL.Parent = bb
        
        local distL = Instance.new("TextLabel")
        distL.Name = "Dist"
        distL.Size = UDim2.new(1, 0, 0.5, 0)
        distL.Position = UDim2.new(0, 0, 0.5, 0)
        distL.BackgroundTransparency = 1
        distL.TextColor3 = NYTRON.Colors.White
        distL.TextSize = 11
        distL.Font = Enum.Font.Gotham
        distL.TextStrokeTransparency = 0.5
        distL.Parent = bb
        
        if NYTRON.Settings.ESP_Distance then
            task.spawn(function()
                while bb and bb.Parent and HumanoidRootPart and hrp do
                    local d = math.floor((HumanoidRootPart.Position - hrp.Position).Magnitude)
                    distL.Text = d .. "m"
                    task.wait(0.3)
                end
            end)
        end
    end
    
    if NYTRON.Settings.ESP_Tracers and HumanoidRootPart then
        local att0 = Instance.new("Attachment")
        att0.Parent = HumanoidRootPart
        
        local att1 = Instance.new("Attachment")
        att1.Parent = hrp
        
        local beam = Instance.new("Beam")
        beam.Attachment0 = att0
        beam.Attachment1 = att1
        beam.Color = ColorSequence.new(NYTRON.Colors.Green)
        beam.Width0 = 0.15
        beam.Width1 = 0.15
        beam.FaceCamera = true
        beam.Transparency = NumberSequence.new(0.3)
        beam.Parent = ESPFolder
    end
end

local function UpdateESP()
    ClearESP()
    
    if NYTRON.Settings.ESP_Self then
        CreateSelfLaser()
    end
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
            CreateTargetESP(v)
        end
    end
end

-- ============================================
-- FUNÇÕES SPEED
-- ============================================
local function UpdateSpeed()
    if not Character then return end
    local hum = Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if NYTRON.Settings.Speed_Both then
        hum.WalkSpeed = NYTRON.Settings.SpeedValue
        hum.JumpPower = NYTRON.Settings.JumpValue
    elseif NYTRON.Settings.Speed_Run then
        hum.WalkSpeed = NYTRON.Settings.SpeedValue
    elseif NYTRON.Settings.Speed_Jump then
        hum.JumpPower = NYTRON.Settings.JumpValue
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end

-- ============================================
-- FUNÇÕES TELEPORT
-- ============================================
local function GetTargets()
    local t = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
            table.insert(t, v)
        end
    end
    return t
end

local function TPBase()
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn") or Workspace:FindFirstChild("Base")
    if spawn and spawn:IsA("BasePart") and HumanoidRootPart then
        HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        Notify("Teleportado para Base")
    elseif HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Notify("Teleportado para Spawn")
    end
end

local function TPRandom()
    local targets = GetTargets()
    if #targets > 0 and HumanoidRootPart then
        local t = targets[math.random(#targets)]
        if t:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = t.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            Notify("TP: " .. t.Name)
        end
    else
        Notify("Sem alvos", NYTRON.Colors.Red)
    end
end

local function TPNearest()
    local targets = GetTargets()
    local nearest, dist = nil, math.huge
    for _, t in pairs(targets) do
        if t:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            local d = (t.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = t
            end
        end
    end
    if nearest and HumanoidRootPart then
        HumanoidRootPart.CFrame = nearest.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        Notify("TP: " .. nearest.Name)
    else
        Notify("Sem alvos", NYTRON.Colors.Red)
    end
end

-- ============================================
-- RESPAWN
-- ============================================
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    UpdateSpeed()
    UpdateESP()
end)

-- ============================================
-- POPULAR ABAS
-- ============================================

-- ESP
CreateCheckbox(TabContents["ESP"], "ESP X-Ray", false, function(v)
    NYTRON.Settings.ESP_XRay = v
    UpdateESP()
end)
CreateCheckbox(TabContents["ESP"], "ESP Nomes", false, function(v)
    NYTRON.Settings.ESP_Names = v
    UpdateESP()
end)
CreateCheckbox(TabContents["ESP"], "ESP Distancia", false, function(v)
    NYTRON.Settings.ESP_Distance = v
    UpdateESP()
end)
CreateCheckbox(TabContents["ESP"], "ESP Tracers", false, function(v)
    NYTRON.Settings.ESP_Tracers = v
    UpdateESP()
end)
CreateCheckbox(TabContents["ESP"], "Laser em Mim (ate Base)", false, function(v)
    NYTRON.Settings.ESP_Self = v
    UpdateESP()
end)
CreateBtn(TabContents["ESP"], "Atualizar ESP", UpdateESP)

-- Speed
CreateCheckbox(TabContents["Speed"], "Correr + Pular", false, function(v)
    NYTRON.Settings.Speed_Both = v
    if v then
        NYTRON.Settings.Speed_Run = false
        NYTRON.Settings.Speed_Jump = false
    end
    UpdateSpeed()
end)
CreateCheckbox(TabContents["Speed"], "Correr Rapido", false, function(v)
    NYTRON.Settings.Speed_Run = v
    UpdateSpeed()
end)
CreateCheckbox(TabContents["Speed"], "Pular Alto", false, function(v)
    NYTRON.Settings.Speed_Jump = v
    UpdateSpeed()
end)
CreateBtn(TabContents["Speed"], "Resetar Speed", function()
    NYTRON.Settings.Speed_Both = false
    NYTRON.Settings.Speed_Run = false
    NYTRON.Settings.Speed_Jump = false
    UpdateSpeed()
    Notify("Speed resetado")
end)

-- TP
CreateBtn(TabContents["TP"], "Teleport Base", TPBase)
CreateBtn(TabContents["TP"], "Teleport Aleatorio", TPRandom)
CreateBtn(TabContents["TP"], "Teleport Mais Proximo", TPNearest)

-- Config
CreateBtn(TabContents["Config"], "Limpar ESP", ClearESP)
CreateBtn(TabContents["Config"], "Destruir Script", function()
    ScreenGui:Destroy()
    ESPFolder:Destroy()
end)

-- ============================================
-- EVENTOS
-- ============================================

LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == NYTRON.Key then
        Notify("Logado com sucesso!")
        task.wait(1)
        LoginFrame.Visible = false
        FloatBtn.Visible = true
    else
        Notify("Key invalida!", NYTRON.Colors.Red)
        KeyInput.Text = ""
    end
end)

FloatBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
end)

-- Loop ESP
task.spawn(function()
    while task.wait(3) do
        if NYTRON.Settings.ESP_XRay or NYTRON.Settings.ESP_Names or NYTRON.Settings.ESP_Distance or NYTRON.Settings.ESP_Tracers or NYTRON.Settings.ESP_Self then
            UpdateESP()
        end
    end
end)

print("[NYTRON] Script V3 carregado!")
print("[NYTRON] Key: NYTRON-INFINITO")
