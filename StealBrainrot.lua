--[[
    NYTRON - Steal a Brainrot V9
    Métodos alternativos que funcionam!
    
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
local BasePosition = nil
local LaserAtivo = false
local LaserBeam = nil
local Logado = false

-- Estados
local SpeedAtivo = false
local PuloAtivo = false
local AntiHitAtivo = false
local TPAtivo = false

-- Conexões e objetos
local SpeedConnection = nil
local PuloConnection = nil
local AntiHitConnection = nil
local TPConnection = nil
local BodyVelocity = nil
local BodyPosition = nil

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

local ESPBtn = CriarBotao("ESP BASE (OFF)", 40, Card)
local TPBtn = CriarBotao("TP BASE (SEGURAR)", 72, Green)
local SetBaseBtn = CriarBotao("MARCAR BASE", 104, Card)

local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(1, -16, 0, 1)
Sep.Position = UDim2.new(0, 8, 0, 140)
Sep.BackgroundColor3 = Gray
Sep.Parent = MainFrame

local SpeedBtn = CriarBotao("SPEED (OFF)", 148, Card)
local PuloBtn = CriarBotao("PULO ALTO (OFF)", 180, Card)
local AntiHitBtn = CriarBotao("ANTI HIT (OFF)", 212, Card)

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

-- TP BASE - SEGURAR PRA FICAR
local function IniciarTP()
    if not BasePosition then
        Notify("Marque sua base!", Color3.fromRGB(255, 80, 80))
        return
    end
    
    TPAtivo = true
    Notify("Segure o botao...")
    
    local destino = CFrame.new(BasePosition.X, BasePosition.Y + 1, BasePosition.Z)
    
    -- Criar BodyPosition pra manter no lugar
    pcall(function()
        if BodyPosition then BodyPosition:Destroy() end
        BodyPosition = Instance.new("BodyPosition")
        BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyPosition.P = 100000
        BodyPosition.D = 1000
        BodyPosition.Position = destino.Position
        BodyPosition.Parent = HumanoidRootPart
    end)
    
    -- Loop de TP enquanto segura
    TPConnection = RunService.Heartbeat:Connect(function()
        if not TPAtivo then return end
        
        pcall(function()
            HumanoidRootPart.CFrame = destino
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            if BodyPosition then
                BodyPosition.Position = destino.Position
            end
        end)
    end)
end

local function PararTP()
    TPAtivo = false
    
    if TPConnection then
        TPConnection:Disconnect()
        TPConnection = nil
    end
    
    if BodyPosition then
        BodyPosition:Destroy()
        BodyPosition = nil
    end
    
    Notify("Solte pra andar!")
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

-- SPEED - Usando CFrame
local function ToggleSpeed()
    SpeedAtivo = not SpeedAtivo
    
    if SpeedAtivo then
        SpeedBtn.Text = "SPEED (ON)"
        SpeedBtn.BackgroundColor3 = Green
        SpeedBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        local speedMultiplier = 2.5
        
        SpeedConnection = RunService.RenderStepped:Connect(function(dt)
            pcall(function()
                local moveDir = Humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    local boost = moveDir * speedMultiplier
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(boost.X, 0, boost.Z)
                end
            end)
        end)
        
        Notify("Speed ON")
    else
        SpeedBtn.Text = "SPEED (OFF)"
        SpeedBtn.BackgroundColor3 = Card
        SpeedBtn.TextColor3 = White
        
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end
        
        Notify("Speed OFF")
    end
end

-- PULO ALTO - Usando BodyVelocity
local function TogglePulo()
    PuloAtivo = not PuloAtivo
    
    if PuloAtivo then
        PuloBtn.Text = "PULO ALTO (ON)"
        PuloBtn.BackgroundColor3 = Green
        PuloBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        PuloConnection = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                -- Criar impulso pra cima
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(0, math.huge, 0)
                bv.Velocity = Vector3.new(0, 100, 0)
                bv.Parent = HumanoidRootPart
                
                task.delay(0.2, function()
                    bv:Destroy()
                end)
            end)
        end)
        
        Notify("Pulo Alto ON")
    else
        PuloBtn.Text = "PULO ALTO (OFF)"
        PuloBtn.BackgroundColor3 = Card
        PuloBtn.TextColor3 = White
        
        if PuloConnection then
            PuloConnection:Disconnect()
            PuloConnection = nil
        end
        
        Notify("Pulo Alto OFF")
    end
end

-- ANTI HIT - Usando BodyPosition pra travar
local function ToggleAntiHit()
    AntiHitAtivo = not AntiHitAtivo
    
    if AntiHitAtivo then
        AntiHitBtn.Text = "ANTI HIT (ON)"
        AntiHitBtn.BackgroundColor3 = Green
        AntiHitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        local lastPos = HumanoidRootPart.Position
        local lastTime = tick()
        
        AntiHitConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local currentPos = HumanoidRootPart.Position
                local currentTime = tick()
                local dt = currentTime - lastTime
                
                if dt > 0 then
                    local speed = (currentPos - lastPos).Magnitude / dt
                    
                    -- Se velocidade muito alta (knockback), volta pro lugar
                    if speed > 100 then
                        HumanoidRootPart.CFrame = CFrame.new(lastPos)
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    else
                        lastPos = currentPos
                    end
                end
                
                lastTime = currentTime
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

-- TP - Segurar pra ficar
TPBtn.MouseButton1Down:Connect(IniciarTP)
TPBtn.MouseButton1Up:Connect(PararTP)
TPBtn.MouseLeave:Connect(function()
    if TPAtivo then PararTP() end
end)

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
    
    -- Limpar conexões antigas
    if SpeedConnection then SpeedConnection:Disconnect() SpeedConnection = nil end
    if PuloConnection then PuloConnection:Disconnect() PuloConnection = nil end
    if AntiHitConnection then AntiHitConnection:Disconnect() AntiHitConnection = nil end
    if TPConnection then TPConnection:Disconnect() TPConnection = nil end
    if BodyPosition then BodyPosition:Destroy() BodyPosition = nil end
    
    -- Resetar estados
    SpeedAtivo = false
    PuloAtivo = false
    AntiHitAtivo = false
    TPAtivo = false
    
    -- Atualizar botões
    SpeedBtn.Text = "SPEED (OFF)"
    SpeedBtn.BackgroundColor3 = Card
    SpeedBtn.TextColor3 = White
    
    PuloBtn.Text = "PULO ALTO (OFF)"
    PuloBtn.BackgroundColor3 = Card
    PuloBtn.TextColor3 = White
    
    AntiHitBtn.Text = "ANTI HIT (OFF)"
    AntiHitBtn.BackgroundColor3 = Card
    AntiHitBtn.TextColor3 = White
    
    if LaserAtivo and BasePosition then
        task.wait(1)
        CriarLaser()
    end
end)

print("[NYTRON] V9 Carregado!")
print("[NYTRON] Key: NYTRON-INFINITO")
