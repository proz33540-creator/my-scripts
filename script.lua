local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if _G.MM2_Hub_Connections then
    for _, conn in ipairs(_G.MM2_Hub_Connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
    end
end
_G.MM2_Hub_Connections = {}

local function SaveConnection(conn)
    table.insert(_G.MM2_Hub_Connections, conn)
    return conn
end

if PlayerGui:FindFirstChild("MM2_Purple_Hub") then PlayerGui["MM2_Purple_Hub"]:Destroy() end

local Theme = { 
    Main = Color3.fromRGB(20, 10, 25), 
    Secondary = Color3.fromRGB(35, 15, 45), 
    Accent = Color3.fromRGB(170, 50, 255), 
    Text = Color3.fromRGB(255, 255, 255), 
    BtnOff = Color3.fromRGB(40, 20, 50), 
    BtnOn = Color3.fromRGB(100, 0, 150)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Purple_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local OverlayFrame = Instance.new("Frame")
OverlayFrame.BackgroundColor3 = Theme.Main
OverlayFrame.BackgroundTransparency = 0.5
OverlayFrame.Position = UDim2.new(0.5, -75, 0, 10)
OverlayFrame.Size = UDim2.new(0, 150, 0, 25)
OverlayFrame.ZIndex = 1001
OverlayFrame.Parent = ScreenGui
Instance.new("UICorner", OverlayFrame).CornerRadius = UDim.new(0, 6)

local StatsLabel = Instance.new("TextLabel")
StatsLabel.BackgroundTransparency = 1
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.Text = "FPS: 60 | Ping: 0ms"
StatsLabel.TextColor3 = Theme.Text
StatsLabel.TextSize = 11
StatsLabel.ZIndex = 1002
StatsLabel.Parent = OverlayFrame

local fpsCounter = 60

task.spawn(function()
    while task.wait(0.5) do
        local frames = 0
        local startTime = tick()
        local connect
        connect = RunService.RenderStepped:Connect(function()
            frames = frames + 1
            if tick() - startTime >= 0.5 then
                fpsCounter = math.floor(frames / (tick() - startTime))
                connect:Disconnect()
            end
        end)
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        StatsLabel.Text = string.format("FPS: %d | Ping: %dms", fpsCounter, ping)
    end
end)

local FovCircle = Instance.new("Frame")
FovCircle.BackgroundTransparency = 1
FovCircle.Size = UDim2.new(0, 300, 0, 300)
FovCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FovCircle.Visible = false
FovCircle.Parent = ScreenGui
Instance.new("UICorner", FovCircle).CornerRadius = UDim.new(1, 0)
local FovStroke = Instance.new("UIStroke", FovCircle)
FovStroke.Color = Theme.Accent
FovStroke.Thickness = 2
FovStroke.Transparency = 0.5

local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 460, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Theme.Accent
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3

local TopBar = Instance.new("Frame")
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 20, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 60))})
TopGradient.Rotation = 45
TopGradient.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "PURPLE HUB V31"
Title.TextColor3 = Theme.Text
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local AuthorText = Instance.new("TextLabel")
AuthorText.BackgroundTransparency = 1
AuthorText.Position = UDim2.new(0, 140, 0, 0)
AuthorText.Size = UDim2.new(0, 200, 1, 0)
AuthorText.Font = Enum.Font.GothamMedium
AuthorText.Text = "Author: Secret"
AuthorText.TextColor3 = Color3.fromRGB(200, 150, 255)
AuthorText.TextSize = 12
AuthorText.TextXAlignment = Enum.TextXAlignment.Left
AuthorText.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 60)
MinimizeBtn.Position = UDim2.new(1, -55, 0, 7.5)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 24)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton")
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
CloseBtn.Position = UDim2.new(1, -30, 0, 7.5)
CloseBtn.Size = UDim2.new(0, 20, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local MinimizedFrame = Instance.new("TextButton")
MinimizedFrame.BackgroundColor3 = Theme.Secondary
MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
MinimizedFrame.Position = MainFrame.Position
MinimizedFrame.Text = ""
MinimizedFrame.Visible = false
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.ClipsDescendants = true
MinimizedFrame.Parent = ScreenGui
Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(0, 10)
local MinStroke = Instance.new("UIStroke", MinimizedFrame)
MinStroke.Color = Theme.Accent
MinStroke.Thickness = 2

local IconLabel = Instance.new("ImageLabel")
IconLabel.BackgroundTransparency = 1
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.Position = UDim2.new(0, 0, 0, 0)
IconLabel.Image = "rbxassetid://120155019758434"
IconLabel.ScaleType = Enum.ScaleType.Crop 
IconLabel.Parent = MinimizedFrame
Instance.new("UICorner", IconLabel).CornerRadius = UDim.new(0, 10)

MinimizeBtn.MouseButton1Click:Connect(function()
    MinimizedFrame.Position = MainFrame.Position
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MinimizedFrame.MouseButton1Click:Connect(function()
    MainFrame.Position = MinimizedFrame.Position
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    if _G.MM2_Hub_Connections then
        for _, conn in ipairs(_G.MM2_Hub_Connections) do
            if conn and typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
        end
    end
    ScreenGui:Destroy()
end)

local SideBar = Instance.new("Frame")
SideBar.BackgroundColor3 = Theme.Secondary
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.Size = UDim2.new(0, 110, 1, -40)
SideBar.Parent = MainFrame
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local TabList = Instance.new("Frame")
TabList.BackgroundTransparency = 1
TabList.Size = UDim2.new(1, 0, 1, 0)
TabList.Parent = SideBar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 6)
Instance.new("UIListLayout", TabList).HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIListLayout", TabList).VerticalAlignment = Enum.VerticalAlignment.Top

local ContentFrame = Instance.new("Frame")
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 110, 0, 40)
ContentFrame.Size = UDim2.new(1, -110, 1, -40)
ContentFrame.Parent = MainFrame

