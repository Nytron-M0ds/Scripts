--[[
    ███╗   ██╗██╗   ██╗████████╗██████╗  ██████╗ ███╗   ██╗
    ████╗  ██║╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔═══██╗████╗  ██║
    ██╔██╗ ██║ ╚████╔╝    ██║   ██████╔╝██║   ██║██╔██╗ ██║
    ██║╚██╗██║  ╚██╔╝     ██║   ██╔══██╗██║   ██║██║╚██╗██║
    ██║ ╚████║   ██║      ██║   ██║  ██║╚██████╔╝██║ ╚████║
    ╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    
    NYTRON MODS - Steal a Brainrot Script V2
    UI Profissional | Abas Separadas | 100% Funcional
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Aguardar Character
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações NYTRON
local NYTRON = {
    Version = "2.0",
    Key = "NYTRON-INFINITO",
    LogoURL = "rbxassetid://0", -- Placeholder, usaremos texto estilizado
    
    Settings = {
        -- ESP
        ESP_XRay = false,
        ESP_Lines = false,
        ESP_Self = false,
        ESP_Names = false,
        ESP_Distance = false,
        ESP_Tracers = false,
        
        -- Speed
        Speed_Run = false,
        Speed_Jump = false,
        Speed_Both = false,
        SpeedValue = 50,
        JumpValue = 120,
        
        -- Teleport
        TP_Enabled = false,
    },
    
    Colors = {
        Primary = Color3.fromRGB(0, 255, 100),      -- Verde neon
        PrimaryDark = Color3.fromRGB(0, 180, 70),   -- Verde escuro
        Secondary = Color3.fromRGB(25, 25, 25),     -- Cinza escuro
        Background = Color3.fromRGB(15, 15, 18),    -- Quase preto
        Card = Color3.fromRGB(20, 20, 25),          -- Card
        Text = Color3.fromRGB(255, 255, 255),       -- Branco
        TextDark = Color3.fromRGB(150, 150, 150),   -- Cinza
        Accent = Color3.fromRGB(0, 255, 100),       -- Verde
        Error = Color3.fromRGB(255, 70, 70),        -- Vermelho
        Warning = Color3.fromRGB(255, 200, 0),      -- Amarelo
    }
}

-- Destruir GUI anterior se existir
if CoreGui:FindFirstChild("NYTRON_GUI") then
    CoreGui:FindFirstChild("NYTRON_GUI"):Destroy()
end

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- Pasta para ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NYTRON_ESP"
ESPFolder.Parent = CoreGui

-- ============================================
-- FUNÇÕES UTILITÁRIAS
-- ============================================

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or NYTRON.Colors.Primary
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- ============================================
-- TELA DE LOADING
-- ============================================

local function CreateLoadingScreen()
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingScreen"
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = NYTRON.Colors.Background
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = ScreenGui
    
    -- Container central
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0, 350, 0, 300)
    Container.Position = UDim2.new(0.5, -175, 0.5, -150)
    Container.BackgroundTransparency = 1
    Container.Parent = LoadingFrame
    
    -- Logo Text (NYTRON estilizado)
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 120, 0, 120)
    LogoFrame.Position = UDim2.new(0.5, -60, 0, 0)
    LogoFrame.BackgroundColor3 = NYTRON.Colors.Secondary
    LogoFrame.Parent = Container
    CreateCorner(LogoFrame, 60)
    CreateStroke(LogoFrame, NYTRON.Colors.Primary, 3)
    
    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    Glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = NYTRON.Colors.Primary
    Glow.ImageTransparency = 0.7
    Glow.Parent = LogoFrame
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "N"
    LogoText.TextColor3 = NYTRON.Colors.Primary
    LogoText.TextSize = 60
    LogoText.Font = Enum.Font.GothamBlack
    LogoText.Parent = LogoFrame
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 135)
    Title.BackgroundTransparency = 1
    Title.Text = "NYTRON MODS"
    Title.TextColor3 = NYTRON.Colors.Primary
    Title.TextSize = 32
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = Container
    
    -- Subtítulo
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 25)
    SubTitle.Position = UDim2.new(0, 0, 0, 175)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Steal a Brainrot"
    SubTitle.TextColor3 = NYTRON.Colors.TextDark
    SubTitle.TextSize = 18
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Parent = Container
    
    -- Barra de loading
    local LoadingBarBG = Instance.new("Frame")
    LoadingBarBG.Size = UDim2.new(0, 280, 0, 6)
    LoadingBarBG.Position = UDim2.new(0.5, -140, 0, 220)
    LoadingBarBG.BackgroundColor3 = NYTRON.Colors.Secondary
    LoadingBarBG.Parent = Container
    CreateCorner(LoadingBarBG, 3)
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = NYTRON.Colors.Primary
    LoadingBar.Parent = LoadingBarBG
    CreateCorner(LoadingBar, 3)
    CreateGradient(LoadingBar, NYTRON.Colors.Primary, NYTRON.Colors.PrimaryDark, 0)
    
    -- Texto de status
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0, 235)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Iniciando..."
    StatusText.TextColor3 = NYTRON.Colors.TextDark
    StatusText.TextSize = 12
    StatusText.Font = Enum.Font.Gotham
    StatusText.Parent = Container
    
    -- Versão
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(1, 0, 0, 20)
    Version.Position = UDim2.new(0, 0, 0, 270)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. NYTRON.Version
    Version.TextColor3 = Color3.fromRGB(60, 60, 60)
    Version.TextSize = 11
    Version.Font = Enum.Font.Gotham
    Version.Parent = Container
    
    return LoadingFrame, LoadingBar, StatusText
