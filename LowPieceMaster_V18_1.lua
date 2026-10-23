-- =======================================================
-- LOW PIECE MASTER V18.1 - CÓDIGO COMPLETO (DELTA MOBILE)
-- =======================================================

_G.AtravessarNPCsActivo = false
_G.FicarAtrasActivo = false
_G.AimbotActivo = false
_G.AutoClickActivo = false
_G.AutoSkillsActivo = false
_G.AutoSwapHotbarActivo = false
_G.AutoTeleportIlha = false
_G.AutoOkarunActivo = false
_G.AutoRaidEasyActivo = false
_G.AutoFarmRaidCicloActivo = false
_G.IlhaSelecionada = "Center Island"
_G.RaioDaArea = 50
_G.DistanciaAtras = 3

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

pcall(function()
    if CoreGui:FindFirstChild("LowPieceMasterV18_Delta") then 
        CoreGui.LowPieceMasterV18_Delta:Destroy() 
    end
    if LocalPlayer.PlayerGui:FindFirstChild("LowPieceMasterV18_Delta") then
        LocalPlayer.PlayerGui.LowPieceMasterV18_Delta:Destroy()
    end
end)

local rng = Random.new()

local GUI = Instance.new("ScreenGui")
GUI.Name = "LowPieceMasterV18_Delta"
GUI.ResetOnSpawn = false

local successParent = pcall(function() GUI.Parent = CoreGui end)
if not successParent then GUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 310, 0, 330)
Main.Position = UDim2.new(0.35, 0, 0.20, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 10) MainCorner.Parent = Main
local MainStroke = Instance.new("UIStroke") MainStroke.Color = Color3.fromRGB(45, 50, 70) MainStroke.Thickness = 1.5 MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner") HeaderCorner.CornerRadius = UDim.new(0, 10) HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "⚡ LOW PIECE HUB V18.1 (DELTA)"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local btnMinimizar = Instance.new("TextButton")
btnMinimizar.Size = UDim2.new(0, 26, 0, 26)
btnMinimizar.Position = UDim2.new(1, -32, 0, 6)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
btnMinimizar.Text = "—"
btnMinimizar.TextColor3 = Color3.fromRGB(200, 200, 220)
btnMinimizar.Font = Enum.Font.GothamBold
btnMinimizar.TextSize = 12
btnMinimizar.Parent = Header
local cMin = Instance.new("UICorner") cMin.CornerRadius = UDim.new(0, 6) cMin.Parent = btnMinimizar

local function criarBotaoModerno(texto, pos, tamanho, acao, pai)
    local btn = Instance.new("TextButton")
    btn.Size = tamanho
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(210, 215, 230)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 9
    btn.Parent = pai or Main

    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    local stroke = Instance.new("UIStroke") stroke.Color = Color3.fromRGB(40, 45, 65) stroke.Thickness = 1 stroke.Parent = btn

    btn.MouseButton1Click:Connect(function() acao(btn, stroke) end)
    return btn, stroke
end

local AbaCombateBtn, _ = criarBotaoModerno("⚔️ Combate", UDim2.new(0, 8, 0, 44), UDim2.new(0, 68, 0, 28), function() end)
local AbaTeleporteBtn, _ = criarBotaoModerno("🌐 Teleportes", UDim2.new(0, 80, 0, 44), UDim2.new(0, 72, 0, 28), function() end)
local AbaBossBtn, _ = criarBotaoModerno("👹 Bosses", UDim2.new(0, 156, 0, 44), UDim2.new(0, 68, 0, 28), function() end)
local AbaRaidBtn, _ = criarBotaoModerno("🏰 Raid", UDim2.new(0, 228, 0, 44), UDim2.new(0, 74, 0, 28), function() end)

AbaCombateBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
AbaCombateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local FrameCombate = Instance.new("Frame")
FrameCombate.Size = UDim2.new(1, -24, 1, -110)
FrameCombate.Position = UDim2.new(0, 12, 0, 80)
FrameCombate.BackgroundTransparency = 1
FrameCombate.Visible = true
FrameCombate.Parent = Main

local FrameTeleporte = Instance.new("Frame")
FrameTeleporte.Size = UDim2.new(1, -24, 1, -110)
FrameTeleporte.Position = UDim2.new(0, 12, 0, 80)
FrameTeleporte.BackgroundTransparency = 1
FrameTeleporte.Visible = false
FrameTeleporte.Parent = Main

