local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CUSTOM_SKIN_ID = 124994246147928
local UI_BACKGROUND_ID = 124844189564405

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
    Main = Color3.fromRGB(15, 10, 20), 
    Secondary = Color3.fromRGB(30, 15, 45), 
    Accent = Color3.fromRGB(170, 0, 255), 
    AccentDark = Color3.fromRGB(100, 0, 160),
    Text = Color3.fromRGB(255, 255, 255), 
    BtnOff = Color3.fromRGB(35, 20, 50), 
    BtnOn = Color3.fromRGB(120, 0, 200)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Purple_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- ОВЕРЛЕЙ
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

-- ОСНОВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.BackgroundTransparency = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 460, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Theme.Accent
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2

-- ФОН
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.Image = "rbxassetid://" .. UI_BACKGROUND_ID
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.ImageTransparency = 0.05
BackgroundImage.ZIndex = 1
BackgroundImage.Parent = MainFrame

-- ВЕРХНЯЯ ПАНЕЛЬ
local TopBar = Instance.new("Frame")
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BackgroundTransparency = 0.2
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.ZIndex = 2
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)
local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 80))})
TopGradient.Rotation = 45
TopGradient.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "PURPLE HUB"
Title.TextColor3 = Theme.Text
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = TopBar

local AuthorText = Instance.new("TextLabel")
AuthorText.BackgroundTransparency = 1
AuthorText.Position = UDim2.new(0, 150, 0, 0)
AuthorText.Size = UDim2.new(0, 200, 1, 0)
AuthorText.Font = Enum.Font.GothamMedium
AuthorText.Text = "Author: Secret"
AuthorText.TextColor3 = Color3.fromRGB(200, 150, 255)
AuthorText.TextSize = 12
AuthorText.TextXAlignment = Enum.TextXAlignment.Left
AuthorText.ZIndex = 3
AuthorText.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 10)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 24)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.TextSize = 18
MinimizeBtn.ZIndex = 3
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
CloseBtn.Position = UDim2.new(1, -30, 0, 10)
CloseBtn.Size = UDim2.new(0, 22, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.TextSize = 18
CloseBtn.ZIndex = 3
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

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

-- РАСТЯГИВАНИЕ ОКНА
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.BackgroundColor3 = Theme.AccentDark
ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
ResizeBtn.Size = UDim2.new(0, 15, 0, 15)
ResizeBtn.Text = ""
ResizeBtn.ZIndex = 10
ResizeBtn.Parent = MainFrame
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 4)

local isResizing = false
local startSize = nil
local startMousePos = nil

ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        startSize = MainFrame.AbsoluteSize
        startMousePos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mouseDelta = input.Position - startMousePos
        local newWidth = math.clamp(startSize.X + mouseDelta.X, 350, 800)
        local newHeight = math.clamp(startSize.Y + mouseDelta.Y, 300, 600)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

-- САЙДБАР
local SideBar = Instance.new("Frame")
SideBar.BackgroundColor3 = Theme.Secondary
SideBar.BackgroundTransparency = 0.3
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.Size = UDim2.new(0, 120, 1, -45)
SideBar.ZIndex = 2
SideBar.Parent = MainFrame
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)

local TabList = Instance.new("Frame")
TabList.BackgroundTransparency = 1
TabList.Size = UDim2.new(1, 0, 1, 0)
TabList.ZIndex = 3
TabList.Parent = SideBar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 8)
Instance.new("UIListLayout", TabList).HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIListLayout", TabList).VerticalAlignment = Enum.VerticalAlignment.Top

local ContentFrame = Instance.new("Frame")
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 120, 0, 45)
ContentFrame.Size = UDim2.new(1, -120, 1, -45)
ContentFrame.ZIndex = 3
ContentFrame.Parent = MainFrame

local Tabs = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Theme.BtnOff
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.ZIndex = 3
    btn.Parent = TabList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, -15, 1, -15)
    frame.Position = UDim2.new(0, 5, 0, 5)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Theme.Accent
    frame.Visible = false
    frame.ZIndex = 4
    frame.Parent = ContentFrame
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 8)
    
    Tabs[name] = {btn = btn, frame = frame}
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            TweenService:Create(t.btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.BtnOff}):Play()
            TweenService:Create(t.btn:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Transparency = 0.5}):Play()
            t.frame.Visible = false
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.BtnOn}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        frame.Visible = true
    end)
    
    return frame