end

-- ============================================
-- TELA DE LOGIN
-- ============================================

local function CreateLoginScreen()
    local LoginFrame = Instance.new("Frame")
    LoginFrame.Name = "LoginScreen"
    LoginFrame.Size = UDim2.new(1, 0, 1, 0)
    LoginFrame.BackgroundColor3 = NYTRON.Colors.Background
    LoginFrame.Visible = false
    LoginFrame.Parent = ScreenGui
    
    -- Card de login
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(0, 380, 0, 320)
    Card.Position = UDim2.new(0.5, -190, 0.5, -160)
    Card.BackgroundColor3 = NYTRON.Colors.Card
    Card.Parent = LoginFrame
    CreateCorner(Card, 16)
    CreateStroke(Card, NYTRON.Colors.Primary, 2)
    
    -- Header do card
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 80)
    Header.BackgroundColor3 = NYTRON.Colors.Secondary
    Header.Parent = Card
    CreateCorner(Header, 16)
    
    -- Fix para cantos do header
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 20)
    HeaderFix.Position = UDim2.new(0, 0, 1, -20)
    HeaderFix.BackgroundColor3 = NYTRON.Colors.Secondary
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    -- Ícone de cadeado
    local LockIcon = Instance.new("TextLabel")
    LockIcon.Size = UDim2.new(0, 50, 0, 50)
    LockIcon.Position = UDim2.new(0.5, -25, 0, 15)
    LockIcon.BackgroundTransparency = 1
    LockIcon.Text = "🔐"
    LockIcon.TextSize = 35
    LockIcon.Parent = Header
    
    -- Título login
    local LoginTitle = Instance.new("TextLabel")
    LoginTitle.Size = UDim2.new(1, 0, 0, 30)
    LoginTitle.Position = UDim2.new(0, 0, 0, 95)
    LoginTitle.BackgroundTransparency = 1
    LoginTitle.Text = "Digite sua Key"
    LoginTitle.TextColor3 = NYTRON.Colors.Text
    LoginTitle.TextSize = 20
    LoginTitle.Font = Enum.Font.GothamBold
    LoginTitle.Parent = Card
    
    -- Subtítulo
    local LoginSubtitle = Instance.new("TextLabel")
    LoginSubtitle.Size = UDim2.new(1, 0, 0, 20)
    LoginSubtitle.Position = UDim2.new(0, 0, 0, 120)
    LoginSubtitle.BackgroundTransparency = 1
    LoginSubtitle.Text = "Acesso exclusivo para membros"
    LoginSubtitle.TextColor3 = NYTRON.Colors.TextDark
    LoginSubtitle.TextSize = 12
    LoginSubtitle.Font = Enum.Font.Gotham
    LoginSubtitle.Parent = Card
    
    -- Input container
    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(0, 320, 0, 50)
    InputContainer.Position = UDim2.new(0.5, -160, 0, 155)
    InputContainer.BackgroundColor3 = NYTRON.Colors.Background
    InputContainer.Parent = Card
    CreateCorner(InputContainer, 10)
    CreateStroke(InputContainer, Color3.fromRGB(50, 50, 50), 1)
    
    -- Input
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "NYTRON-XXXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
    KeyInput.TextColor3 = NYTRON.Colors.Text
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.GothamMedium
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = InputContainer
    
    -- Botão Login
    local LoginButton = Instance.new("TextButton")
    LoginButton.Size = UDim2.new(0, 320, 0, 50)
    LoginButton.Position = UDim2.new(0.5, -160, 0, 220)
    LoginButton.BackgroundColor3 = NYTRON.Colors.Primary
    LoginButton.Text = "ENTRAR"
    LoginButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    LoginButton.TextSize = 16
    LoginButton.Font = Enum.Font.GothamBlack
    LoginButton.Parent = Card
    CreateCorner(LoginButton, 10)
    
    -- Hover effect
    LoginButton.MouseEnter:Connect(function()
        Tween(LoginButton, {BackgroundColor3 = NYTRON.Colors.PrimaryDark}, 0.2)
    end)
    LoginButton.MouseLeave:Connect(function()
        Tween(LoginButton, {BackgroundColor3 = NYTRON.Colors.Primary}, 0.2)
    end)
    
    -- Footer
    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(1, 0, 0, 20)
    Footer.Position = UDim2.new(0, 0, 1, -30)
    Footer.BackgroundTransparency = 1
    Footer.Text = "NYTRON MODS © 2025"
    Footer.TextColor3 = Color3.fromRGB(50, 50, 50)
    Footer.TextSize = 10
    Footer.Font = Enum.Font.Gotham
    Footer.Parent = Card
    
    return LoginFrame, KeyInput, LoginButton
