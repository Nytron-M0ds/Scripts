--[[
    NYTRON - Steal a Brainrot
    ESP Laser + TP Base (leva brainrot junto)
    
    Key: NYTRON-INFINITO
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Limpar anterior
if CoreGui:FindFirstChild("NYTRON_Steal") then
    CoreGui:FindFirstChild("NYTRON_Steal"):Destroy()
end

-- Cores
local Green = Color3.fromRGB(0, 255, 100)
local Dark = Color3.fromRGB(15, 15, 18)
local Card = Color3.fromRGB(22, 22, 28)
local White = Color3.fromRGB(255, 255, 255)
local Gray = Color3.fromRGB(100, 100, 100)

-- Variáveis
local MinhaBase = nil
local BasePosition = nil
local LaserAtivo = false
local LaserBeam = nil
local LaserConnection = nil
local Logado = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_Steal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

--========================================
-- TELA DE LOGIN
--========================================
local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(0, 260, 0, 180)
LoginFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
LoginFrame.BackgroundColor3 = Dark
LoginFrame.Parent = ScreenGui
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 12)
local loginStroke = Instance.new("UIStroke", LoginFrame)
loginStroke.Color = Green
loginStroke.Thickness = 2

-- Logo/Titulo
local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, 0, 0, 50)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "🔒 NYTRON"
LoginTitle.TextColor3 = Green
LoginTitle.TextSize = 22
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.Parent = LoginFrame

-- Input Key
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -30, 0, 38)
KeyInput.Position = UDim2.new(0, 15, 0, 55)
KeyInput.BackgroundColor3 = Card
KeyInput.Text = ""
KeyInput.PlaceholderText = "Key aqui"
KeyInput.PlaceholderColor3 = Gray
KeyInput.TextColor3 = White
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = LoginFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

-- Botao Login
local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(1, -30, 0, 38)
LoginBtn.Position = UDim2.new(0, 15, 0, 105)
LoginBtn.BackgroundColor3 = Green
LoginBtn.Text = "ENTRAR"
LoginBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
LoginBtn.TextSize = 14
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.Parent = LoginFrame
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

-- Status Login
local LoginStatus = Instance.new("TextLabel")
LoginStatus.Size = UDim2.new(1, 0, 0, 20)
LoginStatus.Position = UDim2.new(0, 0, 1, -25)
LoginStatus.BackgroundTransparency = 1
LoginStatus.Text = ""
LoginStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
LoginStatus.TextSize = 11
LoginStatus.Font = Enum.Font.Gotham
LoginStatus.Parent = LoginFrame

--========================================
-- PAINEL PRINCIPAL
--========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Position = UDim2.new(0, 20, 0.5, -100)
MainFrame.BackgroundColor3 = Dark
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Green
mainStroke.Thickness = 2

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Card
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Card
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NYTRON"
TitleLabel.TextColor3 = Green
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -32, 0.5, -12)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "▼"
MinBtn.TextColor3 = Gray
MinBtn.TextSize = 12
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Header

-- Container de botões
local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -20, 0, 145)
BtnContainer.Position = UDim2.new(0, 10, 0, 45)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = MainFrame

local BtnLayout = Instance.new("UIListLayout")
BtnLayout.Padding = UDim.new(0, 8)
BtnLayout.Parent = BtnContainer

-- Função criar botão
local function CriarBotao(texto, cor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = cor or Card
    btn.Text = texto
    btn.TextColor3 = cor == Green and Color3.fromRGB(0,0,0) or White
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = BtnContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- Botões
local ESPBtn = CriarBotao("ESP BASE (OFF)", Card)
local TPBtn = CriarBotao("TP BASE", Green)
local SetBaseBtn = CriarBotao("MARCAR BASE AQUI", Card)

--========================================
-- FUNÇÕES
--========================================

-- Notificação
local function Notify(texto, cor)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 45)
    notif.Position = UDim2.new(0.5, -125, 0, -50)
    notif.BackgroundColor3 = Dark
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    local nStroke = Instance.new("UIStroke", notif)
    nStroke.Color = cor or Green
    nStroke.Thickness = 2
    
    local nText = Instance.new("TextLabel")
    nText.Size = UDim2.new(1, 0, 1, 0)
    nText.BackgroundTransparency = 1
    nText.Text = texto
    nText.TextColor3 = cor or Green
    nText.TextSize = 13
    nText.Font = Enum.Font.GothamMedium
    nText.Parent = notif
    
    -- Animar entrada
    notif:TweenPosition(UDim2.new(0.5, -125, 0, 20), "Out", "Back", 0.4, true)
    
    task.delay(2, function()
        notif:TweenPosition(UDim2.new(0.5, -125, 0, -50), "In", "Back", 0.3, true)
        task.delay(0.4, function()
            notif:Destroy()
        end)
    end)