end

local MainTab = CreateTab("Main", 1)
local TargetTab = CreateTab("Target", 2)
local AvatarTab = CreateTab("Avatar", 3)
local FilterTab = CreateTab("Filter Screen", 4)

-- ЛОГИКА
local states = { esp = false, noclip = false, fly = false, autofarm = false, aimbot = false, hitbox = false, purple_filter = false, custom_skin = false }
local flySpeed = 50
local espObjects = {}
local selectedTarget = nil
local connections = {}
local aimbotFov = 300
local customSkinModel = nil

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "PurpleFilter"
ColorCorrection.TintColor = Color3.fromRGB(120, 0, 255)
ColorCorrection.Contrast = 0.15
ColorCorrection.Saturation = 0.1
ColorCorrection.Enabled = false
ColorCorrection.Parent = Lighting

local function toggleCustomSkin()
    local char = LocalPlayer.Character
    if not char then return end
    if states.custom_skin then
        if CUSTOM_SKIN_ID == 0 then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1
            elseif part:IsA("Decal") or part:IsA("Accessory") then
                part:Destroy()
            end
        end
        task.spawn(function()
            local success, model = pcall(function() return game:GetObjects("rbxassetid://" .. CUSTOM_SKIN_ID)[1] end)
            if success and model then
                customSkinModel = model
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if customSkinModel:IsA("Model") then customSkinModel:PivotTo(hrp.CFrame) else customSkinModel.CFrame = hrp.CFrame end
                    customSkinModel.Parent = char
                    for _, part in pairs(customSkinModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Massless = true
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = hrp
                            weld.Part1 = part
                            weld.Parent = part
                        end
                    end
                end
            end
        end)
    else
        if customSkinModel then customSkinModel:Destroy() customSkinModel = nil end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0 end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:RemoveAccessories()
            if hum:GetAppliedDescription() then hum:ApplyDescription(hum:GetAppliedDescription()) end
        end
    end
end

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

local farmBV, farmBG
local function startAutoFarm()
    if connections.farm then connections.farm:Disconnect() end
    states.noclip = true
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        farmBV = Instance.new("BodyVelocity", hrp); farmBV.MaxForce = Vector3.new(9e5, 9e5, 9e5); farmBV.Velocity = Vector3.new(0, 0, 0)
        farmBG = Instance.new("BodyGyro", hrp); farmBG.MaxTorque = Vector3.new(9e5, 9e5, 9e5); farmBG.P = 9e4; farmBG.CFrame = hrp.CFrame
    end
    connections.farm = task.spawn(function()
        while states.autofarm do
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if h and farmBV then
                local nearestPos, minD = nil, 1000
                for _, obj in pairs(workspace:GetDescendants()) do
                    local n = string.lower(obj.Name)
                    if (n:find("coin") or n:find("candy") or n:find("money")) and not obj:IsDescendantOf(c) then
                        local pos = obj:IsA("BasePart") and obj.Position or (obj:IsA("Model") and obj:GetPivot().Position)
                        if pos then
                            local d = (h.Position - pos).Magnitude
                            if d < minD then minD = d; nearestPos = pos end
                        end
                    end
                end
                if nearestPos then
                    local moveDir = (nearestPos - h.Position).Unit
                    farmBV.Velocity = moveDir * 50
                    farmBG.CFrame = CFrame.lookAt(h.Position, nearestPos)
                    task.wait(0.1)
                else
                    farmBV.Velocity = Vector3.new(0, 0, 0)
                    task.wait(0.2)
                end
            else
                task.wait(0.2)
            end
        end
    end)
end
local function stopAutoFarm()
    states.autofarm = false; states.noclip = false
    if farmBV then farmBV:Destroy() farmBV = nil end
    if farmBG then farmBG:Destroy() farmBG = nil end
    if connections.farm then task.cancel(connections.farm); connections.farm = nil end
end

local function grabGun()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local gunDrop = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
            local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if targetPart and targetPart.Parent ~= char then gunDrop = targetPart; break end
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
    if char:FindFirstChild("Knife") or bp:FindFirstChild("Knife") then return Color3.fromRGB(255, 0, 0) end
    if char:FindFirstChild("Gun") or bp:FindFirstChild("Gun") then return Color3.fromRGB(0, 100, 255) end
    return Color3.fromRGB(0, 255, 0)
end

local function removeESP(player)
    if espObjects[player] then 
        for _, obj in pairs(espObjects[player]) do if obj and obj.Parent then obj:Destroy() end end 
        espObjects[player] = nil 
    end
end

-- ТОЛЬКО ИГРОКИ (СВЕЧЕНИЕ + ОБВОДКА)
local function createESP(player)
    if not states.esp then return end
    removeESP(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Head") then return end
    espObjects[player] = {}
    local color = getPlayerColor(player)
    
    local hl = Instance.new("Highlight", char)
    hl.Adornee = char
    hl.FillColor = color
    hl.FillTransparency = 0.5
    hl.OutlineColor = color
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(espObjects[player], hl)

    if player ~= LocalPlayer then
        local bb = Instance.new("BillboardGui", char.Head)
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.ExtentsOffset = Vector3.new(0, 2.5, 0)
        
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = player.Name
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.TextStrokeTransparency = 0.5
        lbl.TextStrokeColor3 = Color3.new(0,0,0)
        
        table.insert(espObjects[player], bb)
    end
end

local function CreateButton(parent, name, displayName, order, onClick)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Font = Enum.Font.GothamBold
    btn.Text = displayName .. ": " .. (states[name] and "ON" or "OFF")
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.ZIndex = 4
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = states[name] and 0 or 0.8
    
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 0, 170)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = states[name] and 0 or 0.8}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        states[name] = not states[name]
        btn.Text = displayName .. ": " .. (states[name] and "ON" or "OFF")
        btn.BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = states[name] and 0 or 0.8}):Play()
        onClick()
    end)
    return btn