end

-- ============================================
-- NOTIFICAÇÃO
-- ============================================

local function ShowNotification(title, message, notifType, duration)
    duration = duration or 3
    
    local colors = {
        success = NYTRON.Colors.Primary,
        error = NYTRON.Colors.Error,
        warning = NYTRON.Colors.Warning,
        info = Color3.fromRGB(100, 150, 255)
    }
    
    local icons = {
        success = "✓",
        error = "✕",
        warning = "⚠",
        info = "ℹ"
    }
    
    local color = colors[notifType] or colors.info
    local icon = icons[notifType] or icons.info
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 320, 0, 70)
    NotifFrame.Position = UDim2.new(1, 20, 0, 20)
    NotifFrame.BackgroundColor3 = NYTRON.Colors.Card
    NotifFrame.Parent = ScreenGui
    CreateCorner(NotifFrame, 12)
    CreateStroke(NotifFrame, color, 2)
    
    -- Barra lateral colorida
    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 4, 1, -10)
    SideBar.Position = UDim2.new(0, 8, 0, 5)
    SideBar.BackgroundColor3 = color
    SideBar.Parent = NotifFrame
    CreateCorner(SideBar, 2)
    
    -- Ícone
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 20, 0.5, -15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextColor3 = color
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = NotifFrame
    
    -- Título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 0, 25)
    TitleLabel.Position = UDim2.new(0, 55, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = NYTRON.Colors.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame
    
    -- Mensagem
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(1, -70, 0, 20)
    MessageLabel.Position = UDim2.new(0, 55, 0, 35)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = message
    MessageLabel.TextColor3 = NYTRON.Colors.TextDark
    MessageLabel.TextSize = 12
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.Parent = NotifFrame
    
    -- Animação entrada
    Tween(NotifFrame, {Position = UDim2.new(1, -340, 0, 20)}, 0.5, Enum.EasingStyle.Back)
    
    -- Animação saída
    task.delay(duration, function()
        Tween(NotifFrame, {Position = UDim2.new(1, 20, 0, 20)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.5)
        NotifFrame:Destroy()
    end)
end

-- ============================================
-- BOTÃO FLUTUANTE
-- ============================================

local function CreateFloatingButton()
    local FloatButton = Instance.new("ImageButton")
    FloatButton.Name = "FloatingButton"
    FloatButton.Size = UDim2.new(0, 55, 0, 55)
    FloatButton.Position = UDim2.new(0, 15, 0.5, -27)
    FloatButton.BackgroundColor3 = NYTRON.Colors.Card
    FloatButton.Visible = false
    FloatButton.Parent = ScreenGui
    CreateCorner(FloatButton, 27)
    CreateStroke(FloatButton, NYTRON.Colors.Primary, 2)
    
    -- Glow
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(2, 0, 2, 0)
    Glow.Position = UDim2.new(-0.5, 0, -0.5, 0)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = NYTRON.Colors.Primary
    Glow.ImageTransparency = 0.85
    Glow.ZIndex = 0
    Glow.Parent = FloatButton
    
    -- Logo N
    local LogoN = Instance.new("TextLabel")
    LogoN.Size = UDim2.new(1, 0, 1, 0)
    LogoN.BackgroundTransparency = 1
    LogoN.Text = "N"
    LogoN.TextColor3 = NYTRON.Colors.Primary
    LogoN.TextSize = 28
    LogoN.Font = Enum.Font.GothamBlack
    LogoN.ZIndex = 2
    LogoN.Parent = FloatButton
    
    -- Draggable
    local dragging, dragStart, startPos
    
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
-- PAINEL PRINCIPAL COM ABAS
-- ============================================

local CurrentTab = "ESP"

local function CreateMainPanel()
    local MainPanel = Instance.new("Frame")
    MainPanel.Name = "MainPanel"
    MainPanel.Size = UDim2.new(0, 450, 0, 380)
    MainPanel.Position = UDim2.new(0.5, -225, 0.5, -190)
    MainPanel.BackgroundColor3 = NYTRON.Colors.Background
    MainPanel.Visible = false
    MainPanel.Parent = ScreenGui
    CreateCorner(MainPanel, 16)
    CreateStroke(MainPanel, NYTRON.Colors.Primary, 2)
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.Position = UDim2.new(0, -25, 0, -25)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = 0
    Shadow.Parent = MainPanel
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundColor3 = NYTRON.Colors.Card
    Header.Parent = MainPanel
    CreateCorner(Header, 16)
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 20)
    HeaderFix.Position = UDim2.new(0, 0, 1, -20)
    HeaderFix.BackgroundColor3 = NYTRON.Colors.Card
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    -- Logo no header
    local HeaderLogo = Instance.new("TextLabel")
    HeaderLogo.Size = UDim2.new(0, 35, 0, 35)
    HeaderLogo.Position = UDim2.new(0, 15, 0.5, -17)
    HeaderLogo.BackgroundColor3 = NYTRON.Colors.Primary
    HeaderLogo.Text = "N"
    HeaderLogo.TextColor3 = Color3.fromRGB(0, 0, 0)
    HeaderLogo.TextSize = 20
    HeaderLogo.Font = Enum.Font.GothamBlack
    HeaderLogo.Parent = Header
    CreateCorner(HeaderLogo, 8)
    
    -- Título
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(0, 200, 0, 25)
    HeaderTitle.Position = UDim2.new(0, 60, 0, 8)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = "NYTRON MODS"
    HeaderTitle.TextColor3 = NYTRON.Colors.Text
    HeaderTitle.TextSize = 16
    HeaderTitle.Font = Enum.Font.GothamBlack
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = Header
    
    local HeaderSubtitle = Instance.new("TextLabel")
    HeaderSubtitle.Size = UDim2.new(0, 200, 0, 15)
    HeaderSubtitle.Position = UDim2.new(0, 60, 0, 32)
    HeaderSubtitle.BackgroundTransparency = 1
    HeaderSubtitle.Text = "Steal a Brainrot"
    HeaderSubtitle.TextColor3 = NYTRON.Colors.TextDark
    HeaderSubtitle.TextSize = 11
    HeaderSubtitle.Font = Enum.Font.Gotham
    HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderSubtitle.Parent = Header
    
    -- Botão minimizar
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    MinimizeBtn.Position = UDim2.new(1, -50, 0.5, -17)
    MinimizeBtn.BackgroundColor3 = NYTRON.Colors.Secondary
    MinimizeBtn.Text = "▼"
    MinimizeBtn.TextColor3 = NYTRON.Colors.TextDark
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = Header
    CreateCorner(MinimizeBtn, 8)
    
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = NYTRON.Colors.Primary, TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = NYTRON.Colors.Secondary, TextColor3 = NYTRON.Colors.TextDark}, 0.2)
    end)
    
    -- Container de abas
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 100, 1, -65)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainPanel
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    -- Container de conteúdo
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -130, 1, -70)
    ContentContainer.Position = UDim2.new(0, 120, 0, 60)
    ContentContainer.BackgroundColor3 = NYTRON.Colors.Card
    ContentContainer.Parent = MainPanel
    CreateCorner(ContentContainer, 12)
    
    return MainPanel, TabContainer, ContentContainer, MinimizeBtn
