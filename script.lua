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
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 0, 120)}):Play() end)
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

-- СЛАЙДЕР FOV (КАМЕРА) В MAIN
local FovBgMain = Instance.new("Frame")
FovBgMain.BackgroundColor3 = Theme.BtnOff
FovBgMain.Size = UDim2.new(1, 0, 0, 30)
FovBgMain.LayoutOrder = 5
FovBgMain.Parent = MainTab
Instance.new("UICorner", FovBgMain).CornerRadius = UDim.new(0, 6)

local FovSliderMain = Instance.new("TextButton")
FovSliderMain.BackgroundColor3 = Theme.Accent
FovSliderMain.Size = UDim2.new(0.5, 0, 1, 0) 
FovSliderMain.Text = "Camera FOV: 70"
FovSliderMain.Font = Enum.Font.GothamBold
FovSliderMain.TextColor3 = Color3.new(1,1,1)
FovSliderMain.TextSize = 11
FovSliderMain.Parent = FovBgMain
Instance.new("UICorner", FovSliderMain).CornerRadius = UDim.new(0, 6)

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

local FilterBtn = Instance.new("TextButton")
FilterBtn.BackgroundColor3 = Theme.BtnOff
FilterBtn.Size = UDim2.new(1, 0, 0, 30)
FilterBtn.Font = Enum.Font.GothamBold
FilterBtn.Text = "PURPLE FILTER: OFF"
FilterBtn.TextColor3 = Theme.Text
FilterBtn.TextSize = 11
FilterBtn.LayoutOrder = 6
FilterBtn.Parent = MainTab
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 6)
FilterBtn.MouseButton1Click:Connect(function()
    states.purple_filter = not states.purple_filter
    FilterBtn.Text = "PURPLE FILTER: " .. (states.purple_filter and "ON" or "OFF")
    FilterBtn.BackgroundColor3 = states.purple_filter and Theme.BtnOn or Theme.BtnOff
    ColorCorrection.Enabled = states.purple_filter
end)

local GrabGunBtn = Instance.new("TextButton")
GrabGunBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
GrabGunBtn.Size = UDim2.new(1, 0, 0, 30)
GrabGunBtn.Font = Enum.Font.GothamBold
GrabGunBtn.Text = "GRAB GUN NOW"
GrabGunBtn.TextColor3 = Color3.new(1,1,1)
GrabGunBtn.TextSize = 11
GrabGunBtn.LayoutOrder = 7
GrabGunBtn.Parent = MainTab
Instance.new("UICorner", GrabGunBtn).CornerRadius = UDim.new(0, 6)
GrabGunBtn.MouseButton1Click:Connect(function() grabGun() end)

local StopBtn = Instance.new("TextButton")
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
StopBtn.Size = UDim2.new(1, 0, 0, 34)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Text = "STOP ALL"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.LayoutOrder = 8
StopBtn.Parent = MainTab
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)
StopBtn.MouseButton1Click:Connect(function()
    stopFly(); stopNoclip(); stopAutoFarm(); states.esp = false; states.autofarm = false; states.aimbot = false;
    ColorCorrection.Enabled = false; states.purple_filter = false;
    FilterBtn.Text = "PURPLE FILTER: OFF"; FilterBtn.BackgroundColor3 = Theme.BtnOff;
    Camera.FieldOfView = 70; FovSliderMain.Text = "Camera FOV: 70"; FovSliderMain.Size = UDim2.new(0.5, 0, 1, 0);
    for p, _ in pairs(espObjects) do removeESP(p) end; FovCircle.Visible = false;
end)

-- ==================== ВКЛАДКА TARGET ====================
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
            local pBtn = Instance.new("TextButton")
            pBtn.BackgroundColor3 = Theme.Main
            pBtn.Size = UDim2.new(1, -4, 0, 28)
            pBtn.Font = Enum.Font.GothamBold
            pBtn.Text = p.Name
            pBtn.TextColor3 = Theme.Text
            pBtn.TextSize = 11
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

local TpToTargetBtn = Instance.new("TextButton"); TpToTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); TpToTargetBtn.Size = UDim2.new(1, 0, 0, 30); TpToTargetBtn.Font = Enum.Font.GothamBold; TpToTargetBtn.Text = "ТП К ЦЕЛИ"; TpToTargetBtn.TextColor3 = Color3.new(1,1,1); TpToTargetBtn.LayoutOrder = 3; TpToTargetBtn.Parent = TargetTab
Instance.new("UICorner", TpToTargetBtn).CornerRadius = UDim.new(0, 6)
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

-- СЛАЙДЕР FOV АИМБОТА В TARGET
local AimFovBg = Instance.new("Frame"); 
AimFovBg.BackgroundColor3 = Theme.BtnOff; 
AimFovBg.Size = UDim2.new(1, 0, 0, 30); 
AimFovBg.LayoutOrder = 5; 
AimFovBg.Parent = TargetTab
Instance.new("UICorner", AimFovBg).CornerRadius = UDim.new(0, 6)

local AimFovSlider = Instance.new("TextButton"); 
AimFovSlider.BackgroundColor3 = Theme.Accent; 
AimFovSlider.Size = UDim2.new(0.6, 0, 1, 0); 
AimFovSlider.Text = "Aimbot FOV: 300"; 
AimFovSlider.Font = Enum.Font.GothamBold; 
AimFovSlider.TextColor3 = Color3.new(1,1,1); 
AimFovSlider.TextSize = 10; 
AimFovSlider.Parent = AimFovBg
Instance.new("UICorner", AimFovSlider).CornerRadius = UDim.new(0, 6)

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