local Tabs = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Theme.BtnOff
    btn.Size = UDim2.new(1, -15, 0, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.Parent = TabList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, -10, 1, -10)
    frame.Position = UDim2.new(0, 5, 0, 5)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Theme.Accent
    frame.Visible = false
    frame.Parent = ContentFrame
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 5)
    
    Tabs[name] = {btn = btn, frame = frame}
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            TweenService:Create(t.btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.BtnOff}):Play()
            t.frame.Visible = false
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.BtnOn}):Play()
        frame.Visible = true
    end)
    
    frame.ChildAdded:Connect(function()
        task.wait()
        local layout = frame:FindFirstChildOfClass("UIListLayout")
        if layout then frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10) end
    end)
    return frame
end

local MainTab = CreateTab("Main", 1)
local TargetTab = CreateTab("Target", 2)
local EffectsTab = CreateTab("Effects", 3)

local states = { esp = true, noclip = false, fly = false, autofarm = false, aimbot = false, purple_filter = false }
local flySpeed = 50
local fovSize = 300
local espObjects = {}
local selectedTarget = nil
local connections = {}
local currentParticleType = "None"
local aimbotConnection = nil

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "MM2_PurpleFilter"
ColorCorrection.TintColor = Color3.fromRGB(200, 50, 255)
ColorCorrection.Contrast = 0.2
ColorCorrection.Saturation = -0.2
ColorCorrection.Enabled = false
ColorCorrection.Parent = Lighting

local currentParticlePart = nil

