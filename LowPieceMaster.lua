-- =======================================================
-- LOW PIECE MASTER V11.0 - SISTEMA COMPACTO DE RAID (FULL AUTO FIX)
-- =======================================================

_G.AgruparRaidActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoLobbyActivo = false
_G.RaioDaArea = 50
_G.MostrarArea = false

-- Opções selecionadas via painel
_G.RaidSelecionada = "DesertRaid" -- Padrão
_G.DificuldadeSelecionada = "NormalButton" -- Padrão

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- Limpeza de instâncias antigas
if CoreGui:FindFirstChild("LowPieceMasterV11") then 
    CoreGui.LowPieceMasterV11:Destroy() 
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
-- INTERFACE VISUAL TOTALMENTE REFORMULADA
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV11"
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
InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
InfoLabel.TextColor3 = Color3.fromRGB(160, 255, 160)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 13
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Main

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 1, -30)
StatusLabel.Text = "Status: Aguardando Comando..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 11
StatusLabel.BackgroundTransparency = 0.9
StatusLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
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

-- 1. Seção de Combate
criarBotao("Puxar NPCs", UDim2.new(0, 15, 0, 40), UDim2.new(0, 140, 0, 30), Color3.fromRGB(60, 45, 80), function(btn)
    _G.AgruparRaidActivo = not _G.AgruparRaidActivo
    btn.BackgroundColor3 = _G.AgruparRaidActivo and Color3.fromRGB(110, 60, 160) or Color3.fromRGB(60, 45, 80)
end)

criarBotao("Simular Clique", UDim2.new(0, 165, 0, 40), UDim2.new(0, 140, 0, 30), Color3.fromRGB(45, 70, 55), function(btn)
    _G.AutoClickActivo = not _G.AutoClickActivo
    btn.BackgroundColor3 = _G.AutoClickActivo and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 70, 55)
end)

criarBotao("Simular Skills", UDim2.new(0, 15, 0, 75), UDim2.new(0, 140, 0, 30), Color3.fromRGB(70, 65, 45), function(btn)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    btn.BackgroundColor3 = _G.AutoSkillsActivo and Color3.fromRGB(160, 140, 50) or Color3.fromRGB(70, 65, 45)
end)

criarBotao("Ver Área", UDim2.new(0, 165, 0, 75), UDim2.new(0, 140, 0, 30), Color3.fromRGB(45, 60, 75), function(btn)
    _G.MostrarArea = not _G.MostrarArea
    btn.BackgroundColor3 = _G.MostrarArea and Color3.fromRGB(50, 110, 170) or Color3.fromRGB(45, 60, 75)
end)

-- 2. Seção de Escolha de Raids
local Raids = {"DesertRaid", "JojoRaid", "JudgmentHallRaid", "SoulEaterRaid"}
local botoesRaid = {}
for i, raidNome in ipairs(Raids) do
    local posY = 115 + ((i-1) * 32)
    local btn = criarBotao(raidNome, UDim2.new(0, 15, 0, posY), UDim2.new(0, 290, 0, 28), Color3.fromRGB(40, 45, 50), function(self)
        _G.RaidSelecionada = raidNome
        for _, b in pairs(botoesRaid) do b.BackgroundColor3 = Color3.fromRGB(40, 45, 50) end
        self.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        StatusLabel.Text = "Raid Alvo: " .. raidNome
    end)
    if raidNome == _G.RaidSelecionada then btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200) end
    table.insert(botoesRaid, btn)
end

-- 3. Seção de Escolha de Dificuldade
local Dificuldades = {
    {Nome = "Fácil", ID = "EasyButton", PosX = 15},
    {Nome = "Normal", ID = "NormalButton", PosX = 115},
    {Nome = "Difícil", ID = "HardButton", PosX = 215}
}
local botoesDif = {}
for _, dif in ipairs(Dificuldades) do
    local btn = criarBotao(dif.Nome, UDim2.new(0, dif.PosX, 0, 250), UDim2.new(0, 90, 0, 28), Color3.fromRGB(45, 45, 45), function(self)
        _G.DificuldadeSelecionada = dif.ID
        for _, b in pairs(botoesDif) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end
        self.BackgroundColor3 = Color3.fromRGB(180, 100, 20)
    end)
    if dif.ID == _G.DificuldadeSelecionada then btn.BackgroundColor3 = Color3.fromRGB(180, 100, 20) end
    table.insert(botoesDif, btn)
end

-- Controladores de Raio de Área
criarBotao("Área +25", UDim2.new(0, 15, 0, 290), UDim2.new(0, 140, 0, 28), Color3.fromRGB(35, 35, 35), function()
    _G.RaioDaArea = _G.RaioDaArea + 25
    InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
end)
criarBotao("Área -25", UDim2.new(0, 165, 0, 290), UDim2.new(0, 140, 0, 28), Color3.fromRGB(35, 35, 35), function()
    if _G.RaioDaArea > 25 then
        _G.RaioDaArea = _G.RaioDaArea - 25
        InfoLabel.Text = "Raio Atual: " .. _G.RaioDaArea
    end
end)

