local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ID СКИНА
local SKIN_SHAXED = 124994246147928

-- ID ФОНОВ
local BG_DEFAULT = 123806149814449
local BG_ORANGE = 138974528086602
local BG_SAKURA = 111536806870768

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
    Accent = Color3.fromRGB(30, 30, 30),
    AccentDark = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(255, 255, 255), 
    BtnOff = Color3.fromRGB(15, 15, 15),
    BtnOn = Color3.fromRGB(50, 50, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    ActiveTextColor = Color3.fromRGB(255, 255, 255) 
}

local AllButtons = {}

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
MainFrame.BackgroundTransparency = 1
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

-- ФОН (КАРТИНКА)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.Image = "rbxassetid://" .. BG_DEFAULT
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.ImageTransparency = 0.05
BackgroundImage.ZIndex = 1
BackgroundImage.Parent = MainFrame
Instance.new("UICorner", BackgroundImage).CornerRadius = UDim.new(0, 12)

-- ВЕРХНЯЯ ПАНЕЛЬ
local TopBar = Instance.new("Frame")
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BackgroundTransparency = 0.2
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.ZIndex = 2
TopBar.ClipsDescendants = true
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentDark)})
TopGradient.Rotation = 45
TopGradient.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "PURPLE HUB"
Title.TextColor3 = Theme.TextColor
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
AuthorText.TextColor3 = Color3.fromRGB(255, 255, 255)
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
MinimizeBtn.TextColor3 = Theme.TextColor
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
CloseBtn.TextColor3 = Theme.TextColor
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
SideBar.BackgroundTransparency = 1
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
    btn.BackgroundTransparency = 0.4
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Theme.TextColor
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.ZIndex = 3
    btn.Parent = TabList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.6
    
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
    
    Tabs[name] = {btn = btn, frame = frame, stroke = stroke}
    table.insert(AllButtons, {btn = btn, stroke = stroke, isTab = true})
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            TweenService:Create(t.btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.BtnOff, BackgroundTransparency = 0.4, TextColor3 = Theme.TextColor}):Play()
            TweenService:Create(t.btn:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Transparency = 0.6}):Play()
            t.frame.Visible = false
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.BtnOn, BackgroundTransparency = 0, TextColor3 = Theme.ActiveTextColor}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        frame.Visible = true
    end)
    
    return frame
end

local MainTab = CreateTab("Main", 1)
local PlayerTab = CreateTab("Player", 2) -- ЗДЕСЬ НАПИСАНО PLAYER
local TargetTab = CreateTab("Target", 3)
local AvatarTab = CreateTab("Avatar", 4)
local FilterTab = CreateTab("Filter Screen", 5)
local ThemeTab = CreateTab("Theme", 6)
local NeOtrivatTab = CreateTab("НЕ ОТКРЫВАТЬ", 7)

-- ЛОГИКА
local states = { esp = false, noclip = false, fly = false, autofarm = false, aimbot = false, hitbox = false, purple_filter = false, skin_active = false }
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

local function ApplyThemeToAll()
    for _, item in ipairs(AllButtons) do
        if item.btn and item.btn.Parent then
            if item.isTab then
                if item.btn.BackgroundColor3 == Theme.BtnOn then
                    item.btn.BackgroundColor3 = Theme.BtnOn
                    item.stroke.Color = Theme.Accent
                else
                    item.btn.BackgroundColor3 = Theme.BtnOff
                    item.stroke.Color = Theme.Accent
                end
                item.btn.TextColor3 = Theme.TextColor
            else
                if item.btn.Text:find("ON") then
                    item.btn.BackgroundColor3 = Theme.BtnOn
                else
                    item.btn.BackgroundColor3 = Theme.BtnOff
                end
                item.btn.TextColor3 = Theme.TextColor
                if item.stroke then item.stroke.Color = Theme.Accent end
            end
        end
    end
    
    for _, v in pairs(MainFrame:GetDescendants()) do
        if v:IsA("UIStroke") then
            v.Color = Theme.Accent
        end
        if v:IsA("TextButton") and v.BackgroundColor3 == Color3.fromRGB(255, 120, 0) then
            v.BackgroundColor3 = Theme.Accent
        end
    end
