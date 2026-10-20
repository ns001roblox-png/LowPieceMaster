-- =======================================================
-- LOW PIECE MASTER V9.5 - SISTEMA COMPACTO DE RAID + AUTO TELEPORT LOBBY
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoLobbyActivo = false -- Nova automação de teletransporte e entrada automática
_G.RaioDaArea = 50
_G.MostrarArea = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- Tabelas de automação fornecidas por você (com tratamento seguro de carregamento)
local LobbiesRaid = {
	workspace:WaitForChild("RaidSystem"):WaitForChild("Lobbies"):WaitForChild("DesertRaid"),
	workspace:WaitForChild("RaidSystem"):WaitForChild("Lobbies"):WaitForChild("JojoRaid"),
	workspace:WaitForChild("RaidSystem"):WaitForChild("Lobbies"):WaitForChild("JudgmentHallRaid"),
	workspace:WaitForChild("RaidSystem"):WaitForChild("Lobbies"):WaitForChild("SoulEaterRaid"),
}

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV9_5") then 
    CoreGui.LowPieceMasterV9_5:Destroy() 
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
GUI.Name = "LowPieceMasterV9_5"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 300)
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

-- Botão de Ativação do Auto Teleport Lobby
local btnAutoLobby = criarBotao("Auto Teleport + Iniciar Raid", UDim2.new(0, 20, 0, 150), UDim2.new(0, 260, 0, 30), Color3.fromRGB(90, 40, 40), function(btn)
    _G.AutoLobbyActivo = not _G.AutoLobbyActivo
    btn.BackgroundColor3 = _G.AutoLobbyActivo and Color3.fromRGB(180, 60, 60) or Color3.fromRGB(90, 40, 40)
end)

local btnVerArea = criarBotao("Visualizar Área (Esfera)", UDim2.new(0, 20, 0, 185), UDim2.new(0, 260, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

criarBotao("Área +25", UDim2.new(0, 20, 0, 230), UDim2.new(0, 120, 0, 30), Color3.fromRGB(40, 40, 45), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
    InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
end)

criarBotao("Área -25", UDim2.new(0, 160, 0, 230), UDim2.new(0, 120, 0, 30), Color3.fromRGB(40, 40, 45), function()
    if _G.RaioDaArea > 25 then
        _G.RaioDaArea = _G.RaioDaArea - 25
        InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
    end
end)

-- =======================================================
-- LOOPS E SISTEMAS INDEPENDENTES (CLIENT-SIDE)
-- =======================================================

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

-- 1. Loop de Monitoramento Físico, Puxada e Indicadores
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
                            if not Players:GetPlayerFromCharacter(npcModel) then
                                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                                if rootNpc then
                                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                                    if distancia <= _G.RaioDaArea then
                                        for _, part in pairs(npcModel:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.CanCollide = false
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

-- 2. Loop de Auto-Clique Humanizado
task.spawn(function()
    while true do
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

-- 3. Loop de Habilidades (Z, X, C, V)
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
                        VirtualUser:SetKeyDown(tecla)
                        task.wait(rng:NextNumber(0.04, 0.09))
                        VirtualUser:SetKeyUp(tecla)
                        task.wait(rng:NextNumber(0.40, 0.85))
                    end
                end)
            end
        end
    end
end)

-- 4. NOVO: Automação Baseada em Teletransporte Direto para as Raids
task.spawn(function()
    while true do
        task.wait(0.5)
        
        if _G.AutoLobbyActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            
            if rootPlayer then
                local alvoLobby = nil
                for _, lobby in pairs(LobbiesRaid) do
                    if lobby and (lobby:IsA("BasePart") or lobby:FindFirstChild("HumanoidRootPart")) then
                        alvoLobby = lobby:IsA("BasePart") and lobby or lobby:FindFirstChild("HumanoidRootPart")
                        break
                    end
                end
                
                if alvoLobby then
                    local distanciaAtual = (rootPlayer.Position - alvoLobby.Position).Magnitude
                    
                    if distanciaAtual > 8 then
                        rootPlayer.CFrame = alvoLobby.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.5)
                    end
                    
                    if playerGui then
                        local raidUI = playerGui:FindFirstChild("RaidUI")
                        local difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                        
                        if difficultyFrame and difficultyFrame.Visible then
                            pcall(function()
                                local normalBtn = difficultyFrame:FindFirstChild("NormalButton")
                                local startNowBtn = difficultyFrame:FindFirstChild("StartNowButton")
                                
                                if normalBtn and normalBtn.Visible then
                                    local posNormal = normalBtn.AbsolutePosition
                                    VirtualUser:ClickButton1(Vector2.new(posNormal.X + 10, posNormal.Y + 40))
                                    task.wait(0.2)
                                end
                                
                                if startNowBtn and startNowBtn.Visible then
                                    local posStart = startNowBtn.AbsolutePosition
                                    VirtualUser:ClickButton1(Vector2.new(posStart.X + 10, posStart.Y + 40))
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

print("[LOW PIECE] Script Master V9.5 carregado com sucesso (Auto-Teleport integrado).")