end

-- ============================================
-- CRIAR ABA
-- ============================================

local TabButtons = {}
local TabContents = {}

local function CreateTab(parent, contentParent, name, icon)
    -- Botão da aba
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.BackgroundColor3 = NYTRON.Colors.Card
    TabBtn.Text = ""
    TabBtn.Parent = parent
    CreateCorner(TabBtn, 8)
    
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Size = UDim2.new(0, 25, 1, 0)
    TabIcon.Position = UDim2.new(0, 8, 0, 0)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = icon
    TabIcon.TextSize = 16
    TabIcon.TextColor3 = NYTRON.Colors.TextDark
    TabIcon.Parent = TabBtn
    
    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(1, -40, 1, 0)
    TabText.Position = UDim2.new(0, 35, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = name
    TabText.TextColor3 = NYTRON.Colors.TextDark
    TabText.TextSize = 12
    TabText.Font = Enum.Font.GothamMedium
    TabText.TextXAlignment = Enum.TextXAlignment.Left
    TabText.Parent = TabBtn
    
    -- Conteúdo da aba
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = NYTRON.Colors.Primary
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = contentParent
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    TabButtons[name] = {Button = TabBtn, Icon = TabIcon, Text = TabText}
    TabContents[name] = TabContent
    
    -- Click handler
    TabBtn.MouseButton1Click:Connect(function()
        -- Desativar todas as abas
        for tabName, tab in pairs(TabButtons) do
            Tween(tab.Button, {BackgroundColor3 = NYTRON.Colors.Card}, 0.2)
            Tween(tab.Icon, {TextColor3 = NYTRON.Colors.TextDark}, 0.2)
            Tween(tab.Text, {TextColor3 = NYTRON.Colors.TextDark}, 0.2)
            TabContents[tabName].Visible = false
        end
        
        -- Ativar aba clicada
        Tween(TabBtn, {BackgroundColor3 = NYTRON.Colors.Primary}, 0.2)
        Tween(TabIcon, {TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
        Tween(TabText, {TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
        TabContent.Visible = true
        CurrentTab = name
    end)
    
    return TabContent
end

-- ============================================
-- CRIAR TOGGLE BONITO
-- ============================================

local function CreateToggle(parent, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = NYTRON.Colors.Secondary
    ToggleFrame.Parent = parent
    CreateCorner(ToggleFrame, 8)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = NYTRON.Colors.Text
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Size = UDim2.new(0, 45, 0, 24)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.Parent = ToggleFrame
    CreateCorner(ToggleButton, 12)
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    ToggleCircle.Parent = ToggleButton
    CreateCorner(ToggleCircle, 9)
    
    local toggled = default or false
    
    local function UpdateVisual()
        if toggled then
            Tween(ToggleButton, {BackgroundColor3 = NYTRON.Colors.Primary}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        else
            Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(120, 120, 120)}, 0.2)
        end
    end
    
    if default then UpdateVisual() end
    
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggled = not toggled
            UpdateVisual()
            if callback then callback(toggled) end
        end
    end)
    
    return ToggleFrame
end

-- ============================================
-- CRIAR BOTÃO BONITO
-- ============================================

local function CreateButton(parent, name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = NYTRON.Colors.Secondary
    Button.Text = name
    Button.TextColor3 = NYTRON.Colors.Text
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.Parent = parent
    CreateCorner(Button, 8)
    
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = NYTRON.Colors.Primary, TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
    end)
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = NYTRON.Colors.Secondary, TextColor3 = NYTRON.Colors.Text}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return Button
end

-- ============================================
-- CRIAR SLIDER
-- ============================================

local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 55)
    SliderFrame.BackgroundColor3 = NYTRON.Colors.Secondary
    SliderFrame.Parent = parent
    CreateCorner(SliderFrame, 8)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 12, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = NYTRON.Colors.Text
    SliderLabel.TextSize = 13
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, -12, 0, 20)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = NYTRON.Colors.Primary
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, -24, 0, 6)
    SliderBG.Position = UDim2.new(0, 12, 0, 38)
    SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBG.Parent = SliderFrame
    CreateCorner(SliderBG, 3)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = NYTRON.Colors.Primary
    SliderFill.Parent = SliderBG
    CreateCorner(SliderFill, 3)
    
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 14, 0, 14)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    SliderKnob.BackgroundColor3 = NYTRON.Colors.Text
    SliderKnob.Parent = SliderBG
    CreateCorner(SliderKnob, 7)
    
    local dragging = false
    
    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            SliderKnob.Position = UDim2.new(pos, -7, 0.5, -7)
            ValueLabel.Text = tostring(value)
            
            if callback then callback(value) end
        end
    end)
    
    return SliderFrame