end

CreateButton(MainTab, "fly", "FLY", 1, function() if states.fly then startFly() else stopFly() end end)
CreateButton(MainTab, "noclip", "NOCLIP (WALLS)", 2, function() if states.noclip then startNoclip() else stopNoclip() end end)
CreateButton(MainTab, "autofarm", "AUTO FARM (SMOOTH)", 3, function() if states.autofarm then startAutoFarm() else stopAutoFarm() end end)
CreateButton(MainTab, "esp", "ESP PLAYERS", 4, function() 
    if states.esp then 
        for _, p in pairs(Players:GetPlayers()) do createESP(p) end 
    else 
        for p, _ in pairs(espObjects) do removeESP(p) end 
    end 
end)

local FovBgMain = Instance.new("Frame")
FovBgMain.BackgroundColor3 = Theme.BtnOff
FovBgMain.Size = UDim2.new(1, 0, 0, 34)
FovBgMain.LayoutOrder = 5
FovBgMain.ZIndex = 4
FovBgMain.Parent = MainTab
Instance.new("UICorner", FovBgMain).CornerRadius = UDim.new(0, 8)
local FovBgStroke = Instance.new("UIStroke", FovBgMain)
FovBgStroke.Color = Theme.Accent
FovBgStroke.Thickness = 1
FovBgStroke.Transparency = 0.8

local FovSliderMain = Instance.new("TextButton")
FovSliderMain.BackgroundColor3 = Theme.Accent
FovSliderMain.Size = UDim2.new(0.5, 0, 1, 0) 
FovSliderMain.Text = "Camera FOV: 70"
FovSliderMain.Font = Enum.Font.GothamBold
FovSliderMain.TextColor3 = Color3.new(1,1,1)
FovSliderMain.TextSize = 11
FovSliderMain.ZIndex = 4
FovSliderMain.Parent = FovBgMain
Instance.new("UICorner", FovSliderMain).CornerRadius = UDim.new(0, 8)

