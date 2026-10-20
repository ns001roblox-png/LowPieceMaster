-- =======================================================
-- LOW PIECE MASTER FARM HAX V3 - DEFINITIVO COMPLETÃO
-- =======================================================

_G.AutoFarm = false
_G.AutoSkills = false
_G.AutoRaid = false
_G.NpcSelecionado = "Nenhum"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Deleta versões antigas do script para não sobrecarregar a tela
if CoreGui:FindFirstChild("LowPieceMasterV3") then 
    CoreGui.LowPieceMasterV3:Destroy() 
end

-- =======================================================
-- DICIONÁRIO DE ILHAS E NPCS (MAPEADO DO SEU RELATÓRIO)
-- =======================================================
local IlhasDoJogo = {
    ["Ilha Inicial / Slimes"] = {"Slime Man", "Bad Villager"},
    ["Ilha do Deserto / Areia"] = {"Sand Man", "Sandia Man", "Big Sand Man"},
    ["Ilha da Neve / Gelo"] = {"Snow Man", "King Snow Man"},
    ["Marinhos / Outros"] = {"Marine Soldier", "Sky Man"},
    ["Chefões / Bosses"] = {"Mihawk Boss"}
}

-- =======================================================
-- FUNÇÕES DE SUPORTE (COMBATE POR REMOTES & SEGURANÇA)
-- =======================================================

-- Descobre automaticamente o nome da sua fruta/estilo equipado (Ex: Sukuna Heian)
local function obterNomeEstilo()
    local ferramenta = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if ferramenta then
        return ferramenta.Name
    end
    -- Se não tiver ferramenta na mão, tenta pegar a primeira da Backpack
    local naMochila = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    if naMochila then
        return naMochila.Name
    end
    return "Sukuna Heian" -- Padrão de segurança caso não ache
end

-- Limpa a física do NPC para tirar o Knockback e não bugar o registro de dano
local function estabilizarNPC(npc)
    if npc:FindFirstChild("HumanoidRootPart") then
        npc.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        npc.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
        for _, part in pairs(npc:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Varre o mapa procurando o alvo correto (Mundo Aberto ou Raid)
local function buscarAlvo()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local meuPos = LocalPlayer.Character.HumanoidRootPart.Position
    local menorDistancia = math.huge
    local alvo = nil
    
    -- Se for Auto Raid, o foco é o White Ghost (Raid) ou qualquer mob dentro das pastas de Raid
    if _G.AutoRaid then
        for _, pasta in pairs({workspace:FindFirstChild("RaidInstances"), workspace:FindFirstChild("Monsters")}) do
            if pasta then
                for _, npc in pairs(pasta:GetChildren()) do
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 and npc.Name ~= LocalPlayer.Name then
                        local dist = (meuPos - hrp.Position).Magnitude
                        if dist < menorDistancia then
                            menorDistancia = dist
                            alvo = npc
                        end
                    end
                end
            end
        end
        -- Fallback caso o boss final esteja solto no workspace geral
        if not alvo and workspace:FindFirstChild("White Ghost (Raid)") then
            local ghost = workspace["White Ghost (Raid)"]
            if ghost:FindFirstChild("Humanoid") and ghost.Humanoid.Health > 0 then
                alvo = ghost
            end
        end
    elseif _G.AutoFarm and _G.NpcSelecionado ~= "Nenhum" then
        -- Farm Normal por seleção de NPC
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent ~= LocalPlayer.Character and obj.Parent.Name == _G.NpcSelecionado and obj.Health > 0 then
                local hrp = obj.Parent:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (meuPos - hrp.Position).Magnitude
                    if dist < menorDistancia then
                        menorDistancia = dist
                        alvo = obj.Parent
                    end
                end
            end
        end
    end
    return alvo
end

-- =======================================================
-- PAINEL VISUAL COMPACTO E MODERNO
-- =======================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV3"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 440, 0, 280)
Main.Position = UDim2.new(0.25, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 8) mc.Parent = Main

-- Menu Esquerdo de Seleção (Ilhas)
local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0, 150, 0, 280)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SideBar.BorderSizePixel = 0
SideBar.CanvasSize = UDim2.new(0, 0, 0, 380)
SideBar.ScrollBarThickness = 3
SideBar.Parent = Main
local sbl = Instance.new("UIListLayout") sbl.Parent = SideBar

-- Container Direito para os Botões Ligar/Desligar
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0, 290, 0, 280)
Content.Position = UDim2.new(0, 150, 0, 0)
Content.BackgroundTransparency = 1
Content.Parent = Main

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 40)
InfoLabel.Text = "Alvo: Nenhum | Clique em um NPC"
InfoLabel.TextColor3 = Color3.fromRGB(160, 160, 255)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 11
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Content