end

-- ============================================
-- FUNÇÕES ESP
-- ============================================

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

-- ESP Self - Laser quadrado grande
local function CreateSelfESP()
    if not Character or not HumanoidRootPart then return end
    
    -- Box grande ao redor do player
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "ESP_SelfBox"
    Box.Adornee = HumanoidRootPart
    Box.Size = Vector3.new(6, 10, 6)
    Box.Color3 = NYTRON.Colors.Primary
    Box.Transparency = 0.7
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Parent = ESPFolder
    
    -- Highlight
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "ESP_SelfHighlight"
    Highlight.Adornee = Character
    Highlight.FillColor = NYTRON.Colors.Primary
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.6
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Parent = ESPFolder
    
    -- Beam para a base (laser)
    local Attachment0 = Instance.new("Attachment")
    Attachment0.Name = "ESP_SelfAttach0"
    Attachment0.Parent = HumanoidRootPart
    
    -- Procurar base/spawn
    local basePos = Vector3.new(0, 0, 0)
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
    if spawn then
        basePos = spawn.Position
    end
    
    local BasePart = Instance.new("Part")
    BasePart.Name = "ESP_BasePart"
    BasePart.Size = Vector3.new(1, 1, 1)
    BasePart.Position = basePos
    BasePart.Anchored = true
    BasePart.CanCollide = false
    BasePart.Transparency = 1
    BasePart.Parent = ESPFolder
    
    local Attachment1 = Instance.new("Attachment")
    Attachment1.Parent = BasePart
    
    local Beam = Instance.new("Beam")
    Beam.Name = "ESP_SelfBeam"
    Beam.Attachment0 = Attachment0
    Beam.Attachment1 = Attachment1
    Beam.Color = ColorSequence.new(NYTRON.Colors.Primary)
    Beam.Width0 = 0.5
    Beam.Width1 = 0.5
    Beam.FaceCamera = true
    Beam.Transparency = NumberSequence.new(0.3)
    Beam.Parent = ESPFolder