end

local function changeTheme(bgId, accentColor, accentDark, btnOn, textColor, activeTextColor)
    BackgroundImage.Image = "rbxassetid://" .. bgId
    Theme.Accent = accentColor
    Theme.AccentDark = accentDark
    Theme.BtnOn = btnOn
    Theme.TextColor = textColor or Color3.fromRGB(255, 255, 255)
    Theme.ActiveTextColor = activeTextColor or Color3.fromRGB(255, 255, 255)
    
    ColorCorrection.TintColor = accentColor
    
    UIStroke.Color = Theme.Accent
    TopGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentDark)})
    MinimizeBtn.BackgroundColor3 = Theme.AccentDark
    MinStroke.Color = Theme.Accent
    ResizeBtn.BackgroundColor3 = Theme.AccentDark
    
    SideBar.BackgroundColor3 = Theme.Secondary
    
    ApplyThemeToAll()
end

-- ФУНКЦИЯ СКИНОВ
local function toggleCustomSkin(skinId)
    local char = LocalPlayer.Character
    if not char then return end
    
    states.skin_active = false
    
    if skinId ~= 0 then
        states.skin_active = true
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1
            elseif part:IsA("Decal") or part:IsA("Accessory") then
                part:Destroy()
            end
        end
        
        task.spawn(function()
            local success, model = pcall(function() return game:GetObjects("rbxassetid://" .. skinId)[1] end)
            if success and model then
                customSkinModel = model
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if model:IsA("Model") then
                        model:PivotTo(hrp.CFrame)
                    else
                        model.CFrame = hrp.CFrame
                    end
                    
                    model.Parent = char
                    for _, part in pairs(model:GetDescendants()) do
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
    btn.BackgroundTransparency = 0.4
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Font = Enum.Font.GothamBold
    btn.Text = displayName .. ": " .. (states[name] and "ON" or "OFF")
    btn.TextColor3 = states[name] and Theme.ActiveTextColor or Theme.TextColor
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.ZIndex = 4
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = states[name] and 0 or 0.8
    
    table.insert(AllButtons, {btn = btn, stroke = stroke, isTab = false})
    
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentDark, BackgroundTransparency = 0.2}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff, BackgroundTransparency = 0.4}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = states[name] and 0 or 0.8}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        states[name] = not states[name]
        btn.Text = displayName .. ": " .. (states[name] and "ON" or "OFF")
        btn.BackgroundColor3 = states[name] and Theme.BtnOn or Theme.BtnOff
        btn.TextColor3 = states[name] and Theme.ActiveTextColor or Theme.TextColor
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = states[name] and 0 or 0.8}):Play()
        onClick()
    end)
    return btn
end

-- ОСНОВНЫЕ КНОПКИ (Main)
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
FovBgMain.BackgroundTransparency = 0.4
FovBgMain.Size = UDim2.new(1, 0, 0, 34)
FovBgMain.LayoutOrder = 5
FovBgMain.ZIndex = 4
FovBgMain.Parent = MainTab
Instance.new("UICorner", FovBgMain).CornerRadius = UDim.new(0, 8)
local FovBgStroke = Instance.new("UIStroke", FovBgMain)
FovBgStroke.Color = Theme.Accent
FovBgStroke.Thickness = 1
FovBgStroke.Transparency = 0.8
table.insert(AllButtons, {btn = FovBgMain, stroke = FovBgStroke, isTab = false})

