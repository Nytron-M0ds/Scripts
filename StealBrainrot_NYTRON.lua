--[[
    ███╗   ██╗██╗   ██╗████████╗██████╗  ██████╗ ███╗   ██╗
    ████╗  ██║╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔═══██╗████╗  ██║
    ██╔██╗ ██║ ╚████╔╝    ██║   ██████╔╝██║   ██║██╔██╗ ██║
    ██║╚██╗██║  ╚██╔╝     ██║   ██╔══██╗██║   ██║██║╚██╗██║
    ██║ ╚████║   ██║      ██║   ██║  ██║╚██████╔╝██║ ╚████║
    ╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    
    NYTRON MODS - Steal a Brainrot Script
    100% Funcional | UI Profissional
]]

-- Services
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

-- Configurações
local NYTRON = {
    ValidKeys = {
        ["KEY-NYTRON-7DIAS-TESTE"] = true,
        ["KEY-NYTRON-1DIA-ADMIN"] = true,
        ["KEY-NYTRON-30DIAS-VIP"] = true,
    },
    Settings = {
        ESP_XRay = false,
        ESP_Lines = false,
        ESP_Self = false,
        Speed_Run = false,
        Speed_Jump = false,
        Speed_Both = false,
        TP_Enabled = false,
    },
    Colors = {
        Primary = Color3.fromRGB(0, 255, 100),
        Secondary = Color3.fromRGB(20, 20, 20),
        Background = Color3.fromRGB(15, 15, 15),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 200, 80),
    }
}

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_StealBrainrot"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tentar colocar no CoreGui (mais seguro)
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- ============================================
-- TELA DE LOADING INICIAL
-- ============================================
local function CreateLoadingScreen()
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingScreen"
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = NYTRON.Colors.Background
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = ScreenGui
    
    -- Logo NYTRON
    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 400, 0, 80)
    Logo.Position = UDim2.new(0.5, -200, 0.35, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "NYTRON"
    Logo.TextColor3 = NYTRON.Colors.Primary
    Logo.TextSize = 60
    Logo.Font = Enum.Font.GothamBold
    Logo.Parent = LoadingFrame
    
    -- Subtitulo
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(0, 400, 0, 30)
    SubTitle.Position = UDim2.new(0.5, -200, 0.45, 0)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Steal a Brainrot"
    SubTitle.TextColor3 = NYTRON.Colors.Text
    SubTitle.TextSize = 24
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Parent = LoadingFrame
    
    -- Barra de loading
    local LoadingBarBG = Instance.new("Frame")
    LoadingBarBG.Name = "LoadingBarBG"
    LoadingBarBG.Size = UDim2.new(0, 300, 0, 8)
    LoadingBarBG.Position = UDim2.new(0.5, -150, 0.55, 0)
    LoadingBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LoadingBarBG.BorderSizePixel = 0
    LoadingBarBG.Parent = LoadingFrame
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(0, 4)
    LoadingBarCorner.Parent = LoadingBarBG
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = NYTRON.Colors.Primary
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = LoadingBarBG
    
    local LoadingBarCorner2 = Instance.new("UICorner")
    LoadingBarCorner2.CornerRadius = UDim.new(0, 4)
    LoadingBarCorner2.Parent = LoadingBar
    
    -- Texto de loading
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(0, 300, 0, 25)
    LoadingText.Position = UDim2.new(0.5, -150, 0.58, 10)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Carregando..."
    LoadingText.TextColor3 = NYTRON.Colors.Text
    LoadingText.TextSize = 14
    LoadingText.Font = Enum.Font.Gotham
    LoadingText.Parent = LoadingFrame
    
    return LoadingFrame, LoadingBar, LoadingText
end

-- ============================================
-- TELA DE LOGIN (KEY SYSTEM)
-- ============================================
local function CreateLoginScreen()
    local LoginFrame = Instance.new("Frame")
    LoginFrame.Name = "LoginScreen"
    LoginFrame.Size = UDim2.new(1, 0, 1, 0)
    LoginFrame.BackgroundColor3 = NYTRON.Colors.Background
    LoginFrame.BorderSizePixel = 0
    LoginFrame.Visible = false
    LoginFrame.Parent = ScreenGui
    
    -- Container central
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0, 350, 0, 250)
    Container.Position = UDim2.new(0.5, -175, 0.5, -125)
    Container.BackgroundColor3 = NYTRON.Colors.Secondary
    Container.BorderSizePixel = 0
    Container.Parent = LoginFrame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 12)
    ContainerCorner.Parent = Container
    
    -- Borda verde
    local ContainerStroke = Instance.new("UIStroke")
    ContainerStroke.Color = NYTRON.Colors.Primary
    ContainerStroke.Thickness = 2
    ContainerStroke.Parent = Container
    
    -- Titulo
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 NYTRON LOGIN"
    Title.TextColor3 = NYTRON.Colors.Primary
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Container
    
    -- Input da Key
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(0, 280, 0, 45)
    KeyInput.Position = UDim2.new(0.5, -140, 0, 90)
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyInput.BorderSizePixel = 0
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Coloque sua Key aqui..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    KeyInput.TextColor3 = NYTRON.Colors.Text
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Container
    
    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 8)
    KeyInputCorner.Parent = KeyInput
    
    -- Botão Login
    local LoginButton = Instance.new("TextButton")
    LoginButton.Name = "LoginButton"
    LoginButton.Size = UDim2.new(0, 280, 0, 45)
    LoginButton.Position = UDim2.new(0.5, -140, 0, 150)
    LoginButton.BackgroundColor3 = NYTRON.Colors.Primary
    LoginButton.BorderSizePixel = 0
    LoginButton.Text = "🚀 LOGIN"
    LoginButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    LoginButton.TextSize = 18
    LoginButton.Font = Enum.Font.GothamBold
    LoginButton.Parent = Container
    
    local LoginButtonCorner = Instance.new("UICorner")
    LoginButtonCorner.CornerRadius = UDim.new(0, 8)
    LoginButtonCorner.Parent = LoginButton
    
    -- Texto de info
    local InfoText = Instance.new("TextLabel")
    InfoText.Name = "InfoText"
    InfoText.Size = UDim2.new(1, 0, 0, 20)
    InfoText.Position = UDim2.new(0, 0, 1, -30)
    InfoText.BackgroundTransparency = 1
    InfoText.Text = "NYTRON MODS © 2025"
    InfoText.TextColor3 = Color3.fromRGB(80, 80, 80)
    InfoText.TextSize = 12
    InfoText.Font = Enum.Font.Gotham
    InfoText.Parent = Container
    
    return LoginFrame, KeyInput, LoginButton
