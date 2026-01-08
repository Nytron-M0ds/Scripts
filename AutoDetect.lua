--[[
    NYTRON Auto Detect
    Detecta automaticamente Base e Brainrots
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Limpar
if CoreGui:FindFirstChild("NYTRON_Auto") then
    CoreGui:FindFirstChild("NYTRON_Auto"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_Auto"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

-- Cores
local Green = Color3.fromRGB(0, 255, 100)
local Dark = Color3.fromRGB(18, 18, 22)
local Card = Color3.fromRGB(25, 25, 30)
local White = Color3.fromRGB(255, 255, 255)
local Gray = Color3.fromRGB(120, 120, 120)
local Red = Color3.fromRGB(255, 80, 80)
local Yellow = Color3.fromRGB(255, 200, 50)

-- Dados encontrados
local MinhaBase = nil
local Brainrots = {}

-- UI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0.5, -150, 0.5, -200)
Main.BackgroundColor3 = Dark
Main.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = Main

local stroke = Instance.new("UIStroke")
stroke.Color = Green
stroke.Thickness = 2
stroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Card
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NYTRON - Auto Detect"
Title.TextColor3 = Green
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.new(0, 10, 0, 50)
Status.BackgroundTransparency = 1
Status.Text = "Clique em DETECTAR"
Status.TextColor3 = Gray
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

-- Botão Detectar
local DetectBtn = Instance.new("TextButton")
DetectBtn.Size = UDim2.new(1, -20, 0, 40)
DetectBtn.Position = UDim2.new(0, 10, 0, 80)
DetectBtn.BackgroundColor3 = Green
DetectBtn.Text = "DETECTAR TUDO"
DetectBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
DetectBtn.TextSize = 14
DetectBtn.Font = Enum.Font.GothamBold
DetectBtn.Parent = Main
Instance.new("UICorner", DetectBtn).CornerRadius = UDim.new(0, 8)

-- Resultado Base
local BaseLabel = Instance.new("TextLabel")
BaseLabel.Size = UDim2.new(1, -20, 0, 20)
BaseLabel.Position = UDim2.new(0, 10, 0, 135)
BaseLabel.BackgroundTransparency = 1
BaseLabel.Text = "SUA BASE:"
BaseLabel.TextColor3 = Yellow
BaseLabel.TextSize = 12
BaseLabel.Font = Enum.Font.GothamBold
BaseLabel.TextXAlignment = Enum.TextXAlignment.Left
BaseLabel.Parent = Main

local BaseResult = Instance.new("TextLabel")
BaseResult.Size = UDim2.new(1, -20, 0, 25)
BaseResult.Position = UDim2.new(0, 10, 0, 155)
BaseResult.BackgroundColor3 = Card
BaseResult.Text = " Nao detectado"
BaseResult.TextColor3 = Gray
BaseResult.TextSize = 11
BaseResult.Font = Enum.Font.Gotham
BaseResult.TextXAlignment = Enum.TextXAlignment.Left
BaseResult.Parent = Main
Instance.new("UICorner", BaseResult).CornerRadius = UDim.new(0, 5)

-- Botão TP Base
local TPBaseBtn = Instance.new("TextButton")
TPBaseBtn.Size = UDim2.new(1, -20, 0, 30)
TPBaseBtn.Position = UDim2.new(0, 10, 0, 185)
TPBaseBtn.BackgroundColor3 = Card
TPBaseBtn.Text = "TELEPORTAR PRA BASE"
TPBaseBtn.TextColor3 = Green
TPBaseBtn.TextSize = 11
TPBaseBtn.Font = Enum.Font.GothamMedium
TPBaseBtn.Parent = Main
Instance.new("UICorner", TPBaseBtn).CornerRadius = UDim.new(0, 6)

-- Resultado Brainrots
local BrainLabel = Instance.new("TextLabel")
BrainLabel.Size = UDim2.new(1, -20, 0, 20)
BrainLabel.Position = UDim2.new(0, 10, 0, 225)
BrainLabel.BackgroundTransparency = 1
BrainLabel.Text = "BRAINROTS ENCONTRADOS:"
BrainLabel.TextColor3 = Red
BrainLabel.TextSize = 12
BrainLabel.Font = Enum.Font.GothamBold
BrainLabel.TextXAlignment = Enum.TextXAlignment.Left
BrainLabel.Parent = Main

-- Lista de Brainrots
local BrainList = Instance.new("ScrollingFrame")
BrainList.Size = UDim2.new(1, -20, 0, 120)
BrainList.Position = UDim2.new(0, 10, 0, 248)
BrainList.BackgroundColor3 = Card
BrainList.ScrollBarThickness = 3
BrainList.ScrollBarImageColor3 = Green
BrainList.CanvasSize = UDim2.new(0, 0, 0, 0)
BrainList.Parent = Main
Instance.new("UICorner", BrainList).CornerRadius = UDim.new(0, 6)

local BrainLayout = Instance.new("UIListLayout")
BrainLayout.Padding = UDim.new(0, 3)
BrainLayout.Parent = BrainList

BrainLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    BrainList.CanvasSize = UDim2.new(0, 0, 0, BrainLayout.AbsoluteContentSize.Y + 5)
end)

-- Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 1, -40)
CloseBtn.BackgroundColor3 = Red
CloseBtn.Text = "FECHAR"
CloseBtn.TextColor3 = White
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Funções
local function Notify(text)
    Status.Text = text
