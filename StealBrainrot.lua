--[[
    NYTRON - Steal a Brainrot V7
    ESP Laser + TP Base (com proteção)
    
    Key: NYTRON-INFINITO
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
local BasePosition = nil
local LaserAtivo = false
local LaserBeam = nil
local Logado = false
local TPLoop = nil

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_Steal"
ScreenGui.ResetOnSpawn = false
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
Instance.new("UIStroke", LoginFrame).Color = Green

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, 0, 0, 50)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "NYTRON"
LoginTitle.TextColor3 = Green
LoginTitle.TextSize = 22
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.Parent = LoginFrame

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
KeyInput.Parent = LoginFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

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
MainFrame.Size = UDim2.new(0, 200, 0, 175)
MainFrame.Position = UDim2.new(0, 15, 0.5, -87)
MainFrame.BackgroundColor3 = Dark
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Green

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Card
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NYTRON"
TitleLabel.TextColor3 = Green
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = Header

local function CriarBotao(texto, posY, cor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 32)
    btn.Position = UDim2.new(0, 8, 0, posY)
    btn.BackgroundColor3 = cor or Card
    btn.Text = texto
    btn.TextColor3 = cor == Green and Color3.fromRGB(0,0,0) or White
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local ESPBtn = CriarBotao("ESP BASE (OFF)", 40, Card)
local TPBtn = CriarBotao("TP BASE", 78, Green)
local SetBaseBtn = CriarBotao("MARCAR MINHA BASE", 116, Card)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -16, 0, 18)
StatusLabel.Position = UDim2.new(0, 8, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Base: Nao marcada"
StatusLabel.TextColor3 = Gray
StatusLabel.TextSize = 9
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

--========================================
-- FUNÇÕES
--========================================

local function Notify(texto, cor)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 220, 0, 40)
    notif.Position = UDim2.new(0.5, -110, 0, -50)
    notif.BackgroundColor3 = Dark
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", notif).Color = cor or Green
    
    local nText = Instance.new("TextLabel")
    nText.Size = UDim2.new(1, 0, 1, 0)
    nText.BackgroundTransparency = 1
    nText.Text = texto
    nText.TextColor3 = cor or Green
    nText.TextSize = 12
    nText.Font = Enum.Font.GothamMedium
    nText.Parent = notif
    
    notif:TweenPosition(UDim2.new(0.5, -110, 0, 15), "Out", "Back", 0.3, true)
    task.delay(1.5, function()
        notif:TweenPosition(UDim2.new(0.5, -110, 0, -50), "In", "Back", 0.2, true)
        task.delay(0.3, function() notif:Destroy() end)
    end)
end

-- ESP Laser
local function CriarLaser()
    if LaserBeam then
        pcall(function() LaserBeam.beam:Destroy() end)
        pcall(function() LaserBeam.basePart:Destroy() end)
    end
    
    local att0 = HumanoidRootPart:FindFirstChild("NYTRON_Att0") or Instance.new("Attachment")
    att0.Name = "NYTRON_Att0"
    att0.Parent = HumanoidRootPart
    
    local basePart = Instance.new("Part")
    basePart.Name = "NYTRON_BasePart"
    basePart.Size = Vector3.new(2, 2, 2)
    basePart.Position = BasePosition
    basePart.Anchored = true
    basePart.CanCollide = false
    basePart.Transparency = 0.5
    basePart.Color = Green
    basePart.Material = Enum.Material.Neon
    basePart.Parent = Workspace
    
    local att1 = Instance.new("Attachment")
    att1.Parent = basePart
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(Green)
    beam.LightEmission = 1
    beam.Transparency = NumberSequence.new(0.2)
    beam.Width0 = 1
    beam.Width1 = 1
    beam.FaceCamera = true
    beam.Parent = HumanoidRootPart
    
    LaserBeam = {beam = beam, att0 = att0, basePart = basePart}
end

local function DestruirLaser()
    if LaserBeam then
        pcall(function() LaserBeam.beam:Destroy() end)
        pcall(function() LaserBeam.att0:Destroy() end)
        pcall(function() LaserBeam.basePart:Destroy() end)
        LaserBeam = nil
    end
end

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
        Notify("ESP Ativado!")
    else
        ESPBtn.Text = "ESP BASE (OFF)"
        ESPBtn.BackgroundColor3 = Card
        ESPBtn.TextColor3 = White
        DestruirLaser()
        Notify("ESP Desativado!")
    end
end

-- TP BASE COM PROTEÇÃO
local function TPBase()
    if not BasePosition then
        Notify("Marque sua base primeiro!", Color3.fromRGB(255, 80, 80))
        return
    end
    
    Notify("Teleportando...")
    
    -- Posição de destino (no chão, não no ar)
    local destino = CFrame.new(BasePosition.X, BasePosition.Y, BasePosition.Z)
    
    -- Parar loop anterior
    if TPLoop then
        TPLoop:Disconnect()
        TPLoop = nil
    end
    
    -- PROTEÇÃO: Salvar e modificar estados
    local oldHealth = Humanoid.Health
    local oldMaxHealth = Humanoid.MaxHealth
    local oldWalkSpeed = Humanoid.WalkSpeed
    local oldJumpPower = Humanoid.JumpPower
    
    -- Tentar god mode temporário
    pcall(function()
        Humanoid.Health = Humanoid.MaxHealth
    end)
    
    -- Desativar dano temporariamente (se possível)
    local healthConnection
    pcall(function()
        healthConnection = Humanoid.HealthChanged:Connect(function(health)
            if health < oldMaxHealth then
                Humanoid.Health = oldMaxHealth
            end
        end)
    end)
    
    -- Zerar velocidade
    pcall(function()
        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    
    -- Teleport em loop
    local startTime = tick()
    local teleportCount = 0
    
    TPLoop = RunService.Heartbeat:Connect(function()
        teleportCount = teleportCount + 1
        
        if tick() - startTime > 0.8 then
            TPLoop:Disconnect()
            TPLoop = nil
            
            -- Desconectar proteção de vida
            if healthConnection then
                healthConnection:Disconnect()
            end
            
            -- Curar depois do TP
            pcall(function()
                Humanoid.Health = Humanoid.MaxHealth
            end)
            
            Notify("Teleportado!")
            return
        end
        
        -- Teleport
        pcall(function()
            HumanoidRootPart.CFrame = destino
        end)
        
        pcall(function()
            Character:PivotTo(destino)
        end)
        
        -- Manter velocidade zerada
        pcall(function()
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
        
        -- Manter vida cheia durante TP
        pcall(function()
            if Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end)
end

local function MarcarBase()
    BasePosition = HumanoidRootPart.Position
    StatusLabel.Text = "Base: Marcada!"
    StatusLabel.TextColor3 = Green
    Notify("Base marcada aqui!")
    
    if LaserAtivo then
        DestruirLaser()
        CriarLaser()
    end
end

--========================================
-- EVENTOS
--========================================

LoginBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text:upper()
    if key == "NYTRON-INFINITO" then
        LoginFrame.Visible = false
        MainFrame.Visible = true
        Logado = true
        Notify("Logado com sucesso!")
    else
        LoginStatus.Text = "Key invalida!"
    end
end)

ESPBtn.MouseButton1Click:Connect(ToggleESP)
TPBtn.MouseButton1Click:Connect(TPBase)
SetBaseBtn.MouseButton1Click:Connect(MarcarBase)

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
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    if LaserAtivo and BasePosition then
        task.wait(1)
        CriarLaser()
    end
end)

print("[NYTRON] V7 Carregado!")
print("[NYTRON] Key: NYTRON-INFINITO")