local draggingFovMain = false
FovSliderMain.MouseButton1Down:Connect(function() draggingFovMain = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFovMain = false end end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingFovMain then
        local mouseX = UserInputService:GetMouseLocation().X
        local framePos = FovBgMain.AbsolutePosition.X; local frameSize = FovBgMain.AbsoluteSize.X
        local relativeX = math.clamp((mouseX - framePos) / frameSize, 0, 1)
        FovSliderMain.Size = UDim2.new(relativeX, 0, 1, 0)
        local camFov = math.floor(30 + (relativeX * 90))
        FovSliderMain.Text = "Camera FOV: " .. camFov
        Camera.FieldOfView = camFov
    end
end)

local GrabGunBtn = Instance.new("TextButton")
GrabGunBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
GrabGunBtn.Size = UDim2.new(1, 0, 0, 34)
GrabGunBtn.Font = Enum.Font.GothamBold
GrabGunBtn.Text = "GRAB GUN NOW"
GrabGunBtn.TextColor3 = Color3.new(1,1,1)
GrabGunBtn.TextSize = 12
GrabGunBtn.LayoutOrder = 6
GrabGunBtn.ZIndex = 4
GrabGunBtn.Parent = MainTab
Instance.new("UICorner", GrabGunBtn).CornerRadius = UDim.new(0, 8)
GrabGunBtn.MouseButton1Click:Connect(function() grabGun() end)

local StopBtn = Instance.new("TextButton")
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
StopBtn.Size = UDim2.new(1, 0, 0, 36)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Text = "STOP ALL"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.LayoutOrder = 7
StopBtn.ZIndex = 4
StopBtn.Parent = MainTab
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 8)
StopBtn.MouseButton1Click:Connect(function()
    stopFly(); stopNoclip(); stopAutoFarm(); states.esp = false; states.autofarm = false; states.aimbot = false;
    states.hitbox = false; 
    ColorCorrection.Enabled = false; states.purple_filter = false;
    FilterBtn.Text = "FILTER: OFF"; FilterBtn.BackgroundColor3 = Theme.BtnOff;
    Camera.FieldOfView = 70; FovSliderMain.Text = "Camera FOV: 70"; FovSliderMain.Size = UDim2.new(0.5, 0, 1, 0);
    for p, _ in pairs(espObjects) do removeESP(p) end; FovCircle.Visible = false;
end)

local SelectTargetBtn = Instance.new("TextButton"); 
SelectTargetBtn.BackgroundColor3 = Theme.BtnOff; 
SelectTargetBtn.Size = UDim2.new(1, 0, 0, 34); 
SelectTargetBtn.Font = Enum.Font.GothamBold; 
SelectTargetBtn.Text = "Target: None"; 
SelectTargetBtn.TextColor3 = Theme.Text; 
SelectTargetBtn.LayoutOrder = 1; 
SelectTargetBtn.ZIndex = 4
SelectTargetBtn.Parent = TargetTab
Instance.new("UICorner", SelectTargetBtn).CornerRadius = UDim.new(0, 8)

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.BackgroundColor3 = Theme.BtnOff
PlayerListScroll.Size = UDim2.new(1, 0, 0, 100)
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.ScrollBarThickness = 3
PlayerListScroll.ScrollBarImageColor3 = Theme.Accent
PlayerListScroll.LayoutOrder = 2
PlayerListScroll.Visible = false
PlayerListScroll.ZIndex = 4
PlayerListScroll.Parent = TargetTab
Instance.new("UICorner", PlayerListScroll).CornerRadius = UDim.new(0, 8)
Instance.new("UIListLayout", PlayerListScroll).Padding = UDim.new(0, 3)

local function refreshPlayerList()
    for _, child in ipairs(PlayerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.BackgroundColor3 = Theme.Main
            pBtn.Size = UDim2.new(1, -4, 0, 28)
            pBtn.Font = Enum.Font.GothamBold
            pBtn.Text = p.Name
            pBtn.TextColor3 = Theme.Text
            pBtn.TextSize = 11
            pBtn.ZIndex = 5
            pBtn.Parent = PlayerListScroll
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            pBtn.MouseButton1Click:Connect(function()
                selectedTarget = p
                SelectTargetBtn.Text = "Target: " .. p.Name
                PlayerListScroll.Visible = false
            end)
        end
    end
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, count * 32)
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

