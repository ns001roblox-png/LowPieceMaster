-- =======================================================
-- LOW PIECE MASTER V14.0 - FLUXO INTEGRADO E ANTI-DANO
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoLobbyActivo = false
_G.RaioDaArea = 60
_G.DistanciaAtaqueNpc = 12 -- Distância segura aumentada
_G.MostrarArea = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local RaidSelecionada = "DesertRaid"
local DificuldadeSelecionada = "Normal"
local PassoTeleport = 0 -- Controle de etapas do fluxo

local CaminhoLobbies = {
    ["DesertRaid"] = "DesertRaid",
    ["JojoRaid"] = "JojoRaid",
    ["JudgmentHallRaid"] = "JudgmentHallRaid",
    ["SoulEaterRaid"] = "SoulEaterRaid"
}

if CoreGui:FindFirstChild("LowPieceMasterV14") then 
    CoreGui.LowPieceMasterV14:Destroy() 
end

local rng = Random.new()
local IndicadorArea = Instance.new("Part")
IndicadorArea.Shape = Enum.PartType.Ball
IndicadorArea.Material = Enum.Material.ForceField
IndicadorArea.Color = Color3.fromRGB(0, 255, 255)
IndicadorArea.Transparency = 1
IndicadorArea.Anchored = true
IndicadorArea.CanCollide = false
IndicadorArea.Parent = workspace

-- =======================================================
-- INTERFACE VISUAL
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV14"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 310)
Main.Position = UDim2.new(0.35, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0, 5)
InfoLabel.Text = "Status: Pronto"
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
    btn.TextSize = 10
    btn.Parent = Main
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    btn.MouseButton1Click:Connect(function() acao(btn) end)
    return btn
end

-- Seletores de Raids
criarBotao("Desert", UDim2.new(0, 15, 0, 40), UDim2.new(0, 65, 0, 25), Color3.fromRGB(130, 90, 40), function() RaidSelecionada = "DesertRaid" InfoLabel.Text = "Selecionado: Desert" end)
criarBotao("Jojo", UDim2.new(0, 85, 0, 40), UDim2.new(0, 65, 0, 25), Color3.fromRGB(40, 50, 90), function() RaidSelecionada = "JojoRaid" InfoLabel.Text = "Selecionado: Jojo" end)
criarBotao("Judgment", UDim2.new(0, 155, 0, 40), UDim2.new(0, 75, 0, 25), Color3.fromRGB(70, 40, 80), function() RaidSelecionada = "JudgmentHallRaid" InfoLabel.Text = "Selecionado: Judgment" end)
criarBotao("SoulEater", UDim2.new(0, 235, 0, 40), UDim2.new(0, 70, 0, 25), Color3.fromRGB(90, 40, 40), function() RaidSelecionada = "SoulEaterRaid" InfoLabel.Text = "Selecionado: SoulEater" end)

-- Seletores de Dificuldade
criarBotao("Fácil", UDim2.new(0, 15, 0, 75), UDim2.new(0, 90, 0, 25), Color3.fromRGB(40, 40, 40), function() DificuldadeSelecionada = "Easy" InfoLabel.Text = "Dificuldade: Fácil" end)
criarBotao("Normal", UDim2.new(0, 115, 0, 75), UDim2.new(0, 90, 0, 25), Color3.fromRGB(50, 80, 50), function() DificuldadeSelecionada = "Normal" InfoLabel.Text = "Dificuldade: Normal" end)
criarBotao("Difícil", UDim2.new(0, 215, 0, 75), UDim2.new(0, 90, 0, 25), Color3.fromRGB(40, 40, 40), function() DificuldadeSelecionada = "Hard" InfoLabel.Text = "Dificuldade: Difícil" end)

