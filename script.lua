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