end

-- ============================================
-- NOTIFICAÇÃO FLUTUANTE
-- ============================================
local function ShowNotification(message, color, duration)
    duration = duration or 3
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Size = UDim2.new(0, 300, 0, 50)
    NotifFrame.Position = UDim2.new(0.5, -150, 0, -60)
    NotifFrame.BackgroundColor3 = NYTRON.Colors.Secondary
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotifFrame
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = color or NYTRON.Colors.Primary
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = message
    NotifText.TextColor3 = color or NYTRON.Colors.Primary
    NotifText.TextSize = 16
    NotifText.Font = Enum.Font.GothamBold
    NotifText.Parent = NotifFrame
    
    -- Animação de entrada
    local tweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0, 20)
    })
    tweenIn:Play()
    
    -- Animação de saída
    task.delay(duration, function()
        local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -150, 0, -60)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- ============================================
-- BOTÃO FLUTUANTE (LOGO)
-- ============================================
local function CreateFloatingButton()
    local FloatButton = Instance.new("ImageButton")
    FloatButton.Name = "FloatingButton"
    FloatButton.Size = UDim2.new(0, 60, 0, 60)
    FloatButton.Position = UDim2.new(0, 20, 0.5, -30)
    FloatButton.BackgroundColor3 = NYTRON.Colors.Secondary
    FloatButton.BorderSizePixel = 0
    FloatButton.Visible = false
    FloatButton.Parent = ScreenGui
    
    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatButton
    
    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = NYTRON.Colors.Primary
    FloatStroke.Thickness = 2
    FloatStroke.Parent = FloatButton
    
    -- Texto N (Logo)
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "N"
    LogoText.TextColor3 = NYTRON.Colors.Primary
    LogoText.TextSize = 32
    LogoText.Font = Enum.Font.GothamBold
    LogoText.Parent = FloatButton
    
    -- Draggable
    local dragging, dragInput, dragStart, startPos
    
    FloatButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatButton.Position
        end
    end)
    
    FloatButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            FloatButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return FloatButton