local FovSliderMain = Instance.new("TextButton")
FovSliderMain.BackgroundColor3 = Theme.Accent
FovSliderMain.Size = UDim2.new(0.5, 0, 1, 0) 
FovSliderMain.Text = "Camera FOV: 70"
FovSliderMain.Font = Enum.Font.GothamBold
FovSliderMain.TextColor3 = Theme.TextColor
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
GrabGunBtn.BackgroundTransparency = 0.4
GrabGunBtn.Size = UDim2.new(1, 0, 0, 34)
GrabGunBtn.Font = Enum.Font.GothamBold
GrabGunBtn.Text = "GRAB GUN NOW"
GrabGunBtn.TextColor3 = Theme.TextColor
GrabGunBtn.TextSize = 12
GrabGunBtn.LayoutOrder = 6
GrabGunBtn.ZIndex = 4
GrabGunBtn.Parent = MainTab
Instance.new("UICorner", GrabGunBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = GrabGunBtn, stroke = nil, isTab = false})
GrabGunBtn.MouseButton1Click:Connect(function() grabGun() end)

local StopBtn = Instance.new("TextButton")
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
StopBtn.BackgroundTransparency = 0.4
StopBtn.Size = UDim2.new(1, 0, 0, 36)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Text = "STOP ALL"
StopBtn.TextColor3 = Theme.TextColor
StopBtn.LayoutOrder = 7
StopBtn.ZIndex = 4
StopBtn.Parent = MainTab
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = StopBtn, stroke = nil, isTab = false})
StopBtn.MouseButton1Click:Connect(function()
    stopFly(); stopNoclip(); stopAutoFarm(); states.esp = false; states.autofarm = false; states.aimbot = false;
    states.hitbox = false; toggleCustomSkin(0);
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.UseJumpPower = true end
    ColorCorrection.Enabled = false; states.purple_filter = false;
    FilterBtn.Text = "FILTER: OFF"; FilterBtn.BackgroundColor3 = Theme.BtnOff;
    Camera.FieldOfView = 70; FovSliderMain.Text = "Camera FOV: 70"; FovSliderMain.Size = UDim2.new(0.5, 0, 1, 0);
    for p, _ in pairs(espObjects) do removeESP(p) end; FovCircle.Visible = false;
end)

-- ВКЛАДКА PLAYER
local SpeedBg = Instance.new("Frame")
SpeedBg.BackgroundColor3 = Theme.BtnOff
SpeedBg.BackgroundTransparency = 0.4
SpeedBg.Size = UDim2.new(1, 0, 0, 34)
SpeedBg.LayoutOrder = 1
SpeedBg.ZIndex = 4
SpeedBg.Parent = PlayerTab
Instance.new("UICorner", SpeedBg).CornerRadius = UDim.new(0, 8)
local SpeedStroke = Instance.new("UIStroke", SpeedBg)
SpeedStroke.Color = Theme.Accent
SpeedStroke.Thickness = 1
SpeedStroke.Transparency = 0.8
table.insert(AllButtons, {btn = SpeedBg, stroke = SpeedStroke, isTab = false})

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.BackgroundColor3 = Theme.Accent
SpeedSlider.Size = UDim2.new(0.2, 0, 1, 0) 
SpeedSlider.Text = "Speed: 16"
SpeedSlider.Font = Enum.Font.GothamBold
SpeedSlider.TextColor3 = Theme.TextColor
SpeedSlider.TextSize = 11
SpeedSlider.ZIndex = 4
SpeedSlider.Parent = SpeedBg
Instance.new("UICorner", SpeedSlider).CornerRadius = UDim.new(0, 8)

local draggingSpeed = false
SpeedSlider.MouseButton1Down:Connect(function() draggingSpeed = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSpeed = false end end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingSpeed then
        local mouseX = UserInputService:GetMouseLocation().X
        local framePos = SpeedBg.AbsolutePosition.X; local frameSize = SpeedBg.AbsoluteSize.X
        local relativeX = math.clamp((mouseX - framePos) / frameSize, 0.05, 1)
        SpeedSlider.Size = UDim2.new(relativeX, 0, 1, 0)
        local ws = math.floor(16 + (relativeX * 234))
        SpeedSlider.Text = "Speed: " .. ws
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = ws end
    end
end)