-- Controles Manuais
local btnPuxar = criarBotao("Puxar NPCs", UDim2.new(0, 15, 0, 110), UDim2.new(0, 140, 0, 30), Color3.fromRGB(60, 45, 80), function(btn)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    btn.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

local btnClick = criarBotao("Auto Clicker", UDim2.new(0, 165, 0, 110), UDim2.new(0, 140, 0, 30), Color3.fromRGB(45, 70, 55), function(btn)
    _G.AutoClickActivo = not _G.AutoClickActivo
    btn.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

local btnSkills = criarBotao("Auto Skills", UDim2.new(0, 15, 0, 145), UDim2.new(0, 140, 0, 30), Color3.fromRGB(70, 65, 45), function(btn)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    btn.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

local btnVerArea = criarBotao("Ver Área", UDim2.new(0, 165, 0, 145), UDim2.new(0, 140, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

-- Switch Mestre
local btnAutoLobby = criarBotao("INICIAR AUTOMAÇÃO SISTÊMICA", UDim2.new(0, 15, 0, 190), UDim2.new(0, 290, 0, 35), Color3.fromRGB(150, 30, 30), function(btn)
    _G.AutoLobbyActivo = not _G.AutoLobbyActivo
    PassoTeleport = 0
    if not _G.AutoLobbyActivo then
        _G.AutoClickActivo = false
        _G.AgruparRaidActivo = false
        _G.AutoSkillsActivo = false
    end
    btn.BackgroundColor3 = _G.AutoLobbyActivo and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(150, 30, 30)
    btn.Text = _G.AutoLobbyActivo and "AUTOMAÇÃO ATIVA (RODANDO)" or "INICIAR AUTOMAÇÃO SISTÊMICA"
end)

criarBotao("Distância NPCs +2 studs", UDim2.new(0, 15, 0, 235), UDim2.new(0, 290, 0, 25), Color3.fromRGB(40, 45, 60), function()
    _G.DistanciaAtaqueNpc = _G.DistanciaAtaqueNpc + 2
    InfoLabel.Text = "Afastamento Atual: " .. _G.DistanciaAtaqueNpc .. " studs"
end)

-- =======================================================
-- SISTEMAS INTERNOS
-- =======================================================

local function obterLobbyAlvo()
    local raidSys = workspace:FindFirstChild("RaidSystem")
    local lobbies = raidSys and raidSys:FindFirstChild("Lobbies")
    return lobbies and lobbies:FindFirstChild(CaminhoLobbies[RaidSelecionada])
end

local function temNpcNaFrente(rootPlayer)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if not Players:GetPlayerFromCharacter(npcModel) then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                if rootNpc and (rootPlayer.Position - rootNpc.Position).Magnitude <= _G.RaioDaArea then
                    return true
                end
            end
        end
    end
    return false
end

-- Loop de Movimentação dos NPCs (Distanciamento Seguro)
task.spawn(function()
    while true do
        task.wait(0.02)
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
                                if rootNpc and (rootPlayer.Position - rootNpc.Position).Magnitude <= _G.RaioDaArea then
                                    for _, part in pairs(npcModel:GetDescendants()) do
                                        if part:IsA("BasePart") then part.CanCollide = false end
                                    end
                                    -- Trava os NPCs no plano horizontal afastado e levemente rebaixado
                                    rootNpc.CFrame = rootPlayer.CFrame * CFrame.new(0, -3, -_G.DistanciaAtaqueNpc)
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

-- Loop de Detecção / Gatilho de Combate Automático
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoLobbyActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                -- Ativação por presença: Encontrou NPC, liga os módulos na hora
                _G.AutoClickActivo = true
                _G.AgruparRaidActivo = true
                _G.AutoSkillsActivo = true
                InfoLabel.Text = "Status: Combatendo Ameaças"
            end
        end
    end
end)

-- Loop de Ataques Automáticos
task.spawn(function()
    while true do
        task.wait(rng:NextNumber(0.12, 0.22))
        if _G.AutoClickActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function() VirtualUser:ClickButton1(Vector2.new(0, 0)) end)
            end
        end
    end
end)

-- Loop de Skills
task.spawn(function()
    local chaves = {"z", "x", "c", "v"}
    while true do
        task.wait(0.3)
        if _G.AutoSkillsActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function()
                    for _, tecla in pairs(chaves) do
                        if not _G.AutoSkillsActivo or not temNpcNaFrente(rootPlayer) then break end
                        VirtualUser:SetKeyDown(tecla)
                        task.wait(rng:NextNumber(0.04, 0.07))
                        VirtualUser:SetKeyUp(tecla)
                        task.wait(rng:NextNumber(0.40, 0.65))
                    end
                end)
            end
        end
    end
end)

-- MAQUINA DE ESTADOS DO LOBBY: TELEPORTE -> ESPERA -> RAIDUI CLICK
task.spawn(function()
    while true do
        task.wait(0.5)
        
        if _G.AutoLobbyActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            
            if rootPlayer and playerGui then
                -- Se o combate estiver ativo, congela o fluxo do lobby
                if temNpcNaFrente(rootPlayer) then
                    PassoTeleport = 2 
                else
                    local lobbyObj = obterLobbyAlvo()
                    if lobbyObj then
                        local rootLobby = lobbyObj:IsA("BasePart") and lobbyObj or lobbyObj:FindFirstChildWhichIsA("BasePart")
                        
                        if rootLobby then
                            local distancia = (rootPlayer.Position - rootLobby.Position).Magnitude
                            
                            -- ESTÁGIO 0: Teleporta uma vez para o Lobby
                            if PassoTeleport == 0 then
                                if distancia > 15 then
                                    InfoLabel.Text = "Status: Teleportando ao Lobby..."
                                    rootPlayer.CFrame = rootLobby.CFrame * CFrame.new(0, 3, 0)
                                    task.wait(1)
                                end
                                PassoTeleport = 1
                            
                            -- ESTÁGIO 1: Espera estar fisicamente perto e aguarda a RaidUI surgir
                            elseif PassoTeleport == 1 then
                                InfoLabel.Text = "Status: Aguardando Interface Visual..."
                                
                                local raidUI = playerGui:FindFirstChild("RaidUI")
                                local difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                                
                                -- Quando o menu aparecer na tela, faz os cliques automáticos rápidos
                                if difficultyFrame and difficultyFrame.Visible and distancia <= 22 then
                                    pcall(function()
                                        local btnDificuldade = difficultyFrame:FindFirstChild(DificuldadeSelecionada .. "Button")
                                        local startNowBtn = difficultyFrame:FindFirstChild("StartNowButton")
                                        
                                        if btnDificuldade and btnDificuldade.Visible then
                                            local pos = btnDificuldade.AbsolutePosition
                                            VirtualUser:ClickButton1(Vector2.new(pos.X + 10, pos.Y + 40))
                                            task.wait(0.3)
                                        end
                                        
                                        if startNowBtn and startNowBtn.Visible then
                                            local posStart = startNowBtn.AbsolutePosition
                                            VirtualUser:ClickButton1(Vector2.new(posStart.X + 10, posStart.Y + 40))
                                            InfoLabel.Text = "Status: Transicionando para Arena!"
                                            
                                            -- Desliga temporariamente os ataques para a tela de carregamento
                                            _G.AutoClickActivo = false
                                            _G.AgruparRaidActivo = false
                                            _G.AutoSkillsActivo = false
                                            
                                            PassoTeleport = 0 -- Reseta a máquina para o próximo ciclo de partidas
                                            task.wait(6)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("[LOW PIECE] Master V14 Carregado Corretamente.")