end

-- ESP para outros
local function CreateESPForTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = target.HumanoidRootPart
    
    -- Highlight X-Ray
    if NYTRON.Settings.ESP_XRay then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. target.Name
        highlight.Adornee = target
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.OutlineColor = NYTRON.Colors.Primary
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = ESPFolder
    end
    
    -- Nome e distância
    if NYTRON.Settings.ESP_Names or NYTRON.Settings.ESP_Distance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard_" .. target.Name
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = ESPFolder
        
        if NYTRON.Settings.ESP_Names then
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = target.Name
            nameLabel.TextColor3 = NYTRON.Colors.Primary
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Parent = billboard
        end
        
        if NYTRON.Settings.ESP_Distance and HumanoidRootPart then
            local distLabel = Instance.new("TextLabel")
            distLabel.Name = "DistLabel"
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.TextColor3 = NYTRON.Colors.Text
            distLabel.TextSize = 11
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextStrokeTransparency = 0.5
            distLabel.Parent = billboard
            
            -- Atualizar distância
            task.spawn(function()
                while billboard and billboard.Parent do
                    if HumanoidRootPart and hrp then
                        local dist = math.floor((HumanoidRootPart.Position - hrp.Position).Magnitude)
                        distLabel.Text = dist .. "m"
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
    
    -- Tracers/Lines
    if NYTRON.Settings.ESP_Tracers and HumanoidRootPart then
        local Attachment0 = Instance.new("Attachment")
        Attachment0.Name = "ESP_TracerAttach_" .. target.Name
        Attachment0.Parent = HumanoidRootPart
        
        local Attachment1 = Instance.new("Attachment")
        Attachment1.Parent = hrp
        
        local Beam = Instance.new("Beam")
        Beam.Name = "ESP_Tracer_" .. target.Name
        Beam.Attachment0 = Attachment0
        Beam.Attachment1 = Attachment1
        Beam.Color = ColorSequence.new(NYTRON.Colors.Primary)
        Beam.Width0 = 0.1
        Beam.Width1 = 0.1
        Beam.FaceCamera = true
        Beam.Transparency = NumberSequence.new(0.5)
        Beam.Parent = ESPFolder
    end
end

local function UpdateESP()
    ClearESP()
    
    if NYTRON.Settings.ESP_Self then
        CreateSelfESP()
    end
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
            if NYTRON.Settings.ESP_XRay or NYTRON.Settings.ESP_Names or NYTRON.Settings.ESP_Distance or NYTRON.Settings.ESP_Tracers then
                CreateESPForTarget(v)
            end
        end
    end
end

-- ============================================
-- FUNÇÕES SPEED
-- ============================================

local function UpdateSpeed()
    if not Character then return end
    local hum = Character:FindFirstChild("Humanoid")
    if not hum then return end
    
    if NYTRON.Settings.Speed_Both then
        hum.WalkSpeed = NYTRON.Settings.SpeedValue
        hum.JumpPower = NYTRON.Settings.JumpValue
    elseif NYTRON.Settings.Speed_Run then
        hum.WalkSpeed = NYTRON.Settings.SpeedValue
        hum.JumpPower = 50
    elseif NYTRON.Settings.Speed_Jump then
        hum.WalkSpeed = 16
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
    local targets = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
            table.insert(targets, v)
        end
    end
    return targets
end

local function TeleportToBase()
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
    if spawn and HumanoidRootPart then
        HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        ShowNotification("Teleport", "Teleportado para a Base!", "success", 2)
    else
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            ShowNotification("Teleport", "Teleportado para o Spawn!", "success", 2)
        end
    end
end

local function TeleportToRandom()
    local targets = GetTargets()
    if #targets > 0 then
        local target = targets[math.random(1, #targets)]
        if target:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            ShowNotification("Teleport", "Teleportado para: " .. target.Name, "success", 2)
        end
    else
        ShowNotification("Teleport", "Nenhum alvo encontrado!", "error", 2)
    end
end

local function TeleportToNearest()
    local targets = GetTargets()
    local nearest, nearestDist = nil, math.huge
    
    for _, v in pairs(targets) do
        if v:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
            local dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = v
            end
        end
    end
    
    if nearest and HumanoidRootPart then
        HumanoidRootPart.CFrame = nearest.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        ShowNotification("Teleport", "Teleportado para o mais próximo!", "success", 2)
    else
        ShowNotification("Teleport", "Nenhum alvo encontrado!", "error", 2)
    end
end

-- ============================================
-- RECONECTAR AO RESPAWNAR
-- ============================================

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    UpdateSpeed()
    UpdateESP()
end)

-- ============================================
-- INICIALIZAÇÃO
-- ============================================

local LoadingFrame, LoadingBar, StatusText = CreateLoadingScreen()
local LoginFrame, KeyInput, LoginButton = CreateLoginScreen()
local FloatingButton = CreateFloatingButton()
local MainPanel, TabContainer, ContentContainer, MinimizeBtn = CreateMainPanel()

-- Criar abas
local ESPTab = CreateTab(TabContainer, ContentContainer, "ESP", "👁")
local SpeedTab = CreateTab(TabContainer, ContentContainer, "Speed", "⚡")
local TeleportTab = CreateTab(TabContainer, ContentContainer, "TP", "📍")
local SettingsTab = CreateTab(TabContainer, ContentContainer, "Config", "⚙")

-- Ativar primeira aba
TabButtons["ESP"].Button.BackgroundColor3 = NYTRON.Colors.Primary
TabButtons["ESP"].Icon.TextColor3 = Color3.fromRGB(0,0,0)
TabButtons["ESP"].Text.TextColor3 = Color3.fromRGB(0,0,0)
ESPTab.Visible = true

-- ============================================
-- POPULAR ABAS
-- ============================================

-- ABA ESP
CreateToggle(ESPTab, "ESP X-Ray (Ver através)", false, function(v)
    NYTRON.Settings.ESP_XRay = v
    UpdateESP()
end)

CreateToggle(ESPTab, "ESP Nomes", false, function(v)
    NYTRON.Settings.ESP_Names = v
    UpdateESP()
end)

CreateToggle(ESPTab, "ESP Distância", false, function(v)
    NYTRON.Settings.ESP_Distance = v
    UpdateESP()
end)

CreateToggle(ESPTab, "ESP Tracers (Linhas)", false, function(v)
    NYTRON.Settings.ESP_Tracers = v
    UpdateESP()
end)

CreateToggle(ESPTab, "ESP em Mim (Laser Grande)", false, function(v)
    NYTRON.Settings.ESP_Self = v
    UpdateESP()
end)

CreateButton(ESPTab, "🔄 Atualizar ESP", UpdateESP)

-- ABA SPEED
CreateToggle(SpeedTab, "Speed Correr + Pular", false, function(v)
    NYTRON.Settings.Speed_Both = v
    if v then
        NYTRON.Settings.Speed_Run = false
        NYTRON.Settings.Speed_Jump = false
    end
    UpdateSpeed()
end)

CreateToggle(SpeedTab, "Speed Correr", false, function(v)
    NYTRON.Settings.Speed_Run = v
    if v then NYTRON.Settings.Speed_Both = false end
    UpdateSpeed()
end)

CreateToggle(SpeedTab, "Speed Pular", false, function(v)
    NYTRON.Settings.Speed_Jump = v
    if v then NYTRON.Settings.Speed_Both = false end
    UpdateSpeed()
end)

CreateSlider(SpeedTab, "Velocidade Correr", 16, 150, 50, function(v)
    NYTRON.Settings.SpeedValue = v
    UpdateSpeed()
end)

CreateSlider(SpeedTab, "Força do Pulo", 50, 300, 120, function(v)
    NYTRON.Settings.JumpValue = v
    UpdateSpeed()
end)

-- ABA TELEPORT
CreateButton(TeleportTab, "🏠 Teleport Base/Spawn", TeleportToBase)
CreateButton(TeleportTab, "🎯 Teleport Aleatório", TeleportToRandom)
CreateButton(TeleportTab, "📌 Teleport Mais Próximo", TeleportToNearest)

-- ABA CONFIG
CreateButton(SettingsTab, "🗑 Limpar ESP", ClearESP)
CreateButton(SettingsTab, "🔄 Resetar Speed", function()
    NYTRON.Settings.Speed_Both = false
    NYTRON.Settings.Speed_Run = false
    NYTRON.Settings.Speed_Jump = false
    UpdateSpeed()
    ShowNotification("Config", "Speed resetado!", "info", 2)
end)

-- ============================================
-- ANIMAÇÃO DE LOADING
-- ============================================

task.spawn(function()
    local steps = {
        {0.15, "Verificando sistema..."},
        {0.30, "Carregando módulos..."},
        {0.50, "Preparando ESP..."},
        {0.70, "Preparando Speed..."},
        {0.85, "Preparando Teleport..."},
        {1.00, "Finalizando..."},
    }
    
    for _, step in ipairs(steps) do
        Tween(LoadingBar, {Size = UDim2.new(step[1], 0, 1, 0)}, 0.4)
        StatusText.Text = step[2]
        task.wait(0.5)
    end
    
    task.wait(0.3)
    Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
    task.wait(0.5)
    LoadingFrame.Visible = false
    LoginFrame.Visible = true
end)

-- ============================================
-- SISTEMA DE LOGIN
-- ============================================

LoginButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    
    if key == NYTRON.Key then
        ShowNotification("Sucesso", "Logado com sucesso!", "success", 3)
        
        task.wait(1)
        LoginFrame.Visible = false
        
        -- Loading pós-login
        LoadingFrame.Visible = true
        LoadingFrame.BackgroundTransparency = 0
        LoadingBar.Size = UDim2.new(0, 0, 1, 0)
        StatusText.Text = "Iniciando script..."
        
        local steps2 = {
            {0.4, "Carregando interface..."},
            {0.7, "Aplicando configurações..."},
            {1.0, "Pronto!"},
        }
        
        for _, step in ipairs(steps2) do
            Tween(LoadingBar, {Size = UDim2.new(step[1], 0, 1, 0)}, 0.3)
            StatusText.Text = step[2]
            task.wait(0.4)
        end
        
        ShowNotification("Carregado", "Script carregado com sucesso!", "success", 3)
        task.wait(0.5)
        
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
        task.wait(0.5)
        LoadingFrame.Visible = false
        FloatingButton.Visible = true
        
    else
        ShowNotification("Erro", "Key inválida!", "error", 3)
        KeyInput.Text = ""
    end
end)

-- ============================================
-- BOTÃO FLUTUANTE
-- ============================================

FloatingButton.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
end)

-- ============================================
-- LOOP DE ATUALIZAÇÃO
-- ============================================

task.spawn(function()
    while task.wait(3) do
        if NYTRON.Settings.ESP_XRay or NYTRON.Settings.ESP_Names or NYTRON.Settings.ESP_Distance or NYTRON.Settings.ESP_Tracers or NYTRON.Settings.ESP_Self then
            UpdateESP()
        end
    end
end)

-- ============================================
-- PRINT FINAL
-- ============================================

print("═══════════════════════════════════════")
print("   NYTRON MODS - Steal a Brainrot V2")
print("   Key: NYTRON-INFINITO")
print("   Carregado com sucesso!")
print("═══════════════════════════════════════")
