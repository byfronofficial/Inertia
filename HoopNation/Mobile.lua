repeat task.wait() until game:IsLoaded()

local Players = game:GetService('Players');
local Workspace = game:GetService('Workspace');
local RunService = game:GetService('RunService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local UserInputService = game:GetService('UserInputService');

local LocalPlayer = Players.LocalPlayer;
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = Character:FindFirstChildOfClass("Humanoid")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character.HumanoidRootPart
local Camera = Workspace.CurrentCamera;

local BasketballFolder = Workspace:FindFirstChild("Basketballs")
local Courts = Workspace:FindFirstChild("Courts")

local ValuesFolder = LocalPlayer:WaitForChild("Values", 10)
local IsShootingValue = ValuesFolder:WaitForChild("Shooting", 10)
local StaminaValue = ValuesFolder:WaitForChild("Stamina", 10)
local AnklesValue = ValuesFolder:WaitForChild("Ankles", 10)
local SprintValue = ValuesFolder:WaitForChild("Sprinting", 10)

local ShirtsFolder = ReplicatedStorage.Assets.Clothing.Shirts
local PantsFolder = ReplicatedStorage.Assets.Clothing.Pants

local ShootButton = Players.LocalPlayer.PlayerGui.Mobile.Offense.Shoot

local ShootRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Shoot")
local ShootFunction;
local Meter2Meter = LocalPlayer.Character.Meter2.Meter
local SpinbotToggleValue;

for i,v in next, getgc(false) do
    if (type(v) == 'function' and not isexecutorclosure(v) and debug.getinfo(v).name and debug.getinfo(v).name == "Shoot") then
        ShootFunction = v
    end;
end;

local Courts = game.Workspace:FindFirstChild("Courts")

local Settings = {
    AutoGreen = false,
    RageAutoGreen = false,
    InfiniteStamina = false,
    WalkSpeed = false,
    Speed = 11,
    PickupRange = false,
    Range = 1,
    DribbleAmount = 1,
    SpinBotFlag = nil,
    SpinBotSliderAmount = nil,

}

local Connections = {
    AutoGreenConnection = nil,
    DribblingGlide = nil,
    CharacterAddedConnection = nil,
    ControllerInput = nil,
    SpinbotConnection = nil,
    ControllerSpinbotInput = nil,

}

Connections.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local Functions = {
    --[[
    onKeyPress = function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        if input.KeyCode == Enum.KeyCode.E and Toggles.AutoGreenToggle.Value then
            if Options.AutoGreenTypeDropdown.Value == "Function" then

                ShootFunction(true)
                task.wait(0.40)
                ShootFunction(false)

            elseif Options.AutoGreenTypeDropdown.Value == "Remote" then

                task.wait(0.40)
                ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("Shoot"):FireServer(false, -0.99, true)  
                task.wait(0.40)
            end
        elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
            if input.KeyCode == Enum.KeyCode.ButtonX and Toggles.AutoGreenToggle.Value then
                if Options.AutoGreenTypeDropdown.Value == "Function" then

                    ShootFunction(true)
                    task.wait(0.40)
                    ShootFunction(false)

                elseif Options.AutoGreenTypeDropdown.Value == "Remote" then

                    task.wait(0.40)
                    ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("Shoot"):FireServer(false, -0.99, true)  
                    task.wait(0.40)
                end
            end
        end
    end,
    ]]

    increaseGreatestComponent = function(vector, increaseAmount)
        local absX = math.abs(vector.X)
        local absY = math.abs(vector.Y)
        local absZ = math.abs(vector.Z)

        local greatest = math.max(absX, absY, absZ) -- Find the largest absolute value

        if greatest == absX then
            return Vector3.new(vector.X + math.sign(vector.X) * increaseAmount, vector.Y, vector.Z)
        elseif greatest == absY then
            return Vector3.new(vector.X, vector.Y + math.sign(vector.Y) * increaseAmount, vector.Z)
        else
            return Vector3.new(vector.X, vector.Y, vector.Z + math.sign(vector.Z) * increaseAmount)
        end
    end,

    FindClosestBasketball = function(ShortestDistance)
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return nil
        end

        if game.Workspace.Basketballs:FindFirstChildOfClass("MeshPart") then
            if (Character.HumanoidRootPart.Position - game.Workspace.Basketballs:FindFirstChildOfClass("MeshPart").Position).Magnitude <= ShortestDistance then
                local basketball = game.Workspace.Basketballs.Basketball
                return basketball
            end
        else
            for _, court in next, Courts:GetChildren() do
                local ValuesFolder = court:FindFirstChild("Values")
                if ValuesFolder then
                    for _, object in next, ValuesFolder:GetChildren() do
                        if object:IsA("StringValue") and object.Value == LocalPlayer.Name then
                            --print("Found court for player:", LocalPlayer.Name)
                            local basketball = court:FindFirstChild("Basketball")
                            if basketball and (Character.HumanoidRootPart.Position - basketball.Position).Magnitude <= ShortestDistance then
                                return basketball -- Return the basketball instance
                            end
                        end
                    end
                end
            end
        end

        return nil -- If no basketball is found, return nil
    end,

    ToggleSpinbot = function(Value)
        local root = Character and Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
    
        if Value then
            local oldSpin = root:FindFirstChild("Spinning")
            if oldSpin then oldSpin:Destroy() end
    
            local spinSpeed = Settings.SpinBotSliderAmount -- default spin speed
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = root
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
        else
            local oldSpin = root:FindFirstChild("Spinning")
            if oldSpin then oldSpin:Destroy() end
        end
    end
}

Functions.getClosestPlayer = function(MaxDistance)
    local closestPlayer = nil
    local shortestDistance = MaxDistance  -- Set initial distance to a large number

    for _, otherPlayer in next, (Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer 
            and otherPlayer.Character
            and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then

            -- Ensure 'Values' exists and contains a 'Basketball'
            --local values = otherPlayer.Character:FindFirstChild("Values")
            --local basketball = values and values:FindFirstChild("Basketball")

            -- Uncomment this line if checking for basketball is important
            --if basketball and basketball.Value == "Basketball" then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (HumanoidRootPart.Position - otherRoot.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
            --end
        end
    end

    return closestPlayer
end

local ArrayField = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3AArrayfield%20Library"))()

local Window = ArrayField:CreateWindow({
    Name = "Inertia | Mobile",
    LoadingTitle = "Inertia | Mobile",
    LoadingSubtitle = "Inertia | Mobile",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "ArrayField"
    },
    Discord = {
        Enabled = false,
        Invite = "sirius",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "ArrayField",
        Subtitle = "Key System",
        Note = "Join the discord (discord.gg/sirius)",
        FileName = "ArrayFieldsKeys",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"Hello",'Bye'},
        Actions = {
            [1] = {
                Text = 'Click here to copy the key link',
                OnPress = function()

                end,
            }
        },
    }
})

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Main",false)
local RageAutoGreenToggle = Tab:CreateToggle({
    Name = "Rage Auto-Green",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "RageAutoGreenFlag",
    Callback = function(Value)
        Settings.RageAutoGreen = Value
    end,
})

local AutoGreenToggle = Tab:CreateToggle({
    Name = "Auto Green",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "AutoGreenFlag",
    Callback = function(Value)
        Settings.AutoGreen = Value
    end,
})

local AlwaysSprintToggle = Tab:CreateToggle({
    Name = "Always Sprint",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "AlwaysSprintFlag",
    Callback = function(Value)
        if Value then
            if not SprintValue.Value then
                SprintValue.Value = true
            end
        else
            if SprintValue.Value then
                SprintValue.Value = false
            end
        end
    end,
})

local InfiniteStaminaToggle = Tab:CreateToggle({
    Name = "Infinite Stamina",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "InfiniteStaminaFlag",
    Callback = function(Value)
        Settings.InfiniteStamina = Value
    end,
})

local WalkSpeedToggle = Tab:CreateToggle({
    Name = "Walk Speed",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "WalkSpeedFlag",
    Callback = function(Value)
        Settings.WalkSpeed = Value
    end,
})

local WalkSpeedSlider = Tab:CreateSlider({
    Name = "Speed",
    Range = {0, 100},
    Increment = 1,
    Suffix = "*",
    CurrentValue = 11,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        Settings.Speed = Value
    end,
})

local PickUpRangeToggle = Tab:CreateToggle({
    Name = "Pick Up Range",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "PickUpRangeFlag",
    Callback = function(Value)
        Settings.PickupRange = Value
    end,
})

local PickUpRangeSlider = Tab:CreateSlider({
    Name = "Range",
    Range = {0, 100},
    Increment = 1,
    Suffix = "*",
    CurrentValue = 11,
    Flag = "PickUpRangeSlider",
    Callback = function(Value)
        Settings.Range = Value
    end,
})

local UnlockGamepassesToggle = Tab:CreateToggle({
    Name = "Unlock All",
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "UnlockGamepassesFlag",
    Callback = function()
        if GamepassValues then
            for i,v in next, (GamepassValues:GetChildren()) do
                v.Value = true
            end
        else
            GamepassValues = LocalPlayer.Character.Stats.Gamepasses or nil
            error("Could not find character, make sure you are loaded in!")
        end
    end,
})

local DribbleGlideToggle = Tab:CreateToggle({
    Name = 'Dribble Glide',
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "DribbleGlideFlag",

    Callback = function(Value)
        if Value then
            if not Connections.DribblingGlide then
                Connections.DribblingGlide = LocalPlayer.Values.Dribbling:GetPropertyChangedSignal("Value"):Connect(function()
                    task.wait(0.3)
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local bodyVelocity = hrp.BodyVelocity
                    local newval = Functions.increaseGreatestComponent(bodyVelocity.Velocity, Settings.DribbleAmount)

                    while LocalPlayer.Values.Dribbling.Value == true do
                        bodyVelocity.MaxForce = Vector3.new(99999, 0, 99999)
                        bodyVelocity.Velocity = newval
                        wait()
                    end

                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                end)
            end
        else
            if Connections.DribblingGlide then
                Connections.DribblingGlide:Disconnect()
                Connections.DribblingGlide = nil
            end
        end
    end
})

local DribbleGlideSlider = Tab:CreateSlider({
    Name = "Dribble Amount",
    Range = {0.1, 10},
    Increment = 1,
    Suffix = "*",
    CurrentValue = 11,
    Flag = "DribbleAmountSlider",
    Callback = function(Value)
        Settings.DribbleAmount = Value
    end,
})

local SpinBotToggleButton = Tab:CreateToggle({
    Name = 'SpinBot',
    Info = {
        Title = 'Slider template',
        Image = '12735851647',
        Description = 'Just a slider for stuff',
    },
    CurrentValue = false,
    Flag = "SpinBotFlag",

    Callback = function(Value)
        Functions.ToggleSpinbot(Value)
    end
})

local SpinBotSliderElement = Tab:CreateSlider({
    Name = "SpinBot Slider",
    Range = {1, 50},
    Increment = 1,
    Suffix = "*",
    CurrentValue = 5,
    Flag = "SpinBotSliderAmount",
    Callback = function(Value)
        Settings.SpinBotSliderAmount = Value
    end,
})


Connections.AutoGreenConnection = ShootButton.MouseButton1Down:Connect(function()
    if Settings.AutoGreen then
        ShootRemote:FireServer(true, 100)
        ShootRemote:FireServer(false, -0.99, true)
    end
end)

Connections.ControllerInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonX and Settings.AutoGreen then
            ShootRemote:FireServer(true, 100)
            ShootRemote:FireServer(false, -0.99, true)
        end
    end
end)

Connections.ControllerSpinbotInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonR1 then
            Settings.SpinBotFlag = not Settings.SpinBotFlag
            Functions.ToggleSpinbot(Settings.SpinBotFlag)
        end
    end
end)

local function test()
    return true
end

local ref = hookfunction(test, function(...)
    return false
end)

if test() == false and ref() == true and test ~= ref then
    --print("Hookfunction works for your executor!")
    local old; old = hookfunction(ShootFunction, function(...)
        if Settings.RageAutoGreen then
            local v36 = -0.99
            ReplicatedStorage.Events.Shoot:FireServer(p34, v36, false)
            Meter2Meter.Parent.Enabled = false
        else
            old(...)
        end
    end)
else
    print("Hookfunction is not supported in your executor!")
end

RunService.RenderStepped:Connect(function()
    if Settings.WalkSpeed then
        Humanoid.WalkSpeed = Settings.Speed
    end
    if Settings.InfiniteStamina then
        StaminaValue.Value = 1
    end
    if Settings.PickupRange then
        local ball = Functions.FindClosestBasketball(Settings.Range)
        if ball then
            firetouchinterest(ball, Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 15), true)
            firetouchinterest(ball, Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 15), false)
        end
    end
end)
