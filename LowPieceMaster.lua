-- =======================================================
-- LOW PIECE MASTER V10.1 - SISTEMA COMPACTO DE RAID AUTOMÁTICO (FIXED)
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoLobbyActivo = false

_G.RaidSelecionada = "DesertRaid"
_G.DificuldadeSelecionada = "Normal"
_G.RaioDaArea = 50
_G.MostrarArea = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV10_Fixed") then 
    CoreGui.LowPieceMasterV10_Fixed:Destroy() 
end

local rng = Random.new()

-- Indicador visual da área
local IndicadorArea = Instance.new("Part")
IndicadorArea.Shape = Enum.PartType.Ball
IndicadorArea.Material = Enum.Material.ForceField
IndicadorArea.Color = Color3.fromRGB(0, 255, 255)
IndicadorArea.Transparency = 1
IndicadorArea.Anchored = true
IndicadorArea.CanCollide = false
IndicadorArea.Parent = workspace

-- Interface Visual Reestruturada
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV10_Fixed"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.35, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0, 5)
InfoLabel.Text = "Low Piece Master V10.1"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 14
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Main

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 1, -30)
StatusLabel.Text = "Status: Aguardando Comando..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 11
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

local function criarBotao(texto, pos, tamanho, cor, acao, parent)
    local btn = Instance.new("TextButton")
    btn.Size = tamanho
    btn.Position = pos
    btn.BackgroundColor3 = cor
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.Parent = parent or Main
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    btn.MouseButton1Click:Connect(function() acao(btn) end)
    return btn
end

