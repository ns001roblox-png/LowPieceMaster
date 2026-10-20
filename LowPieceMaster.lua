-- =======================================================
-- LOW PIECE MASTER V7.0 - SISTEMA HUMANIADO DE RAID
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
local PhysicsService = game:GetService("PhysicsService")

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV7") then 
    CoreGui.LowPieceMasterV7:Destroy() 
end

-- Grupo de colisão para que os NPCs não colidam entre si ao serem agrupados
pcall(function()
    PhysicsService:RegisterCollisionGroup("RaidNpcsV7")
end)
PhysicsService:CollisionGroupSetCollidable("RaidNpcsV7", "RaidNpcsV7", false)

-- Indicador visual da área no Workspace do cliente
local IndicadorArea = Instance.new("Part")
IndicadorArea.Shape = Enum.PartType.Ball
IndicadorArea.Material = Enum.Material.ForceField
IndicadorArea.Color = Color3.fromRGB(0, 255, 255)
IndicadorArea.Transparency = 0.8
IndicadorArea.Anchored = true
IndicadorArea.CanCollide = false
IndicadorArea.Parent = workspace

-- =======================================================
-- INTERFACE VISUAL SIMPLIFICADA (SEM LISTAS)
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV7"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 310, 0, 260)
Main.Position = UDim2.new(0.35, 0, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 35)
InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
InfoLabel.TextColor3 = Color3.fromRGB(160, 255, 160)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 12
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
    btn.MouseButton1Click:Connect(acao)
    return btn
end

local btnPuxar = criarBotao("🧲 Puxar NPCs (Dentro da Área)", UDim2.new(0, 15, 0, 45), UDim2.new(0, 280, 0, 30), Color3.fromRGB(60, 45, 80), function(self)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    self.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

local btnClick = criarBotao("⚔️ Auto Clique Humano", UDim2.new(0, 15, 0, 80), UDim2.new(0, 280, 0, 30), Color3.fromRGB(45, 70, 55), function(self)
    _G.AutoClickActivo = not _G.AutoClickActivo
    self.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

local btnSkills = criarBotao("⚡ Habilidades Humanizadas (Z,X,C,V)", UDim2.new(0, 15, 0, 115), UDim2.new(0, 280, 0, 30), Color3.fromRGB(70, 65, 45), function(self)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    self.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

local btnVerArea = criarBotao("👁️ Visualizar Área (Esfera)", UDim2.new(0, 15, 0, 150), UDim2.new(0, 280, 0, 30), Color3.fromRGB(45, 60, 75), function(self)
    _G.MostrarArea = not _G.MostrarArea
    self.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

criarBotao("Área +25", UDim2.new(0, 15, 0, 190), UDim2.new(0, 135, 0, 30), Color3.fromRGB(40, 40, 45), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
    InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
end)

criarBotao("Área -25", UDim2.new(0, 160, 0, 190), UDim2.new(0, 135, 0, 30), Color3.fromRGB(40, 40, 45), function()
    if _G.RaioDaArea > 25 then
        _G.RaioDaArea = _G.RaioDaArea - 25
        InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
    end
end)

-- =======================================================
-- FUNÇÃO AUXILIAR: VERIFICA SE HÁ NPC ENFRENTE
-- =======================================================
local function temNpcNaFrente(rootPlayer)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if not Players:GetPlayerFromCharacter(npcModel) and npcModel ~= LocalPlayer.Character then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                if rootNpc then
                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                    if distancia <= _G.RaioDaArea then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- =======================================================
-- LOOPS MECÂNICOS HUMANIADOS
-- =======================================================

-- 1. Loop do Indicador e do Agrupamento Físico Restrito por Área
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
                            -- Garante restrição absoluta: ignora se for um player real
                            if not Players:GetPlayerFromCharacter(npcModel) and npcModel ~= character then
                                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                                if rootNpc then
                                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                                    -- Apenas puxa se já estiver fisicamente DENTRO do raio estipulado
                                    if distancia <= _G.RaioDaArea then
                                        for _, part in pairs(npcModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.CollisionGroup = "RaidNpcsV7"
                                            end
                                        end
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

-- 2. Loop de Cliques Condicionais e Humaniados (Random Delay)
local rngClick = Random.new()
task.spawn(function()
    while true do
        -- Delay randômico simulando o dedo de uma pessoa real (entre 140ms e 280ms)
        local delayHumano = rngClick:NextNumber(0.14, 0.28)
        task.wait(delayHumano)
        
        if _G.AutoClickActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            
            -- Só clica se houver fisicamente um NPC detectado na área próxima
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
            end
        end
    end
end)

-- 3. Loop de Habilidades Condicionais e Humaniadas (Simulação de Digitação Real)
local chavesHabilidades = {"z", "x", "c", "v"}
local rngSkill = Random.new()
task.spawn(function()
    while true do
        -- Delay de verificação geral entre combos
        task.wait(0.5)
        
        if _G.AutoSkillsActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            
            -- Só solta poderes se houver inimigos puxados na área próxima
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function()
                    for _, tecla in pairs(chavesHabilidades) do
                        if not _G.AutoSkillsActivo or not temNpcNaFrente(rootPlayer) then break end
                        
                        -- Simula o tempo que um ser humano leva para apertar uma tecla física (40ms a 90ms)
                        VirtualUser:SetKeyDown(tecla)
                        task.wait(rngSkill:NextNumber(0.04, 0.09))
                        VirtualUser:SetKeyUp(tecla)
                        
                        -- Tempo de espera realista entre soltar uma habilidade e a próxima (400ms a 850ms)
                        task.wait(rngSkill:NextNumber(0.4, 0.85))
                    end
                end)
            end
        end
    end
end)

print("[LOW PIECE] Script Master V7.0 inicializado com sucesso. Totalmente humanizado.")