local FrameBoss = Instance.new("Frame")
FrameBoss.Size = UDim2.new(1, -24, 1, -110)
FrameBoss.Position = UDim2.new(0, 12, 0, 80)
FrameBoss.BackgroundTransparency = 1
FrameBoss.Visible = false
FrameBoss.Parent = Main

local FrameRaid = Instance.new("Frame")
FrameRaid.Size = UDim2.new(1, -24, 1, -110)
FrameRaid.Position = UDim2.new(0, 12, 0, 80)
FrameRaid.BackgroundTransparency = 1
FrameRaid.Visible = false
FrameRaid.Parent = Main

local function resetAbas()
    FrameCombate.Visible = false
    FrameTeleporte.Visible = false
    FrameBoss.Visible = false
    FrameRaid.Visible = false

    AbaCombateBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
    AbaTeleporteBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
    AbaBossBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
    AbaRaidBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)

    AbaCombateBtn.TextColor3 = Color3.fromRGB(210, 215, 230)
    AbaTeleporteBtn.TextColor3 = Color3.fromRGB(210, 215, 230)
    AbaBossBtn.TextColor3 = Color3.fromRGB(210, 215, 230)
    AbaRaidBtn.TextColor3 = Color3.fromRGB(210, 215, 230)
end

AbaCombateBtn.MouseButton1Click:Connect(function()
    resetAbas()
    FrameCombate.Visible = true
    AbaCombateBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    AbaCombateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

AbaTeleporteBtn.MouseButton1Click:Connect(function()
    resetAbas()
    FrameTeleporte.Visible = true
    AbaTeleporteBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    AbaTeleporteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

AbaBossBtn.MouseButton1Click:Connect(function()
    resetAbas()
    FrameBoss.Visible = true
    AbaBossBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    AbaBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

AbaRaidBtn.MouseButton1Click:Connect(function()
    resetAbas()
    FrameRaid.Visible = true
    AbaRaidBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    AbaRaidBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

local minimizado = false
btnMinimizar.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    FrameCombate.Visible = not minimizado and AbaCombateBtn.BackgroundColor3 == Color3.fromRGB(0, 120, 215)
    FrameTeleporte.Visible = not minimizado and AbaTeleporteBtn.BackgroundColor3 == Color3.fromRGB(0, 120, 215)
    FrameBoss.Visible = not minimizado and AbaBossBtn.BackgroundColor3 == Color3.fromRGB(0, 120, 215)
    FrameRaid.Visible = not minimizado and AbaRaidBtn.BackgroundColor3 == Color3.fromRGB(0, 120, 215)

    AbaCombateBtn.Visible = not minimizado
    AbaTeleporteBtn.Visible = not minimizado
    AbaBossBtn.Visible = not minimizado
    AbaRaidBtn.Visible = not minimizado

    if minimizado then
        Main.Size = UDim2.new(0, 310, 0, 38)
        btnMinimizar.Text = "+"
    else
        Main.Size = UDim2.new(0, 310, 0, 330)
        btnMinimizar.Text = "—"
    end
end)

local function aplicarEstiloToggle(btn, stroke, ativo, textoBase)
    if ativo then
        btn.BackgroundColor3 = Color3.fromRGB(15, 75, 45)
        btn.TextColor3 = Color3.fromRGB(80, 255, 160)
        stroke.Color = Color3.fromRGB(0, 200, 100)
        btn.Text = textoBase .. ": ON"
    else
        btn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
        btn.TextColor3 = Color3.fromRGB(210, 215, 230)
        stroke.Color = Color3.fromRGB(40, 45, 65)
        btn.Text = textoBase .. ": OFF"
    end
end

local btnNpcAtrav, strokeNpcAtrav = criarBotaoModerno("NPCs Atravessáveis: OFF", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 24), function(btn, stroke)
    _G.AtravessarNPCsActivo = not _G.AtravessarNPCsActivo
    aplicarEstiloToggle(btn, stroke, _G.AtravessarNPCsActivo, "NPCs Atravessáveis")
end, FrameCombate)

local btnFicarAtras, strokeFicarAtras = criarBotaoModerno("Ficar Atrás do NPC: OFF", UDim2.new(0, 0, 0, 28), UDim2.new(1, 0, 0, 24), function(btn, stroke)
    _G.FicarAtrasActivo = not _G.FicarAtrasActivo
    aplicarEstiloToggle(btn, stroke, _G.FicarAtrasActivo, "Ficar Atrás do NPC")
end, FrameCombate)

local btnAimbot, strokeAimbot = criarBotaoModerno("Aimbot: OFF", UDim2.new(0, 0, 0, 56), UDim2.new(0, 138, 0, 24), function(btn, stroke)
    _G.AimbotActivo = not _G.AimbotActivo
    aplicarEstiloToggle(btn, stroke, _G.AimbotActivo, "Aimbot")
end, FrameCombate)

local btnAutoClick, strokeAutoClick = criarBotaoModerno("Auto Click: OFF", UDim2.new(0, 148, 0, 56), UDim2.new(0, 138, 0, 24), function(btn, stroke)
    _G.AutoClickActivo = not _G.AutoClickActivo
    aplicarEstiloToggle(btn, stroke, _G.AutoClickActivo, "Auto Click")
end, FrameCombate)

local btnAutoSkills, strokeAutoSkills = criarBotaoModerno("Auto Skills: OFF", UDim2.new(0, 0, 0, 84), UDim2.new(1, 0, 0, 24), function(btn, stroke)
    _G.AutoSkillsActivo = not _G.AutoSkillsActivo
    aplicarEstiloToggle(btn, stroke, _G.AutoSkillsActivo, "Auto Skills")
end, FrameCombate)

local btnSwapHotbar, strokeSwapHotbar = criarBotaoModerno("Trocar Armas Hotbar (Swap): OFF", UDim2.new(0, 0, 0, 112), UDim2.new(1, 0, 0, 24), function(btn, stroke)
    _G.AutoSwapHotbarActivo = not _G.AutoSwapHotbarActivo
    aplicarEstiloToggle(btn, stroke, _G.AutoSwapHotbarActivo, "Trocar Armas Hotbar")
end, FrameCombate)

local lblDistancia = Instance.new("TextLabel")
lblDistancia.Size = UDim2.new(1, 0, 0, 14)
lblDistancia.Position = UDim2.new(0, 0, 0, 140)
lblDistancia.Text = "Distância Atrás: " .. _G.DistanciaAtras .. " studs"
lblDistancia.TextColor3 = Color3.fromRGB(160, 170, 190)
lblDistancia.Font = Enum.Font.GothamBold
lblDistancia.TextSize = 9
lblDistancia.BackgroundTransparency = 1
lblDistancia.Parent = FrameCombate

criarBotaoModerno("Distância -", UDim2.new(0, 0, 0, 156), UDim2.new(0, 138, 0, 22), function()
    if _G.DistanciaAtras > 1 then _G.DistanciaAtras = _G.DistanciaAtras - 1 end
    lblDistancia.Text = "Distância Atrás: " .. _G.DistanciaAtras .. " studs"
end, FrameCombate)

criarBotaoModerno("Distância +", UDim2.new(0, 148, 0, 156), UDim2.new(0, 138, 0, 22), function()
    _G.DistanciaAtras = _G.DistanciaAtras + 1
    lblDistancia.Text = "Distância Atrás: " .. _G.DistanciaAtras .. " studs"
end, FrameCombate)

local botoesIlhas = {}
local listaIlhas = {"Snow Island", "Sand Island", "Center Island", "Slime Island", "Fall Island", "Boss Island", "Event Island", "Sky Island"}

local function atualizarSelecaoIlha(nomeIlha)
    _G.IlhaSelecionada = nomeIlha
    for nome, btn in pairs(botoesIlhas) do
        if nome == nomeIlha then
            btn.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "• " .. nome
        else
            btn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
            btn.TextColor3 = Color3.fromRGB(180, 185, 200)
            btn.Text = nome
        end
    end
end

for i, nome in ipairs(listaIlhas) do
    local posX = (i % 2 == 1) and 0 or 148
    local posY = math.floor((i - 1) / 2) * 28
    local btn, _ = criarBotaoModerno(nome, UDim2.new(0, posX, 0, posY), UDim2.new(0, 138, 0, 25), function()
        atualizarSelecaoIlha(nome)
    end, FrameTeleporte)
    botoesIlhas[nome] = btn
end
atualizarSelecaoIlha(_G.IlhaSelecionada)

local btnTeleport, _ = criarBotaoModerno("🚀 TELEPORTAR PARA ILHA", UDim2.new(0, 0, 0, 125), UDim2.new(1, 0, 0, 30), function(btn)
    _G.AutoTeleportIlha = not _G.AutoTeleportIlha
    if _G.AutoTeleportIlha then
        btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        btn.Text = "⏹ CANCELAR MONITORAMENTO"
    else
        btn.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
        btn.Text = "🚀 TELEPORTAR PARA ILHA"
    end
end, FrameTeleporte)

local btnOkarun, strokeOkarun = criarBotaoModerno("Auto Farm Okarun: OFF", UDim2.new(0, 0, 0, 10), UDim2.new(1, 0, 0, 35), function(btn, stroke)
    _G.AutoOkarunActivo = not _G.AutoOkarunActivo
    aplicarEstiloToggle(btn, stroke, _G.AutoOkarunActivo, "Auto Farm Okarun")
end, FrameBoss)

local lblBossStatus = Instance.new("TextLabel")
lblBossStatus.Size = UDim2.new(1, 0, 0, 40)
lblBossStatus.Position = UDim2.new(0, 0, 0, 55)
lblBossStatus.Text = "Status Boss: Monitorando Spawn..."
lblBossStatus.TextColor3 = Color3.fromRGB(160, 170, 190)
lblBossStatus.Font = Enum.Font.GothamMedium
lblBossStatus.TextSize = 11
lblBossStatus.BackgroundTransparency = 1
lblBossStatus.Parent = FrameBoss

local btnAutoFarmRaid, strokeAutoFarmRaid = criarBotaoModerno("🤖 AUTO FARM RAID COMPLETO: OFF", UDim2.new(0, 0, 0, 5), UDim2.new(1, 0, 0, 30), function(btn, stroke)
    _G.AutoFarmRaidCicloActivo = not _G.AutoFarmRaidCicloActivo
    aplicarEstiloToggle(btn, stroke, _G.AutoFarmRaidCicloActivo, "🤖 AUTO FARM RAID COMPLETO")
end, FrameRaid)

local lblRaidStatus = Instance.new("TextLabel")
lblRaidStatus.Size = UDim2.new(1, 0, 0, 50)
lblRaidStatus.Position = UDim2.new(0, 0, 0, 45)
lblRaidStatus.Text = "Status Raid: Sistema Pronto"
lblRaidStatus.TextColor3 = Color3.fromRGB(160, 170, 190)
lblRaidStatus.Font = Enum.Font.GothamMedium
lblRaidStatus.TextSize = 10
lblRaidStatus.TextWrapped = true
lblRaidStatus.BackgroundTransparency = 1
lblRaidStatus.Parent = FrameRaid

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.Text = "Status: Pronto para Farmar"
StatusLabel.TextColor3 = Color3.fromRGB(100, 110, 130)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 10
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

local function acionarBotaoUI(btnObj)
    if not btnObj or not btnObj:IsA("GuiButton") or not btnObj.Visible then return false end
    pcall(function()
        if getconnections then
            for _, conn in pairs(getconnections(btnObj.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(btnObj.Activated)) do conn:Fire() end
        end
    end)
    return true
end

local function atualizarBotoesUI()
    aplicarEstiloToggle(btnFicarAtras, strokeFicarAtras, _G.FicarAtrasActivo, "Ficar Atrás do NPC")
    aplicarEstiloToggle(btnAutoClick, strokeAutoClick, _G.AutoClickActivo, "Auto Click")
    aplicarEstiloToggle(btnAutoSkills, strokeAutoSkills, _G.AutoSkillsActivo, "Auto Skills")
    aplicarEstiloToggle(btnSwapHotbar, strokeSwapHotbar, _G.AutoSwapHotbarActivo, "Trocar Armas Hotbar")
    lblDistancia.Text = "Distância Atrás: " .. _G.DistanciaAtras .. " studs"
end

local function obterPosicaoSegura(targetNpc, character)
    local npcCFrame = targetNpc.CFrame
    local direcaoAtras = -npcCFrame.LookVector * _G.DistanciaAtras
    local destinoIdeal = npcCFrame.Position + direcaoAtras

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, targetNpc.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local rayResult = workspace:Raycast(npcCFrame.Position, direcaoAtras, raycastParams)

    if rayResult then
        local direcaoFrente = npcCFrame.LookVector * 2.5
        return CFrame.new(npcCFrame.Position + direcaoFrente, npcCFrame.Position)
    else
        return CFrame.new(destinoIdeal, npcCFrame.Position)
    end
end

local function forcarSelecaoEasy(raidUI)
    if not raidUI then return false end

    pcall(function()
        for _, desc in pairs(raidUI:GetDescendants()) do
            if desc:IsA("GuiButton") and desc.Visible then
                local nome = string.lower(desc.Name)
                local texto = desc:IsA("TextButton") and string.lower(desc.Text) or ""

                if string.find(nome, "easy") or string.find(texto, "easy") or string.find(texto, "fácil") then
                    acionarBotaoUI(desc)
                    task.wait(0.2)
                end
            end
        end

        for _, desc in pairs(raidUI:GetDescendants()) do
            if desc:IsA("GuiButton") and desc.Visible then
                local nome = string.lower(desc.Name)
                local texto = desc:IsA("TextButton") and string.lower(desc.Text) or ""

                if string.find(nome, "start") or string.find(texto, "start") or string.find(texto, "iniciar") then
                    acionarBotaoUI(desc)
                    task.wait(0.2)
                end
            end
        end
    end)
end

-- CICLO COMPLETO DE AUTO FARM RAID
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoFarmRaidCicloActivo then
            pcall(function()
                local character = LocalPlayer.Character
                local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")

                if rootPlayer then
                    lblRaidStatus.Text = "Status Raid: Teleportando para o Lobby..."
                    lblRaidStatus.TextColor3 = Color3.fromRGB(200, 160, 80)

                    local lobby = workspace:FindFirstChild("RaidSystem") and workspace.RaidSystem:FindFirstChild("Lobbies") and workspace.RaidSystem.Lobbies:FindFirstChild("JudgmentHallRaid")
                    if lobby then
                        local posLobby = lobby:IsA("Model") and (lobby.PrimaryPart and lobby.PrimaryPart.CFrame or lobby:FindFirstChildWhichIsA("BasePart", true).CFrame) or lobby.CFrame
                        rootPlayer.CFrame = posLobby + Vector3.new(0, 3, 0)
                    end

                    task.wait(2)

                    lblRaidStatus.Text = "Status Raid: Selecionando Dificuldade Fácil..."
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local raidUI = playerGui and playerGui:WaitForChild("RaidUI", 6)

                    if raidUI then
                        for i = 1, 4 do
                            forcarSelecaoEasy(raidUI)
                            task.wait(0.3)
                        end
                    end

                    lblRaidStatus.Text = "Status Raid: Aguardando entrada na Raid..."
                    local raidInstances = workspace:WaitForChild("RaidInstances", 12)
                    local dentroDaRaid = false

                    local timeout = 0
                    repeat
                        task.wait(1)
                        timeout = timeout + 1
                        if raidInstances and #raidInstances:GetChildren() > 0 then
                            dentroDaRaid = true
                        end
                    until dentroDaRaid or timeout > 15 or not _G.AutoFarmRaidCicloActivo

                    if dentroDaRaid then
                        lblRaidStatus.Text = "Status Raid: ⚔️ DENTRO DA RAID! Atacando..."
                        lblRaidStatus.TextColor3 = Color3.fromRGB(0, 210, 255)

                        _G.FicarAtrasActivo = true
                        _G.AutoClickActivo = true
                        _G.AutoSkillsActivo = true
                        _G.AutoSwapHotbarActivo = true
                        _G.DistanciaAtras = 10
                        atualizarBotoesUI()

                        repeat
                            task.wait(2)
                        until (#raidInstances:GetChildren() == 0) or not _G.AutoFarmRaidCicloActivo

                        lblRaidStatus.Text = "Status Raid: Raid Finalizada! Resetando..."
                        lblRaidStatus.TextColor3 = Color3.fromRGB(255, 100, 100)

                        _G.FicarAtrasActivo = false
                        _G.AutoClickActivo = false
                        _G.AutoSkillsActivo = false
                        _G.AutoSwapHotbarActivo = false
                        atualizarBotoesUI()

                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.Health = 0
                        end

                        LocalPlayer.CharacterAdded:Wait()
                        task.wait(3)
                    end
                end
            end)
        end
    end
end)

local function encontrarOkarun()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if npcModel.Name == "Okarun" or string.find(string.lower(npcModel.Name), "okarun") then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                if rootNpc then return rootNpc, obj end
            end
        end
    end
    return nil, nil
end

local function encontrarNpcMaisProximo(rootPlayer)
    local npcProximo = nil
    local menorDistancia = _G.RaioDaArea

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
            local npcModel = obj.Parent
            if not Players:GetPlayerFromCharacter(npcModel) then
                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                if rootNpc then
                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                    if distancia <= menorDistancia then
                        menorDistancia = distancia
                        npcProximo = rootNpc
                    end
                end
            end
        end
    end
    return npcProximo
end

task.spawn(function()
    while true do
        task.wait(0.05)
        local character = LocalPlayer.Character
        local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")

        if rootPlayer then
            if _G.AutoOkarunActivo then
                local rootOkarun, humOkarun = encontrarOkarun()
                if rootOkarun and humOkarun then
                    lblBossStatus.Text = "Status Boss: ⚔️ ATACANDO OKARUN!"
                    lblBossStatus.TextColor3 = Color3.fromRGB(80, 255, 160)
                    pcall(function()
                        rootPlayer.CFrame = obterPosicaoSegura(rootOkarun, character)
                    end)
                end
            end

            pcall(function()
                if _G.AtravessarNPCsActivo then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Humanoid") and obj.Parent and obj.Health > 0 then
                            local npcModel = obj.Parent
                            if not Players:GetPlayerFromCharacter(npcModel) then
                                local rootNpc = npcModel:FindFirstChild("HumanoidRootPart")
                                if rootNpc then
                                    local distancia = (rootPlayer.Position - rootNpc.Position).Magnitude
                                    if distancia <= _G.RaioDaArea then
                                        rootNpc.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            if not _G.AutoOkarunActivo then
                local targetNpc = encontrarNpcMaisProximo(rootPlayer)
                if targetNpc then
                    pcall(function()
                        if _G.FicarAtrasActivo then
                            rootPlayer.CFrame = obterPosicaoSegura(targetNpc, character)
                        end
                    end)
                end
            end
        end
    end
end)

-- LOOP DE ATAQUE COMPATÍVEL COM DELTA MOBILE
task.spawn(function()
    while true do
        task.wait(0.2)
        local character = LocalPlayer.Character
        if character then
            if _G.AutoClickActivo or _G.AutoSkillsActivo then
                pcall(function()
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoTeleportIlha then
            local character = LocalPlayer.Character
            local rootPlayer = character and character:FindFirstChild("HumanoidRootPart")
            if rootPlayer then
                StatusLabel.Text = "Status: Teleportando para " .. _G.IlhaSelecionada
                local islandsFolder = workspace:WaitForChild("Island", 2)
                if islandsFolder then
                    local targetIsland = islandsFolder:FindFirstChild(_G.IlhaSelecionada)
                    if targetIsland then
                        local targetCFrame = nil
                        if targetIsland:IsA("Model") then
                            if targetIsland.PrimaryPart then
                                targetCFrame = targetIsland.PrimaryPart.CFrame + Vector3.new(0, 10, 0)
                            else
                                local part = targetIsland:FindFirstChildWhichIsA("BasePart", true)
                                if part then targetCFrame = part.CFrame + Vector3.new(0, 10, 0) end
                            end
                        end
                        if targetCFrame then
                            rootPlayer.CFrame = targetCFrame
                            StatusLabel.Text = "Status: Chegou em " .. _G.IlhaSelecionada
                            _G.AutoTeleportIlha = false
                            btnTeleport.BackgroundColor3 = Color3.fromRGB(26, 29, 42)
                            btnTeleport.Text = "🚀 TELEPORTAR PARA ILHA"
                        end
                    end
                end
            end
        end
    end
end)

print("[LOW PIECE] V18.1 Carregado com Suporte Delta Mobile!")