-- Botões de Combate Alternáveis
local btnPuxar = criarBotao("Puxar NPCs", UDim2.new(0, 15, 0, 40), UDim2.new(0, 140, 0, 30), Color3.fromRGB(60, 45, 80), function(btn)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    btn.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

local btnClick = criarBotao("Auto Clique", UDim2.new(0, 165, 0, 40), UDim2.new(0, 140, 0, 30), Color3.fromRGB(45, 70, 55), function(btn)
    _G.AutoClickActivo = not _G.AutoClickActivo
    btn.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

local btnSkills = criarBotao("Auto Habilidades", UDim2.new(0, 15, 0, 75), UDim2.new(0, 140, 0, 30), Color3.fromRGB(70, 65, 45), function(btn)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    btn.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

local btnVerArea = criarBotao("Visualizar Área", UDim2.new(0, 165, 0, 75), UDim2.new(0, 140, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

-- Painel de Seleção de Raid
local RaidFrame = Instance.new("Frame")
RaidFrame.Size = UDim2.new(0, 290, 0, 100)
RaidFrame.Position = UDim2.new(0, 15, 0, 115)
RaidFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
RaidFrame.BorderSizePixel = 0
RaidFrame.Parent = Main
local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 5) rc.Parent = RaidFrame

local RaidTitle = Instance.new("TextLabel")
RaidTitle.Size = UDim2.new(1, 0, 0, 20)
RaidTitle.Text = "Selecione a Raid alvo:"
RaidTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
RaidTitle.Font = Enum.Font.GothamBold
RaidTitle.TextSize = 10
RaidTitle.BackgroundTransparency = 1
RaidTitle.Parent = RaidFrame

local botoesRaid = {}
local raids = {"DesertRaid", "JojoRaid", "JudgmentHallRaid", "SoulEaterRaid"}

local function atualizarRaidBotoes()
    for nome, btn in pairs(botoesRaid) do
        btn.BackgroundColor3 = (_G.RaidSelecionada == nome) and Color3.fromRGB(45, 110, 165) or Color3.fromRGB(50, 50, 60)
    end
end

for i, nomeRaid in ipairs(raids) do
    local x = ((i-1) % 2) * 140 + 5
    local y = math.floor((i-1) / 2) * 35 + 25
    local btn = criarBotao(nomeRaid, UDim2.new(0, x, 0, y), UDim2.new(0, 135, 0, 30), Color3.fromRGB(50, 50, 60), function()
        _G.RaidSelecionada = nomeRaid
        atualizarRaidBotoes()
    end, RaidFrame)
    botoesRaid[nomeRaid] = btn
end
atualizarRaidBotoes()

-- Painel de Seleção de Dificuldade
local DifFrame = Instance.new("Frame")
DifFrame.Size = UDim2.new(0, 290, 0, 60)
DifFrame.Position = UDim2.new(0, 15, 0, 225)
DifFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
DifFrame.BorderSizePixel = 0
DifFrame.Parent = Main
local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(0, 5) dc.Parent = DifFrame

local DifTitle = Instance.new("TextLabel")
DifTitle.Size = UDim2.new(1, 0, 0, 20)
DifTitle.Text = "Selecione a Dificuldade:"
DifTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
DifTitle.Font = Enum.Font.GothamBold
DifTitle.TextSize = 10
DifTitle.BackgroundTransparency = 1
DifTitle.Parent = DifFrame

local botoesDif = {}
local dificuldades = {"Easy", "Normal", "Hard"}

local function atualizarDifBotoes()
    for nome, btn in pairs(botoesDif) do
        btn.BackgroundColor3 = (_G.DificuldadeSelecionada == nome) and Color3.fromRGB(165, 110, 45) or Color3.fromRGB(50, 50, 60)
    end
end

for i, nomeDif in ipairs(dificuldades) do
    local x = (i-1) * 92 + 5
    local btn = criarBotao(nomeDif, UDim2.new(0, x, 0, 25), UDim2.new(0, 88, 0, 30), Color3.fromRGB(50, 50, 60), function()
        _G.DificuldadeSelecionada = nomeDif
        atualizarDifBotoes()
    end, DifFrame)
    botoesDif[nomeDif] = btn
end
atualizarDifBotoes()

-- Botão Mestre de Automação do Loop Cíclico
local btnLoopMestre = criarBotao("INICIAR LOOP AUTOMÁTICO DE RAID", UDim2.new(0, 15, 0, 295), UDim2.new(0, 290, 0, 40), Color3.fromRGB(120, 40, 40), function(btn)
    _G.AutoLobbyActivo = not _G.AutoLobbyActivo
    if _G.AutoLobbyActivo then
        btn.BackgroundColor3 = Color3.fromRGB(50, 160, 90)
        btn.Text = "LOOP AUTOMÁTICO ATIVADO [ON]"
        
        -- Ativa dinamicamente os hacks utilitários de combate junto
        _G.AgruparRaidActivo = true
        _G.AutoClickActivo = true
        _G.AutoSkillsActivo = true
        
        btnPuxar.BackgroundColor3 = Color3.fromRGB(110, 60, 160)
        btnClick.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
        btnSkills.BackgroundColor3 = Color3.fromRGB(160, 140, 50)
    else
        btn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        btn.Text = "INICIAR LOOP AUTOMÁTICO DE RAID"
        StatusLabel.Text = "Status: Automação desligada."
    end
end)

criarBotao("Config: Raio +25", UDim2.new(0, 15, 0, 345), UDim2.new(0, 140, 0, 30), Color3.fromRGB(40, 40, 45), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
end)

criarBotao("Config: Raio -25", UDim2.new(0, 165, 0, 345), UDim2.new(0, 140, 0, 30), Color3.fromRGB(40, 40, 45), function()
    if _G.RaioDaArea > 25 then _G.RaioDaArea = _G.RaioDaArea - 25 end
end)


-- =======================================================
-- MÓDULOS DE VERIFICAÇÃO E COMBATE
-- =======================================================

local function temNpcNaFrente(rootPlayer)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if not Players:GetPlayerFromCharacter(npcModel) then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChildWhichIsA("BasePart")
                if rootNpc then
                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                    if distancia <= (_G.RaioDaArea + 10) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- 1. Loop Físico: Puxada Global de Inimigos e Indicadores de Área
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
                                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChildWhichIsA("BasePart")
                                if rootNpc and rootNpc ~= rootPlayer then
                                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                                    if distancia <= _G.RaioDaArea then
                                        for _, part in pairs(npcModel:GetDescendants()) do
                                            if part:IsA("BasePart") then part.CanCollide = false end
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

-- 2. Loop de Ataques por Clique M1
task.spawn(function()
    while true do
        task.wait(rng:NextNumber(0.15, 0.25))
        if _G.AutoClickActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function() VirtualUser:ClickButton1(Vector2.new(0, 0)) end)
            end
        end
    end
end)

-- 3. Loop de Ataques por Teclas Especiais (Skills)
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
                        task.wait(rng:NextNumber(0.04, 0.08))
                        VirtualUser:SetKeyUp(tecla)
                        task.wait(rng:NextNumber(0.40, 0.75))
                    end
                end)
            end
        end
    end
end)


-- =======================================================
-- NÚCLEO DA AUTOMAÇÃO CÍCLICA DE RAID E CORREÇÃO DE TELEPORT
-- =======================================================

task.spawn(function()
    while true do
        task.wait(1)
        
        if _G.AutoLobbyActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            
            if rootPlayer then
                -- Se já houver inimigos ativos por perto, o script entra em espera produtiva e luta
                if temNpcNaFrente(rootPlayer) then
                    StatusLabel.Text = "Status: Em combate! Limpando sala..."
                    task.wait(2)
                else
                    StatusLabel.Text = "Status: Procurando lobby selecionado..."
                    
                    -- Busca o caminho dinâmico da Raid que foi escolhida na tela
                    local caminhoLobby = workspace:臨時CFrameBusca(workspace:FindFirstChild("RaidSystem"))
                    local raidSystem = workspace:FindFirstChild("RaidSystem")
                    local lobbies = raidSystem and raidSystem:FindFirstChild("Lobbies")
                    local alvoLobby = lobbies and lobbies:FindFirstChild(_G.RaidSelecionada)
                    
                    if alvoLobby then
                        -- SOLUÇÃO UNIVERSAL DE TELEPORT: Usa GetPivot() para evitar erros se for modelo ou bloco
                        local localCFrame = nil
                        if alvoLobby:IsA("Model") then
                            localCFrame = alvoLobby:GetPivot()
                        elseif alvoLobby:IsA("BasePart") then
                            localCFrame = alvoLobby.CFrame
                        end
                        
                        if localCFrame then
                            local distanciaLobby = (rootPlayer.Position - localCFrame.Position).Magnitude
                            
                            -- Se estiver longe do lobby marcado, executa o deslocamento físico imediato
                            if distanciaLobby > 12 then
                                StatusLabel.Text = "Status: Teleportando para " .. _G.RaidSelecionada .. "..."
                                
                                -- Desativa temporariamente a gravidade e colisões locais para evitar travar no mapa
                                pcall(function()
                                    for _, part in pairs(character:GetDescendants()) do
                                        if part:IsA("BasePart") then part.CanCollide = false end
                                    end
                                    -- Teleporta com 3.5 studs de folga no eixo Y (altura)
                                    rootPlayer.CFrame = localCFrame * CFrame.new(0, 3.5, 0)
                                end)
                                
                                task.wait(0.6) -- Janela de tolerância para o Roblox carregar o mapa
                            end
                            
                            -- Gerenciamento de ativação dos Menus no Painel da Tela
                            if playerGui then
                                local raidUI = playerGui:FindFirstChild("RaidUI")
                                local difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                                
                                if difficultyFrame and difficultyFrame.Visible then
                                    StatusLabel.Text = "Status: Configurando Dificuldade (" .. _G.DificuldadeSelecionada .. ")..."
                                    
                                    pcall(function()
                                        -- Associa a escolha do painel ao botão correspondente da UI nativa
                                        local botaoAlvoDificuldade = difficultyFrame:FindFirstChild(_G.DificuldadeSelecionada .. "Button")
                                        local startNowBtn = difficultyFrame:FindFirstChild("StartNowButton")
                                        
                                        if botaoAlvoDificuldade and botaoAlvoDificuldade.Visible then
                                            local posDif = botaoAlvoDificuldade.AbsolutePosition
                                            VirtualUser:ClickButton1(Vector2.new(posDif.X + 15, posDif.Y + 45))
                                            task.wait(0.3)
                                        end
                                        
                                        if startNowBtn and startNowBtn.Visible then
                                            local posStart = startNowBtn.AbsolutePosition
                                            VirtualUser:ClickButton1(Vector2.new(posStart.X + 15, posStart.Y + 45))
                                            StatusLabel.Text = "Status: Raid Iniciada com Sucesso!"
                                            task.wait(3) -- Aguarda carregamento inicial da sala
                                        end
                                     pcall(function() end) end)
                                end
                            end
                        end
                    else
                        StatusLabel.Text = "⚠️ ERRO: O objeto '" .. _G.RaidSelecionada .. "' não foi achado no mapa!"
                        print("[LOW PIECE ERROR]: Não foi possível ler o caminho da Raid selecionada.")
                    end
                end
            end
        end
    end
end)

print("[LOW PIECE] Script Master V10.1 (Auto-Cycle & GetPivot Universal) Carregado!")
