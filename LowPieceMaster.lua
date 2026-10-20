-- =======================================================
-- LOW PIECE MASTER V8.0 - SISTEMA COMPACTO DE RAID (FIXED)
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.RaioDaArea = 50
_G.MostrarArea = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV6") then 
    CoreGui.LowPieceMasterV6:Destroy() 
end

-- Gerador de números pseudo-aleatórios para simulação humana
local rng = Random.new()

-- Indicador visual local da área
local IndicadorArea = Instance.new("Part")
IndicadorArea.Shape = Enum.PartType.Ball
IndicadorArea.Material = Enum.Material.ForceField
IndicadorArea.Color = Color3.fromRGB(0, 255, 255)
IndicadorArea.Transparency = 1
IndicadorArea.Anchored = true
IndicadorArea.CanCollide = false
IndicadorArea.Parent = workspace

-- =======================================================
-- INTERFACE VISUAL RE ESTRUTURADA E LIMPA
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV6"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 260)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 40)
InfoLabel.Position = UDim2.new(0, 0, 0, 5)
InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
InfoLabel.TextColor3 = Color3.fromRGB(160, 255, 160)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 13
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Main

local function criarBotao(texto, pos, tamanho, cor, acao)
    local btn = Instance.new("TextButton")
    btn.Size = tamanho
    btn.Position = pos
    btn.BackgroundColor3 = cor
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.Parent = Main
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    btn.MouseButton1Click:Connect(function() acao(btn) end)
    return btn
end

local btnPuxar = criarBotao("Puxar NPCs da Área", UDim2.new(0, 20, 0, 45), UDim2.new(0, 260, 0, 30), Color3.fromRGB(60, 45, 80), function(btn)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    btn.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

local btnClick = criarBotao("Simular Clique (Ataque)", UDim2.new(0, 20, 0, 80), UDim2.new(0, 260, 0, 30), Color3.fromRGB(45, 70, 55), function(btn)
    _G.AutoClickActivo = not _G.AutoClickActivo
    btn.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

local btnSkills = criarBotao("Simular Habilidades", UDim2.new(0, 20, 0, 115), UDim2.new(0, 260, 0, 30), Color3.fromRGB(70, 65, 45), function(btn)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    btn.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

local btnVerArea = criarBotao("Visualizar Área (Esfera)", UDim2.new(0, 20, 0, 150), UDim2.new(0, 260, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

criarBotao("Área +25", UDim2.new(0, 20, 0, 195), UDim2.new(0, 120, 0, 30), Color3.fromRGB(40, 40, 45), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
    InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
end)

criarBotao("Área -25", UDim2.new(0, 160, 0, 195), UDim2.new(0, 120, 0, 30), Color3.fromRGB(40, 40, 45), function()
    if _G.RaioDaArea > 25 then
        _G.RaioDaArea = _G.RaioDaArea - 25
        InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
    end
end)

-- =======================================================
-- LOOPS E SISTEMAS INDEPENDENTES (CLIENT-SIDE)
-- =======================================================

-- Função para verificar se há algum NPC válido por perto para bater
local function temNpcNaFrente(rootPlayer)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if not Players:GetPlayerFromCharacter(npcModel) then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                if rootNpc then
                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                    if distancia <= (_G.RaioDaArea + 5) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- 1. Loop de Monitoramento Físico de Puxada e Indicadores
task.spawn(function()
    while true do
        task.wait(0.1)
        local character = LocalPlayer.Character
        local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
        
        if rootPlayer then
            if _G.MostrarArea then
                IndicadorArea.Size = Vector3.new(_G.RaioDaArea * 2, _G.RaioDaArea * 2, _G.RaioDaArea * 2)
                IndicadorArea.CFrame = rootPlayer.CFrame
                IndicadorArea.Transparency = 0.8
            else
                IndicadorArea.Transparency = 1
            end
            
            if _G.AgruparRaidActivo then
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
                            local npcModel = obj.Parent
                            -- Trava estrita para ignorar jogadores reais
                            if not Players:GetPlayerFromCharacter(npcModel) then
                                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                                if rootNpc then
                                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                                    -- Só puxa se já estiver na ilha/área de alcance configurada
                                    if distancia <= _G.RaioDaArea then
                                        -- Remove colisão local temporária nas partes para não bugar
                                        for _, part in pairs(npcModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.CanCollide = false
                                            end
                                        end
                                        -- Posiciona rigidamente na frente do player
                                        rootNpc.CFrame = rootPlayer.CFrame * CFrame.new(0, 0, -4)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        else
            IndicadorArea.Transparency = 1
        end
    end
end)

-- 2. Loop de Auto-Clique Humanizado Condicional
task.spawn(function()
    while true do
        -- Atraso dinâmico de pessoa real jogando (entre 150ms e 300ms por clique)
        local delayClique = rng:NextNumber(0.15, 0.30)
        task.wait(delayClique)
        
        if _G.AutoClickActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
            end
        end
    end
end)

-- 3. Loop de Habilidades Humanizadas Condicionais (Teclado Z, X, C, V)
local chaves = {"z", "x", "c", "v"}
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoSkillsActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function()
                    for _, tecla in pairs(chaves) do
                        if not _G.AutoSkillsActivo or not temNpcNaFrente(rootPlayer) then break end
                        
                        -- Simulação do pressionar mecânico humano da tecla (40ms a 90ms pressionado)
                        VirtualUser:SetKeyDown(tecla)
                        task.wait(rng:NextNumber(0.04, 0.09))
                        VirtualUser:SetKeyUp(tecla)
                        
                        -- Tempo de reação mental humano para soltar a próxima skill (400ms a 850ms)
                        task.wait(rng:NextNumber(0.40, 0.85))
                    end
                end)
            end
        end
    end
end)

print("[LOW PIECE] Script Master V8.0 carregado com sucesso.")