SelectTargetBtn.MouseButton1Click:Connect(function()
    PlayerListScroll.Visible = not PlayerListScroll.Visible
    if PlayerListScroll.Visible then refreshPlayerList() end
end)

local TpToTargetBtn = Instance.new("TextButton"); TpToTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); TpToTargetBtn.Size = UDim2.new(1, 0, 0, 34); TpToTargetBtn.Font = Enum.Font.GothamBold; TpToTargetBtn.Text = "ТП К ЦЕЛИ"; TpToTargetBtn.TextColor3 = Color3.new(1,1,1); TpToTargetBtn.LayoutOrder = 3; TpToTargetBtn.ZIndex = 4; TpToTargetBtn.Parent = TargetTab
Instance.new("UICorner", TpToTargetBtn).CornerRadius = UDim.new(0, 8)
TpToTargetBtn.MouseButton1Click:Connect(function() if selectedTarget and selectedTarget.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2) end end)

CreateButton(TargetTab, "aimbot", "AIMBOT (LOCK)", 4, function() 
    FovCircle.Visible = states.aimbot
    if states.aimbot then
        SaveConnection(RunService.RenderStepped:Connect(function()
            if not states.aimbot then return end
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local closest = nil
            local minDist = aimbotFov / 2
            local currentPing = 0
            pcall(function() currentPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local hasKnife = (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife"))
                    if hasKnife then
                        local headPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if onScreen then
                            local dist = (Vector2.new(headPos.X, headPos.Y) - screenCenter).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closest = p
                            end
                        end
                    end
                end
            end
            if closest then
                local head = closest.Character:FindFirstChild("Head")
                if head then
                    local predPos = head.Position + (head.AssemblyLinearVelocity * currentPing)
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, predPos), 0.5)
                end
            end
        end))
    end
end)

local AimFovBg = Instance.new("Frame"); 
AimFovBg.BackgroundColor3 = Theme.BtnOff; 
AimFovBg.Size = UDim2.new(1, 0, 0, 34); 
AimFovBg.LayoutOrder = 5; 
AimFovBg.ZIndex = 4
AimFovBg.Parent = TargetTab
Instance.new("UICorner", AimFovBg).CornerRadius = UDim.new(0, 8)
local AimFovStroke = Instance.new("UIStroke", AimFovBg)
AimFovStroke.Color = Theme.Accent
AimFovStroke.Thickness = 1
AimFovStroke.Transparency = 0.8

local AimFovSlider = Instance.new("TextButton"); 
AimFovSlider.BackgroundColor3 = Theme.Accent; 
AimFovSlider.Size = UDim2.new(0.6, 0, 1, 0); 
AimFovSlider.Text = "Aimbot FOV: 300"; 
AimFovSlider.Font = Enum.Font.GothamBold; 
AimFovSlider.TextColor3 = Color3.new(1,1,1); 
AimFovSlider.TextSize = 10; 
AimFovSlider.ZIndex = 4
AimFovSlider.Parent = AimFovBg
Instance.new("UICorner", AimFovSlider).CornerRadius = UDim.new(0, 8)

local draggingAimFov = false
AimFovSlider.MouseButton1Down:Connect(function() draggingAimFov = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingAimFov = false end end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingAimFov then
        local mouseX = UserInputService:GetMouseLocation().X
        local framePos = AimFovBg.AbsolutePosition.X; local frameSize = AimFovBg.AbsoluteSize.X
        local relativeX = math.clamp((mouseX - framePos) / frameSize, 0.1, 1)
        AimFovSlider.Size = UDim2.new(relativeX, 0, 1, 0)
        aimbotFov = math.floor(relativeX * 500) + 50
        AimFovSlider.Text = "Aimbot FOV: " .. aimbotFov
        FovCircle.Size = UDim2.new(0, aimbotFov, 0, aimbotFov)
        FovCircle.Position = UDim2.new(0.5, -aimbotFov/2, 0.5, -aimbotFov/2)
    end
end)

