--[[
    NYTRON Multi TP
    Varios metodos de teleport - um vai funcionar!
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Limpar
if CoreGui:FindFirstChild("NYTRON_TP") then
    CoreGui:FindFirstChild("NYTRON_TP"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_TP"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

-- Cores
local Green = Color3.fromRGB(0, 255, 100)
local Dark = Color3.fromRGB(18, 18, 22)
local Card = Color3.fromRGB(25, 25, 30)
local White = Color3.fromRGB(255, 255, 255)
local Gray = Color3.fromRGB(120, 120, 120)

-- Metodo atual
local MetodoAtual = 1
local Metodos = {"CFrame", "Tween", "MoveTo", "Velocity", "PivotTo"}

-- Funcoes de TP
local function TP_CFrame(pos)
    pcall(function()
        HumanoidRootPart.CFrame = CFrame.new(pos)
    end)
end

local function TP_Tween(pos)
    pcall(function()
        local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(pos)})
        tween:Play()
    end)
end

local function TP_MoveTo(pos)
    pcall(function()
        Humanoid:MoveTo(pos)
    end)
end

local function TP_Velocity(pos)
    pcall(function()
        local diff = pos - HumanoidRootPart.Position
        HumanoidRootPart.Velocity = diff * 5
        task.wait(0.2)
        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.CFrame = CFrame.new(pos)
    end)
end

local function TP_PivotTo(pos)
    pcall(function()
        Character:PivotTo(CFrame.new(pos))
    end)
end

local function Teleport(pos)
    local metodo = Metodos[MetodoAtual]
    
    if metodo == "CFrame" then
        TP_CFrame(pos)
    elseif metodo == "Tween" then
        TP_Tween(pos)
    elseif metodo == "MoveTo" then
        TP_MoveTo(pos)
    elseif metodo == "Velocity" then
        TP_Velocity(pos)
    elseif metodo == "PivotTo" then
        TP_PivotTo(pos)
    end
end

-- UI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.5, -160)
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
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Card
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "NYTRON - Multi TP"
Title.TextColor3 = Green
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

-- Metodo Label
local MetodoLabel = Instance.new("TextLabel")
MetodoLabel.Size = UDim2.new(1, -20, 0, 20)
MetodoLabel.Position = UDim2.new(0, 10, 0, 45)
MetodoLabel.BackgroundTransparency = 1
MetodoLabel.Text = "Metodo: " .. Metodos[MetodoAtual]
MetodoLabel.TextColor3 = White
MetodoLabel.TextSize = 12
MetodoLabel.Font = Enum.Font.Gotham
MetodoLabel.Parent = Main

-- Botao Trocar Metodo
local TrocarBtn = Instance.new("TextButton")
TrocarBtn.Size = UDim2.new(1, -20, 0, 35)
TrocarBtn.Position = UDim2.new(0, 10, 0, 70)
TrocarBtn.BackgroundColor3 = Card
TrocarBtn.Text = "TROCAR METODO"
TrocarBtn.TextColor3 = Green
TrocarBtn.TextSize = 12
TrocarBtn.Font = Enum.Font.GothamMedium
TrocarBtn.Parent = Main
Instance.new("UICorner", TrocarBtn).CornerRadius = UDim.new(0, 6)

-- Separador
local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(1, -20, 0, 1)
Sep.Position = UDim2.new(0, 10, 0, 115)
Sep.BackgroundColor3 = Gray
Sep.Parent = Main

-- Coordenadas
local CoordsLabel = Instance.new("TextLabel")
CoordsLabel.Size = UDim2.new(1, -20, 0, 20)
CoordsLabel.Position = UDim2.new(0, 10, 0, 125)
CoordsLabel.BackgroundTransparency = 1
CoordsLabel.Text = "Coordenadas (X, Y, Z):"
CoordsLabel.TextColor3 = Gray
CoordsLabel.TextSize = 11
CoordsLabel.Font = Enum.Font.Gotham
CoordsLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordsLabel.Parent = Main

