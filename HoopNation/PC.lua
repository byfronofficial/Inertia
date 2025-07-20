repeat task.wait() until game:IsLoaded()

local Players = game:GetService('Players');
local Workspace = game:GetService('Workspace');
local RunService = game:GetService('RunService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local UserInputService = game:GetService('UserInputService');

local LocalPlayer = Players.LocalPlayer;
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character.HumanoidRootPart
local Camera = Workspace.CurrentCamera;

local BasketballFolder = Workspace:FindFirstChild("Basketballs")
local Courts = Workspace:FindFirstChild("Courts")

local ValuesFolder = LocalPlayer:WaitForChild("Values", 10)
local IsShootingValue = ValuesFolder:WaitForChild("Shooting", 10)
local StaminaValue = ValuesFolder:WaitForChild("Stamina", 10)
local AnklesValue = ValuesFolder:WaitForChild("Ankles", 10)
local SprintValue = ValuesFolder:WaitForChild("Sprinting", 10)
local ankleBreakerId = "rbxassetid://89008535250310"

local ShootRemote = ReplicatedStorage.Events.Shoot
local ShootFunction; 

local ShirtsFolder = ReplicatedStorage.Assets.Clothing.Shirts
local PantsFolder = ReplicatedStorage.Assets.Clothing.Pants

local FadeawayAnimation = ReplicatedStorage.Animations.Fadeaway -- rbxassetid://94243198836046
local BlockAnimation = ReplicatedStorage.Animations.Block -- rbxassetid://16002659797
local ChestPassAnimation = ReplicatedStorage.Animations.ChestPass -- rbxassetid://16632131364
local JumpshotAnimation = ReplicatedStorage.Animations.Jumpshot -- rbxassetid://73707962057370
local PassAnimation = ReplicatedStorage.Animations.Pass -- rbxassetid://16632131364
local StealRAnimation = ReplicatedStorage.Animations.StealR -- rbxassetid://16053995400
local HoldBallAnimation = ReplicatedStorage.Animations.HoldBall -- rbxassetid://76191169643944
local BackflipAnimation = ReplicatedStorage.Animations.Backflip -- rbxassetid://85268116174650

local FadeawayTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.Fadeaway) -- rbxassetid://94243198836046
local BlockTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.Block) -- rbxassetid://16002659797
local ChestPassTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.ChestPass) -- rbxassetid://16632131364
local JumpshotTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.Jumpshot) -- rbxassetid://73707962057370
local PassTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.Pass) -- rbxassetid://16632131364
local StealRTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.StealR) -- rbxassetid://16053995400
local HoldBallTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.HoldBall) -- rbxassetid://76191169643944
local BackflipTrack = humanoid:LoadAnimation(ReplicatedStorage.Animations.Backflip) -- rbxassetid://85268116174650

local FadeawayKeybind = Enum.KeyCode.L
local BlockKeybind = Enum.KeyCode.B
local ChestPassKeybind = Enum.KeyCode.C
local JumpshotKeybind = Enum.KeyCode.J
local PassKeybind = Enum.KeyCode.P
local StealRKeybind = Enum.KeyCode.R
local HoldBallKeybind = Enum.KeyCode.H
local BackflipKeybind = Enum.KeyCode.F

local shirtNames = {}
local pantNames = {}

for _, shirt in next, (ShirtsFolder:GetChildren()) do
  if shirt:IsA("Folder") or shirt:IsA("Model") or shirt:IsA("Shirt") then -- Adjust if necessary
    table.insert(shirtNames, shirt.Name)
  end
end

for _, pant in next, (PantsFolder:GetChildren()) do
  if pant:IsA("Folder") or pant:IsA("Model") or pant:IsA("Pants") and pant.Name ~= 'Clothing' then -- Adjust if necessary
    table.insert(pantNames, pant.Name)
  end
end

table.sort(shirtNames)
table.sort(pantNames)


for i,v in next, getgc(false) do
  if (type(v) == 'function' and not isexecutorclosure(v) and debug.getinfo(v).name and debug.getinfo(v).name == "Shoot") then
    ShootFunction = v
  end;
end;

local GamepassValues = LocalPlayer.Character.Stats.Gamepasses or nil
local NameTag = LocalPlayer.Character.Head.Nametag.NameLabel or nil
local CurrentInput;

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local walkflinging;

local FalseBoolean1 = false
local Meter2Meter = LocalPlayer.Character.Meter2.Meter
local NumberValue = Instance.new("NumberValue")
NumberValue.Value = 0
local Tween1 = game:GetService("TweenService"):Create(NumberValue, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
  ["Value"] = 0.98
})
local Tween2 = game:GetService("TweenService"):Create(NumberValue, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
  ["Value"] = 0
})
local FalseBoolean2 = false
local NumberValue2 = 0

local Drawings = {
  Snapline = Drawing.new("Line"),
  SnaplineOutline = Drawing.new("Line"),
}