end

local function ClearBrainList()
    for _, v in pairs(BrainList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function AddBrainItem(obj, dist)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 28)
    btn.BackgroundColor3 = Dark
    btn.Text = "  " .. obj.Name .. " (" .. math.floor(dist) .. "m)"
    btn.TextColor3 = White
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = BrainList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        if obj and obj:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            Notify("Teleportado para " .. obj.Name)
        elseif obj and obj.PrimaryPart then
            HumanoidRootPart.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            Notify("Teleportado para " .. obj.Name)
        elseif obj and obj:IsA("BasePart") then
            HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
            Notify("Teleportado para " .. obj.Name)
        end
    end)
end

local function DetectAll()
    Notify("Detectando...")
    MinhaBase = nil
    Brainrots = {}
    ClearBrainList()
    
    local playerName = Player.Name
    
    -- Procurar Base
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        
        -- Procura base pelo nome do jogador
        if name:find(playerName:lower()) or name:find("base") then
            if obj:IsA("Model") or obj:IsA("BasePart") then
                MinhaBase = obj
            end
        end
        
        -- Procura brainrots
        if name:find("brainrot") or name:find("brain") or name:find("rot") or name:find("mob") or name:find("enemy") or name:find("npc") then
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                table.insert(Brainrots, obj)
            elseif obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                table.insert(Brainrots, obj)
            end
        end
    end
    
    -- Também procura em pastas específicas
    local possibleFolders = {"Brainrots", "Mobs", "NPCs", "Enemies", "Entities", "Spawned"}
    for _, folderName in pairs(possibleFolders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in pairs(folder:GetChildren()) do
                if obj:IsA("Model") then
                    local found = false
                    for _, b in pairs(Brainrots) do
                        if b == obj then found = true break end
                    end
                    if not found then
                        table.insert(Brainrots, obj)
                    end
                end
            end
        end
    end
    
    -- Atualizar UI - Base
    if MinhaBase then
        BaseResult.Text = " " .. MinhaBase.Name
        BaseResult.TextColor3 = Green
    else
        BaseResult.Text = " Nao encontrado (clique TP pra ir pro spawn)"
        BaseResult.TextColor3 = Gray
    end
    
    -- Atualizar UI - Brainrots
    if #Brainrots > 0 then
        -- Ordenar por distância
        table.sort(Brainrots, function(a, b)
            local posA = a:FindFirstChild("HumanoidRootPart") and a.HumanoidRootPart.Position or (a.PrimaryPart and a.PrimaryPart.Position or Vector3.new(0,0,0))
            local posB = b:FindFirstChild("HumanoidRootPart") and b.HumanoidRootPart.Position or (b.PrimaryPart and b.PrimaryPart.Position or Vector3.new(0,0,0))
            return (posA - HumanoidRootPart.Position).Magnitude < (posB - HumanoidRootPart.Position).Magnitude
        end)
        
        for _, brain in pairs(Brainrots) do
            local pos = brain:FindFirstChild("HumanoidRootPart") and brain.HumanoidRootPart.Position or (brain.PrimaryPart and brain.PrimaryPart.Position or Vector3.new(0,0,0))
            local dist = (pos - HumanoidRootPart.Position).Magnitude
            AddBrainItem(brain, dist)
        end
        
        Notify("Encontrado: " .. #Brainrots .. " brainrots!")
    else
        Notify("Nenhum brainrot encontrado")
        
        -- Mostrar todos os Models do Workspace pra ajudar
        local allModels = {}
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") or obj:IsA("Folder") then
                table.insert(allModels, obj)
            end
        end
        
        for _, obj in pairs(allModels) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 28)
            btn.BackgroundColor3 = Dark
            btn.Text = "  [?] " .. obj.Name .. " (" .. obj.ClassName .. ")"
            btn.TextColor3 = Yellow
            btn.TextSize = 10
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = BrainList
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        end
        
        Notify("Mostrando itens do Workspace")
    end
end

-- Eventos
DetectBtn.MouseButton1Click:Connect(DetectAll)

TPBaseBtn.MouseButton1Click:Connect(function()
    if MinhaBase then
        local pos = MinhaBase:IsA("Model") and (MinhaBase.PrimaryPart and MinhaBase.PrimaryPart.Position or MinhaBase:GetModelCFrame().Position) or MinhaBase.Position
        HumanoidRootPart.CFrame = CFrame.new(pos) + Vector3.new(0, 10, 0)
        Notify("Teleportado pra base!")
    else
        -- Tenta ir pro spawn
        local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
        if spawn then
            HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            Notify("Teleportado pro spawn!")
        else
            HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            Notify("Teleportado pro centro do mapa!")
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Draggable
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Header.InputEnded:Connect(function() dragging = false end)
UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

print("[NYTRON] Auto Detect carregado!")
print("[NYTRON] Clique em DETECTAR TUDO")