-- Criador Dinâmico de Toggles (Botões ON/OFF)
local function criarToggle(texto, pos, varGlobal)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    btn.Text = texto .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.Parent = Content
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        _G[varGlobal] = not _G[varGlobal]
        if _G[varGlobal] then
            btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            btn.Text = texto .. ": ON"
            
            -- Se ligar a Raid, envia automaticamente o remote de entrada na dificuldade Easy
            if varGlobal == "AutoRaid" then
                pcall(function() 
                    ReplicatedStorage.Remote.SelectDifficulty:FireServer("Easy") 
                end)
            end
        else
            btn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            btn.Text = texto .. ": OFF"
        end
    end)
end

criarToggle("Ativar Auto Farm Selecionado", UDim2.new(0, 20, 0, 50), "AutoFarm")
criarToggle("Auto Usar Habilidades (E, R, T, F)", UDim2.new(0, 20, 0, 100), "AutoSkills")
criarToggle("Modo Auto Raid Avançado", UDim2.new(0, 20, 0, 150), "AutoRaid")

-- Construtor Automático dos Sub-Botões de NPCs na Barra Lateral
for nomeIlha, tabelaNpcs in pairs(IlhasDoJogo) do
    local lblIlha = Instance.new("TextLabel")
    lblIlha.Size = UDim2.new(1, 0, 0, 25)
    lblIlha.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    lblIlha.Text = "📌 " .. nomeIlha
    lblIlha.TextColor3 = Color3.fromRGB(255, 200, 100)
    lblIlha.Font = Enum.Font.GothamBold
    lblIlha.TextSize = 10
    lblIlha.Parent = SideBar
    
    for _, npc in pairs(tabelaNpcs) do
        local btnNpc = Instance.new("TextButton")
        btnNpc.Size = UDim2.new(1, 0, 0, 30)
        btnNpc.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        btnNpc.Text = "   ⚔️ " .. npc
        btnNpc.TextColor3 = Color3.fromRGB(220, 220, 220)
        btnNpc.Font = Enum.Font.Gotham
        btnNpc.TextSize = 11
        btnNpc.TextXAlignment = Enum.TextXAlignment.Left
        btnNpc.Parent = SideBar
        
        btnNpc.MouseButton1Click:Connect(function()
            _G.NpcSelecionado = npc
            InfoLabel.Text = "Alvo: " .. _G.NpcSelecionado .. " | Estilo: " .. obterNomeEstilo()
        end)
    end
end

-- =======================================================
-- LOOPS AUTOMATIZADOS E CORREÇÃO DE NETCODE
-- =======================================================

-- Loop Principal: Teleport Silencioso + Ataque Direto via Fogo de Remote
task.spawn(function()
    while true do
        task.wait(0.01) -- Frequência máxima de resposta
        
        if (_G.AutoFarm or _G.AutoRaid) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local alvo = buscarAlvo()
                
                if alvo and alvo:FindFirstChild("HumanoidRootPart") then
                    local inimigoHRP = alvo.HumanoidRootPart
                    local meuHRP = LocalPlayer.Character.HumanoidRootPart
                    
                    estabilizarNPC(alvo)
                    
                    -- Garante que sua arma/fruta esteja na mão para computar o dano
                    if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                        local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                        if tool then tool.Parent = LocalPlayer.Character end
                    end
                    
                    -- Fica travado acima do alvo (Protegido de ataques de solo)
                    meuHRP.CFrame = inimigoHRP.CFrame * CFrame.new(0, 4.5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    meuHRP.Velocity = Vector3.new(0,0,0)
                    
                    -- DISPARO VIA REDE: Envia o sinal CombatEvent direto pro servidor com o seu estilo atual
                    local estilo = obterNomeEstilo()
                    ReplicatedStorage.Remote.CombatEvent:FireServer(estilo, Vector3.new(0,0,0))
                end
            end)
        end
    end
end)

-- Loop Secundário: Disparador das Habilidades E, R, T, F via Remotes Network
local RemotesSkills = {"Skill_E", "Skill_R", "Skill_T", "Skill_F"}
task.spawn(function()
    local idx = 1
    while true do
        task.wait(0.6) -- Intervalo perfeito para não travar os cooldowns
        
        if _G.AutoSkills and (_G.AutoFarm or _G.AutoRaid) then
            pcall(function()
                local alvo = buscarAlvo()
                if alvo then
                    local estilo = obterNomeEstilo()
                    local remoteNome = RemotesSkills[idx]
                    
                    -- Executa a skill via rede instantaneamente
                    if ReplicatedStorage.Remote:FindFirstChild(remoteNome) then
                        ReplicatedStorage.Remote[remoteNome]:FireServer(estilo)
                    end
                    
                    idx = idx % #RemotesSkills + 1
                end
            end)
        end
    end
end)

-- Loop Auxiliar: Ativação Automática do Haki do Armamento
task.spawn(function()
    while true do
        task.wait(5)
        if (_G.AutoFarm or _G.AutoRaid) then
            pcall(function()
                ReplicatedStorage.Remote.HakiEvent:FireServer("ArmamentHaki")
            end)
        end
    end
end)

-- Sistema Anti-AFK integrado para não cair da partida privada
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("[LOW PIECE] Script Master V3 carregado com sucesso!")
