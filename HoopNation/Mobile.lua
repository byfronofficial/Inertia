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

print("Defined all Vars")

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

print("Defined Settings")

local Connections = {
    AutoGreenConnection = nil,
    DribblingGlide = nil,
    CharacterAddedConnection = nil,
    ControllerInput = nil,
    SpinbotConnection = nil,
    ControllerSpinbotInput = nil,

}

print("Defined Connections")

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

print("Defined all Functions")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Hoop Nation",
    SubTitle = "By Zypher and The",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Example toggle (already included)
local RageAutoGreenToggle = Tabs.Main:AddToggle("RageAutoGreenToggle", {
    Title = "Rage Auto-Green",
    Default = false,
    Callback = function(Value)
        Settings.RageAutoGreen = Value
    end
})

-- Auto Green Toggle
Tabs.Main:AddToggle("AutoGreenToggle", {
    Title = "Auto Green",
    Default = false,
    Callback = function(Value)
        Settings.AutoGreen = Value
    end
})

-- Always Sprint Toggle
Tabs.Main:AddToggle("AlwaysSprintToggle", {
    Title = "Always Sprint",
    Default = false,
    Callback = function(Value)
        SprintValue.Value = Value
    end
})

-- Infinite Stamina Toggle
Tabs.Main:AddToggle("InfiniteStaminaToggle", {
    Title = "Infinite Stamina",
    Default = false,
    Callback = function(Value)
        Settings.InfiniteStamina = Value
    end
})

-- WalkSpeed Toggle
Tabs.Main:AddToggle("WalkSpeedToggle", {
    Title = "Walk Speed",
    Default = false,
    Callback = function(Value)
        Settings.WalkSpeed = Value
    end
})

-- WalkSpeed Slider
Tabs.Main:AddSlider("WalkSpeedSlider", {
    Title = "Speed",
    Default = 11,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        Settings.Speed = Value
    end
})

-- Pick Up Range Toggle
Tabs.Main:AddToggle("PickUpRangeToggle", {
    Title = "Pick Up Range",
    Default = false,
    Callback = function(Value)
        Settings.PickupRange = Value
    end
})

-- Pick Up Range Slider
Tabs.Main:AddSlider("PickUpRangeSlider", {
    Title = "Pick Up Range",
    Default = 11,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        Settings.Range = Value
    end
})

-- Unlock All Toggle
Tabs.Main:AddToggle("UnlockGamepassesToggle", {
    Title = "Unlock All",
    Default = false,
    Callback = function()
        GamepassValues = GamepassValues or (LocalPlayer.Character.Stats and LocalPlayer.Character.Stats:FindFirstChild("Gamepasses"))
        if GamepassValues then
            for _, v in ipairs(GamepassValues:GetChildren()) do
                v.Value = true
            end
        else
            warn("Gamepasses not found. Make sure you are loaded in!")
        end
    end
})

-- Dribble Glide Toggle
Tabs.Main:AddToggle("DribbleGlideToggle", {
    Title = "Dribble Glide",
    Default = false,
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

                    bodyVelocity.Velocity = Vector3.zero
                    bodyVelocity.MaxForce = Vector3.zero
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

-- Dribble Amount Slider
Tabs.Main:AddSlider("DribbleAmountSlider", {
    Title = "Dribble Amount",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Settings.DribbleAmount = Value
    end
})

-- SpinBot Toggle
Tabs.Main:AddToggle("SpinBotToggle", {
    Title = "SpinBot",
    Default = false,
    Callback = function(Value)
        Settings.SpinBotFlag = Value
        Functions.ToggleSpinbot(Value)
    end
})

-- SpinBot Speed Slider
Tabs.Main:AddSlider("SpinBotSliderAmount", {
    Title = "SpinBot Speed",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        Settings.SpinBotSliderAmount = Value
    end
})

Connections.AutoGreenConnection = ShootButton.MouseButton1Down:Connect(function()
    if Settings.AutoGreen then
        ShootRemote:FireServer(true, 100)
        ShootRemote:FireServer(false, -0.99, true)
    end
end)

print("Defined Connection 1")

Connections.ControllerInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonX and Settings.AutoGreen then
            ShootRemote:FireServer(true, 100)
            ShootRemote:FireServer(false, -0.99, true)
        end
    end
end)

print("Defined Connection 2")

Connections.ControllerSpinbotInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        if input.KeyCode == Enum.KeyCode.ButtonR1 then
            Settings.SpinBotFlag = not Settings.SpinBotFlag
            Functions.ToggleSpinbot(Settings.SpinBotFlag)
        end
    end
end)

print("Defined Connection 3")

local old; old = hookfunction(ShootFunction, function(...)
    if Settings.RageAutoGreen then
        local v36 = -0.99
        ReplicatedStorage.Events.Shoot:FireServer(p34, v36, false)
        Meter2Meter.Parent.Enabled = false
    else
        old(...)
    end
end)

print("Defined Hook")

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

 print("Defined RenderStepped")