end

-- ============================================
-- PAINEL PRINCIPAL
-- ============================================
local function CreateMainPanel()
    local MainPanel = Instance.new("Frame")
    MainPanel.Name = "MainPanel"
    MainPanel.Size = UDim2.new(0, 400, 0, 450)
    MainPanel.Position = UDim2.new(0.5, -200, 0.5, -225)
    MainPanel.BackgroundColor3 = NYTRON.Colors.Background
    MainPanel.BorderSizePixel = 0
    MainPanel.Visible = false
    MainPanel.Parent = ScreenGui
    
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 12)
    PanelCorner.Parent = MainPanel
    
    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = NYTRON.Colors.Primary
    PanelStroke.Thickness = 2
    PanelStroke.Parent = MainPanel
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = NYTRON.Colors.Secondary
    Header.BorderSizePixel = 0
    Header.Parent = MainPanel
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    -- Titulo do painel
    local PanelTitle = Instance.new("TextLabel")
    PanelTitle.Size = UDim2.new(0, 250, 1, 0)
    PanelTitle.Position = UDim2.new(0, 15, 0, 0)
    PanelTitle.BackgroundTransparency = 1
    PanelTitle.Text = "⚡ NYTRON - Steal a Brainrot"
    PanelTitle.TextColor3 = NYTRON.Colors.Primary
    PanelTitle.TextSize = 16
    PanelTitle.Font = Enum.Font.GothamBold
    PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
    PanelTitle.Parent = Header
    
    -- Botão Minimizar (Triângulo)
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
    MinimizeBtn.Position = UDim2.new(1, -50, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "▼"
    MinimizeBtn.TextColor3 = NYTRON.Colors.Primary
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = Header
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeBtn
    
    -- Container de funções
    local FunctionsContainer = Instance.new("ScrollingFrame")
    FunctionsContainer.Name = "FunctionsContainer"
    FunctionsContainer.Size = UDim2.new(1, -20, 1, -70)
    FunctionsContainer.Position = UDim2.new(0, 10, 0, 60)
    FunctionsContainer.BackgroundTransparency = 1
    FunctionsContainer.BorderSizePixel = 0
    FunctionsContainer.ScrollBarThickness = 4
    FunctionsContainer.ScrollBarImageColor3 = NYTRON.Colors.Primary
    FunctionsContainer.CanvasSize = UDim2.new(0, 0, 0, 600)
    FunctionsContainer.Parent = MainPanel
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = FunctionsContainer
    
    return MainPanel, FunctionsContainer, MinimizeBtn
end

-- ============================================
-- CRIAR TOGGLE (SWITCH)
-- ============================================
local function CreateToggle(parent, name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
    ToggleFrame.BackgroundColor3 = NYTRON.Colors.Secondary
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0, 250, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = NYTRON.Colors.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 26)
    ToggleButton.Position = UDim2.new(1, -65, 0.5, -13)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = false
    
    local function Toggle()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = NYTRON.Colors.Primary}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
        
        if callback then
            callback(toggled)
        end
    end
    
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Toggle()
        end
    end)
    
    return ToggleFrame
end

-- ============================================
-- CRIAR BOTÃO
-- ============================================
local function CreateButton(parent, name, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = name
    ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    ButtonFrame.BackgroundColor3 = NYTRON.Colors.Secondary
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = name
    ButtonFrame.TextColor3 = NYTRON.Colors.Text
    ButtonFrame.TextSize = 14
    ButtonFrame.Font = Enum.Font.Gotham
    ButtonFrame.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        -- Efeito de clique
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = NYTRON.Colors.Primary}):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = NYTRON.Colors.Secondary}):Play()
        
        if callback then
            callback()
        end
    end)
    
    return ButtonFrame