local HitboxBtn = Instance.new("TextButton")
HitboxBtn.BackgroundColor3 = Theme.BtnOff
HitboxBtn.Size = UDim2.new(1, 0, 0, 36)
HitboxBtn.Font = Enum.Font.GothamBold
HitboxBtn.Text = "HITBOX EXPANDER: OFF"
HitboxBtn.TextColor3 = Color3.new(1,1,1)
HitboxBtn.TextSize = 12
HitboxBtn.LayoutOrder = 6
HitboxBtn.ZIndex = 4
HitboxBtn.Parent = TargetTab
Instance.new("UICorner", HitboxBtn).CornerRadius = UDim.new(0, 8)

HitboxBtn.MouseButton1Click:Connect(function()
    states.hitbox = not states.hitbox
    HitboxBtn.Text = "HITBOX EXPANDER: " .. (states.hitbox and "ON" or "OFF")
    HitboxBtn.BackgroundColor3 = states.hitbox and Theme.BtnOn or Theme.BtnOff
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and states.hitbox then
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool and tool.Name == "Knife" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                    if tHum and tHum.Health > 0 then
                        local oldCFrame = char.HumanoidRootPart.CFrame
                        char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        task.wait(0.05)
                        pcall(function() tool:Activate() end)
                        task.wait(0.05)
                        char.HumanoidRootPart.CFrame = oldCFrame
                    end
                end
            end
        end
    end
end)

local FilterBtn = Instance.new("TextButton")
FilterBtn.BackgroundColor3 = Theme.BtnOff
FilterBtn.Size = UDim2.new(1, 0, 0, 34)
FilterBtn.Font = Enum.Font.GothamBold
FilterBtn.Text = "FILTER: OFF"
FilterBtn.TextColor3 = Theme.Text
FilterBtn.TextSize = 12
FilterBtn.LayoutOrder = 1
FilterBtn.ZIndex = 4
FilterBtn.Parent = FilterTab
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 8)
FilterBtn.MouseButton1Click:Connect(function()
    states.purple_filter = not states.purple_filter
    FilterBtn.Text = "FILTER: " .. (states.purple_filter and "ON" or "OFF")
    FilterBtn.BackgroundColor3 = states.purple_filter and Theme.BtnOn or Theme.BtnOff
    ColorCorrection.Enabled = states.purple_filter
end)

-- АВАТАР
CreateButton(AvatarTab, "custom_skin", "CUSTOM SKIN", 1, function() toggleCustomSkin() end)

local SkinInfo = Instance.new("TextLabel")
SkinInfo.BackgroundTransparency = 1
SkinInfo.Size = UDim2.new(1, 0, 0, 30)
SkinInfo.Font = Enum.Font.GothamBold
SkinInfo.Text = "Модель применится."
SkinInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
SkinInfo.TextSize = 11
SkinInfo.LayoutOrder = 2
SkinInfo.ZIndex = 4
SkinInfo.Parent = AvatarTab

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then 
        if MainFrame.Visible then
            MainFrame.Visible = false; MinimizedFrame.Visible = true; MinimizedFrame.Position = MainFrame.Position
        else
            MainFrame.Visible = true; MinimizedFrame.Visible = false; MainFrame.Position = MinimizedFrame.Position
        end
    end
end)

Tabs["Main"].btn.BackgroundColor3 = Theme.BtnOn
Tabs["Main"].frame.Visible = true

task.spawn(function()
    while task.wait(1) do
        if states.esp then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not espObjects[p] then createESP(p) end
                else
                    removeESP(p)
                end
            end
        end
    end
end)

SaveConnection(RunService.Heartbeat:Connect(function()
    if not states.esp then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and espObjects[p] then
            local c = getPlayerColor(p)
            for _, o in pairs(espObjects[p]) do
                if o:IsA("Highlight") then o.FillColor = c; o.OutlineColor = c
                elseif o:IsA("BillboardGui") and o:FindFirstChild("TextLabel") then o.TextLabel.TextColor3 = c end
            end
        end
    end
end))

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