-- Input X
local InputX = Instance.new("TextBox")
InputX.Size = UDim2.new(0, 75, 0, 30)
InputX.Position = UDim2.new(0, 10, 0, 150)
InputX.BackgroundColor3 = Card
InputX.Text = "0"
InputX.PlaceholderText = "X"
InputX.TextColor3 = White
InputX.TextSize = 12
InputX.Font = Enum.Font.Gotham
InputX.Parent = Main
Instance.new("UICorner", InputX).CornerRadius = UDim.new(0, 5)

-- Input Y
local InputY = Instance.new("TextBox")
InputY.Size = UDim2.new(0, 75, 0, 30)
InputY.Position = UDim2.new(0, 95, 0, 150)
InputY.BackgroundColor3 = Card
InputY.Text = "50"
InputY.PlaceholderText = "Y"
InputY.TextColor3 = White
InputY.TextSize = 12
InputY.Font = Enum.Font.Gotham
InputY.Parent = Main
Instance.new("UICorner", InputY).CornerRadius = UDim.new(0, 5)

-- Input Z
local InputZ = Instance.new("TextBox")
InputZ.Size = UDim2.new(0, 75, 0, 30)
InputZ.Position = UDim2.new(0, 180, 0, 150)
InputZ.BackgroundColor3 = Card
InputZ.Text = "0"
InputZ.PlaceholderText = "Z"
InputZ.TextColor3 = White
InputZ.TextSize = 12
InputZ.Font = Enum.Font.Gotham
InputZ.Parent = Main
Instance.new("UICorner", InputZ).CornerRadius = UDim.new(0, 5)

-- Botao TP Coords
local TPCoordsBtn = Instance.new("TextButton")
TPCoordsBtn.Size = UDim2.new(1, -20, 0, 35)
TPCoordsBtn.Position = UDim2.new(0, 10, 0, 190)
TPCoordsBtn.BackgroundColor3 = Green
TPCoordsBtn.Text = "TELEPORTAR"
TPCoordsBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
TPCoordsBtn.TextSize = 13
TPCoordsBtn.Font = Enum.Font.GothamBold
TPCoordsBtn.Parent = Main
Instance.new("UICorner", TPCoordsBtn).CornerRadius = UDim.new(0, 6)

-- Separador 2
local Sep2 = Instance.new("Frame")
Sep2.Size = UDim2.new(1, -20, 0, 1)
Sep2.Position = UDim2.new(0, 10, 0, 235)
Sep2.BackgroundColor3 = Gray
Sep2.Parent = Main

-- Posicao Atual
local PosLabel = Instance.new("TextLabel")
PosLabel.Size = UDim2.new(1, -20, 0, 40)
PosLabel.Position = UDim2.new(0, 10, 0, 245)
PosLabel.BackgroundTransparency = 1
PosLabel.Text = "Sua posicao: carregando..."
PosLabel.TextColor3 = Gray
PosLabel.TextSize = 10
PosLabel.Font = Enum.Font.Gotham
PosLabel.TextWrapped = true
PosLabel.Parent = Main

-- Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 1, -40)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Text = "FECHAR"
CloseBtn.TextColor3 = White
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Eventos
TrocarBtn.MouseButton1Click:Connect(function()
    MetodoAtual = MetodoAtual + 1
    if MetodoAtual > #Metodos then MetodoAtual = 1 end
    MetodoLabel.Text = "Metodo: " .. Metodos[MetodoAtual]
end)

TPCoordsBtn.MouseButton1Click:Connect(function()
    local x = tonumber(InputX.Text) or 0
    local y = tonumber(InputY.Text) or 50
    local z = tonumber(InputZ.Text) or 0
    Teleport(Vector3.new(x, y, z))
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Atualizar posicao
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if HumanoidRootPart then
            local pos = HumanoidRootPart.Position
            PosLabel.Text = string.format("Sua posicao: X=%.1f  Y=%.1f  Z=%.1f", pos.X, pos.Y, pos.Z)
        end
        task.wait(0.5)
    end
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
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

print("[NYTRON] Multi TP carregado!")
print("[NYTRON] Troque o metodo ate um funcionar!")
