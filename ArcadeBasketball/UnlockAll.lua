local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local inventory = player:WaitForChild("Profile"):WaitForChild("Inventory")
local clothingAssets = ReplicatedStorage:WaitForChild("ClothingAssets")

for _, item in next, (inventory:GetChildren()) do
    item:Destroy()
end

for _, asset in next, (clothingAssets:GetChildren()) do
    asset:Clone().Parent = inventory
end