Drawings.Snapline.Thickness = 1
Drawings.Snapline.Color = Color3.fromRGB(255,255,255)
Drawings.SnaplineOutline.Color = Color3.fromRGB(0,0,0)
Drawings.Snapline.ZIndex = 2
Drawings.SnaplineOutline.Thickness = 1.1

local Functions = {
  onKeyPress = function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.E and Toggles.AutoGreenToggle.Value then
      if Options.AutoGreenTypeDropdown.Value == "Function" then

        ShootFunction(true)
        task.wait(0.40)
        ShootFunction(false)

      elseif Options.AutoGreenTypeDropdown.Value == "Remote" then

                  ShootRemote:FireServer(true, 100)
                  ShootRemote:FireServer(false, -0.99, false)
      end
    elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
      if input.KeyCode == Enum.KeyCode.ButtonX and Toggles.AutoGreenToggle.Value then
        if Options.AutoGreenTypeDropdown.Value == "Function" then

          ShootFunction(true)
          task.wait(0.40)
          ShootFunction(false)

        elseif Options.AutoGreenTypeDropdown.Value == "Remote" then

                      ShootRemote:FireServer(true, 100)
                      ShootRemote:FireServer(false, -0.99, false)
        end
      end
    end
  end,

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
      for _, court in ipairs(Courts:GetChildren()) do
        local ValuesFolder = court:FindFirstChild("Values")
        if ValuesFolder then
          for _, object in next, (ValuesFolder:GetChildren()) do
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

        local spinSpeed = Options.SpinbotSliderAmount.Value -- default spin speed
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = root
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
      else
          local oldSpin = root:FindFirstChild("Spinning")
          if oldSpin then oldSpin:Destroy() end
      end
  end,
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

Functions.updateSnapline = function()
  local ClosestTarget = Functions.getClosestPlayer(Options.MaxDistance.Value)
  if ClosestTarget and ClosestTarget.Character then
    local rootPart = ClosestTarget.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
      local Camera = game.Workspace.CurrentCamera
      local PositionC, OnScreen = Camera:WorldToViewportPoint(rootPart.Position)

      -- Initialize Snapline drawing objects if not already initialized
      if not Drawings.Snapline then
        Drawings.Snapline = Drawing.new("Line")
      end
      if not Drawings.SnaplineOutline then
        Drawings.SnaplineOutline = Drawing.new("Line")
      end

      if OnScreen then
        local x, y = math.floor(PositionC.X), math.floor(PositionC.Y)
        Drawings.Snapline.Visible = true
        Drawings.Snapline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - Camera.ViewportSize.Y)
        Drawings.Snapline.To = Vector2.new(x, y)

        Drawings.SnaplineOutline.Visible = true
        Drawings.SnaplineOutline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - Camera.ViewportSize.Y)
        Drawings.SnaplineOutline.To = Vector2.new(x, y)
      else
        Drawings.Snapline.Visible = false
        Drawings.SnaplineOutline.Visible = false
      end
    else
      Drawings.Snapline.Visible = false
      Drawings.SnaplineOutline.Visible = false
    end
  else
    Drawings.Snapline.Visible = false
    Drawings.SnaplineOutline.Visible = false
  end
end

Functions.getHoopPosition = function()
  local Hoop1 = game.Workspace:FindFirstChild("Hoop")
  local Hoop2 = game.Workspace:FindFirstChild("Hoop2")

  if Hoop1 and Hoop2 and Hoop1:FindFirstChild("Goal") and Hoop2:FindFirstChild("Goal") then
    local Hoop1Goal = Hoop1.Goal.Position
    local Hoop2Goal = Hoop2.Goal.Position
    local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position

    if playerPos then
      local dist1 = (playerPos - Hoop1Goal).Magnitude
      local dist2 = (playerPos - Hoop2Goal).Magnitude

      if dist1 < dist2 then
        return Hoop1Goal
      else
        return Hoop2Goal
      end
    end
  else
    for _, court in next, (Courts:GetChildren()) do
      local ValuesFolder = court:FindFirstChild("Values")
      if ValuesFolder then
        for _, object in next, (ValuesFolder:GetChildren()) do
          if object:IsA("StringValue") and object.Value == LocalPlayer.Name then
            local hoop = court:FindFirstChild("Hoop")
            if hoop and hoop:FindFirstChild("Goal") then
              return hoop.Goal.Position
            end
          end
        end
      end
    end
  end
  return nil
end