end

-- Criar Laser
local function CriarLaser()
    if LaserBeam then LaserBeam:Destroy() end
    
    -- Criar attachment no jogador
    local att0 = Instance.new("Attachment")
    att0.Name = "NYTRON_Att0"
    att0.Parent = HumanoidRootPart
    
    -- Criar part invisível na base
    local basePart = Instance.new("Part")
    basePart.Name = "NYTRON_BasePart"
    basePart.Size = Vector3.new(1, 1, 1)
    basePart.Position = BasePosition
    basePart.Anchored = true
    basePart.CanCollide = false
    basePart.Transparency = 1
    basePart.Parent = Workspace
    
    local att1 = Instance.new("Attachment")
    att1.Name = "NYTRON_Att1"
    att1.Parent = basePart
    
    -- Criar beam
    local beam = Instance.new("Beam")
    beam.Name = "NYTRON_Beam"
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(Green)
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Transparency = NumberSequence.new(0.3)
    beam.Width0 = 0.5
    beam.Width1 = 0.5
    beam.FaceCamera = true
    beam.Parent = HumanoidRootPart
    
    LaserBeam = {beam = beam, att0 = att0, att1 = att1, basePart = basePart}
end

-- Destruir Laser
local function DestruirLaser()
    if LaserBeam then
        pcall(function() LaserBeam.beam:Destroy() end)
        pcall(function() LaserBeam.att0:Destroy() end)
        pcall(function() LaserBeam.att1:Destroy() end)
        pcall(function() LaserBeam.basePart:Destroy() end)
        LaserBeam = nil
    end
end

-- Toggle ESP
local function ToggleESP()
    if not BasePosition then
        Notify("Marque sua base primeiro!", Color3.fromRGB(255, 80, 80))
        return
    end
    
    LaserAtivo = not LaserAtivo
    
    if LaserAtivo then
        ESPBtn.Text = "ESP BASE (ON)"
        ESPBtn.BackgroundColor3 = Green
        ESPBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        CriarLaser()
        Notify("ESP Base ativado!")
    else
        ESPBtn.Text = "ESP BASE (OFF)"
        ESPBtn.BackgroundColor3 = Card
        ESPBtn.TextColor3 = White
        DestruirLaser()
        Notify("ESP Base desativado!")
    end
end

-- TP Base (leva tudo junto)
local function TPBase()
    if not BasePosition then
        Notify("Marque sua base primeiro!", Color3.fromRGB(255, 80, 80))
        return
    end
    
    -- Teleportar jogador
    local destino = BasePosition + Vector3.new(0, 5, 0)
    
    -- Método 1: PivotTo (leva tudo que está anexado)
    pcall(function()
        Character:PivotTo(CFrame.new(destino))
    end)
    
    -- Método 2: CFrame backup
    pcall(function()
        HumanoidRootPart.CFrame = CFrame.new(destino)
    end)
    
    -- Pegar qualquer tool/brainrot que esteja segurando
    pcall(function()
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") or tool:IsA("Model") then
                -- A tool já vem junto com o personagem
            end
        end
    end)
    
    Notify("Teleportado pra base!")
end

-- Marcar Base
local function MarcarBase()
    BasePosition = HumanoidRootPart.Position
    Notify("Base marcada aqui!")
    
    -- Se ESP tava ativo, recriar laser
    if LaserAtivo then
        DestruirLaser()
        CriarLaser()
    end
end

--========================================
-- EVENTOS
--========================================

-- Login
LoginBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key == "NYTRON-INFINITO" or key == "nytron-infinito" then
        LoginStatus.Text = ""
        LoginFrame.Visible = false
        MainFrame.Visible = true
        Logado = true
        Notify("Logado com sucesso!")
    else
        LoginStatus.Text = "Key invalida!"
        LoginStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- Botões
ESPBtn.MouseButton1Click:Connect(ToggleESP)
TPBtn.MouseButton1Click:Connect(TPBase)
SetBaseBtn.MouseButton1Click:Connect(MarcarBase)

-- Minimizar
local minimizado = false
MinBtn.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    BtnContainer.Visible = not minimizado
    
    if minimizado then
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 45), "Out", "Quad", 0.2, true)
        MinBtn.Text = "▲"
    else
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 200), "Out", "Quad", 0.2, true)
        MinBtn.Text = "▼"
    end
end)

-- Draggable
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
Header.InputEnded:Connect(function() dragging = false end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Recriar laser se tava ativo
    if LaserAtivo and BasePosition then
        task.wait(1)
        CriarLaser()
    end
end)

print("[NYTRON] Script carregado!")
print("[NYTRON] Key: NYTRON-INFINITO")