-- 4. BOTÃO MESTRE: LOOP AUTOMÁTICO COMPLETO
local btnAutoLobby = criarBotao("INICIAR LOOP DE RAID (AUTO)", UDim2.new(0, 15, 0, 335), UDim2.new(0, 290, 0, 40), Color3.fromRGB(120, 30, 30), function(btn)
    _G.AutoLobbyActivo = not _G.AutoLobbyActivo
    if _G.AutoLobbyActivo then
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
        btn.Text = "LOOP ATIVADO (RODANDO)"
    else
        btn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
        btn.Text = "INICIAR LOOP DE RAID (AUTO)"
        StatusLabel.Text = "Status: Parado."
    end
end)

-- =======================================================
-- LOOPS E SISTEMAS DE SEGUNDO PLANO
-- =======================================================

-- Função para verificar se existem inimigos por perto
local function temNpcNaFrente(rootPlayer)
    local encontrou = false
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
                local npcModel = obj.Parent
                if not Players:GetPlayerFromCharacter(npcModel) then
                    local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                    if rootNpc then
                        local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                        if distancia <= (_G.RaioDaArea + 15) then
                            encontrou = true
                            break
                        end
                    end
                end
            end
        end
    end)
    return encontrou
end

-- 1. Loop Físico: Puxada de NPCs e Esfera Visual
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

-- 2. Loop de Ataques Automáticos (Clique)
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

-- 3. Loop de Habilidades Automáticas
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
                        task.wait(rng:NextNumber(0.05, 0.08))
                        VirtualUser:SetKeyUp(tecla)
                        task.wait(rng:NextNumber(0.35, 0.60))
                    end
                end)
            end
        end
    end
end)

-- 4. NOVO: MÁQUINA DE ESTADO INTELIGENTE E AUTOMÁTICA
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoLobbyActivo then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            
            if rootPlayer then
                -- Verifica se JÁ está dentro de uma batalha/Raid ocorrendo
                if temNpcNaFrente(rootPlayer) then
                    StatusLabel.Text = "Status: Em combate! Defendendo sala..."
                    -- Garante que o auto-ataque e puxada fiquem ativos na ação
                    _G.AutoClickActivo = true
                    _G.AutoSkillsActivo = true
                    _G.AgruparRaidActivo = true
                else
                    StatusLabel.Text = "Status: Procurando/Aguardando Lobby..."
                    
                    -- Busca o objeto selecionado de maneira dinâmica e segura
                    local raidSystem = workspace:FindFirstChild("RaidSystem")
                    local lobbies = raidSystem and raidSystem:FindFirstChild("Lobbies")
                    local alvoLobby = lobbies and lobbies:FindFirstChild(_G.RaidSelecionada)
                    
                    if alvoLobby then
                        local posicaoAlvo = nil
                        if alvoLobby:IsA("BasePart") then
                            posicaoAlvo = alvoLobby.CFrame
                        elseif alvoLobby:IsA("Model") then
                            posicaoAlvo = alvoLobby:GetPivot()
                        end
                        
                        if posicaoAlvo then
                            local distancia = (rootPlayer.Position - posicaoAlvo.Position).Magnitude
                            
                            -- Se estiver longe do lobby, faz o Teleporte Rígido Imediato
                            if distancia > 15 then
                                StatusLabel.Text = "Status: Teleportando para " .. _G.RaidSelecionada
                                rootPlayer.CFrame = posicaoAlvo * CFrame.new(0, 3, 0)
                                task.wait(0.8) -- Tempo técnico de sincronização física com o servidor
                            end
                            
                            -- Manipulação da Interface do Jogo (Iniciar a Partida)
                            if playerGui then
                                local raidUI = playerGui:FindFirstChild("RaidUI")
                                local difficultyFrame = raidUI and raidUI:FindFirstChild("DifficultyFrame")
                                
                                if difficultyFrame and difficultyFrame.Visible then
                                    StatusLabel.Text = "Status: Configurando Dificuldade..."
                                    
                                    pcall(function()
                                        -- Clica no botão correspondente à Dificuldade Escolhida no Painel
                                        local btnDif = difficultyFrame:FindFirstChild(_G.DificuldadeSelecionada)
                                        if btnDif and btnDif.Visible then
                                            local pos = btnDif.AbsolutePosition
                                            VirtualUser:ClickButton1(Vector2.new(pos.X + 10, pos.Y + 40))
                                            task.wait(0.3)
                                        end
                                        
                                        -- Clica em StartNow
                                        local startNowBtn = difficultyFrame:FindFirstChild("StartNowButton")
                                        if startNowBtn and startNowBtn.Visible then
                                            local posStart = startNowBtn.AbsolutePosition
                                            VirtualUser:ClickButton1(Vector2.new(posStart.X + 10, posStart.Y + 40))
                                            StatusLabel.Text = "Status: Raid Iniciada!"
                                            task.wait(2)
                                        end
                                    end)
                                end
                            end
                        end
                    else
                        StatusLabel.Text = "Status: ERRO - Lobby não localizado!"
                    end
                end
            end
        end
    end
end)

print("[LOW PIECE] Script Master V11.0 Carregado com Sucesso. (Corrigido)")