local function applyParticle(type)
    if currentParticlePart then currentParticlePart:Destroy() end
    if type == "None" then return end
    
    currentParticlePart = Instance.new("Part")
    currentParticlePart.Size = Vector3.new(50, 10, 50)
    currentParticlePart.Anchored = true
    currentParticlePart.CanCollide = false
    currentParticlePart.Transparency = 1
    currentParticlePart.Parent = workspace
    
    local emitter = Instance.new("ParticleEmitter")
    emitter.Rate = 50
    emitter.Lifetime = NumberRange.new(2, 6)
    emitter.Speed = NumberRange.new(1, 20)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.EmissionDirection = Enum.NormalId.Bottom
    emitter.Acceleration = Vector3.new(0, -3, 0)
    emitter.LockedToPart = false
    
    local purpleColor = ColorSequence.new(Color3.fromRGB(180, 50, 255))
    
    if type == "Heart" then
        emitter.Texture = "rbxassetid://4747071246"
        emitter.Color = purpleColor
    elseif type == "Star" then
        emitter.Texture = "rbxassetid://6031075931"
        emitter.Color = purpleColor
    elseif type == "Money" then
        emitter.Texture = "rbxassetid://1439512662"
        emitter.Color = purpleColor
    end
    
    emitter.Parent = currentParticlePart
    
    task.spawn(function()
        while currentParticlePart and currentParticlePart.Parent do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                currentParticlePart.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 30, 0)
            end
            task.wait(0.1)
        end
    end)
end

local FilterBtn = Instance.new("TextButton")
FilterBtn.BackgroundColor3 = Theme.BtnOff
FilterBtn.Size = UDim2.new(1, 0, 0, 30)
FilterBtn.Font = Enum.Font.GothamBold
FilterBtn.Text = "PURPLE FILTER: OFF"
FilterBtn.TextColor3 = Theme.Text
FilterBtn.TextSize = 11
FilterBtn.LayoutOrder = 1
FilterBtn.Parent = EffectsTab
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 6)
FilterBtn.MouseButton1Click:Connect(function()
    states.purple_filter = not states.purple_filter
    FilterBtn.Text = "PURPLE FILTER: " .. (states.purple_filter and "ON" or "OFF")
    FilterBtn.BackgroundColor3 = states.purple_filter and Theme.BtnOn or Theme.BtnOff
    ColorCorrection.Enabled = states.purple_filter
end)

local ParticleLabel = Instance.new("TextLabel")
ParticleLabel.BackgroundTransparency = 1
ParticleLabel.Size = UDim2.new(1, 0, 0, 30)
ParticleLabel.Font = Enum.Font.GothamBold
ParticleLabel.Text = "PARTICLES"
ParticleLabel.TextColor3 = Theme.Text
ParticleLabel.TextSize = 12
ParticleLabel.LayoutOrder = 2
ParticleLabel.Parent = EffectsTab

local ParticleFrame = Instance.new("Frame")
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.Size = UDim2.new(1, 0, 0, 30)
ParticleFrame.LayoutOrder = 3
ParticleFrame.Parent = EffectsTab
Instance.new("UIListLayout", ParticleFrame).FillDirection = Enum.FillDirection.Horizontal
Instance.new("UIListLayout", ParticleFrame).Padding = UDim.new(0, 4)

local particleButtons = {}

local function updateParticleButtons()
    for pType, btn in pairs(particleButtons) do
        if currentParticleType == pType then
            btn.BackgroundColor3 = Theme.BtnOn
        else
            btn.BackgroundColor3 = Theme.BtnOff
        end
    end
end

local function CreateParticleBtn(text, pType, order)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Theme.BtnOff
    btn.Size = UDim2.new(0.23, 0, 1, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.TextSize = 10
    btn.LayoutOrder = order
    btn.Parent = ParticleFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    particleButtons[pType] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentParticleType = pType
        updateParticleButtons()
        applyParticle(pType)
    end)
end

CreateParticleBtn("Hearts", "Heart", 1)
CreateParticleBtn("Stars", "Star", 2)
CreateParticleBtn("Money", "Money", 3)
CreateParticleBtn("None", "None", 4)
updateParticleButtons()

local function startNoclip()
    if connections.noclip then connections.noclip:Disconnect() end
    connections.noclip = SaveConnection(RunService.Stepped:Connect(function()
        if not states.noclip then return end
        local char = LocalPlayer.Character
        if char then for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then c.CanCollide = false end end end
    end))
end
local function stopNoclip()
    if connections.noclip then connections.noclip:Disconnect() end
    local char = LocalPlayer.Character
    if char then for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then c.CanCollide = true end end end
