-- =======================================================
-- LOW PIECE MASTER V12.0 - SISTEMA DEFINITIVO DE AUTO-RAID
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoLobbyActivo = false

_G.RaidSelecionada = "DesertRaid"
_G.DificuldadeSelecionada = "NormalButton" -- Padrão

_G.RaioDaArea = 50
_G.MostrarArea = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV12") then 
    CoreGui.LowPieceMasterV12:Destroy() 
end

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
-- INTERFACE VISUAL COMPACTA E COMPLETA
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV12"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.35, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0, 5)
InfoLabel.Text = "Low Piece Raid Automática"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 14
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Main

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 30)
StatusLabel.Text = "Status: Parado"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 11
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

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

-- Seletor de Raids
local btnDesert = criarBotao("Desert", UDim2.new(0, 15, 0, 65), UDim2.new(0, 65, 0, 25), Color3.fromRGB(120, 90, 40), function() _G.RaidSelecionada = "DesertRaid" StatusLabel.Text = "Mapa: Desert" end)
local btnJojo = criarBotao("Jojo", UDim2.new(0, 90, 0, 65), UDim2.new(0, 65, 0, 25), Color3.fromRGB(40, 40, 45), function() _G.RaidSelecionada = "JojoRaid" StatusLabel.Text = "Mapa: Jojo" end)
local btnHall = criarBotao("Judgment", UDim2.new(0, 165, 0, 65), UDim2.new(0, 65, 0, 25), Color3.fromRGB(40, 40, 45), function() _G.RaidSelecionada = "JudgmentHallRaid" StatusLabel.Text = "Mapa: Judgment" end)
local btnSoul = criarBotao("SoulEater", UDim2.new(0, 240, 0, 65), UDim2.new(0, 65, 0, 25), Color3.fromRGB(40, 40, 45), function() _G.RaidSelecionada = "SoulEaterRaid" StatusLabel.Text = "Mapa: SoulEater" end)

local function resetBotaoLobbies()
    btnDesert.BackgroundColor3 = _G.RaidSelecionada == "DesertRaid" and Color3.fromRGB(120, 90, 40) or Color3.fromRGB(40, 40, 45)
    btnJojo.BackgroundColor3 = _G.RaidSelecionada == "JojoRaid" and Color3.fromRGB(120, 90, 40) or Color3.fromRGB(40, 40, 45)
    btnHall.BackgroundColor3 = _G.RaidSelecionada == "JudgmentHallRaid" and Color3.fromRGB(120, 90, 40) or Color3.fromRGB(40, 40, 45)
    btnSoul.BackgroundColor3 = _G.RaidSelecionada == "SoulEaterRaid" and Color3.fromRGB(120, 90, 40) or Color3.fromRGB(40, 40, 45)
end
btnDesert.MouseButton1Click:Connect(resetBotaoLobbies)
btnJojo.MouseButton1Click:Connect(resetBotaoLobbies)
btnHall.MouseButton1Click:Connect(resetBotaoLobbies)
btnSoul.MouseButton1Click:Connect(resetBotaoLobbies)

-- Seletor de Dificuldades
local btnEasy = criarBotao("Fácil", UDim2.new(0, 20, 0, 100), UDim2.new(0, 80, 0, 25), Color3.fromRGB(40, 40, 45), function() _G.DificuldadeSelecionada = "EasyButton" end)
local btnNormal = criarBotao("Normal", UDim2.new(0, 120, 0, 100), UDim2.new(0, 80, 0, 25), Color3.fromRGB(40, 80, 40), function() _G.DificuldadeSelecionada = "NormalButton" end)
local btnHard = criarBotao("Difícil", UDim2.new(0, 220, 0, 100), UDim2.new(0, 80, 0, 25), Color3.fromRGB(40, 40, 45), function() _G.DificuldadeSelecionada = "HardButton" end)

local function resetBotaoDificuldade()
    btnEasy.BackgroundColor3 = _G.DificuldadeSelecionada == "EasyButton" and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(40, 40, 45)
    btnNormal.BackgroundColor3 = _G.DificuldadeSelecionada == "NormalButton" and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(40, 40, 45)
    btnHard.BackgroundColor3 = _G.DificuldadeSelecionada == "HardButton" and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(40, 40, 45)
end
btnEasy.MouseButton1Click:Connect(resetBotaoDificuldade)
btnNormal.MouseButton1Click:Connect(resetBotaoDificuldade)
btnHard.MouseButton1Click:Connect(resetBotaoDificuldade)

-- Botões de Combate e Loop
local btnAutoLobby = criarBotao("LIGAR AUTO-RAID COMPLETO", UDim2.new(0, 20, 0, 140), UDim2.new(0, 260, 0, 35), Color3.fromRGB(90, 30, 30), function(btn)
    _G.AutoLobbyActivo = not _G.AutoLobbyActivo
    btn.BackgroundColor3 = _G.AutoLobbyActivo and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(90, 30, 30)
    btn.Text = _G.AutoLobbyActivo and "DESLIGAR AUTO-RAID COMPLETO" or "LIGAR AUTO-RAID COMPLETO"
end)

