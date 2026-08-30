-- ==========================================
-- SYRAK ULTIMATE HUB v8 (Kompakte Version)
-- ==========================================
local CoreGui, TS, UIS, RS, Players, Lighting = game:GetService("CoreGui"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("Players"), game:GetService("Lighting")
local LP = Players.LocalPlayer

if CoreGui:FindFirstChild("SyrakHubGui") then CoreGui.SyrakHubGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SyrakHubGui"
ScreenGui.ResetOnSpawn = false

local Blur = Instance.new("BlurEffect", Lighting) Blur.Size = 0

-- 1. INTRO SCREEN
local IntroFrame = Instance.new("Frame", ScreenGui) IntroFrame.Size = UDim2.new(1,0,1,0) IntroFrame.BackgroundColor3 = Color3.fromRGB(10,11,15) IntroFrame.BackgroundTransparency = 1

local IntroTitle = Instance.new("TextLabel", IntroFrame) IntroTitle.Size = UDim2.new(0,400,0,40) IntroTitle.Position = UDim2.new(0.5,-200,0.4,-20) IntroTitle.BackgroundTransparency = 1 IntroTitle.Text = "MADE BY SYRAK" IntroTitle.TextColor3 = Color3.fromRGB(0,170,255) IntroTitle.TextTransparency = 1 IntroTitle.TextSize = 36 IntroTitle.Font = Enum.Font.GothamBold

local IntroSub = Instance.new("TextLabel", IntroFrame) IntroSub.Size = UDim2.new(0,400,0,25) IntroSub.Position = UDim2.new(0.5,-200,0.4,25) IntroSub.BackgroundTransparency = 1 IntroSub.Text = "INITIALIZING CORE SYSTEMS..." IntroSub.TextColor3 = Color3.fromRGB(160,165,180) IntroSub.TextTransparency = 1 IntroSub.TextSize = 13 IntroSub.Font = Enum.Font.Gotham

local BarBg = Instance.new("Frame", IntroFrame) BarBg.Size = UDim2.new(0,300,0,6) BarBg.Position = UDim2.new(0.5,-150,0.4,65) BarBg.BackgroundColor3 = Color3.fromRGB(25,28,38) BarBg.BorderSizePixel = 0 BarBg.BackgroundTransparency = 1
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1,0)

local BarFill = Instance.new("Frame", BarBg) BarFill.Size = UDim2.new(0,0,1,0) BarFill.BackgroundColor3 = Color3.fromRGB(0,170,255) BarFill.BorderSizePixel = 0
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1,0)

-- 2. GUI ELEMENTS
local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Size = UDim2.new(0,340,0,290) MainFrame.Position = UDim2.new(0.5,-170,0.5,-145) MainFrame.BackgroundColor3 = Color3.fromRGB(16,17,22) MainFrame.BorderSizePixel = 0 MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

local TopBar = Instance.new("Frame", MainFrame) TopBar.Size = UDim2.new(1,0,0,42) TopBar.BackgroundColor3 = Color3.fromRGB(22,24,32) TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", TopBar) Title.Size = UDim2.new(1,-50,1,0) Title.Position = UDim2.new(0,15,0,0) Title.BackgroundTransparency = 1 Title.Text = "SYRAK HUB v8" Title.TextColor3 = Color3.fromRGB(0,170,255) Title.TextSize = 16 Title.Font = Enum.Font.GothamBold Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar) CloseBtn.Size = UDim2.new(0,30,0,30) CloseBtn.Position = UDim2.new(1,-35,0.5,-15) CloseBtn.BackgroundTransparency = 1 CloseBtn.Text = "X" CloseBtn.TextColor3 = Color3.fromRGB(180,180,180) CloseBtn.TextSize = 16 CloseBtn.Font = Enum.Font.GothamBold

local OpenBtn = Instance.new("TextButton", ScreenGui) OpenBtn.Size = UDim2.new(0,85,0,35) OpenBtn.Position = UDim2.new(0,15,0.3,0) OpenBtn.BackgroundColor3 = Color3.fromRGB(22,24,32) OpenBtn.Text = "SYRAK" OpenBtn.TextColor3 = Color3.fromRGB(0,170,255) OpenBtn.Font = Enum.Font.GothamBold OpenBtn.TextSize = 14 OpenBtn.Visible = false OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,8)

local Scroll = Instance.new("ScrollingFrame", Instance.new("Frame", MainFrame)) Scroll.Parent.Size = UDim2.new(1,-20,1,-55) Scroll.Parent.Position = UDim2.new(0,10,0,48) Scroll.Parent.BackgroundTransparency = 1 Scroll.Size = UDim2.new(1,0,1,0) Scroll.BackgroundTransparency = 1 Scroll.CanvasSize = UDim2.new(0,0,0,240) Scroll.ScrollBarThickness = 3 Scroll.ScrollBarImageColor3 = Color3.fromRGB(0,170,255)
local Layout = Instance.new("UIListLayout", Scroll) Layout.SortOrder = Enum.SortOrder.LayoutOrder Layout.Padding = UDim.new(0,8)

local function CreateButton(txt)
    local btn = Instance.new("TextButton", Scroll) btn.Size = UDim2.new(1,-10,0,42) btn.BackgroundColor3 = Color3.fromRGB(26,28,38) btn.Text = txt btn.TextColor3 = Color3.fromRGB(220,220,230) btn.Font = Enum.Font.Gotham btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