local JumpBg = Instance.new("Frame")
JumpBg.BackgroundColor3 = Theme.BtnOff
JumpBg.BackgroundTransparency = 0.4
JumpBg.Size = UDim2.new(1, 0, 0, 34)
JumpBg.LayoutOrder = 2
JumpBg.ZIndex = 4
JumpBg.Parent = PlayerTab
Instance.new("UICorner", JumpBg).CornerRadius = UDim.new(0, 8)
local JumpStroke = Instance.new("UIStroke", JumpBg)
JumpStroke.Color = Theme.Accent
JumpStroke.Thickness = 1
JumpStroke.Transparency = 0.8
table.insert(AllButtons, {btn = JumpBg, stroke = JumpStroke, isTab = false})

local JumpSlider = Instance.new("TextButton")
JumpSlider.BackgroundColor3 = Theme.Accent
JumpSlider.Size = UDim2.new(0.2, 0, 1, 0)
JumpSlider.Text = "Jump: 50"
JumpSlider.Font = Enum.Font.GothamBold
JumpSlider.TextColor3 = Theme.TextColor
JumpSlider.TextSize = 11
JumpSlider.ZIndex = 4
JumpSlider.Parent = JumpBg
Instance.new("UICorner", JumpSlider).CornerRadius = UDim.new(0, 8)

local draggingJump = false
JumpSlider.MouseButton1Down:Connect(function() draggingJump = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingJump = false end end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingJump then
        local mouseX = UserInputService:GetMouseLocation().X
        local framePos = JumpBg.AbsolutePosition.X; local frameSize = JumpBg.AbsoluteSize.X
        local relativeX = math.clamp((mouseX - framePos) / frameSize, 0.05, 1)
        JumpSlider.Size = UDim2.new(relativeX, 0, 1, 0)
        local jp = math.floor(50 + (relativeX * 450))
        JumpSlider.Text = "Jump: " .. jp
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = jp
            hum.UseJumpPower = true
        end
    end
end)

local ResetPlayerBtn = Instance.new("TextButton")
ResetPlayerBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
ResetPlayerBtn.BackgroundTransparency = 0.4
ResetPlayerBtn.Size = UDim2.new(1, 0, 0, 36)
ResetPlayerBtn.Font = Enum.Font.GothamBold
ResetPlayerBtn.Text = "RESET STATS"
ResetPlayerBtn.TextColor3 = Theme.TextColor
ResetPlayerBtn.LayoutOrder = 3
ResetPlayerBtn.ZIndex = 4
ResetPlayerBtn.Parent = PlayerTab
Instance.new("UICorner", ResetPlayerBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = ResetPlayerBtn, stroke = nil, isTab = false})
ResetPlayerBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        hum.UseJumpPower = true
    end
    SpeedSlider.Size = UDim2.new(0.2, 0, 1, 0)
    SpeedSlider.Text = "Speed: 16"
    JumpSlider.Size = UDim2.new(0.2, 0, 1, 0)
    JumpSlider.Text = "Jump: 50"
end)

-- ВКЛАДКА TARGET
local SelectTargetBtn = Instance.new("TextButton"); 
SelectTargetBtn.BackgroundColor3 = Theme.BtnOff; 
SelectTargetBtn.BackgroundTransparency = 0.4
SelectTargetBtn.Size = UDim2.new(1, 0, 0, 34); 
SelectTargetBtn.Font = Enum.Font.GothamBold; 
SelectTargetBtn.Text = "Target: None"; 
SelectTargetBtn.TextColor3 = Theme.TextColor; 
SelectTargetBtn.LayoutOrder = 1; 
SelectTargetBtn.ZIndex = 4
SelectTargetBtn.Parent = TargetTab
Instance.new("UICorner", SelectTargetBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = SelectTargetBtn, stroke = nil, isTab = false})

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.BackgroundColor3 = Theme.BtnOff
PlayerListScroll.BackgroundTransparency = 0.4
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
            pBtn.BackgroundTransparency = 0.4
            pBtn.Size = UDim2.new(1, -4, 0, 28)
            pBtn.Font = Enum.Font.GothamBold
            pBtn.Text = p.Name
            pBtn.TextColor3 = Theme.TextColor
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

