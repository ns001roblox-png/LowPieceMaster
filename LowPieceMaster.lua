-- =======================================================
-- LOW PIECE MASTER V10.0 - PAINEL AUTOMÁTICO DE RAIDS ANINHADO
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoRaidLoop = false        -- Controle do ciclo automático total
_G.RaidSelecionada = "DesertRaid" -- Padrão inicial
_G.DificuldadeSelecionada = "NormalButton" -- Padrão inicial
_G.RaioDaArea = 50
_G.MostrarArea = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV10") then 
    CoreGui.LowPieceMasterV10:Destroy() 
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
-- INTERFACE VISUAL EXPANDIDA (PAINEL COMPLETO)
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV10"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 480)
Main.Position = UDim2.new(0.35, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0, 5)
InfoLabel.Text = "CONFIGURAÇÕES DE COMBATE"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 12
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Main

local function criarBotao(texto, pos, tamanho, cor, acao, pai)
    local btn = Instance.new("TextButton")
    btn.Size = tamanho
    btn.Position = pos
    btn.BackgroundColor3 = cor
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.Parent = pai or Main
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    btn.MouseButton1Click:Connect(function() acao(btn) end)
    return btn
end

-- Botões de Combate Originais
local btnPuxar = criarBotao("Puxar NPCs da Área", UDim2.new(0, 20, 0, 35), UDim2.new(0, 280, 0, 30), Color3.fromRGB(60, 45, 80), function(btn)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    btn.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

local btnClick = criarBotao("Simular Clique (Ataque)", UDim2.new(0, 20, 0, 70), UDim2.new(0, 280, 0, 30), Color3.fromRGB(45, 70, 55), function(btn)
    _G.AutoClickActivo = not _G.AutoClickActivo
    btn.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

local btnSkills = criarBotao("Simular Habilidades", UDim2.new(0, 20, 0, 105), UDim2.new(0, 280, 0, 30), Color3.fromRGB(70, 65, 45), function(btn)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    btn.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

-- Divisor visual para a nova seção de automação de Raids
local Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 280, 0, 2)
Linha.Position = UDim2.new(0, 20, 0, 145)
Linha.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Linha.BorderSizePixel = 0
Linha.Parent = Main

local LabelRaids = Instance.new("TextLabel")
LabelRaids.Size = UDim2.new(1, 0, 0, 25)
LabelRaids.Position = UDim2.new(0, 0, 0, 150)
LabelRaids.Text = "GERENCIADOR E SELEÇÃO DE RAIDS"
LabelRaids.TextColor3 = Color3.fromRGB(255, 200, 100)
LabelRaids.Font = Enum.Font.GothamBold
LabelRaids.TextSize = 12
LabelRaids.BackgroundTransparency = 1
LabelRaids.Parent = Main

-- Listagem de botões seletores de Raids (Estilo Rádio: Apenas 1 ativo)
local botoesRaids = {}
local listaRaids = {"DesertRaid", "JojoRaid", "JudgmentHallRaid", "SoulEaterRaid"}

local function atualizarSelecaoRaid(nomeRaid)
    _G.RaidSelecionada = nomeRaid
    for nome, btn in pairs(botoesRaids) do
        if nome == nomeRaid then
            btn.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
            btn.Text = "[X] " .. nome
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.Text = "[ ] " .. nome
        end
    end
end

for i, nome in ipairs(listaRaids) do
    local posX = (i % 2 == 1) and 20 or 165
    local posY = 180 + (math.floor((i - 1) / 2) * 35)
    botoesRaids[nome] = criarBotao("[ ] " .. nome, UDim2.new(0, posX, 0, posY), UDim2.new(0, 135, 0, 30), Color3.fromRGB(35, 35, 45), function()
        atualizarSelecaoRaid(nome)
    end)
end
atualizarSelecaoRaid(_G.RaidSelecionada)

-- Listagem de botões seletores de Dificuldade
local botoesDificuldade = {}
local listaDificuldades = {
    {Exibicao = "Fácil", ID = "EasyButton"},
    {Exibicao = "Normal", ID = "NormalButton"},
    {Exibicao = "Difícil", ID = "HardButton"}
}

local function atualizarSelecaoDificuldade(idDificuldade)
    _G.DificuldadeSelecionada = idDificuldade
    for id, btn in pairs(botoesDificuldade) do
        if id == idDificuldade then
            btn.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
    end
end

for i, dif in ipairs(listaDificuldades) do
    local posX = 20 + ((i - 1) * 95)
    botoesDificuldade[dif.ID] = criarBotao(dif.Exibicao, UDim2.new(0, posX, 0, 260), UDim2.new(0, 85, 0, 30), Color3.fromRGB(40, 40, 50), function()
        atualizarSelecaoDificuldade(dif.ID)
    end)
end
atualizarSelecaoDificuldade(_G.DificuldadeSelecionada)

-- Botão Mestre de Início de Fluxo Automático Intermitente
local btnAutoRaid = criarBotao("INICIAR LOOP AUTOMÁTICO DE RAID", UDim2.new(0, 20, 0, 305), UDim2.new(0, 280, 0, 35), Color3.fromRGB(120, 35, 35), function(btn)
    _G.AutoRaidLoop = not _G.AutoRaidLoop
    if _G.AutoRaidLoop then
        btn.BackgroundColor3 = Color3.fromRGB(45, 140, 45)
        btn.Text = "LOOP DE RAID: ATIVADO (RODANDO)"
    else
        btn.BackgroundColor3 = Color3.fromRGB(120, 35, 35)
        btn.Text = "INICIAR LOOP AUTOMÁTICO DE RAID"
    end
end)

-- Controles de Tamanho do Raio
criarBotao("Área +25", UDim2.new(0, 20, 0, 355), UDim2.new(0, 135, 0, 30), Color3.fromRGB(30, 30, 35), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
end)
criarBotao("Área -25", UDim2.new(0, 165, 0, 355), UDim2.new(0, 135, 0, 30), Color3.fromRGB(30, 30, 35), function()
    if _G.RaioDaArea > 25 then _G.RaioDaArea = _G.RaioDaArea - 25 end
end)

local btnVerArea = criarBotao("Visualizar Área (Esfera)", UDim2.new(0, 20, 0, 395), UDim2.new(0, 280, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

-- Status Informativo de Estado de Fluxo
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 435)
StatusLabel.Text = "Status: Aguardando Inicialização..."
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

-- =======================================================
-- SISTEMAS CORE E AUTOMATISMOS CONDICIONAIS
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

-- Monitoramento Físico e Ajustes do Círculo de Alcance
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

-- Loops de Luta Originais (Ataques e Skills)
task.spawn(function()
    while true do
        task.wait(rng:NextNumber(0.15, 0.30))
        if _G.AutoClickActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            if rootPlayer and temNpcNaFrente(rootPlayer) then
                pcall(function() VirtualUser:ClickButton1(Vector2.new(0, 0)) end)
            end
        end
    end
end)

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
-- NOVO GERENCIADOR E FLUXO INTELIGENTE DO LOOP DE RAID
-- =======================================================
task.spawn(function()
    while true do
        task.wait(1)
        
        if _G.AutoRaidLoop then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            
            if rootPlayer and playerGui then
                local raidUI = playerGui:FindFirstChild("RaidUI")
                local difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                
                -- ETAPA 1: Verificar se você já está DENTRO da Raid lutando
                -- O jogo remove ou fecha o frame do Lobby/Dificuldade quando a Raid inicia.
                if not (difficultyFrame and difficultyFrame.Visible) and temNpcNaFrente(rootPlayer) then
                    StatusLabel.Text = "Status: Em combate na Raid. Aguardando conclusão..."
                    
                    -- Liga os módulos de ataque caso estejam desligados para garantir a vitória automática
                    _G.AutoClickActivo = true
                    _G.AutoSkillsActivo = true
                    _G.AgruparRaidActivo = true
                    
                    -- Espera ativa estruturada enquanto houver inimigos vivos na arena da Raid
                    repeat 
                        task.wait(2) 
                    until not _G.AutoRaidLoop or not temNpcNaFrente(rootPlayer)
                    
                    StatusLabel.Text = "Status: Raid finalizada! Aguardando transição..."
                    task.wait(5) -- Tempo técnico de segurança para carregamento ou retorno ao mapa principal
                end
                
                -- ETAPA 2: Processo de Teletransporte e Entrada (Fora da Raid ou no Lobby)
                if _G.AutoRaidLoop then
                    StatusLabel.Text = "Status: Localizando Lobby: " .. _G.RaidSelecionada
                    
                    local localLobby = workspace:SafeWaitForChild("RaidSystem", 3)
                        and workspace.RaidSystem:SafeWaitForChild("Lobbies", 3)
                        and workspace.RaidSystem.Lobbies:FindFirstChild(_G.RaidSelecionada)
                    
                    if localLobby then
                        local alvoPart = localLobby:IsA("BasePart") and localLobby or localLobby:FindFirstChild("HumanoidRootPart")
                        if alvoPart then
                            local distancia = (rootPlayer.Position - alvoPart.Position).Magnitude
                            
                            -- Executa teletransporte caso esteja distante do receptáculo da Raid
                            if distancia > 10 then
                                StatusLabel.Text = "Status: Teleportando para o Lobby..."
                                rootPlayer.CFrame = alvoPart.CFrame * CFrame.new(0, 3, 0)
                                task.wait(1.5) -- Tempo para sincronizar a interface do jogo com o servidor
                            end
                            
                            -- Interage com os Menus com base nas configurações selecionadas no Painel
                            raidUI = playerGui:FindFirstChild("RaidUI")
                            difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                            
                            if difficultyFrame and difficultyFrame.Visible then
                                StatusLabel.Text = "Status: Configurando Dificuldade e Iniciando..."
                                pcall(function()
                                    local btnDif = difficultyFrame:FindFirstChild(_G.DificuldadeSelecionada)
                                    local btnStart = difficultyFrame:FindFirstChild("StartNowButton")
                                    
                                    if btnDif and btnDif.Visible then
                                        local posDif = btnDif.AbsolutePosition
                                        VirtualUser:ClickButton1(Vector2.new(posDif.X + 10, posDif.Y + 40))
                                        task.wait(0.5)
                                    end
                                    
                                    if btnStart and btnStart.Visible then
                                        local posStart = btnStart.AbsolutePosition
                                        VirtualUser:ClickButton1(Vector2.new(posStart.X + 10, posStart.Y + 40))
                                        task.wait(2)
                                    end
                                end)
                            end
                        end
                    else
                        StatusLabel.Text = "Status: Erro! Lobby não encontrado no mapa."
                    end
                end
            end
        end
    end
end)

-- Função auxiliar segura de extensão para evitar congelamentos infinitos por WaitForChild
function Instance:SafeWaitForChild(childName, timeout)
    local child = self:FindFirstChild(childName)
    if child then return child end
    local start = os.clock()
    while os.clock() - start < (timeout or 5) do
        child = self:FindFirstChild(childName)
        if child then return child end
        task.wait(0.1)
    end
    return nil
end

print("[LOW PIECE] Painel Master V10.0 carregado com sucesso.")