end

local bv, bg, flyConn
local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
    end
end
local function startFly()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    pcall(function()
        hum.PlatformStand = true
        bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.maxTorque = Vector3.new(9e5, 9e5, 9e5); bg.cframe = hrp.CFrame
        bv = Instance.new("BodyVelocity", hrp); bv.velocity = Vector3.new(0, 0, 0); bv.maxForce = Vector3.new(9e5, 9e5, 9e5)
        flyConn = RunService.RenderStepped:Connect(function()
            if not states.fly or not hrp or not char.Parent then stopFly() return end
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            bv.velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.new(0, 0, 0)
            bg.cframe = Camera.CFrame
        end)
    end)
end

local function startAutoFarm()
    if connections.farm then connections.farm:Disconnect() end
    connections.farm = task.spawn(function()
        while states.autofarm do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local nearestPos, minD = nil, 1000
                for _, obj in pairs(workspace:GetDescendants()) do
                    local n = string.lower(obj.Name)
                    if (n:find("coin") or n:find("candy") or n:find("money")) and not obj:IsDescendantOf(char) then
                        local pos = obj:IsA("BasePart") and obj.Position or (obj:IsA("Model") and obj:GetPivot().Position)
                        if pos then
                            local d = (hrp.Position - pos).Magnitude
                            if d < minD then minD = d; nearestPos = pos end
                        end
                    end
                end
                if nearestPos then
                    hrp.CFrame = CFrame.new(nearestPos + Vector3.new(0, 2, 0))
                    task.wait(0.05)
                else
                    task.wait(0.2)
                end
            else
                task.wait(0.2)
            end
        end
    end)
end
local function stopAutoFarm()
    if connections.farm then 
        states.autofarm = false
        task.cancel(connections.farm)
        connections.farm = nil
    end
end

local function grabGun()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local gunDrop = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
            local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if targetPart and targetPart.Parent ~= char then
                gunDrop = targetPart
                break
            end
        end
    end
    if gunDrop then
        local oldPos = hrp.CFrame
        hrp.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0, 2, 0))
        task.wait(0.15)
        hrp.CFrame = oldPos
    end
end

local function getPlayerColor(player)
    local char = player.Character
    local bp = player.Backpack
    if not char or not bp then return Color3.fromRGB(0, 255, 0) end
    if char:FindFirstChild("Knife") then return Color3.fromRGB(255, 0, 0) end
    if char:FindFirstChild("Gun") then return Color3.fromRGB(0, 100, 255) end
    if bp:FindFirstChild("Knife") then return Color3.fromRGB(255, 0, 0) end
    if bp:FindFirstChild("Gun") then return Color3.fromRGB(0, 100, 255) end
    return Color3.fromRGB(0, 255, 0)
end
local function removeESP(player)
    if espObjects[player] then 
        for _, obj in pairs(espObjects[player]) do if obj and obj.Parent then obj:Destroy() end end 
        espObjects[player] = nil 
    end
end
local function createESP(player)
    if not states.esp then return end
    removeESP(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Head") then return end
    espObjects[player] = {}
    local color = getPlayerColor(player)
    local hl = Instance.new("Highlight", char); hl.Adornee = char; hl.FillColor = color; hl.FillTransparency = 0.5; hl.OutlineColor = color
    table.insert(espObjects[player], hl)
    if player ~= LocalPlayer then
        local bb = Instance.new("BillboardGui", char.Head); bb.AlwaysOnTop = true; bb.Size = UDim2.new(0, 200, 0, 50); bb.ExtentsOffset = Vector3.new(0, 2.5, 0)
        local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = player.Name; lbl.TextColor3 = color; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14
        table.insert(espObjects[player], bb)
    end
end

local function killAllInstant()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local knife = char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))
    if not knife or not hum then return end
    
    if knife.Parent == LocalPlayer.Backpack then 
        hum:EquipTool(knife) 
        task.wait(0.2) 
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
            local tHum = p.Character:FindFirstChildOfClass("Humanoid")
            if tHrp and tHum and tHum.Health > 0 then
                pcall(function()
                    char.HumanoidRootPart.CFrame = tHrp.CFrame * CFrame.new(0, 0, 1)
                    knife:Activate() 
                end)
            end
        end
    end