local TpToTargetBtn = Instance.new("TextButton"); TpToTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); TpToTargetBtn.BackgroundTransparency = 0.4; TpToTargetBtn.Size = UDim2.new(1, 0, 0, 34); TpToTargetBtn.Font = Enum.Font.GothamBold; TpToTargetBtn.Text = "ТП К ЦЕЛИ"; TpToTargetBtn.TextColor3 = Theme.TextColor; TpToTargetBtn.LayoutOrder = 3; TpToTargetBtn.ZIndex = 4; TpToTargetBtn.Parent = TargetTab
Instance.new("UICorner", TpToTargetBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = TpToTargetBtn, stroke = nil, isTab = false})
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
AimFovBg.BackgroundTransparency = 0.4
AimFovBg.Size = UDim2.new(1, 0, 0, 34); 
AimFovBg.LayoutOrder = 5; 
AimFovBg.ZIndex = 4
AimFovBg.Parent = TargetTab
Instance.new("UICorner", AimFovBg).CornerRadius = UDim.new(0, 8)
local AimFovStroke = Instance.new("UIStroke", AimFovBg)
AimFovStroke.Color = Theme.Accent
AimFovStroke.Thickness = 1
AimFovStroke.Transparency = 0.8
table.insert(AllButtons, {btn = AimFovBg, stroke = AimFovStroke, isTab = false})

local AimFovSlider = Instance.new("TextButton"); 
AimFovSlider.BackgroundColor3 = Theme.Accent; 
AimFovSlider.Size = UDim2.new(0.6, 0, 1, 0); 
AimFovSlider.Text = "Aimbot FOV: 300"; 
AimFovSlider.Font = Enum.Font.GothamBold; 
AimFovSlider.TextColor3 = Theme.TextColor; 
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
HitboxBtn.BackgroundTransparency = 0.4
HitboxBtn.Size = UDim2.new(1, 0, 0, 36)
HitboxBtn.Font = Enum.Font.GothamBold
HitboxBtn.Text = "HITBOX EXPANDER: OFF"
HitboxBtn.TextColor3 = Theme.TextColor
HitboxBtn.TextSize = 12
HitboxBtn.LayoutOrder = 6
HitboxBtn.ZIndex = 4
HitboxBtn.Parent = TargetTab
Instance.new("UICorner", HitboxBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = HitboxBtn, stroke = nil, isTab = false})

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
FilterBtn.BackgroundTransparency = 0.4
FilterBtn.Size = UDim2.new(1, 0, 0, 34)
FilterBtn.Font = Enum.Font.GothamBold
FilterBtn.Text = "FILTER: OFF"
FilterBtn.TextColor3 = Theme.TextColor
FilterBtn.TextSize = 12
FilterBtn.LayoutOrder = 1
FilterBtn.ZIndex = 4
FilterBtn.Parent = FilterTab
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = FilterBtn, stroke = nil, isTab = false})
FilterBtn.MouseButton1Click:Connect(function()
    states.purple_filter = not states.purple_filter
    FilterBtn.Text = "FILTER: " .. (states.purple_filter and "ON" or "OFF")
    FilterBtn.BackgroundColor3 = states.purple_filter and Theme.BtnOn or Theme.BtnOff
    ColorCorrection.Enabled = states.purple_filter
end)

-- АВАТАР
local SkinShaxedBtn = Instance.new("TextButton")
SkinShaxedBtn.BackgroundColor3 = Theme.BtnOff
SkinShaxedBtn.BackgroundTransparency = 0.4
SkinShaxedBtn.Size = UDim2.new(1, 0, 0, 36)
SkinShaxedBtn.Font = Enum.Font.GothamBold
SkinShaxedBtn.Text = "SKIN: Shaxed"
SkinShaxedBtn.TextColor3 = Theme.TextColor
SkinShaxedBtn.TextSize = 12
SkinShaxedBtn.LayoutOrder = 1
SkinShaxedBtn.ZIndex = 4
SkinShaxedBtn.Parent = AvatarTab
Instance.new("UICorner", SkinShaxedBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = SkinShaxedBtn, stroke = nil, isTab = false})
SkinShaxedBtn.MouseButton1Click:Connect(function()
    toggleCustomSkin(SKIN_SHAXED)
end)

