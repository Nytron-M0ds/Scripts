--[[
    NYTRON Explorer
    Visualize a estrutura do jogo
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Limpar anterior
if CoreGui:FindFirstChild("NYTRON_Explorer") then
    CoreGui:FindFirstChild("NYTRON_Explorer"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYTRON_Explorer"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

-- Cores
local Colors = {
    Green = Color3.fromRGB(0, 255, 100),
    Dark = Color3.fromRGB(18, 18, 22),
    Card = Color3.fromRGB(25, 25, 30),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(120, 120, 120),
    Folder = Color3.fromRGB(255, 200, 50),
    Part = Color3.fromRGB(100, 150, 255),
    Model = Color3.fromRGB(255, 100, 100),
    Script = Color3.fromRGB(100, 255, 100),
}

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
end

local function Stroke(p, col)
    local s = Instance.new("UIStroke")
    s.Color = col or Colors.Green
    s.Thickness = 1
    s.Parent = p
end

-- Painel Principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = Colors.Dark
Main.Parent = ScreenGui
Corner(Main, 10)
Stroke(Main, Colors.Green)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Colors.Card
Header.Parent = Main
Corner(Header, 10)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Colors.Card
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NYTRON Explorer"
Title.TextColor3 = Colors.Green
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
CloseBtn.BackgroundColor3 = Colors.Card
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Gray
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
Corner(CloseBtn, 5)

-- Path atual
local PathLabel = Instance.new("TextLabel")
PathLabel.Size = UDim2.new(1, -16, 0, 25)
PathLabel.Position = UDim2.new(0, 8, 0, 40)
PathLabel.BackgroundColor3 = Colors.Card
PathLabel.Text = " game"
PathLabel.TextColor3 = Colors.White
PathLabel.TextSize = 11
PathLabel.Font = Enum.Font.Gotham
PathLabel.TextXAlignment = Enum.TextXAlignment.Left
PathLabel.TextTruncate = Enum.TextTruncate.AtEnd
PathLabel.Parent = Main
Corner(PathLabel, 5)

-- Botão Voltar
local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 60, 0, 25)
BackBtn.Position = UDim2.new(0, 8, 0, 70)
BackBtn.BackgroundColor3 = Colors.Card
BackBtn.Text = "< Voltar"
BackBtn.TextColor3 = Colors.Green
BackBtn.TextSize = 11
BackBtn.Font = Enum.Font.GothamMedium
BackBtn.Parent = Main
Corner(BackBtn, 5)

-- Botão Copiar Path
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 80, 0, 25)
CopyBtn.Position = UDim2.new(0, 75, 0, 70)
CopyBtn.BackgroundColor3 = Colors.Card
CopyBtn.Text = "Copiar Path"
CopyBtn.TextColor3 = Colors.Green
CopyBtn.TextSize = 11
CopyBtn.Font = Enum.Font.GothamMedium
CopyBtn.Parent = Main
Corner(CopyBtn, 5)

-- Botão Workspace
local WSBtn = Instance.new("TextButton")
WSBtn.Size = UDim2.new(0, 80, 0, 25)
WSBtn.Position = UDim2.new(0, 162, 0, 70)
WSBtn.BackgroundColor3 = Colors.Green
WSBtn.Text = "Workspace"
WSBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
WSBtn.TextSize = 11
WSBtn.Font = Enum.Font.GothamMedium
WSBtn.Parent = Main
Corner(WSBtn, 5)

-- Botão Players
local PlayersBtn = Instance.new("TextButton")
PlayersBtn.Size = UDim2.new(0, 60, 0, 25)
PlayersBtn.Position = UDim2.new(0, 249, 0, 70)
PlayersBtn.BackgroundColor3 = Colors.Card
PlayersBtn.Text = "Players"
PlayersBtn.TextColor3 = Colors.Green
PlayersBtn.TextSize = 11
PlayersBtn.Font = Enum.Font.GothamMedium
PlayersBtn.Parent = Main
Corner(PlayersBtn, 5)

-- Lista de itens
local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(1, -16, 1, -110)
ListFrame.Position = UDim2.new(0, 8, 0, 102)
ListFrame.BackgroundColor3 = Colors.Card
ListFrame.ScrollBarThickness = 4
ListFrame.ScrollBarImageColor3 = Colors.Green
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.Parent = Main
Corner(ListFrame, 6)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = ListFrame

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end)

-- Variáveis
local CurrentPath = game
local PathHistory = {}

-- Função para obter cor por tipo
local function GetColor(obj)
    if obj:IsA("Folder") then return Colors.Folder
    elseif obj:IsA("Model") then return Colors.Model
    elseif obj:IsA("BasePart") then return Colors.Part
    elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then return Colors.Script
    else return Colors.White end
end