end

-- ============================================
-- CRIAR SEPARADOR
-- ============================================
local function CreateSeparator(parent, text)
    local SepFrame = Instance.new("Frame")
    SepFrame.Name = "Separator"
    SepFrame.Size = UDim2.new(1, 0, 0, 30)
    SepFrame.BackgroundTransparency = 1
    SepFrame.Parent = parent
    
    local SepText = Instance.new("TextLabel")
    SepText.Size = UDim2.new(1, 0, 1, 0)
    SepText.BackgroundTransparency = 1
    SepText.Text = "━━━ " .. text .. " ━━━"
    SepText.TextColor3 = NYTRON.Colors.Primary
    SepText.TextSize = 12
    SepText.Font = Enum.Font.GothamBold
    SepText.Parent = SepFrame
    
    return SepFrame
end

-- ============================================
-- FUNÇÕES DO JOGO - ESP
-- ============================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NYTRON_ESP"
ESPFolder.Parent = CoreGui

local function CreateESP(target, espType)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = target.HumanoidRootPart
    
    -- Highlight (X-Ray)
    if espType == "xray" or espType == "all" then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight_" .. target.Name
        highlight.Adornee = target
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = NYTRON.Colors.Primary
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = ESPFolder
    end
    
    -- BillboardGui (Nome)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name_" .. target.Name
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ESPFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = target.Name
    nameLabel.TextColor3 = NYTRON.Colors.Primary
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard
end

local function CreateESPLines(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local line = Drawing.new("Line")
    line.Visible = true
    line.Color = NYTRON.Colors.Primary
    line.Thickness = 1
    line.Transparency = 1
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not NYTRON.Settings.ESP_Lines then
            line:Remove()
            connection:Disconnect()
            return
        end
        
        if target and target:FindFirstChild("HumanoidRootPart") and Character and Character:FindFirstChild("HumanoidRootPart") then
            local camera = Workspace.CurrentCamera
            local targetPos, onScreen1 = camera:WorldToViewportPoint(target.HumanoidRootPart.Position)
            local myPos, onScreen2 = camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
            
            if onScreen1 and onScreen2 then
                line.From = Vector2.new(myPos.X, myPos.Y)
                line.To = Vector2.new(targetPos.X, targetPos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line:Remove()
            connection:Disconnect()
        end
    end)
end

local function CreateSelfESP()
    if not Character then return end
    
    local selfHighlight = Instance.new("Highlight")
    selfHighlight.Name = "ESP_Self"
    selfHighlight.Adornee = Character
    selfHighlight.FillColor = NYTRON.Colors.Primary
    selfHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    selfHighlight.FillTransparency = 0.5
    selfHighlight.OutlineTransparency = 0
    selfHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    selfHighlight.Parent = ESPFolder
end

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

local function UpdateESP()
    ClearESP()
    
    if NYTRON.Settings.ESP_Self then
        CreateSelfESP()
    end
    
    -- Encontrar brainrots/players
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
            if NYTRON.Settings.ESP_XRay then
                CreateESP(v, "xray")
            end
            if NYTRON.Settings.ESP_Lines then
                pcall(function()
                    CreateESPLines(v)
                end)
            end
        end
    end
end

-- ============================================
-- FUNÇÕES DO JOGO - SPEED (MOLAS)
-- ============================================
local speedConnection
local originalWalkSpeed = 16
local originalJumpPower = 50

local function SetSpeed(runSpeed, jumpPower)
    if Character and Humanoid then
        if runSpeed then
            Humanoid.WalkSpeed = runSpeed
        end
        if jumpPower then
            Humanoid.JumpPower = jumpPower
        end
    end
end

local function EnableSpeedRun()
    SetSpeed(50, nil)
end

local function EnableSpeedJump()
    SetSpeed(nil, 120)
end

local function EnableSpeedBoth()
    SetSpeed(50, 120)
end

local function DisableSpeed()
    SetSpeed(originalWalkSpeed, originalJumpPower)
end

-- Reconectar quando respawnar
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    
    if NYTRON.Settings.Speed_Both then
        EnableSpeedBoth()
    elseif NYTRON.Settings.Speed_Run then
        EnableSpeedRun()
    elseif NYTRON.Settings.Speed_Jump then
        EnableSpeedJump()
    end
    
    if NYTRON.Settings.ESP_Self then
        CreateSelfESP()
    end
end)