Functions.teleportToDefensivePosition = function(MaxDistance)
  local userInputDown = UserInputService:IsKeyDown(Enum.KeyCode.G)
  local mobileGuardButton = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Mobile") and LocalPlayer.PlayerGui.Mobile:FindFirstChild("Defense") and LocalPlayer.PlayerGui.Mobile.Defense:FindFirstChild("Guard")

  if not userInputDown and (not mobileGuardButton or not mobileGuardButton:IsDescendantOf(LocalPlayer.PlayerGui)) then
    return -- Exit if G is not held and the mobile guard button doesn't exist
  end

  local guarding = userInputDown -- Assume guarding is triggered by holding G on PC
  if mobileGuardButton then
    mobileGuardButton.MouseButton1Down:Connect(function()
      guarding = true
    end)
    mobileGuardButton.MouseButton1Up:Connect(function()
      guarding = false
    end)
  end

  if not guarding then return end -- Exit if not guarding

  local targetPlayer = Functions.getClosestPlayer(MaxDistance)
  local hoopPosition = Functions.getHoopPosition()

  if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and hoopPosition then
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local predictionTime = Options.PredictionAmount.Value
    local predictedPosition = targetRoot.Position + (targetRoot.Velocity * predictionTime)

    local hoopToPlayer = (predictedPosition - hoopPosition).unit
    local defensivePosition = predictedPosition - (hoopToPlayer * 3.25)

    defensivePosition = Vector3.new(defensivePosition.X, targetRoot.Position.Y, defensivePosition.Z)
    HumanoidRootPart.CFrame = CFrame.new(defensivePosition, targetRoot.Position)

    ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("Guard"):FireServer(true)
  end
end

Functions.AutoBlock = function()		
  local target = Functions.getClosestPlayer(16)
  if target then
    --print("1/1")
    if target.Values.Shooting.Value or target.Values.Dunking.Value then
      --print("2/2")
      task.wait()
      ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("Block"):FireServer()
    end
  end
end

Functions.GetOutOfBounds = function(Value)
  local character = LocalPlayer.Character
  if not character or not character:FindFirstChild("HumanoidRootPart") then
    return nil
  end

  for _, court in next, Courts:GetChildren() do
    local OutOfBounds = Value and court:FindFirstChild("OutOfBounds") or ReplicatedStorage:FindFirstChild("OutOfBounds")

    if OutOfBounds then
      if Value then
        OutOfBounds.Parent = ReplicatedStorage
      else
        OutOfBounds.Parent = court
      end
    end
  end
end

Functions.GetCourtBorders = function(Value)
  local character = LocalPlayer.Character
  if not character or not character:FindFirstChild("HumanoidRootPart") then
    return nil
  end

  for _, court in next, Courts:GetChildren() do
    local CourtBorders = Value and court:FindFirstChild("CourtBorders") or ReplicatedStorage:FindFirstChild("CourtBorders")

    if CourtBorders then
      if Value then
        CourtBorders.Parent = ReplicatedStorage
      else
        CourtBorders.Parent = court
      end
    end
  end
end

Functions.walkflingFunction = function()
  if humanoid then
    humanoid.Died:Connect(function()
      walkflinging = false
    end)
  end

  walkflinging = true
  repeat RunService.Heartbeat:Wait()
    local character = Character
    local root = HumanoidRootPart
    local vel, movel = nil, 0.1

    while not (character and character.Parent and root and root.Parent) do
      RunService.Heartbeat:Wait()
      character = Character
      root = HumanoidRootPart
    end

    vel = root.Velocity
    root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

    RunService.RenderStepped:Wait()
    if character and character.Parent and root and root.Parent then
      root.Velocity = vel
    end

    RunService.Stepped:Wait()
    if character and character.Parent and root and root.Parent then
      root.Velocity = vel + Vector3.new(0, movel, 0)
      movel = movel * -1
    end
  until walkflinging == false
end

local Connections = {
  WatermarkConnection = nil,
  AutoGreenInput = nil,
  MobileAutoGreenInput = nil,
  InfiniteStamina = nil,
  DribblingGlide = nil,
  PickupRange = nil,
  WalkSpeed = nil,
  JumpPower = nil,
  HipHeight = nil,
  AutoBlock = nil,
  AutoGuard = nil,
  UpdateSnapline = nil,
  SpinbotConnection = nil,
  CharacterAddedConnection = nil,
}

Connections.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
  Character = newCharacter
  humanoid = newCharacter:WaitForChild("Humanoid")
  HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Zyai-Lua/Inertia.mov/refs/heads/main/Linoria'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/Zyai-Lua/Inertia.mov/refs/heads/main/LinoriaTheme'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
  Title = 'Inertia | <font color=\"#00ff00\">Free</font> | Hoop Nation V2',
  Center = true,
  AutoShow = true,
  TabPadding = 8,
  MenuFadeTime = 0.2
})