local btnPuxar = criarBotao("Puxar NPCs da Área", UDim2.new(0, 20, 0, 185), UDim2.new(0, 260, 0, 30), Color3.fromRGB(60, 45, 80), function(btn)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    btn.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

local btnClick = criarBotao("Simular Clique (Ataque)", UDim2.new(0, 20, 0, 220), UDim2.new(0, 260, 0, 30), Color3.fromRGB(45, 70, 55), function(btn)
    _G.AutoClickActivo = not _G.AutoClickActivo
    btn.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

local btnSkills = criarBotao("Simular Habilidades", UDim2.new(0, 20, 0, 255), UDim2.new(0, 260, 0, 30), Color3.fromRGB(70, 65, 45), function(btn)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    btn.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

local btnVerArea = criarBotao("Visualizar Área (Esfera)", UDim2.new(0, 20, 0, 290), UDim2.new(0, 260, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

criarBotao("Área +25", UDim2.new(0, 20, 0, 330), UDim2.new(0, 120, 0, 30), Color3.fromRGB(40, 40, 45), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
    InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
end)

criarBotao("Área -25", UDim2.new(0, 160, 0, 330), UDim2.new(0, 120, 0, 30), Color3.fromRGB(40, 40, 45), function()
    if _G.RaioDaArea > 25 then
        _G.RaioDaArea = _G.RaioDaArea - 25
        InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
    end
end)

-- =======================================================
-- FUNÇÕES COMPLEMENTARES DE COMBATE E SEGURANÇA
-- =======================================================

local function temNpcNaFrente(rootPlayer)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if not Players:GetPlayerFromCharacter(npcModel) then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                if rootNpc then
                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                    if distancia <= (_G.RaioDaArea + 15) then
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

-- =======================================================
-- LÓGICA CORE DA AUTOMAÇÃO CÍCLICA (CORRIGIDA)
-- =======================================================
task.spawn(function()
    while true do
        task.wait(1)
        
        if _G.AutoLobbyActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            
            if rootPlayer and playerGui then
                local raidUI = playerGui:FindFirstChild("RaidUI")
                local difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                
                -- VERIFICAÇÃO 1: ESTAMOS DENTRO DE UMA SALA DE COMBATE ATIVA?
                if temNpcNaFrente(rootPlayer) then
                    StatusLabel.Text = "Status: Em combate! Defendendo a Raid..."
                    
                    -- Liga os ataques automaticamente enquanto estiver dentro
                    _G.AutoClickActivo = true
                    _G.AutoSkillsActivo = true
                    _G.AgruparRaidActivo = true
                    
                    btnClick.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
                    btnSkills.BackgroundColor3 = Color3.fromRGB(160, 140, 50)
                    btnPuxar.BackgroundColor3 = Color3.fromRGB(110, 60, 160)
                    
                    -- Pausa o ciclo de teletransporte até a sala limpar
                    repeat task.wait(1) until not temNpcNaFrente(rootPlayer) or not _G.AutoLobbyActivo
                    
                else
                    -- VERIFICAÇÃO 2: O MENU DE ENTRADA DO LOBBY ESTÁ NA TELA?
                    if difficultyFrame and difficultyFrame.Visible then
                        StatusLabel.Text = "Status: Selecionando Dificuldade..."
                        
                        pcall(function()
                            local targetBtn = difficultyFrame:FindFirstChild(_G.DificuldadeSelecionada)
                            local startNowBtn = difficultyFrame:FindFirstChild("StartNowButton")
                            
                            -- Garante a seleção da dificuldade via cliques virtuais
                            if targetBtn and targetBtn.Visible then
                                local posTarget = targetBtn.AbsolutePosition
                                VirtualUser:ClickButton1(Vector2.new(posTarget.X + 15, posTarget.Y + 45))
                                task.wait(0.5)
                            end
                            
                            -- Inicia a Raid
                            if startNowBtn and startNowBtn.Visible then
                                local posStart = startNowBtn.AbsolutePosition
                                VirtualUser:ClickButton1(Vector2.new(posStart.X + 15, posStart.Y + 45))
                                StatusLabel.Text = "Status: Entrando na Raid..."
                                task.wait(3) -- Espera o jogo carregar o teletransporte interno
                            end
                        end)
                        
                    else
                        -- VERIFICAÇÃO 3: SE NÃO ESTÁ EM COMBATE E NÃO ESTÁ COM O MENU ABER, TELEPORTAR AO LOBBY
                        StatusLabel.Text = "Status: Buscando Lobby no mapa..."
                        
                        local raidSystem = workspace:FindFirstChild("RaidSystem")
                        local lobbies = raidSystem and raidSystem:FindFirstChild("Lobbies")
                        local alvoLobby = lobbies and lobbies:FindFirstChild(_G.RaidSelecionada)
                        
                        if alvoLobby then
                            local parteDestino = alvoLobby:IsA("BasePart") and alvoLobby or alvoLobby:FindFirstChildWhichIsA("BasePart")
                            
                            if parteDestino then
                                local distancia = (rootPlayer.Position - parteDestino.Position).Magnitude
                                
                                -- SÓ TELEPORTA SE ESTIVER A MAIS DE 30 BLING-STUDS DO LOBBY (Evita teletransporte em loop infinito)
                                if distancia > 30 then
                                    StatusLabel.Text = "Status: Teleportando para " .. _G.RaidSelecionada
                                    
                                    -- Pequena limpeza de velocidade linear para não bugar o anticheat
                                    rootPlayer.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                    rootPlayer.CFrame = parteDestino.CFrame * CFrame.new(0, 3, 0)
                                    
                                    task.wait(1.5) -- Tempo essencial para a interface gráfica do jogo registrar que você pisou no Lobby e abrir o painel
                                else
                                    StatusLabel.Text = "Status: Aguardando abertura do menu..."
                                end
                            end
                        else
                            StatusLabel.Text = "Status: Erro! Lobby não encontrado no mapa."
                        end
                    end
                end
            end
        end
    end
end)

print("[LOW PIECE] Script Master V12.0 Carregado.")