-- ============================================
-- FUNÇÕES DO JOGO - TELEPORT
-- ============================================
local function GetBrainrots()
    local brainrots = {}
    
    -- Procurar por brainrots no workspace
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name:lower():find("brainrot") or v.Name:lower():find("brain") or v:FindFirstChild("Humanoid") then
                if v ~= Character then
                    table.insert(brainrots, v)
                end
            end
        end
    end
    
    -- Se não encontrar específicos, pegar todos os modelos com humanoid
    if #brainrots == 0 then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
                table.insert(brainrots, v)
            end
        end
    end
    
    return brainrots
end

local function TeleportToBase()
    -- Procurar spawn/base
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn") or Workspace:FindFirstChild("Base")
    
    if spawn then
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            ShowNotification("✅ Teleportado para Base!", NYTRON.Colors.Primary, 2)
        end
    else
        -- Teleportar para posição inicial
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            ShowNotification("✅ Teleportado para Spawn!", NYTRON.Colors.Primary, 2)
        end
    end
end

local function TeleportToBrainrot()
    local brainrots = GetBrainrots()
    
    if #brainrots > 0 then
        local target = brainrots[math.random(1, #brainrots)]
        if target and target:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            ShowNotification("✅ Teleportado para: " .. target.Name, NYTRON.Colors.Primary, 2)
        end
    else
        ShowNotification("❌ Nenhum Brainrot encontrado!", Color3.fromRGB(255, 0, 0), 2)
    end
end

local function TeleportToNearest()
    local brainrots = GetBrainrots()
    local nearest = nil
    local nearestDist = math.huge
    
    for _, v in pairs(brainrots) do
        if v:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            local dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = v
            end
        end
    end
    
    if nearest then
        HumanoidRootPart.CFrame = nearest.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        ShowNotification("✅ Teleportado para o mais próximo!", NYTRON.Colors.Primary, 2)
    else
        ShowNotification("❌ Nenhum alvo encontrado!", Color3.fromRGB(255, 0, 0), 2)
    end
end

-- ============================================
-- INICIALIZAÇÃO
-- ============================================
local LoadingFrame, LoadingBar, LoadingText = CreateLoadingScreen()
local LoginFrame, KeyInput, LoginButton = CreateLoginScreen()
local FloatingButton = CreateFloatingButton()
local MainPanel, FunctionsContainer, MinimizeBtn = CreateMainPanel()

-- Animação de loading inicial
task.spawn(function()
    local loadingSteps = {
        {progress = 0.2, text = "Carregando módulos..."},
        {progress = 0.4, text = "Verificando anti-cheat..."},
        {progress = 0.6, text = "Carregando funções..."},
        {progress = 0.8, text = "Preparando interface..."},
        {progress = 1, text = "Quase pronto..."},
    }
    
    for _, step in ipairs(loadingSteps) do
        TweenService:Create(LoadingBar, TweenInfo.new(0.5), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()
        LoadingText.Text = step.text
        task.wait(0.6)
    end
    
    task.wait(0.5)
    LoadingFrame.Visible = false
    LoginFrame.Visible = true
end)

-- Sistema de Login
LoginButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    
    if NYTRON.ValidKeys[key] then
        ShowNotification("✅ Logado com sucesso!", NYTRON.Colors.Primary, 3)
        task.wait(1)
        
        LoginFrame.Visible = false
        
        -- Loading após login
        LoadingFrame.Visible = true
        LoadingBar.Size = UDim2.new(0, 0, 1, 0)
        LoadingText.Text = "Iniciando script..."
        
        local loadingSteps2 = {
            {progress = 0.3, text = "Carregando ESP..."},
            {progress = 0.6, text = "Carregando Speed..."},
            {progress = 0.9, text = "Carregando Teleport..."},
            {progress = 1, text = "Concluído!"},
        }
        
        for _, step in ipairs(loadingSteps2) do
            TweenService:Create(LoadingBar, TweenInfo.new(0.4), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()
            LoadingText.Text = step.text
            task.wait(0.5)
        end
        
        task.wait(0.5)
        ShowNotification("✅ Carregamento concluído!", NYTRON.Colors.Primary, 3)
        task.wait(1)
        
        LoadingFrame.Visible = false
        FloatingButton.Visible = true
        
    else
        ShowNotification("❌ Key inválida!", Color3.fromRGB(255, 0, 0), 3)
        KeyInput.Text = ""
    end
end)

-- Botão flutuante abre/fecha painel
FloatingButton.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

-- Botão minimizar
MinimizeBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
end)

-- ============================================
-- CRIAR FUNÇÕES NO PAINEL
-- ============================================

-- Separador ESP
CreateSeparator(FunctionsContainer, "ESP")

-- ESP X-Ray
CreateToggle(FunctionsContainer, "👁️ ESP X-Ray", function(enabled)
    NYTRON.Settings.ESP_XRay = enabled
    UpdateESP()
end)

-- ESP Lines
CreateToggle(FunctionsContainer, "📍 ESP Lines", function(enabled)
    NYTRON.Settings.ESP_Lines = enabled
    UpdateESP()
end)

-- ESP Self (em mim)
CreateToggle(FunctionsContainer, "🔆 ESP em Mim (Grande)", function(enabled)
    NYTRON.Settings.ESP_Self = enabled
    UpdateESP()
end)

-- Separador Speed
CreateSeparator(FunctionsContainer, "SPEED (MOLAS)")

-- Speed Correr + Pular
CreateToggle(FunctionsContainer, "⚡ Speed Correr + Pular Alto", function(enabled)
    NYTRON.Settings.Speed_Both = enabled
    NYTRON.Settings.Speed_Run = false
    NYTRON.Settings.Speed_Jump = false
    if enabled then
        EnableSpeedBoth()
    else
        DisableSpeed()
    end
end)

-- Speed só Correr
CreateToggle(FunctionsContainer, "🏃 Speed Correr Rápido", function(enabled)
    NYTRON.Settings.Speed_Run = enabled
    if enabled then
        NYTRON.Settings.Speed_Both = false
        EnableSpeedRun()
    else
        DisableSpeed()
    end
end)

-- Speed só Pular
CreateToggle(FunctionsContainer, "🦘 Speed Pular Alto", function(enabled)
    NYTRON.Settings.Speed_Jump = enabled
    if enabled then
        NYTRON.Settings.Speed_Both = false
        EnableSpeedJump()
    else
        DisableSpeed()
    end
end)

-- Separador Teleport
CreateSeparator(FunctionsContainer, "TELEPORT")

-- TP Base
CreateButton(FunctionsContainer, "🏠 Teleport Base/Spawn", TeleportToBase)

-- TP Brainrot Random
CreateButton(FunctionsContainer, "🎯 Teleport Brainrot (Random)", TeleportToBrainrot)

-- TP Mais Próximo
CreateButton(FunctionsContainer, "📌 Teleport Mais Próximo", TeleportToNearest)

-- Separador Extra
CreateSeparator(FunctionsContainer, "EXTRA")

-- Atualizar ESP
CreateButton(FunctionsContainer, "🔄 Atualizar ESP", UpdateESP)

-- Créditos
CreateSeparator(FunctionsContainer, "NYTRON MODS © 2025")

-- ============================================
-- LOOP DE ATUALIZAÇÃO
-- ============================================
task.spawn(function()
    while task.wait(5) do
        if NYTRON.Settings.ESP_XRay or NYTRON.Settings.ESP_Lines or NYTRON.Settings.ESP_Self then
            UpdateESP()
        end
    end
end)

print("═══════════════════════════════════════")
print("   NYTRON - Steal a Brainrot Loaded!")
print("   Key de teste: KEY-NYTRON-7DIAS-TESTE")
print("═══════════════════════════════════════")
