--[[
    NYTRON - Steal a Brainrot V8
    ESP + TP + Speed + Pulo + Anti Hit
    
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

-- Estados dos toggles
local SpeedAtivo = false
local PuloAtivo = false
local AntiHitAtivo = false

-- Valores originais
local OriginalSpeed = 16
local OriginalJump = 50

-- Conexões
local AntiHitConnection = nil

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
MainFrame.Size = UDim2.new(0, 200, 0, 290)
MainFrame.Position = UDim2.new(0, 15, 0.5, -145)
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

-- Função criar botão
local function CriarBotao(texto, posY, cor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 28)
    btn.Position = UDim2.new(0, 8, 0, posY)
    btn.BackgroundColor3 = cor or Card
    btn.Text = texto
    btn.TextColor3 = cor == Green and Color3.fromRGB(0,0,0) or White
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Botões
local ESPBtn = CriarBotao("ESP BASE (OFF)", 40, Card)
local TPBtn = CriarBotao("TP BASE", 72, Green)
local SetBaseBtn = CriarBotao("MARCAR BASE", 104, Card)

-- Separador
local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(1, -16, 0, 1)
Sep.Position = UDim2.new(0, 8, 0, 140)
Sep.BackgroundColor3 = Gray
Sep.Parent = MainFrame

-- Novos botões
local SpeedBtn = CriarBotao("SPEED (OFF)", 148, Card)
local PuloBtn = CriarBotao("PULO ALTO (OFF)", 180, Card)
local AntiHitBtn = CriarBotao("ANTI HIT (OFF)", 212, Card)

-- Status
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
    notif.Size = UDim2.new(0, 200, 0, 35)
    notif.Position = UDim2.new(0.5, -100, 0, -40)
    notif.BackgroundColor3 = Dark
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", notif).Color = cor or Green
    
    local nText = Instance.new("TextLabel")
    nText.Size = UDim2.new(1, 0, 1, 0)
    nText.BackgroundTransparency = 1
    nText.Text = texto
    nText.TextColor3 = cor or Green
    nText.TextSize = 11
    nText.Font = Enum.Font.GothamMedium
    nText.Parent = notif
    
    notif:TweenPosition(UDim2.new(0.5, -100, 0, 10), "Out", "Back", 0.3, true)
    task.delay(1.2, function()
        notif:TweenPosition(UDim2.new(0.5, -100, 0, -40), "In", "Back", 0.2, true)
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
        Notify("Marque sua base!", Color3.fromRGB(255, 80, 80))
        return
    end
    
    LaserAtivo = not LaserAtivo
    
    if LaserAtivo then
        ESPBtn.Text = "ESP BASE (ON)"
        ESPBtn.BackgroundColor3 = Green
        ESPBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        CriarLaser()
        Notify("ESP ON")
    else
        ESPBtn.Text = "ESP BASE (OFF)"
        ESPBtn.BackgroundColor3 = Card
        ESPBtn.TextColor3 = White
        DestruirLaser()
        Notify("ESP OFF")
    end
end

-- TP BASE
local function TPBase()
    if not BasePosition then
        Notify("Marque sua base!", Color3.fromRGB(255, 80, 80))
        return
    end
    
    local destino = CFrame.new(BasePosition.X, BasePosition.Y, BasePosition.Z)
    
    if TPLoop then TPLoop:Disconnect() end
    
    local healthConn
    pcall(function()
        healthConn = Humanoid.HealthChanged:Connect(function()
            Humanoid.Health = Humanoid.MaxHealth
        end)
    end)
    
    local startTime = tick()
    TPLoop = RunService.Heartbeat:Connect(function()
        if tick() - startTime > 0.8 then
            TPLoop:Disconnect()
            if healthConn then healthConn:Disconnect() end
            pcall(function() Humanoid.Health = Humanoid.MaxHealth end)
            Notify("Teleportado!")
            return
        end
        
        pcall(function()
            HumanoidRootPart.CFrame = destino
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
    end)
end

local function MarcarBase()
    BasePosition = HumanoidRootPart.Position
    StatusLabel.Text = "Base: OK"
    StatusLabel.TextColor3 = Green
    Notify("Base marcada!")
    
    if LaserAtivo then
        DestruirLaser()
        CriarLaser()
    end
end

-- SPEED
local function ToggleSpeed()
    SpeedAtivo = not SpeedAtivo
    
    if SpeedAtivo then
        SpeedBtn.Text = "SPEED (ON)"
        SpeedBtn.BackgroundColor3 = Green
        SpeedBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        pcall(function()
            Humanoid.WalkSpeed = 80
        end)
        Notify("Speed ON")
    else
        SpeedBtn.Text = "SPEED (OFF)"
        SpeedBtn.BackgroundColor3 = Card
        SpeedBtn.TextColor3 = White
        pcall(function()
            Humanoid.WalkSpeed = OriginalSpeed
        end)
        Notify("Speed OFF")
    end
end

-- PULO ALTO
local function TogglePulo()
    PuloAtivo = not PuloAtivo
    
    if PuloAtivo then
        PuloBtn.Text = "PULO ALTO (ON)"
        PuloBtn.BackgroundColor3 = Green
        PuloBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        pcall(function()
            Humanoid.JumpPower = 120
            Humanoid.JumpHeight = 30
        end)
        Notify("Pulo Alto ON")
    else
        PuloBtn.Text = "PULO ALTO (OFF)"
        PuloBtn.BackgroundColor3 = Card
        PuloBtn.TextColor3 = White
        pcall(function()
            Humanoid.JumpPower = OriginalJump
            Humanoid.JumpHeight = 7.2
        end)
        Notify("Pulo Alto OFF")
    end
end

-- ANTI HIT / ANTI KNOCKBACK
local function ToggleAntiHit()
    AntiHitAtivo = not AntiHitAtivo
    
    if AntiHitAtivo then
        AntiHitBtn.Text = "ANTI HIT (ON)"
        AntiHitBtn.BackgroundColor3 = Green
        AntiHitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Anti Knockback: zera velocidade constantemente
        AntiHitConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local vel = HumanoidRootPart.Velocity
                -- Se velocidade for muito alta (knockback), zera
                if vel.Magnitude > 50 then
                    HumanoidRootPart.Velocity = Vector3.new(0, vel.Y, 0)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
                end
            end)
        end)
        
        Notify("Anti Hit ON")
    else
        AntiHitBtn.Text = "ANTI HIT (OFF)"
        AntiHitBtn.BackgroundColor3 = Card
        AntiHitBtn.TextColor3 = White
        
        if AntiHitConnection then
            AntiHitConnection:Disconnect()
            AntiHitConnection = nil
        end
        
        Notify("Anti Hit OFF")
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
        Notify("Logado!")
    else
        LoginStatus.Text = "Key invalida!"
    end
end)

ESPBtn.MouseButton1Click:Connect(ToggleESP)
TPBtn.MouseButton1Click:Connect(TPBase)
SetBaseBtn.MouseButton1Click:Connect(MarcarBase)
SpeedBtn.MouseButton1Click:Connect(ToggleSpeed)
PuloBtn.MouseButton1Click:Connect(TogglePulo)
AntiHitBtn.MouseButton1Click:Connect(ToggleAntiHit)

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
    
    -- Reaplicar configurações
    task.wait(0.5)
    
    if SpeedAtivo then
        pcall(function() Humanoid.WalkSpeed = 80 end)
    end
    
    if PuloAtivo then
        pcall(function() 
            Humanoid.JumpPower = 120
            Humanoid.JumpHeight = 30
        end)
    end
    
    if LaserAtivo and BasePosition then
        CriarLaser()
    end
    
    -- Reconectar Anti Hit
    if AntiHitAtivo then
        if AntiHitConnection then AntiHitConnection:Disconnect() end
        AntiHitConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local vel = HumanoidRootPart.Velocity
                if vel.Magnitude > 50 then
                    HumanoidRootPart.Velocity = Vector3.new(0, vel.Y, 0)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
                end
            end)
        end)
    end
end)

print("[NYTRON] V8 Carregado!")
print("[NYTRON] Key: NYTRON-INFINITO")