local SpeedBtn, JumpBtn, FlyBtn, NoclipBtn = CreateButton("Speed Boost (AN / AUS)"), CreateButton("High Jump (AN / AUS)"), CreateButton("Smooth Fly (AN / AUS)"), CreateButton("Noclip / Durch Wände (AN / AUS)")

-- 3. DRAG SYSTEM
local function MakeDraggable(obj, handle)
    handle = handle or obj
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = inp.Position startPos = obj.Position end end)
    UIS.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - dragStart obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
    handle.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
MakeDraggable(MainFrame, TopBar) MakeDraggable(OpenBtn, OpenBtn)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- 4. CHEAT FUNKTIONEN
local isSpeed, isJump, isFly, isNoclip = false, false, false, false
local bodyVel, bodyGyro, flyConn

SpeedBtn.MouseButton1Click:Connect(function() isSpeed = not isSpeed SpeedBtn.BackgroundColor3 = isSpeed and Color3.fromRGB(0,140,220) or Color3.fromRGB(26,28,38) end)
RS.RenderStepped:Connect(function() if LP.Character and LP.Character:FindFirstChild("Humanoid") then if isSpeed then LP.Character.Humanoid.WalkSpeed = 60 elseif LP.Character.Humanoid.WalkSpeed == 60 then LP.Character.Humanoid.WalkSpeed = 16 end end end)

JumpBtn.MouseButton1Click:Connect(function() isJump = not isJump JumpBtn.BackgroundColor3 = isJump and Color3.fromRGB(0,140,220) or Color3.fromRGB(26,28,38) end)
UIS.JumpRequest:Connect(function() if isJump and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.Velocity = Vector3.new(LP.Character.HumanoidRootPart.Velocity.X, 120, LP.Character.HumanoidRootPart.Velocity.Z) end end)

FlyBtn.MouseButton1Click:Connect(function()
    isFly = not isFly FlyBtn.BackgroundColor3 = isFly and Color3.fromRGB(0,140,220) or Color3.fromRGB(26,28,38)
    local char = LP.Character if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hrp, hum = char.HumanoidRootPart, char.Humanoid
    if isFly then
        hum.PlatformStand = true
        bodyVel = Instance.new("BodyVelocity", hrp) bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge) bodyVel.Velocity = Vector3.zero
        bodyGyro = Instance.new("BodyGyro", hrp) bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) bodyGyro.P = 9e4 bodyGyro.CFrame = hrp.CFrame
        flyConn = RS.RenderStepped:Connect(function()
            if not isFly or not char or not hrp then return end
            local cam, moveDir = workspace.CurrentCamera, hum.MoveDirection
            bodyGyro.CFrame = cam.CFrame
            if moveDir.Magnitude > 0 then
                local moveVec = (cam.CFrame.LookVector * (moveDir:Dot(cam.CFrame.LookVector))) + (cam.CFrame.RightVector * (moveDir:Dot(cam.CFrame.RightVector)))
                bodyVel.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * 50 or Vector3.zero
            else bodyVel.Velocity = Vector3.zero end
        end)
    else
        if flyConn then flyConn:Disconnect() end if bodyVel then bodyVel:Destroy() end if bodyGyro then bodyGyro:Destroy() end hum.PlatformStand = false
    end
end)

NoclipBtn.MouseButton1Click:Connect(function() isNoclip = not isNoclip NoclipBtn.BackgroundColor3 = isNoclip and Color3.fromRGB(0,140,220) or Color3.fromRGB(26,28,38) end)
RS.Stepped:Connect(function() if isNoclip and LP.Character then for _, p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)

-- 5. ANIMATED INTRO
local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TS:Create(IntroFrame, tInfo, {BackgroundTransparency = 0}):Play() TS:Create(IntroTitle, tInfo, {TextTransparency = 0}):Play() TS:Create(IntroSub, tInfo, {TextTransparency = 0}):Play() TS:Create(BarBg, tInfo, {BackgroundTransparency = 0}):Play() TS:Create(Blur, tInfo, {Size = 20}):Play()
task.wait(0.6) IntroSub.Text = "BYPASSING SECURITY..." TS:Create(BarFill, TweenInfo.new(0.8), {Size = UDim2.new(0.35,0,1,0)}):Play()
task.wait(0.8) IntroSub.Text = "LOADING MODULES & HOOKS..." TS:Create(BarFill, TweenInfo.new(0.9), {Size = UDim2.new(0.75,0,1,0)}):Play()
task.wait(0.9) IntroSub.Text = "SYSTEM READY! WELCOME SYRAK" TS:Create(BarFill, TweenInfo.new(0.5), {Size = UDim2.new(1,0,1,0)}):Play()
task.wait(0.7)
TS:Create(IntroFrame, tInfo, {BackgroundTransparency = 1}):Play() TS:Create(IntroTitle, tInfo, {TextTransparency = 1}):Play() TS:Create(IntroSub, tInfo, {TextTransparency = 1}):Play() TS:Create(BarBg, tInfo, {BackgroundTransparency = 1}):Play() TS:Create(BarFill, tInfo, {BackgroundTransparency = 1}):Play() TS:Create(Blur, tInfo, {Size = 0}):Play()
task.wait(0.5) IntroFrame:Destroy() Blur:Destroy() MainFrame.Visible = true