local Tabs = {
  Main = Window:AddTab('Main'),
  Miscellaneous = Window:AddTab('Miscellaneous'),
  ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Main = Tabs.Main:AddLeftGroupbox('Main')
local Unlocks = Tabs.Main:AddLeftGroupbox('Unlocks')
local Player = Tabs.Main:AddRightGroupbox('Player')
local Animations = Tabs.Main:AddRightGroupbox('Animations')
local Miscellaneous = Tabs.Miscellaneous:AddLeftGroupbox('Miscellaneous')

Miscellaneous:AddToggle('OutOfBoundsToggle', {
  Text = 'Remove OutOfBounds',
  Default = false,
  Tooltip = 'Removes all OutOfBounds',

  Callback = function(Value)
    Functions.GetOutOfBounds(Value)
  end
})

Miscellaneous:AddToggle('CourtBordersToggle', {
  Text = 'Remove CourtBorders',
  Default = false,
  Tooltip = 'Removes all CourtBorders',

  Callback = function(Value)
    Functions.GetCourtBorders(Value)
  end
})

Unlocks:AddDropdown('ShirtDropdown', {
  Values = shirtNames,
  Default = 1,
  Multi = false,

  Text = 'Select a Shirt',
  Tooltip = 'Choose a clothing item',

  Callback = function(Value)
    local ShirtObject = ReplicatedStorage.Assets.Clothing.Shirts:FindFirstChild(Value)

    if ShirtObject and ShirtObject:IsA("Shirt") then
      local ShirtID = ShirtObject.ShirtTemplate
      local Character = LocalPlayer.Character

      if Character then
        local Shirt = Character:FindFirstChildOfClass("Shirt")

        if not Shirt then
          Shirt = Instance.new("Shirt")
          Shirt.Parent = Character
        end

        Shirt.ShirtTemplate = ShirtID
      end
    else
      warn("Shirt not found or invalid shirt object:", Value)
    end
  end
})

Unlocks:AddDropdown('PantDropdown', {
  Values = pantNames,
  Default = 1,
  Multi = false,

  Text = 'Select a Pant',
  Tooltip = 'Choose a clothing item',

  Callback = function(Value)
    local PantObject = ReplicatedStorage.Assets.Clothing.Pants:FindFirstChild(Value)

    -- Ensure the pants exist and are of type "Pants"
    if PantObject and PantObject:IsA("Pants") then
      local PantsID = PantObject.PantsTemplate
      local Character = LocalPlayer.Character

      if Character then
        local Pants = Character:FindFirstChildOfClass("Pants")

        -- If the character has no pants, create a new one
        if not Pants then
          Pants = Instance.new("Pants")
          Pants.Parent = Character
        end

        -- Apply the selected pants template
        Pants.PantsTemplate = PantsID
      end
    else
      warn("Pants not found or invalid pants object:", Value)
    end
  end
})

local UnlockGamepasses = Unlocks:AddButton({
  Text = 'Unlock Gamepasses',
  Func = function()
    if GamepassValues then
      for i,v in next, (GamepassValues:GetChildren()) do
        v.Value = true
      end
    else
      Libray:Notify("Could not find character, make sure you are loaded in!")
      GamepassValues = LocalPlayer.Character.Stats.Gamepasses or nil
    end
  end,
  DoubleClick = false,
  Tooltip = 'Unlocks gamepasses like dunk packs for free'
})

Main:AddToggle('AutoGreenRageToggle', {
  Text = '<font color=\"#ff0000\">Rage Auto-Green</font>',
  Default = false,
  Tooltip = 'Very obvious -- works the best',

  Callback = function(Value)
    Toggles.AutoGreenRageToggle.Value = Value

--[[
  if Value then
    
  end
  ]]
  end
}):AddKeyPicker('AutoGreenRageKeyPicker', {
Default = 'B',
SyncToggleState = false,

Mode = 'Toggle',

Text = 'Rage Auto-Green', 
NoUI = false, 

Callback = function(Value)
  Toggles.AutoGreenRageToggle:SetValue(Value)
end,
})

Main:AddToggle('AutoGreenToggle', {
  Text = 'Auto Green',
  Default = false,
  Tooltip = 'Works for both meter types',

  Callback = function(Value)
    Toggles.AutoGreenToggle.Value = Value

    if Value then
      if not Connections.AutoGreenInput then
        Connections.AutoGreenInput = UserInputService.InputBegan:Connect(Functions.onKeyPress)
      end
    else
      if Connections.AutoGreenInput then
        Connections.AutoGreenInput:Disconnect()
        Connections.AutoGreenInput = nil
      end
    end
  end
})

Main:AddDropdown('AutoGreenTypeDropdown', {
  Values = { 'Function', 'Remote'},
  Default = 1,
  Multi = false,

  Text = 'Method',
  Tooltip = 'All of them should work but if one does not try a different one!',

  Callback = function(Value)
    Options.AutoGreenTypeDropdown.Value = Value
  end
})

Main:AddToggle('AutoGuard', {
  Text = 'Auto Guard (BLATANT)',
  Default = false,
  Tooltip = 'Automatically guards closest player with a basketball',

  Callback = function(Value)
    Toggles.AutoGuard.Value = Value

    if Value then
      if not Connections.AutoGuard then
        Connections.AutoGuard = RunService.RenderStepped:Connect(function()
          Functions.teleportToDefensivePosition(Options.MaxDistance.Value)
        end)
      end
    else
      if Connections.AutoGuard then
        Connections.AutoGuard:Disconnect()
        Connections.AutoGuard = nil
      end
    end
  end
})

Main:AddLabel('Hold G When you want to Auto Guard.')

Main:AddSlider('PredictionAmount', {
  Text = 'Offset',
  Default = 0.5,
  Min = 0,
  Max = 3,
  Rounding = 2,
  Compact = false,

  Callback = function(Value)
    Options.PredictionAmount.Value = Value
  end
})

Main:AddSlider('MaxDistance', {
  Text = 'Distance',
  Default = 15,
  Min = 0,
  Max = 100,
  Rounding = 2,
  Compact = false,

  Callback = function(Value)
    Options.MaxDistance.Value = Value
  end
})

Main:AddToggle('Indicator', {
  Text = 'Indicator',
  Default = false,
  Tooltip = 'Shows the closest guarded player!',

  Callback = function(Value)
    Toggles.Indicator.Value = Value

    if Value then
      if not Connections.UpdateSnapline then
        Connections.UpdateSnapline = RunService.RenderStepped:Connect(Functions.updateSnapline)
      end
    else
      if Connections.UpdateSnapline then
        Connections.UpdateSnapline:Disconnect()
        Connections.UpdateSnapline = nil
        Drawings.Snapline.Visible = false
        Drawings.SnaplineOutline.Visible = false
      end
    end
  end
}):AddColorPicker('IndicatorColor', {
  Default = Color3.new(1, 1, 1),
  Title = 'IndicatorColor',
  Transparency = 0,

  Callback = function(Value)
    Drawings.Snapline.Color = Value
  end
})

Main:AddToggle('AutoBlockToggle', {
  Text = 'Auto Block',
  Default = false,
  Tooltip = 'Automatically blocks when a person shoots',

  Callback = function(Value)
    Toggles.AutoBlockToggle.Value = Value

    if Value then
      if not Connections.AutoBlock then
        Connections.AutoBlock = RunService.RenderStepped:Connect(Functions.AutoBlock)
      end
    else
      if Connections.AutoBlock then
        Connections.AutoBlock:Disconnect()
        Connections.AutoBlock = nil
      end
    end
  end
})

Player:AddToggle('AntiAnklesToggle', {
  Text = 'Anti-Ankles',
  Default = false,
  Tooltip = 'Stops AnkleBreakers',

  Callback = function(Value)

  end
})

Player:AddToggle('WalkFlingToggle', {
  Text = 'Walk Fling',
  Default = false,
  Tooltip = 'Allows you to fling when walking',

  Callback = function(Value)
    if Value then
      Functions.walkflingFunction()
    else
      walkflinging = false
    end
  end
})

Player:AddToggle('WalkSpeedToggle', {
  Text = 'Walk Speed',
  Default = false,
  Tooltip = 'Enables Walk Speed',

  Callback = function(Value)
    Toggles.WalkSpeedToggle.Value = Value

    if Value then
      if not Connections.WalkSpeed then
        Connections.WalkSpeed = RunService.RenderStepped:Connect(function()
          if Character:FindFirstChildOfClass("Humanoid").WalkSpeed ~= Options.WalkSpeedSlider.Value then
            Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Options.WalkSpeedSlider.Value
          end
        end)
      end
    else
      if Connections.WalkSpeed then
        Connections.WalkSpeed:Disconnect()
        Connections.WalkSpeed = nil
      end
    end
  end
}):AddKeyPicker('WalkSpeedKeyPicker', {
  Default = 'L',
  SyncToggleState = false,

  Mode = 'Toggle',

  Text = 'WalkSpeed', 
  NoUI = false,

  Callback = function(Value)
    Toggles.WalkSpeedToggle:SetValue(Value)
  end,
})

Player:AddSlider('WalkSpeedSlider', {
  Text = 'Amount',
  Default = 11,
  Min = 11,
  Max = 100,
  Rounding = 2,
  Compact = false,

  Callback = function(Value)
    Options.WalkSpeedSlider.Value = Value
  end
})

Player:AddToggle('JumpPowerToggle', {
  Text = 'Jump Power',
  Default = false,
  Tooltip = 'Enables Jump Power',

  Callback = function(Value)
    Toggles.JumpPowerToggle.Value = Value

    if Value then
      Character:FindFirstChildOfClass("Humanoid").JumpPower = Options.JumpPowerSlider.Value
    else
      Character:FindFirstChildOfClass("Humanoid").JumpPower = 0
    end
  end
})

Player:AddSlider('JumpPowerSlider', {
  Text = 'Amount',
  Default = 0,
  Min = 0,
  Max = 50,
  Rounding = 2,
  Compact = false,

  Callback = function(Value)
    Options.JumpPowerSlider.Value = Value

    if Toggles.JumpPowerToggle.Value then
      Character:FindFirstChildOfClass("Humanoid").JumpPower = Options.JumpPowerSlider.Value
    else
      Character:FindFirstChildOfClass("Humanoid").JumpPower = 0
    end
  end
})

Player:AddToggle('HipHeightToggle', {
  Text = 'Hip Height',
  Default = false,
  Tooltip = 'Enables Hip Height',

  Callback = function(Value)
    Toggles.HipHeightToggle.Value = Value

    if Value then
      Character:FindFirstChildOfClass("Humanoid").HipHeight = Options.HipHeightSlider.Value
    else
      Character:FindFirstChildOfClass("Humanoid").HipHeight = 2.4090378284454346
    end
  end
})

Player:AddSlider('HipHeightSlider', {
  Text = 'Amount',
  Default = 2,
  Min = 2,
  Max = 20,
  Rounding = 2,
  Compact = false,

  Callback = function(Value)
    Options.HipHeightSlider.Value = Value

    if Toggles.HipHeightToggle.Value then
      Character:FindFirstChildOfClass("Humanoid").HipHeight = Options.HipHeightSlider.Value
    else
      Character:FindFirstChildOfClass("Humanoid").HipHeight = 2.4090378284454346
    end
  end
})

  Player:AddToggle('AlwaysSprintToggle', {
  Text = 'Always Sprint',
  Default = false,
  Tooltip = 'Allows you to sprint without holding down',

  Callback = function(Value)
    --Toggles.AlwaysSprintToggle.Value = Value

    if Value then
              if not SprintValue.Value then
                  SprintValue.Value = true
              end
    else
              if SprintValue.Value then
                  SprintValue.Value = false
              end
    end
  end
})

Player:AddToggle('InfiniteStaminaToggle', {
  Text = 'Infinite Stamina',
  Default = false,
  Tooltip = 'inf stamina',

  Callback = function(Value)
    Toggles.InfiniteStaminaToggle.Value = Value

    if Value then
      if not Connections.InfiniteStamina then
        Connections.InfiniteStamina = StaminaValue:GetPropertyChangedSignal("Value"):Connect(function(Value)
          StaminaValue.Value = 1
        end)
      end
    else
      if Connections.InfiniteStamina then
        Connections.InfiniteStamina:Disconnect()
        Connections.InfiniteStamina = nil
      end
    end
  end
})

Player:AddToggle('DribbleGlideToggle', {
  Text = 'Dribble Glide',
  Default = false,
  Tooltip = 'dribbel glide',

  Callback = function(Value)
    Toggles.DribbleGlideToggle.Value = Value

    if Value then
      if not Connections.DribblingGlide then
        Connections.DribblingGlide = LocalPlayer.Values.Dribbling:GetPropertyChangedSignal("Value"):Connect(function()
          task.wait(0.3)
          local hrp = LocalPlayer.Character.HumanoidRootPart
          local bodyVelocity = hrp.BodyVelocity
          local newval = Functions.increaseGreatestComponent(bodyVelocity.Velocity, Options.GlideAmount.Value)

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

Player:AddSlider('GlideAmount', {
  Text = 'Amount',
  Default = 1,
  Min = 1,
  Max = 5,
  Rounding = 1,
  Compact = false,

  Callback = function(Value)
    Options.GlideAmount.Value = Value
  end
})

Player:AddToggle('PickupRangeToggle', {
    Text = 'Pickup Range',
    Default = false,
    Tooltip = 'Modify the distance in which you can pickup the ball',

    Callback = function(Value)
        Toggles.PickupRangeToggle.Value = Value

        if Value then
            if not Connections.PickupRange then
                Connections.PickupRange = RunService.RenderStepped:Connect(function()
                    local target = Functions.FindClosestBasketball(Options.PickupRangeAmount.Value)
                    if target and not LocalPlayer.Values.Shooting.Value then
                        firetouchinterest(target, Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 15), 0)
                        firetouchinterest(target, Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 15), 1) 
                    else
                        return
                    end
                end)
            end
        else
            if Connections.PickupRange then
                Connections.PickupRange:Disconnect()
                Connections.PickupRange = nil
            end
        end
    end
}):AddKeyPicker('PickupRangeKeyPicker', {
    Default = 'M', 
    SyncToggleState = false,

    Mode = 'Toggle', 

    Text = 'Pickup Range', 
    NoUI = false,

    Callback = function(Value)
        Toggles.PickupRangeToggle:SetValue(Value)
    end,
})

--[[
Player:AddToggle('PickupRangeToggle', {
    Text = 'Pickup Range',
    Default = false,
    Tooltip = 'Modify the distance in which you can pickup the ball',

    Callback = function(Value)
        Toggles.PickupRangeToggle.Value = Value

        if Value then
            if not Connections.PickupRange then
                Connections.PickupRange = RunService.RenderStepped:Connect(function()
                    local target = Functions.FindClosestBasketball(Options.PickupRangeAmount.Value)
                    if target and not LocalPlayer.Values.Shooting.Value then
                        firetouchinterest(target, Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 15), true)
                        firetouchinterest(target, Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 15), false) 
                    else
                        return
                    end
                end)
            end
        else
            if Connections.PickupRange then
                Connections.PickupRange:Disconnect()
                Connections.PickupRange = nil
            end
        end
    end
}):AddKeyPicker('PickupRangeKeyPicker', {
    Default = 'M', 
    SyncToggleState = false,

    Mode = 'Toggle', 

    Text = 'Pickup Range', 
    NoUI = false,

    Callback = function(Value)
        Toggles.PickupRangeToggle:SetValue(Value)
    end,
})
end
]]

