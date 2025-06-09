local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ShootRemote = ReplicatedStorage.Packages.Knit.Services.ControlService.RE:WaitForChild("Shoot")

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.P then
        ShootRemote:FireServer(1)
    end
end)

--print('Loaded!')