end

local function CreateButton(parent, name, displayName, order, onClick)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = displayName .. ": " .. (states[name] and "ON" or "OFF")
    btn.TextColor3 = Theme.Text
    btn.TextSize = 11
    btn.LayoutOrder = order
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 30, 120)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff}):Play() end)
    btn.MouseButton1Click:Connect(function()
        states[name] = not states[name]
        btn.Text = displayName .. ": " .. (states[name] and "ON" or "OFF")
        btn.BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff
        onClick()
    end)
    return btn
end

CreateButton(MainTab, "fly", "FLY", 1, function() if states.fly then startFly() else stopFly() end end)
CreateButton(MainTab, "noclip", "NOCLIP (WALLS)", 2, function() if states.noclip then startNoclip() else stopNoclip() end end)
CreateButton(MainTab, "autofarm", "AUTO FARM (FAST)", 3, function() if states.autofarm then startAutoFarm() else stopAutoFarm() end end)
CreateButton(MainTab, "esp", "ESP PLAYERS", 4, function() 
    if states.esp then for _, p in pairs(Players:GetPlayers()) do createESP(p) end 
    else for p, _ in pairs(espObjects) do removeESP(p) end end 
end)

local GrabGunBtn = Instance.new("TextButton")
GrabGunBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
GrabGunBtn.Size = UDim2.new(1, 0, 0, 30)
GrabGunBtn.Font = Enum.Font.GothamBold
GrabGunBtn.Text = "GRAB GUN NOW"
GrabGunBtn.TextColor3 = Color3.new(1,1,1)
GrabGunBtn.TextSize = 11
GrabGunBtn.LayoutOrder = 5
GrabGunBtn.Parent = MainTab
Instance.new("UICorner", GrabGunBtn).CornerRadius = UDim.new(0, 6)
GrabGunBtn.MouseButton1Click:Connect(function() grabGun() end)

local StopBtn = Instance.new("TextButton")
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
StopBtn.Size = UDim2.new(1, 0, 0, 34)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Text = "STOP ALL"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.LayoutOrder = 6
StopBtn.Parent = MainTab
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)
StopBtn.MouseButton1Click:Connect(function()
    stopFly(); stopNoclip(); stopAutoFarm(); states.esp = false; states.autofarm = false; states.aimbot = false;
    ColorCorrection.Enabled = false;
    if currentParticlePart then currentParticlePart:Destroy() end
    for p, _ in pairs(espObjects) do removeESP(p) end; FovCircle.Visible = false;
end)

local SelectTargetBtn = Instance.new("TextButton"); 
SelectTargetBtn.BackgroundColor3 = Theme.BtnOff; 
SelectTargetBtn.Size = UDim2.new(1, 0, 0, 30); 
SelectTargetBtn.Font = Enum.Font.GothamBold; 
SelectTargetBtn.Text = "Target: None"; 
SelectTargetBtn.TextColor3 = Theme.Text; 
SelectTargetBtn.LayoutOrder = 1; 
SelectTargetBtn.Parent = TargetTab
Instance.new("UICorner", SelectTargetBtn).CornerRadius = UDim.new(0, 6)

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.BackgroundColor3 = Theme.BtnOff
PlayerListScroll.Size = UDim2.new(1, 0, 0, 100)
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.ScrollBarThickness = 3
PlayerListScroll.ScrollBarImageColor3 = Theme.Accent
PlayerListScroll.LayoutOrder = 2
PlayerListScroll.Visible = false
PlayerListScroll.Parent = TargetTab
Instance.new("UICorner", PlayerListScroll).CornerRadius = UDim.new(0, 6)
Instance.new("UIListLayout", PlayerListScroll).Padding = UDim.new(0, 3)

local function refreshPlayerList()
    for _, child in ipairs(PlayerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local p