-- Função para obter ícone por tipo
local function GetIcon(obj)
    if obj:IsA("Folder") then return "📁"
    elseif obj:IsA("Model") then return "📦"
    elseif obj:IsA("BasePart") then return "🔷"
    elseif obj:IsA("Script") or obj:IsA("LocalScript") then return "📜"
    elseif obj:IsA("ModuleScript") then return "📗"
    elseif obj:IsA("Player") then return "👤"
    elseif obj:IsA("Humanoid") then return "🧍"
    elseif obj:IsA("Tool") then return "🔧"
    elseif obj:IsA("Sound") then return "🔊"
    elseif obj:IsA("Decal") or obj:IsA("Texture") then return "🖼"
    elseif obj:IsA("Light") then return "💡"
    elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then return "✨"
    elseif obj:IsA("BillboardGui") or obj:IsA("ScreenGui") or obj:IsA("SurfaceGui") then return "🖥"
    elseif obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then return "📡"
    elseif obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then return "🔗"
    elseif obj:IsA("ValueBase") then return "📊"
    else return "📄" end
end

-- Função para obter path completo
local function GetFullPath(obj)
    local path = obj.Name
    local current = obj.Parent
    while current and current ~= game do
        path = current.Name .. "." .. path
        current = current.Parent
    end
    return "game." .. path
end

-- Função para criar item na lista
local function CreateItem(obj)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -8, 0, 28)
    item.BackgroundColor3 = Colors.Dark
    item.Text = ""
    item.Parent = ListFrame
    Corner(item, 4)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 25, 1, 0)
    icon.Position = UDim2.new(0, 5, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = GetIcon(obj)
    icon.TextSize = 14
    icon.Parent = item
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -90, 1, 0)
    name.Position = UDim2.new(0, 30, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = obj.Name
    name.TextColor3 = GetColor(obj)
    name.TextSize = 12
    name.Font = Enum.Font.Gotham
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.Parent = item
    
    local class = Instance.new("TextLabel")
    class.Size = UDim2.new(0, 55, 1, 0)
    class.Position = UDim2.new(1, -60, 0, 0)
    class.BackgroundTransparency = 1
    class.Text = obj.ClassName
    class.TextColor3 = Colors.Gray
    class.TextSize = 9
    class.Font = Enum.Font.Gotham
    class.TextXAlignment = Enum.TextXAlignment.Right
    class.TextTruncate = Enum.TextTruncate.AtEnd
    class.Parent = item
    
    -- Hover
    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = Colors.Card
    end)
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = Colors.Dark
    end)
    
    -- Click
    item.MouseButton1Click:Connect(function()
        local children = {}
        pcall(function() children = obj:GetChildren() end)
        if #children > 0 then
            table.insert(PathHistory, CurrentPath)
            CurrentPath = obj
            LoadChildren(obj)
        end
    end)
    
    return item
end

-- Função para carregar filhos
function LoadChildren(parent)
    -- Limpar lista
    for _, v in pairs(ListFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    -- Atualizar path
    if parent == game then
        PathLabel.Text = " game"
    else
        PathLabel.Text = " " .. GetFullPath(parent)
    end
    
    -- Carregar filhos
    local children = {}
    pcall(function() children = parent:GetChildren() end)
    
    -- Ordenar: Folders primeiro, depois Models, depois resto
    table.sort(children, function(a, b)
        local aScore = a:IsA("Folder") and 1 or (a:IsA("Model") and 2 or 3)
        local bScore = b:IsA("Folder") and 1 or (b:IsA("Model") and 2 or 3)
        if aScore == bScore then
            return a.Name < b.Name
        end
        return aScore < bScore
    end)
    
    for _, child in pairs(children) do
        CreateItem(child)
    end
end

-- Eventos
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

BackBtn.MouseButton1Click:Connect(function()
    if #PathHistory > 0 then
        CurrentPath = table.remove(PathHistory)
        LoadChildren(CurrentPath)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    local path = PathLabel.Text:sub(2)
    if setclipboard then
        setclipboard(path)
    elseif toclipboard then
        toclipboard(path)
    end
    CopyBtn.Text = "Copiado!"
    task.delay(1, function()
        CopyBtn.Text = "Copiar Path"
    end)
end)

WSBtn.MouseButton1Click:Connect(function()
    PathHistory = {}
    CurrentPath = game:GetService("Workspace")
    LoadChildren(CurrentPath)
end)

PlayersBtn.MouseButton1Click:Connect(function()
    PathHistory = {}
    CurrentPath = game:GetService("Players")
    LoadChildren(CurrentPath)
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
Header.InputEnded:Connect(function(input)
    dragging = false
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Iniciar no Workspace
CurrentPath = game:GetService("Workspace")
LoadChildren(CurrentPath)

print("[NYTRON] Explorer carregado!")