local ResetSkinBtn = Instance.new("TextButton")
ResetSkinBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
ResetSkinBtn.BackgroundTransparency = 0.4
ResetSkinBtn.Size = UDim2.new(1, 0, 0, 36)
ResetSkinBtn.Font = Enum.Font.GothamBold
ResetSkinBtn.Text = "RESET SKIN"
ResetSkinBtn.TextColor3 = Theme.TextColor
ResetSkinBtn.TextSize = 12
ResetSkinBtn.LayoutOrder = 2
ResetSkinBtn.ZIndex = 4
ResetSkinBtn.Parent = AvatarTab
Instance.new("UICorner", ResetSkinBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = ResetSkinBtn, stroke = nil, isTab = false})
ResetSkinBtn.MouseButton1Click:Connect(function()
    toggleCustomSkin(0)
end)

local SkinInfo = Instance.new("TextLabel")
SkinInfo.BackgroundTransparency = 1
SkinInfo.Size = UDim2.new(1, 0, 0, 30)
SkinInfo.Font = Enum.Font.GothamBold
SkinInfo.Text = "Выберите скин."
SkinInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
SkinInfo.TextSize = 11
SkinInfo.LayoutOrder = 3
SkinInfo.ZIndex = 4
SkinInfo.Parent = AvatarTab

-- ТЕМА (ФОНЫ)
local function CreateThemeBtn(text, bgId, accent, accentDark, btnOn, textColor, activeTextColor, order)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Theme.BtnOff
    btn.BackgroundTransparency = 0.4
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Theme.TextColor
    btn.TextSize = 12
    btn.LayoutOrder = order
    btn.ZIndex = 4
    btn.Parent = ThemeTab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.8
    
    table.insert(AllButtons, {btn = btn, stroke = stroke, isTab = false})
    
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play() end)
    
    btn.MouseButton1Click:Connect(function()
        changeTheme(bgId, accent, accentDark, btnOn, textColor, activeTextColor)
    end)
end

CreateThemeBtn("ORANGE THEME", BG_ORANGE, Color3.fromRGB(255, 120, 0), Color3.fromRGB(200, 80, 0), Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), 1)
CreateThemeBtn("SAKURA THEME", BG_SAKURA, Color3.fromRGB(255, 100, 150), Color3.fromRGB(200, 50, 100), Color3.fromRGB(255, 120, 170), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), 2)
CreateThemeBtn("DEFAULT THEME", BG_DEFAULT, Color3.fromRGB(30, 30, 30), Color3.fromRGB(15, 15, 15), Color3.fromRGB(50, 50, 50), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), 3)

-- КНОПКА ВНУТРИ ВКЛАДКИ "НЕ ОТКРЫВАТЬ"
local CrashBtn = Instance.new("TextButton")
CrashBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CrashBtn.BackgroundTransparency = 0.4
CrashBtn.Size = UDim2.new(1, 0, 0, 50)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.Text = "НЕ НАЖИМАТЬ"
CrashBtn.TextColor3 = Theme.TextColor
CrashBtn.TextSize = 14
CrashBtn.LayoutOrder = 1
CrashBtn.ZIndex = 4
CrashBtn.Parent = NeOtrivatTab
Instance.new("UICorner", CrashBtn).CornerRadius = UDim.new(0, 8)
table.insert(AllButtons, {btn = CrashBtn, stroke = nil, isTab = false})

CrashBtn.MouseButton1Click:Connect(function()
    LocalPlayer:Kick("Я же сказал не нажимать")
end)

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
Tabs["Main"].btn.TextColor3 = Theme.ActiveTextColor
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
