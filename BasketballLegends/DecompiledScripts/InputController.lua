local v1 = game:GetService("ReplicatedStorage")
game:GetService("CollectionService")
local u2 = game:GetService("UserInputService")
local u3 = game:GetService("Players")
local u4 = require(v1.Packages.Knit)
local u5 = require(v1.Modules.SharedUtil)
local u6 = require(v1:WaitForChild("Modules"):WaitForChild("Basketball"))
local u7 = require(v1.Modules.Items)
local u8 = u4.Player
local v9 = u4.CreateController
local v10 = {
    ["Name"] = "InputController",
    ["Args"] = {
        ["InAction"] = false,
        ["GuardCD"] = false,
        ["BlockCD"] = false,
        ["StealCD"] = false,
        ["ScreenCD"] = false,
        ["DunkCD"] = false,
        ["EuroCD"] = false,
        ["PumpFakeCD"] = false,
        ["Holding"] = false,
        ["Jumped"] = false,
        ["Released"] = false,
        ["Landed"] = false,
        ["Ended"] = false,
        ["InEuro"] = false,
        ["Posting"] = false,
        ["PostDirection"] = "Right",
        ["CanDribble"] = true,
        ["CanShoot"] = true,
        ["DoubleDribble"] = false,
        ["ShotType"] = "Jumpshot",
        ["LastRebound"] = tick(),
        ["KeyZ1"] = false,
        ["KeyZ2"] = false,
        ["KeyC1"] = false,
        ["KeyC2"] = false,
        ["KeyX1"] = false,
        ["KeyX2"] = false,
        ["KeyF1"] = false,
        ["KeyF2"] = false,
        ["ControllerPassing"] = false,
        ["EmoteCD"] = false,
        ["LastEmoteTick"] = 0,
        ["StopEmoteTick"] = 0
    },
    ["CurrentInputLayout"] = "Unidentified",
    ["ControlEvent"] = Instance.new("BindableEvent", script),
    ["LastInput"] = tick()
}
local u11 = v9(v10)
local u12 = nil
local u13 = nil
local u14 = nil
local u15 = nil
local u16 = nil
local u17 = nil
local u18 = workspace.CurrentCamera
local u19 = {
    [Enum.KeyCode.ButtonA] = true
}
function u11.KnitStart(u20) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u4
        [3] = u13
        [4] = u14
        [5] = u15
        [6] = u16
        [7] = u17
        [8] = u6
        [9] = u2
        [10] = u11
        [11] = u19
    --]]
    u12 = u4.GetService("ControlService")
    u13 = u4.GetController("DataController")
    u14 = u4.GetController("GameController")
    u15 = u4.GetController("PlayerController")
    u16 = u4.GetController("UIController")
    u17 = u4.GetController("VisualController")
    u6:Load()
    u2.InputBegan:Connect(function(p21, p22) --[[Anonymous function at line 96]]
        --[[
        Upvalues:
            [1] = u11
            [2] = u19
            [3] = u15
            [4] = u16
            [5] = u17
        --]]
        u11.LastInput = tick()
        if p22 and u19[p21.KeyCode] == nil then
            return
        elseif u15.Args.Setup == true then
            if p21.UserInputType == Enum.UserInputType.Keyboard then
                local v23 = p21.KeyCode
                if v23 == Enum.KeyCode.Tab then
                    u16.UIs.Leaderboard:Toggle()
                    return
                end
                if v23 == Enum.KeyCode.E then
                    u11:Shoot(true)
                    return
                end
                if v23 == Enum.KeyCode.Z then
                    u11:Combo("Left")
                    u11:Dribble("Left")
                    return
                end
                if v23 == Enum.KeyCode.C then
                    u11:Combo("Right")
                    u11:Dribble("Right")
                    return
                end
                if v23 == Enum.KeyCode.X then
                    u11:Combo("Back")
                    u11:Stepback()
                    return
                end
                if v23 == Enum.KeyCode.F then
                    if u15.Args.toolEquipped then
                        u11:Combo("Euro")
                        u11:Eurostep()
                    else
                        u11:Guard(true)
                    end
                end
                if v23 == Enum.KeyCode.G then
                    if u15.Args.toolEquipped then
                        u11:Post(true)
                    else
                        u11:Emote()
                    end
                end
                if v23 == Enum.KeyCode.V then
                    u11:Screen(true)
                    u11:SelfLob()
                    return
                end
                if v23 == Enum.KeyCode.Space then
                    u11:Jump()
                    return
                end
                if v23 == Enum.KeyCode.R then
                    if u15.Args.toolEquipped then
                        u11:PumpFake()
                    else
                        u11:Steal()
                    end
                end
                if v23 == Enum.KeyCode.One then
                    u11:Pass(1)
                    return
                end
                if v23 == Enum.KeyCode.Two then
                    u11:Pass(2)
                    return
                end
                if v23 == Enum.KeyCode.Three then
                    u11:Pass(3)
                    return
                end
                if v23 == Enum.KeyCode.Four then
                    u11:Pass(4)
                    return
                end
            else
                local v24 = p21.KeyCode
                if v24 == Enum.KeyCode.ButtonR2 then
                    u11:Shoot(true)
                    return
                end
                if v24 == Enum.KeyCode.DPadLeft then
                    u11:Combo("Left")
                    u11:Dribble("Left")
                    return
                end
                if v24 == Enum.KeyCode.DPadRight then
                    u11:Combo("Right")
                    u11:Dribble("Right")
                    return
                end
                if v24 == Enum.KeyCode.DPadDown then
                    u11:Combo("Back")
                    u11:Stepback()
                    return
                end
                if v24 == Enum.KeyCode.ButtonL2 then
                    if u15.Args.toolEquipped then
                        u11:Post(true)
                    else
                        u11:Guard(true)
                    end
                end
                if v24 == Enum.KeyCode.ButtonB then
                    if u11.Args.ControllerPassing == true then
                        u11:Pass(3)
                    else
                        u11:Screen(true)
                        u11:SelfLob()
                    end
                end
                if v24 == Enum.KeyCode.ButtonA then
                    if u11.Args.ControllerPassing == true then
                        u11:Pass(4)
                    else
                        u11:Jump()
                    end
                end
                if v24 == Enum.KeyCode.ButtonX then
                    if u15.Args.toolEquipped then
                        if u11.Args.ControllerPassing == true then
                            u11:Pass(1)
                        else
                            u11:PumpFake()
                        end
                    else
                        u11:Steal()
                        return
                    end
                end
                if v24 == Enum.KeyCode.ButtonY then
                    if not u15.Args.toolEquipped then
                        u11:Emote()
                        return
                    end
                    if u11.Args.ControllerPassing == true then
                        u11:Pass(2)
                        return
                    end
                else
                    if v24 == Enum.KeyCode.ButtonL1 then
                        u11:Combo("Euro")
                        u11:Eurostep()
                        return
                    end
                    if v24 == Enum.KeyCode.ButtonR1 then
                        u11.Args.ControllerPassing = true
                        return
                    end
                    if v24 == Enum.KeyCode.ButtonL3 then
                        u17:MSL()
                    end
                end
            end
        end
    end)
    u2.InputChanged:Connect(function(_) --[[Anonymous function at line 227]] end)
    u2.InputEnded:Connect(function(p25, _) --[[Anonymous function at line 231]]
        --[[
        Upvalues:
            [1] = u11
            [2] = u20
            [3] = u15
        --]]
        u11.LastInput = tick()
        if p25.UserInputType == Enum.UserInputType.Keyboard then
            local v26 = p25.KeyCode
            if v26 == Enum.KeyCode.E then
                u11:Shoot(false)
                return
            end
            if v26 == Enum.KeyCode.F then
                u11:Guard(false)
                return
            end
            if v26 == Enum.KeyCode.V then
                u11:Screen(false)
                return
            end
            if v26 == Enum.KeyCode.G and u20.Args.Posting == true then
                u11:Post(false)
                return
            end
        else
            local v27 = p25.KeyCode
            if v27 == Enum.KeyCode.ButtonR2 then
                u11:Shoot(false)
                return
            end
            if v27 == Enum.KeyCode.ButtonL2 then
                if u15.Args.toolEquipped then
                    u11:Post(false)
                else
                    u11:Guard(false)
                end
            end
            if v27 == Enum.KeyCode.ButtonB then
                u11:Screen(false)
                return
            end
            if v27 == Enum.KeyCode.ButtonR1 then
                u11.Args.ControllerPassing = false
            end
        end
    end)
    u2.TouchTapInWorld:Connect(function(_, _) --[[Anonymous function at line 264]] end)
    if u2.MouseEnabled then
        u20.CurrentInputLayout = "MouseKeyboard"
    elseif #u2:GetConnectedGamepads() > 0 then
        u20.CurrentInputLayout = "Gamepad"
    else
        u20.CurrentInputLayout = "Touch"
    end
    local v28 = u2:GetLastInputType()
    if v28 then
        if string.find(v28.Name, "Gamepad") == nil then
            if v28.Name == "Keyboard" or string.find(v28.Name, "Mouse") ~= nil then
                u20.CurrentInputLayout = "MouseKeyboard"
            elseif v28.Name == "Touch" then
                u20.CurrentInputLayout = "Touch"
            end
        else
            u20.CurrentInputLayout = "Gamepad"
        end
    end
    u2.LastInputTypeChanged:Connect(function(p29) --[[Anonymous function at line 291]]
        --[[
        Upvalues:
            [1] = u20
            [2] = u17
        --]]
        local v30 = u20.CurrentInputLayout
        if string.find(p29.Name, "Gamepad") == nil then
            if p29.Name == "Keyboard" or string.find(p29.Name, "Mouse") ~= nil then
                u20.CurrentInputLayout = "MouseKeyboard"
                u17:MSL(false)
            elseif p29.Name == "Touch" then
                u20.CurrentInputLayout = "Touch"
            end
        else
            u20.CurrentInputLayout = "Gamepad"
        end
        if u20.CurrentInputLayout ~= v30 then
            u20.ControlEvent:Fire(u20.CurrentInputLayout, v30)
        end
    end)
    while true do
        wait(1)
        u20.ControlEvent:Fire(u20.CurrentInputLayout)
        local _ = tick() - u11.LastInput
    end