Player:AddSlider('PickupRangeAmount', {
  Text = 'Amount',
  Default = 10,
  Min = 5,
  Max = 100,
  Rounding = 2,
  Compact = false,

  Callback = function(Value)
    Options.PickupRangeAmount.Value = Value
  end
})

Player:AddToggle('Spinbot', {
  Text = "Spinbot",
  Default = false,
  Tooltip = "Enables Spinbot",

  Callback = function(Value)
	Functions.ToggleSpinbot(Value)
  end,
}):AddKeyPicker('SpinbotToggleKeypicker', {
      Default = 'R',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Spinbot',
      NoUI = false,
      Callback = function(Value)
          Functions.ToggleSpinbot(Value)
      end,
  })

Player:AddSlider('SpinbotSliderAmount', {
	Text = 'Amount',
	Default = 1,
	Min = 1,
	Max = 20,
	Rounding = 2,
	Compact = false,
  
	Callback = function(Value)
	  Options.SpinbotSliderAmount.Value = Value
	end
  })

Animations:AddLabel('Anims show to other players')

  Animations:AddToggle('FakeFadeawayToggle', {
      Text = "Fake Fadeaway",
      Default = false,
      Tooltip = "Plays Fadeaway animation",
  }):AddKeyPicker('FakeFadeawayKeyPicker', {
      Default = 'L',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake Fadeaway',
      NoUI = false,
      ChangedCallback = function(NewInput)
          FadeawayKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == FadeawayKeybind and Toggles.FakeFadeawayToggle.Value then
          FadeawayTrack:Play()
      end
  end)

  Animations:AddToggle('FakeBlockToggle', {
      Text = "Fake Block",
      Default = false,
      Tooltip = "Plays Block animation",
  }):AddKeyPicker('FakeBlockKeyPicker', {
      Default = 'B',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake Block',
      NoUI = false,
      ChangedCallback = function(NewInput)
          BlockKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == BlockKeybind and Toggles.FakeBlockToggle.Value then
          BlockTrack:Play()
      end
  end)

  Animations:AddToggle('FakeChestPassToggle', {
      Text = "Fake ChestPass",
      Default = false,
      Tooltip = "Plays ChestPass animation",
  }):AddKeyPicker('FakeChestPassKeyPicker', {
      Default = 'C',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake ChestPass',
      NoUI = false,
      ChangedCallback = function(NewInput)
          ChestPassKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == ChestPassKeybind and Toggles.FakeChestPassToggle.Value then
          ChestPassTrack:Play()
      end
  end)

  Animations:AddToggle('FakeJumpshotToggle', {
      Text = "Fake Jumpshot",
      Default = false,
      Tooltip = "Plays Jumpshot animation",
  }):AddKeyPicker('FakeJumpshotKeyPicker', {
      Default = 'J',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake Jumpshot',
      NoUI = false,
      ChangedCallback = function(NewInput)
          JumpshotKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == JumpshotKeybind and Toggles.FakeJumpshotToggle.Value then
          JumpshotTrack:Play()
      end
  end)

  Animations:AddToggle('FakePassToggle', {
      Text = "Fake Pass",
      Default = false,
      Tooltip = "Plays Pass animation",
  }):AddKeyPicker('FakePassKeyPicker', {
      Default = 'P',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake Pass',
      NoUI = false,
      ChangedCallback = function(NewInput)
          PassKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == PassKeybind and Toggles.FakePassToggle.Value then
          PassTrack:Play()
      end
  end)

  Animations:AddToggle('FakeStealRToggle', {
      Text = "Fake StealR",
      Default = false,
      Tooltip = "Plays StealR animation",
  }):AddKeyPicker('FakeStealRKeyPicker', {
      Default = 'R',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake StealR',
      NoUI = false,
      ChangedCallback = function(NewInput)
          StealRKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == StealRKeybind and Toggles.FakeStealRToggle.Value then
          StealRTrack:Play()
      end
  end)

  Animations:AddToggle('FakeHoldBallToggle', {
      Text = "Fake HoldBall",
      Default = false,
      Tooltip = "Plays HoldBall animation",
  }):AddKeyPicker('FakeHoldBallKeyPicker', {
      Default = 'H',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake HoldBall',
      NoUI = false,
      ChangedCallback = function(NewInput)
          HoldBallKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == HoldBallKeybind and Toggles.FakeHoldBallToggle.Value then
          HoldBallTrack:Play()
      end
  end)

  Animations:AddToggle('FakeBackflipToggle', {
      Text = "Fake Backflip",
      Default = false,
      Tooltip = "Plays Backflip animation",
  }):AddKeyPicker('FakeBackflipKeyPicker', {
      Default = 'F',
      SyncToggleState = false,
      Mode = 'Toggle',
      Text = 'Fake Backflip',
      NoUI = false,
      ChangedCallback = function(NewInput)
          BackflipKeybind = NewInput
      end,
  })
  UserInputService.InputBegan:Connect(function(input, gpe)
      if gpe or UserInputService:GetFocusedTextBox() then return end
      if input.KeyCode == BackflipKeybind and Toggles.FakeBackflipToggle.Value then
          BackflipTrack:Play()
      end
  end)


--[[
local old; old = hookfunction(ShootFunction, newcclosure(function()
if LocalPlayer.Values.WaitingDribble.Value == true then
  return
elseif LocalPlayer.Values.Dunking.Value == true then
  return
elseif LocalPlayer.Values.PushingBack.Value == true then
  return
elseif LocalPlayer.Values.Moving.Value == true then
  return
else
  if LocalPlayer.Values.Dribbling.Value == true then
    repeat wait() until LocalPlayer.Values.Dribbling.Value == false
  end
  if LocalPlayer.Values.WaitingDribble.Value == true then
    return
  elseif LocalPlayer.Values.Basketball.Value == nil then
    return
  elseif LocalPlayer.Values.CanShoot.Value == false then
    return
  elseif LocalPlayer.Values.Shooting.Value == true and p34 == true then
    return
  elseif LocalPlayer.Values.Shooting.Value == false and p34 == false then
    return
  elseif p34 == true then
    if LocalPlayer.Settings.NoMeter.Value == "Off" then
      Meter2Meter.Parent.Enabled = true
    end
    Tween1:Play()
    FalseBoolean2 = true
    FalseBoolean1 = true
    ReplicatedStorage.Events.Shoot:FireServer(p34, 100)
    task.spawn(function()
      task.wait(0.42)
      if FalseBoolean1 == true then
        Tween1:Pause()
        Tween2:Play()
        FalseBoolean2 = false
      end
      task.wait(0.45)
      if FalseBoolean1 == true then
        v_u_37(false)
      end
    end)
  else
    Tween1:Pause()
    Tween2:Pause()
    FalseBoolean1 = false
    --local clamped = math.clamp(-NumberValue, -1, 0)
    --var35_upvw = clamped * -87
    local v35 = -NumberValue.Value
    local v36 = -0.99
    ReplicatedStorage.Events.Shoot:FireServer(p34, v36, FalseBoolean2)
    task.wait(1.5)
    Meter2Meter.Parent.Enabled = false
    Tween2:Play()
  end
end
end))
]]

--autistic and rare way of doing such a toggle
local old; old = hookfunction(ShootFunction, function(...)
  if Toggles.AutoGreenRageToggle.Value then
    local v36 = -0.99
    ReplicatedStorage.Events.Shoot:FireServer(p34, v36, FalseBoolean2)
    Meter2Meter.Parent.Enabled = false
  else
    old(...)
  end
end)

--[[
example of hookfunc w/ returning args that are important and shit

local old; old = hookfunction(ShootFunction, newcclosure(function(v36)
if Toggles.AutoGreenRageToggle.Value then
  v36 = -0.99
end
local v35 = -NumberValue.Value
--local v36 = -0.99
ReplicatedStorage.Events.Shoot:FireServer(p34, v36, FalseBoolean2)
--task.wait(1.5)
Meter2Meter.Parent.Enabled = false
return old(v36)
end))
]]
AnklesValue:GetPropertyChangedSignal("Value"):Connect(function()
  if AnklesValue.Value == true and Toggles.AntiAnklesToggle.Value then
    -- Stop BodyVelocity
    local bv = hrp:FindFirstChildOfClass("BodyVelocity")
    if bv then
      repeat bv.MaxForce = Vector3.new(0, 0, 0) task.wait(0.1) until bv.MaxForce == Vector3.new(0, 0, 0)
    end

    -- Stop ankle breaker animation
    if humanoid and humanoid:FindFirstChildOfClass("Animator") then
      local animator = humanoid:FindFirstChildOfClass("Animator")
      local tracks = animator:GetPlayingAnimationTracks()
      for _, track in ipairs(tracks) do
        if track.Animation and track.Animation.AnimationId == ankleBreakerId then
          track:Stop()
          print("Ankle breaker animation stopped.")
        end
      end
    end
  end
end)

Library:SetWatermarkVisibility(true)

Connections.WatermarkConnection = RunService.RenderStepped:Connect(function()
  FrameCounter += 1;

  if (tick() - FrameTimer) >= 1 then
    FPS = FrameCounter;
    FrameTimer = tick();
    FrameCounter = 0;
  end;

  Library:SetWatermark(('Inertia | Free | %s fps | %s ms'):format(
    math.floor(FPS),
    math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()

  for index, connection in next, Connections do
    if connection then
      connection:Disconnect()
      connection = nil
    end
  end

  Character:FindFirstChildOfClass("Humanoid").HipHeight = 2.4090378284454346

  Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddLabel('Made by: Zyai, The')
MenuGroup:AddButton('Copy Discord', function() setclipboard("https://discord.gg/J7A8pzqPYE") end)
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddToggle('WatermarkVisibiltyToggle', {
  Text = 'Hide Watermark',
  Default = false,
  Tooltip = 'Hides Watermark',

  Callback = function(Value)
    Library:SetWatermarkVisibility(not Value)
  end
})
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Inertia_mov')
SaveManager:SetFolder('Inertia_mov/Hoop-Nation')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

Library:Notify(("Welcome to Inertia.Mov "..LocalPlayer.Name.." 👋"), 6)
Library:Notify(("Status: 🟢 - Undetected (Safe to use)"), 6)