end
function u11.GetBallValues(_) --[[Anonymous function at line 324]]
    --[[
    Upvalues:
        [1] = u6
    --]]
    local _, v31 = u6:GetValues()
    return v31
end
function cardinalConvert(p32)
    local v33 = p32.X
    local v34 = -p32.Z
    local v35 = math.atan2(v33, v34) / 1.5707963267948966
    local v36 = -math.round(v35) * 1.5707963267948966
    local v37 = -math.sin(v36)
    local v38 = -math.cos(v36)
    local v39 = math.abs(v37) <= 1e-10 and 0 or v37
    local v40 = math.abs(v38) <= 1e-10 and 0 or v38
    return Vector3.new(v39, 0, v40)
end
function u11.Shoot(p41, p42) --[[Anonymous function at line 341]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u14
        [3] = u6
        [4] = u5
        [5] = u8
        [6] = u18
        [7] = u16
        [8] = u12
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u14.GameValues then
            if not u14.GameValues.Inbounding then
                if p42 == true then
                    if p41.Args.CanShoot == true and p41.Args.Holding == false then
                        local _, v43 = u6:GetValues()
                        if not v43 then
                            return
                        end
                        local v44 = u5.Ball:GetGoal(u8)
                        if not v44 then
                            return
                        end
                        local v45 = u5.Math:XYMagnitude(u15.Args.HumanoidRootPart.Position, v44.Position)
                        if u15.Args.SpawnTick and tick() - u15.Args.SpawnTick < 5 then
                            return
                        end
                        if v45 < 15 and u15.Args.HumanoidRootPart.Velocity.Magnitude > 4 then
                            p41.Args.ShotType = "Layup"
                        else
                            p41.Args.ShotType = "Jumpshot"
                        end
                        if v45 < 2.5 then
                            return
                        end
                        p41.Args.CanShoot = false
                        p41.Args.Holding = true
                        p41.Args.Jumped = false
                        p41.Args.Released = false
                        p41.Args.Landed = false
                        local v46 = "Jumpshot"
                        local v47 = 1.25
                        if p41.Args.ShotType == "Layup" then
                            v46 = "Ball_Layup" .. (v43.Hand == "Right" and "R" or (v43.Hand == "Left" and "L" or false))
                            v47 = 1.75
                            if v45 < 10 then
                                v46 = "Ball_ShortLayup" .. (v43.Hand == "Right" and "R" or (v43.Hand == "Left" and "L" or false))
                            end
                        elseif p41.Args.ShotType == "Jumpshot" then
                            local v48 = u15.Args.HumanoidRootPart
                            local v49 = u15.Args.Humanoid
                            local v50 = u5.Ball:GetGoal(u8)
                            local v51 = u18.CFrame:VectorToObjectSpace(v49.MoveDirection).Unit
                            if v50 then
                                v51 = v50.CFrame:VectorToObjectSpace(v49.MoveDirection).Unit
                            end
                            if v50.CFrame:toObjectSpace(v48.CFrame).Z < 2 then
                                local v52 = v51.X
                                if math.abs(v52) > 0.9 then
                                    local v53 = v51.Z
                                    v51 = Vector3.new(v53, 0, 1)
                                end
                            end
                            if v51.X < -0.6 then
                                p41.Args.ShotType = "FadeLeft"
                                v46 = "JumpshotLeft"
                                v47 = 1.4
                            end
                            if v51.X > 0.6 then
                                p41.Args.ShotType = "FadeRight"
                                v46 = "JumpshotRight"
                                v47 = 1.4
                            end
                            if v51.Z > 0.6 then
                                p41.Args.ShotType = "FadeBack"
                                v46 = "Ball_FadeBack"
                                v47 = 1.4
                            end
                        end
                        if p41.Args.Posting then
                            p41.Args.Posting = false
                            u15:StopAnimation("Ball_PostDribbleR")
                            u15:StopAnimation("Ball_PostDribbleL")
                            if v43.Hand == "Right" then
                                u15:PlayAnimation("Ball_DribbleR")
                            elseif v43.Hand == "Left" then
                                u15:PlayAnimation("Ball_DribbleL")
                            end
                            if p41.Args.ShotType == "Jumpshot" or p41.Args.ShotType == "FadeBack" then
                                p41.Args.ShotType = "FadeBack"
                                v46 = "Ball_FadeBack"
                                v47 = 1.4
                            else
                                p41.Args.ShotType = "PostHook"
                                v46 = "Ball_PostHook" .. (v43.Hand == "Right" and "R" or (v43.Hand == "Left" and "L" or false))
                                v47 = 1.3
                            end
                        end
                        u15.Args.Humanoid.AutoRotate = false
                        u15.Args.Humanoid.WalkSpeed = 0
                        task.spawn(function() --[[Anonymous function at line 467]]
                            --[[
                            Upvalues:
                                [1] = u16
                            --]]
                            u16.UIs.Shooting:Handle()
                        end)
                        if p41.Args.InEuro then
                            local v54 = tick()
                            repeat
                                task.wait()
                            until tick() - v54 > 0.5 or not p41.Args.InEuro
                            v47 = v47 * 1.2
                            if not u15.Args.toolEquipped then
                                return
                            end
                        end
                        u12.StartShoot:Fire()
                        u15:PlayAnimation(v46, v47)
                        if p41.Args.ShotType == "Layup" then
                            u15:StartMovement("Forward", 7)
                            return
                        end
                        if p41.Args.ShotType == "ReverseLayup" then
                            u15:StartMovement("ForwardOpposite", 5)
                            return
                        end
                        if p41.Args.ShotType == "Jumpshot" then
                            u15:StartTurn()
                            repeat
                                task.wait()
                            until p41.Args.Jumped
                            u15:StopMovement()
                            if p41.Args.CanShoot == false then
                                u15:StartMovement("Forward", 3)
                                return
                            end
                        else
                            if p41.Args.ShotType == "FadeBack" then
                                u15:StartMovement("Back", 7)
                                return
                            end
                            if p41.Args.ShotType == "FadeLeft" then
                                u15:StartMovement("Left", 9)
                                return
                            end
                            if p41.Args.ShotType == "FadeRight" then
                                u15:StartMovement("Right", 9)
                                return
                            end
                            if p41.Args.ShotType == "PostHook" then
                                u15:StartMovement(p41.Args.PostDirection, 9)
                                return
                            end
                        end
                    end
                elseif p42 == false and (p41.Args.CanShoot == false and p41.Args.Holding == true) then
                    task.wait(0.1)
                    local v55 = u16.UIs.Shooting:GetCurrentPoint()
                    repeat
                        task.wait()
                    until p41.Args.Released
                    u12.Shoot:Fire(v55)
                    if p41.Args.ShotType == "Layup" then
                        task.wait(0.2)
                    elseif p41.Args.ShotType == "ReverseLayup" then
                        repeat
                            task.wait()
                        until p41.Args.Landed
                    elseif p41.Args.ShotType == "Jumpshot" then
                        repeat
                            task.wait()
                        until p41.Args.Landed
                    elseif p41.Args.ShotType == "FadeBack" then
                        repeat
                            task.wait()
                        until p41.Args.Landed
                    elseif p41.Args.ShotType == "FadeLeft" then
                        repeat
                            task.wait()
                        until p41.Args.Landed
                    elseif p41.Args.ShotType == "FadeRight" then
                        repeat
                            task.wait()
                        until p41.Args.Landed
                    elseif p41.Args.ShotType == "PostHook" then
                        repeat
                            task.wait()
                        until p41.Args.Landed
                    end
                    u15.Args.Humanoid.AutoRotate = true
                    if u14.GameValues and not u14.GameValues.Locked then
                        u15.Args.Humanoid.WalkSpeed = 17
                    end
                    u15:StopMovement()
                    p41.Args.CanShoot = true
                    p41.Args.Holding = false
                end
            end
        else
            return
        end
    else
        return
    end
end
function u11.Pass(p56, p57) --[[Anonymous function at line 541]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u3
        [3] = u8
        [4] = u17
        [5] = u12
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if p56.Args.CanShoot == false then
            return
        elseif p56.Args.InEuro or p56.Args.CanDribble ~= false then
            local v58 = nil
            for _, v59 in pairs(u3:GetPlayers()) do
                if v59:GetAttribute("Team") ~= nil and (v59:GetAttribute("Court") ~= nil and (v59 ~= u8 and (v59:GetAttribute("Team") == u8:GetAttribute("Team") and (v59:GetAttribute("Court") == u8:GetAttribute("Court") and (v59.Character and v59.Character:GetAttribute("Screening") ~= true))))) then
                    v58 = v59.Character
                end
            end
            if p57 then
                local v60 = u17:PassTagTable()
                if v60[p57] then
                    for _, v61 in pairs(u3:GetPlayers()) do
                        if v61.UserId == v60[p57] and (v61.Character and v61.Character:GetAttribute("Screening") ~= true) then
                            v58 = v61.Character
                        end
                    end
                end
            end
            if v58 then
                p56.Args.CanShoot = false
                p56.Args.CanDribble = false
                u15:PlayAnimation("Ball_Pass")
                u15:StartTurn(v58.HumanoidRootPart.Position)
                u15.Args.Humanoid.WalkSpeed = 8
                task.wait(0.25)
                u12.Pass:Fire(v58)
                u15:StopMovement()
            end
        end
    else
        return
    end
end
function u11.Dribble(p62, p63) --[[Anonymous function at line 589]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u14
        [3] = u6
        [4] = u12
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u14.GameValues then
            if u14.GameValues.Inbounding then
                return
            else
                local v64, v65 = u6:GetValues()
                if v65 then
                    if p62.Args.CanShoot == false then
                        return
                    elseif p62.Args.CanDribble == false then
                        return
                    elseif p62.Args.Posting then
                        return
                    elseif not p62.Args.DoubleDribble then
                        local v66 = string.sub(p63, 1, 3) == "BTB"
                        local v67 = string.sub(p63, 1, 4) == "Spin"
                        local v68
                        if v66 then
                            if p63 == "BTBLeft" and v65.Hand == "Right" then
                                return
                            end
                            if p63 == "BTBRight" and v65.Hand == "Left" then
                                return
                            end
                            v68 = p63 == "BTBRight" and "Left" or (p63 == "BTBLeft" and "Right" or p63)
                        else
                            v68 = p63
                        end
                        if v67 then
                            if p63 == "SpinLeft" and v65.Hand == "Right" then
                                return
                            end
                            if p63 == "SpinRight" and v65.Hand == "Left" then
                                return
                            end
                            v68 = p63 == "SpinRight" and "Left" or (p63 == "SpinLeft" and "Right" or v68)
                        end
                        local v69 = v65.Hand == p63 and "Hesi" or "Cross"
                        u12.StartDribble:Fire()
                        u15.Args.Humanoid.WalkSpeed = 0
                        p62.Args.CanShoot = false
                        p62.Args.CanDribble = false
                        p62.Args.Ended = false
                        u6:SetValue(v64, "Hand", v68)
                        u15:StartMovement(v68, 14)
                        u15:StopAnimation("Ball_DribbleR")
                        u15:StopAnimation("Ball_DribbleL")
                        if p63 == "Right" then
                            u15:PlayAnimation("Ball_" .. v69 .. "R", 1.75)
                        elseif p63 == "Left" then
                            u15:PlayAnimation("Ball_" .. v69 .. "L", 1.75)
                        elseif p63 == "BTBRight" then
                            u15:PlayAnimation("Ball_BTBR2L", 1.85)
                        elseif p63 == "BTBLeft" then
                            u15:PlayAnimation("Ball_BTBL2R", 1.85)
                        elseif p63 == "SpinRight" then
                            u15:PlayAnimation("Ball_SpinR2L", 2.75)
                        elseif p63 == "SpinLeft" then
                            u15:PlayAnimation("Ball_SpinL2R", 2.75)
                        end
                        repeat
                            task.wait()
                        until p62.Args.Ended
                        u15:StopMovement()
                        if u15.Args.Character:FindFirstChild("Basketball") then
                            if v68 == "Right" then
                                u15:PlayAnimation("Ball_DribbleR")
                            elseif v68 == "Left" then
                                u15:PlayAnimation("Ball_DribbleL")
                            end
                        end
                        if u14.GameValues and not u14.GameValues.Locked then
                            u15.Args.Humanoid.WalkSpeed = 17
                        end
                        p62.Args.CanShoot = true
                        task.wait(0.1)
                        p62.Args.CanDribble = true
                    end
                else
                    return
                end
            end
        else
            return
        end
    else
        return
    end
end
function u11.PumpFake(u70) --[[Anonymous function at line 691]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u13
        [3] = u14
        [4] = u6
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u13.Data then
            if u13.Data.Abilities.PumpFake then
                if u14.GameValues then
                    if u14.GameValues.Inbounding then
                        return
                    else
                        local _, v71 = u6:GetValues()
                        if v71 then
                            if u70.Args.CanShoot == false then
                                return
                            elseif u70.Args.CanDribble == false then
                                return
                            elseif u70.Args.EuroCD == true then
                                return
                            elseif u70.Args.PumpFakeCD == true then
                                return
                            elseif u70.Args.Posting then
                                return
                            elseif not u70.Args.DoubleDribble then
                                local v72 = u15.Args.Moved
                                u15.Args.Humanoid.WalkSpeed = 0
                                u70.Args.PumpFakeCD = true
                                u70.Args.DoubleDribble = v72
                                u70.Args.CanShoot = false
                                u70.Args.CanDribble = false
                                u15.Args.Humanoid.AutoRotate = false
                                u15.Args.Humanoid.WalkSpeed = 0
                                u15:PlayAnimation("Ball_PumpFake", 1.35)
                                u15:StartMovement("Forward", 3)
                                u15:StopAnimation("Ball_DribbleR")
                                u15:StopAnimation("Ball_DribbleL")
                                u15:PlayAnimation("Ball_NormalHold")
                                task.wait(0.75)
                                u15.Args.Humanoid.AutoRotate = true
                                u15:StopMovement()
                                u70.Args.CanShoot = true
                                u70.Args.CanDribble = true
                                if not v72 then
                                    u15:StopAnimation("Ball_NormalHold")
                                    if u14.GameValues and not u14.GameValues.Locked then
                                        u15.Args.Humanoid.WalkSpeed = 17
                                    end
                                    if u15.Args.Character:FindFirstChild("Basketball") then
                                        if v71.Hand == "Right" then
                                            u15:PlayAnimation("Ball_DribbleR")
                                        elseif v71.Hand == "Left" then
                                            u15:PlayAnimation("Ball_DribbleL")
                                        end
                                    end
                                end
                                task.delay(4, function() --[[Anonymous function at line 755]]
                                    --[[
                                    Upvalues:
                                        [1] = u70
                                    --]]
                                    u70.Args.PumpFakeCD = false
                                end)
                            end
                        else
                            return
                        end
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function u11.Eurostep(p73, p74) --[[Anonymous function at line 760]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u13
        [3] = u14
        [4] = u6
        [5] = u5
        [6] = u8
        [7] = u12
        [8] = u11
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u13.Data then
            if u13.Data.Abilities.Eurostep then
                if u14.GameValues then
                    if u14.GameValues.Inbounding then
                        return
                    else
                        local v75, v76 = u6:GetValues()
                        if v76 then
                            if p73.Args.CanShoot == false then
                                return
                            elseif p73.Args.CanDribble == false then
                                return
                            elseif p73.Args.EuroCD == true then
                                return
                            elseif p73.Args.Posting then
                                return
                            elseif p73.Args.DoubleDribble then
                                return
                            elseif u15.Args.HumanoidRootPart.Velocity.Magnitude > 4 then
                                local v77 = u5.Ball:GetGoal(u8)
                                local v78 = u15.Args.HumanoidRootPart
                                if u5.Math:XYMagnitude(v78.Position, v77.Position) <= 38 then
                                    u12.StartDribble:Fire(true)
                                    u15.Args.Humanoid.WalkSpeed = 0
                                    p73.Args.EuroCD = true
                                    p73.Args.InEuro = true
                                    p73.Args.CanDribble = false
                                    p73.Args.Ended = false
                                    local v79 = v76.Hand
                                    local v80 = v76.Hand == "Left" and "Right" or (v76.Hand == "Right" and "Left" or false)
                                    u15:PlayAnimation("Eurostep_" .. v76.Hand, 1.4)
                                    u6:SetValue(v75, "Hand", v80)
                                    u15:StopAnimation("Ball_DribbleR")
                                    u15:StopAnimation("Ball_DribbleL")
                                    if p74 then
                                        u15:StartMovement(v79 .. "Forward", 28, nil, true)
                                        task.wait(0.15)
                                        u15:StartMovement(v80 .. "Forward", 35, nil, true)
                                        task.wait(0.25)
                                    else
                                        u15:StartMovement(v80 .. "Forward", 30, nil, true)
                                        task.wait(0.4)
                                    end
                                    p73.Args.InEuro = false
                                    if p73.Args.CanShoot == true then
                                        u15:StopMovement()
                                    end
                                    task.wait(0.1)
                                    if p73.Args.CanShoot == true and p73.Args.Holding == false then
                                        u11:Shoot(true)
                                        u11:Shoot(false)
                                    end
                                    task.wait(3)
                                    p73.Args.EuroCD = false
                                end
                            else
                                return
                            end
                        else
                            return
                        end
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function u11.Stepback(p81) --[[Anonymous function at line 836]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u14
        [3] = u6
        [4] = u12
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u14.GameValues then
            if u14.GameValues.Inbounding then
                return
            else
                local _, v82 = u6:GetValues()
                if v82 then
                    if p81.Args.CanShoot == false then
                        return
                    elseif p81.Args.CanDribble == false then
                        return
                    elseif p81.Args.KeyX1 or p81.Args.KeyX2 then
                        return
                    elseif p81.Args.Posting then
                        return
                    elseif not p81.Args.DoubleDribble then
                        u12.StartDribble:Fire()
                        u15.Args.Humanoid.WalkSpeed = 0
                        p81.Args.CanShoot = false
                        p81.Args.CanDribble = false
                        p81.Args.Ended = false
                        u15:StartMovement("Back", 14)
                        u15:StopAnimation("Ball_DribbleR")
                        u15:StopAnimation("Ball_DribbleL")
                        if v82.Hand == "Right" then
                            u15:PlayAnimation("Ball_StepbackR", 1.75)
                        elseif v82.Hand == "Left" then
                            u15:PlayAnimation("Ball_StepbackL", 1.75)
                        end
                        repeat
                            task.wait()
                        until p81.Args.Ended
                        u15:StopMovement()
                        if u15.Args.Character:FindFirstChild("Basketball") then
                            if v82.Hand == "Right" then
                                u15:PlayAnimation("Ball_DribbleR")
                            elseif v82.Hand == "Left" then
                                u15:PlayAnimation("Ball_DribbleL")
                            end
                        end
                        if u14.GameValues and not u14.GameValues.Locked then
                            u15.Args.Humanoid.WalkSpeed = 17
                        end
                        p81.Args.CanShoot = true
                        task.wait(0.1)
                        p81.Args.CanDribble = true
                    end
                else
                    return
                end
            end
        else
            return
        end
    else
        return
    end
end
function u11.Guard(p83, p84) --[[Anonymous function at line 890]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u14
        [3] = u8
        [4] = u5
        [5] = u12
    --]]
    if not u15.Args.Character:FindFirstChild("Basketball") then
        if p84 == nil then
            p84 = not u15.Args.Character:GetAttribute("Guarding")
        end
        if p84 then
            if p83.Args.GuardCD == true then
                return
            end
            if p83.Args.InAction then
                return
            end
            if not u14.GameValues then
                return
            end
            if u14.GameValues.Inbounding then
                return
            end
            if u14.GameValues.Practice then
                return
            end
            if u14.GameValues.ScoringContest then
                return
            end
            if u14.GameValues.Possession == nil then
                return
            end
            if u8:GetAttribute("Team") == u14.GameValues.Possession then
                return
            end
            local v85 = u5.Ball:GetClosestBall(u8)
            if not v85 then
                return
            end
            if v85.Parent == workspace then
                return
            end
            if (u15.Args.HumanoidRootPart.Position - v85.Position).Magnitude > 25 then
                return
            end
            u15.Args.TargetGuard = v85
        end
        u12.Guard:Fire(p84)
        p83.Args.InAction = p84
    end
end
function u11.Screen(u86, p87) --[[Anonymous function at line 940]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u14
        [3] = u8
        [4] = u5
        [5] = u12
    --]]
    if not u15.Args.Character:FindFirstChild("Basketball") then
        if p87 then
            if u86.Args.ScreenCD == true then
                return
            end
            if u86.Args.InAction then
                return
            end
            if not u14.GameValues then
                return
            end
            if u14.GameValues.Inbounding then
                return
            end
            if u14.GameValues.Possession == nil then
                return
            end
            if u8:GetAttribute("Team") ~= u14.GameValues.Possession then
                return
            end
            if u14.GameValues.Practice then
                return
            end
            if u14.GameValues.ScoringContest then
                return
            end
            local v88 = u5.Ball:GetClosestBall(u8)
            if not v88 then
                return
            end
            if v88.Parent == workspace then
                return
            end
        end
        u12.Screen:Fire(p87)
        u86.Args.InAction = p87
        if p87 == false then
            u86.Args.ScreenCD = true
            task.delay(0.25, function() --[[Anonymous function at line 974]]
                --[[
                Upvalues:
                    [1] = u86
                --]]
                u86.Args.ScreenCD = false
            end)
        end
    end
end
function u11.Jump(p89, p90) --[[Anonymous function at line 980]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u5
        [3] = u8
        [4] = u13
        [5] = u12
        [6] = u7
        [7] = u14
        [8] = u11
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if p89.Args.CanShoot == false then
            return
        end
        if p89.Args.CanDribble == false and p89.Args[false] then
            return
        end
        if p89.Args.Posting then
            return
        end
        if p89.Args.DoubleDribble then
            return
        end
        local v91 = u5.Ball:GetGoal(u8)
        if not v91 then
            return
        end
        local v92 = u15.Args.HumanoidRootPart
        local v93 = u5.Math:XYMagnitude(v92.Position, v91.Position)
        local v94 = v92.Velocity.Magnitude
        local v95
        if v93 < 12.5 and v93 > 5 then
            local v96 = p89.Args.InEuro or v94 > 3
            v95 = p90 == true and true or v96
        else
            v95 = false
        end
        local v97 = v95 == false and (v93 <= 5 and v93 > 2) and true or v95
        local v98
        if u13.Data.Dunks then
            v98 = u13.Data.Dunks.Equipped
        else
            v98 = nil
        end
        if p89.Args.DunkCD == true then
            v97 = false
        end
        if v91.CFrame:toObjectSpace(v92.CFrame).Z < -2 then
            v97 = false
        end
        if u15.Args.SpawnTick and tick() - u15.Args.SpawnTick < 5 then
            v97 = false
        end
        if v97 and v98 then
            p89.Args.CanShoot = false
            p89.Args.CanDribble = false
            p89.Args.DunkCD = true
            if p89.Args.InEuro then
                local v99 = tick()
                repeat
                    task.wait()
                until tick() - v99 > 0.5 or not p89.Args.InEuro
            end
            u12.StartDunk:Fire()
            u15.Args.Humanoid.WalkSpeed = 0
            local v100 = u7.Dunks[v98][6] or 1.5
            if p90 then
                v100 = v100 * 1.25
            end
            u15:PlayAnimation("Dunk_" .. v98, v100)
            u15:StopAnimation("Rebound")
            u15:StartTurn()
            local v101 = Instance.new("BodyPosition")
            v101.D = 1100
            v101.P = 8000
            v101.MaxForce = Vector3.new(1, 1, 1) * (1 / 0)
            local v102 = CFrame.new
            local v103 = v91.Position
            local v104 = v92.Position.X
            local v105 = v91.Position.Y
            local v106 = v92.Position.Z
            v101.Position = (v102(v103, (Vector3.new(v104, v105, v106))) * CFrame.new(0, -0.4, -1.3)).Position
            v101.Parent = v92
            if u7.Dunks[v98][7] then
                v101.D = 100
                v101.P = 300
                v101.Position = v91.Position - Vector3.new(0, 1.75, 0)
            end
            task.wait(p90 and 0.6 or 0.75)
            u12.Dunk:Fire()
            if u7.Dunks[v98][7] then
                task.wait(u7.Dunks[v98][7])
            end
            if u14.GameValues and not u14.GameValues.Locked then
                u15.Args.Humanoid.WalkSpeed = 17
            end
            u15:StopMovement()
            v101:Destroy()
            task.wait(1)
            p89.Args.CanShoot = true
            p89.Args.CanDribble = true
            task.wait(3)
            p89.Args.DunkCD = false
            return
        end
    else
        local v107 = u5.Ball:GetClosestBall(u8)
        local v108 = "Jump"
        if v107 and (u15.Args.HumanoidRootPart.Position - v107.Position).Magnitude < 20 then
            v108 = v107.Parent ~= workspace and "Block" or (v107.Position.Y > 3 and "Rebound" or v108)
        end
        if v108 == "Block" then
            if p89.Args.InAction then
                return
            elseif p89.Args.BlockCD then
                return
            elseif u14.GameValues then
                if u14.GameValues.Inbounding then
                    return
                elseif u14.GameValues.Practice then
                    return
                elseif u14.GameValues.ScoringContest then
                    return
                elseif u14.GameValues.Possession == nil then
                    return
                elseif u8:GetAttribute("Team") == u14.GameValues.Possession then
                    return
                elseif u15.Args.Character:GetAttribute("Stealing") then
                    return
                elseif u15.Args.Character:GetAttribute("Broken") then
                    return
                elseif not u15.Args.Character:GetAttribute("PostBlockedCD") then
                    u15.Args.Humanoid.WalkSpeed = 0
                    p89.Args.BlockCD = true
                    p89.Args.InAction = true
                    u12.Block:Fire()
                    u15:StartMovement("Forward", 18, v107)
                    u15:PlayAnimation("Block")
                    task.wait(0.6)
                    if u15.Args.Character:GetAttribute("Contact") == nil then
                        u15:StopMovement()
                    end
                    task.wait(0.4)
                    if u15.Args.Character:GetAttribute("Contact") == nil and (u14.GameValues and not u14.GameValues.Locked) then
                        u15.Args.Humanoid.WalkSpeed = 17
                    end
                    p89.Args.InAction = false
                    task.wait(2)
                    p89.Args.BlockCD = false
                end
            else
                return
            end
        end
        if v108 == "Rebound" then
            if p89.Args.InAction then
                return
            elseif p89.Args.BlockCD then
                return
            elseif u14.GameValues then
                if u14.GameValues.Inbounding then
                    return
                elseif u15.Args.Character:GetAttribute("Stealing") then
                    return
                elseif u15.Args.Character:GetAttribute("Broken") then
                    return
                elseif not u15.Args.Character:GetAttribute("PostBlockedCD") then
                    u15.Args.Humanoid.WalkSpeed = 7
                    p89.Args.BlockCD = true
                    p89.Args.InAction = true
                    u15:PlayAnimation("Rebound", 2.4)
                    u11.Args.LastRebound = tick()
                    local v109 = u15.Args.Humanoid
                    v109.JumpPower = 50
                    v109:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(0.5)
                    v109.JumpPower = 0
                    if u14.GameValues and not (u14.GameValues.Locked or p89.Args.DoubleDribble) then
                        u15.Args.Humanoid.WalkSpeed = 17
                    end
                    u15:StopMovement()
                    p89.Args.InAction = false
                    task.wait(2)
                    p89.Args.BlockCD = false
                end
            else
                return
            end
        end
        local _ = v108 == "Jump"
    end
end
function u11.Steal(p110) --[[Anonymous function at line 1215]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u5
        [3] = u8
        [4] = u14
        [5] = u12
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        return
    else
        local v111 = u5.Ball:GetClosestBall(u8)
        if v111 then
            if p110.Args.InAction then
                return
            elseif p110.Args.StealCD then
                return
            elseif u15.Args.Character:GetAttribute("Blocking") then
                return
            elseif u15.Args.Character:GetAttribute("PostBlockedCD") then
                return
            elseif u14.GameValues then
                if u14.GameValues.Inbounding then
                    return
                elseif u14.GameValues.Practice then
                    return
                elseif u14.GameValues.ScoringContest then
                    return
                elseif u14.GameValues.Possession == nil then
                    return
                elseif u8:GetAttribute("Team") ~= u14.GameValues.Possession then
                    u15.Args.Humanoid.WalkSpeed = 0
                    p110.Args.StealCD = true
                    p110.Args.InAction = true
                    u12.Steal:Fire()
                    u15:StartMovement("Forward", 7, v111)
                    u15:PlayAnimation("Steal", 1.5)
                    task.wait(0.6)
                    u15:StopMovement()
                    if u15.Args.Character:GetAttribute("Broken") then
                        task.wait(0.75)
                    end
                    if u14.GameValues and not u14.GameValues.Locked then
                        u15.Args.Humanoid.WalkSpeed = 17
                    end
                    p110.Args.InAction = false
                    task.wait(4)
                    p110.Args.StealCD = false
                end
            else
                return
            end
        else
            return
        end
    end
end
function u11.Combo(p112, p113) --[[Anonymous function at line 1274]]
    --[[
    Upvalues:
        [1] = u15
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        local v114 = p112.CurrentInputLayout == "Touch" and 0.2 or 0.13
        local v115 = p112.CurrentInputLayout == "Touch" and 0.25 or 0.15
        if p113 == "Left" then
            if p112.Args.KeyZ1 == false then
                p112.Args.KeyZ1 = true
                task.wait(v114)
                p112.Args.KeyZ1 = false
            else
                p112.Args.KeyZ2 = true
                task.wait(v114)
                p112.Args.KeyZ2 = false
            end
        elseif p113 == "Right" then
            if p112.Args.KeyC1 == false then
                p112.Args.KeyC1 = true
                task.wait(v114)
                p112.Args.KeyC1 = false
            else
                p112.Args.KeyC2 = true
                task.wait(v114)
                p112.Args.KeyC2 = false
            end
        else
            if p113 == "Back" then
                if p112.Args.KeyZ1 == true then
                    p112.Args.KeyX1 = true
                    task.wait(v114)
                    p112.Args.KeyX1 = false
                    return
                end
                if p112.Args.KeyC1 == true then
                    p112.Args.KeyX2 = true
                    task.wait(v114)
                    p112.Args.KeyX2 = false
                    return
                end
            elseif p113 == "Euro" then
                if p112.Args.KeyF1 == false then
                    p112.Args.KeyF1 = true
                    task.wait(v115)
                    p112.Args.KeyF1 = false
                    return
                end
                p112.Args.KeyF2 = true
                task.wait(v115)
                p112.Args.KeyF2 = false
            end
            return
        end
    else
        return
    end
end
function u11.HandleDribbleCheck(p116) --[[Anonymous function at line 1323]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u6
        [3] = u11
    --]]
    if p116.Args.KeyZ1 == false and (p116.Args.KeyC1 == false and p116.Args.KeyF1 == false) then
        return
    elseif p116.Args.CanDribble == false then
        return
    elseif u15.Args.Character:FindFirstChild("Basketball") then
        local _, v117 = u6:GetValues()
        if v117 then
            if p116.Args.KeyZ1 == true and v117.Hand == "Left" then
                if p116.Args.KeyX1 == true then
                    p116.Args.KeyZ1 = false
                    p116.Args.KeyX1 = false
                    u11:Dribble("BTBLeft")
                    return
                end
                if p116.Args.KeyZ2 == true then
                    p116.Args.KeyZ1 = false
                    p116.Args.KeyZ2 = false
                    u11:Dribble("SpinLeft")
                    return
                end
            elseif p116.Args.KeyC1 == true and v117.Hand == "Right" then
                if p116.Args.KeyX2 == true then
                    p116.Args.KeyC1 = false
                    p116.Args.KeyX2 = false
                    u11:Dribble("BTBRight")
                    return
                end
                if p116.Args.KeyC2 == true then
                    p116.Args.KeyC1 = false
                    p116.Args.KeyC2 = false
                    u11:Dribble("SpinRight")
                    return
                end
            elseif p116.Args.KeyF2 == true then
                u11:Eurostep(true)
            end
        end
    else
        return
    end
end
function u11.Post(p118, p119) --[[Anonymous function at line 1361]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u13
        [3] = u14
        [4] = u6
        [5] = u5
        [6] = u8
        [7] = u12
        [8] = u18
        [9] = u11
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u13.Data then
            if u13.Data.Abilities.Post then
                if u14.GameValues then
                    if u14.GameValues.Inbounding then
                        return
                    elseif p118.Args.CanShoot == false then
                        return
                    elseif p118.Args.DoubleDribble then
                        return
                    else
                        local _, v120 = u6:GetValues()
                        if v120 then
                            local v121 = u5.Ball:GetGoal(u8)
                            local v122 = u15.Args.HumanoidRootPart
                            local v123 = u5.Math:XYMagnitude(v122.Position, v121.Position)
                            if p119 == true and v123 > 38 then
                                return
                            else
                                p118.Args.Posting = p119
                                p118.Args.PostDirection = v120.Hand
                                u15.Args.PostTick = tick()
                                u12.Posting:Fire(p119, v120.Hand)
                                if p118.Args.Posting == true then
                                    u15.Args.BodyGyro.MaxTorque = Vector3.new(0, 1000000, 0)
                                    u15:StopAnimation("Ball_DribbleR", 0.2)
                                    u15:StopAnimation("Ball_DribbleL", 0.2)
                                    if v120.Hand == "Right" then
                                        u15:PlayAnimation("Ball_PostDribbleR", 1, 0.2)
                                    elseif v120.Hand == "Left" then
                                        u15:PlayAnimation("Ball_PostDribbleL", 1, 0.2)
                                    end
                                    u15.Args.Humanoid.WalkSpeed = 14
                                    u15.Args.Humanoid.AutoRotate = false
                                elseif p118.Args.Posting == false then
                                    u15.Args.BodyGyro.MaxTorque = Vector3.new(0, 0, 0)
                                    u15:StopAnimation("Ball_PostDribbleR")
                                    u15:StopAnimation("Ball_PostDribbleL")
                                    if v120.Hand == "Right" then
                                        u15:PlayAnimation("Ball_DribbleR")
                                    elseif v120.Hand == "Left" then
                                        u15:PlayAnimation("Ball_DribbleL")
                                    end
                                    local v124 = false
                                    if v123 <= 38 then
                                        local v125 = u18.CFrame:VectorToObjectSpace(u15.Args.Humanoid.MoveDirection).Unit
                                        if v125.X <= -0.75 then
                                            if v120.Hand == "Right" then
                                                u11:Dribble("SpinRight")
                                                v124 = true
                                            end
                                        elseif v125.X >= 0.75 and v120.Hand == "Left" then
                                            u11:Dribble("SpinLeft")
                                            v124 = true
                                        end
                                    end
                                    if not v124 then
                                        u15.Args.Humanoid.WalkSpeed = 17
                                    end
                                    u15.Args.Humanoid.AutoRotate = true
                                end
                            end
                        else
                            return
                        end
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function u11.SelfLob(p126) --[[Anonymous function at line 1436]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u13
        [3] = u14
        [4] = u5
        [5] = u8
        [6] = u12
    --]]
    if u15.Args.Character:FindFirstChild("Basketball") then
        if u13.Data then
            if u13.Data.Abilities.Lob then
                if u14.GameValues then
                    if u14.GameValues.Inbounding then
                        return
                    elseif p126.Args.Posting then
                        return
                    elseif p126.Args.CanShoot == false then
                        return
                    elseif p126.Args.InEuro or p126.Args.CanDribble ~= false then
                        local v127 = u5.Ball:GetGoal(u8)
                        local v128 = u15.Args.HumanoidRootPart
                        local v129 = u5.Math:XYMagnitude(v128.Position, v127.Position)
                        if v129 <= 38 and v129 >= 12.5 then
                            p126.Args.CanShoot = false
                            p126.Args.CanDribble = false
                            u15:PlayAnimation("Ball_Pass")
                            u15.Args.LobTick = tick()
                            task.wait(0.25)
                            u12.Pass:Fire("SelfLob")
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function u11.Emote(_) --[[Anonymous function at line 1475]]
    --[[
    Upvalues:
        [1] = u8
        [2] = u11
        [3] = u15
        [4] = u12
    --]]
    if u8:GetAttribute("Emoting") then
        if tick() - u11.Args.LastEmoteTick >= 1 then
            u15:CancelEmote()
        end
    elseif u11.Args.EmoteCD or u8:GetAttribute("Court") then
        return
    elseif tick() - u11.Args.StopEmoteTick < 2.5 then
        return
    elseif not u15:IsAnimationPlaying(u15.Args.LastEmote) then
        u11.Args.EmoteCD = true
        u11.Args.LastEmoteTick = tick()
        u12.Emote:Fire()
        task.wait(2)
        u11.Args.EmoteCD = false
    end
end
return u11
