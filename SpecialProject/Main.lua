repeat task.wait() until game:IsLoaded()

local url = "https://raw.githubusercontent.com/byfronofficial/Inertia/main/SpecialProject/Main.lua"

local Players = game:GetService("Players")
local player = Players.LocalPlayer

repeat task.wait() until player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainMenu")

local MainMenu = player.PlayerGui.MainMenu
repeat task.wait() until MainMenu:FindFirstChild("Main")
repeat task.wait() until MainMenu.Main:FindFirstChild("Important") and MainMenu.Main:FindFirstChild("Play")
repeat task.wait() until MainMenu:FindFirstChild("RemoteEvent")

firesignal(MainMenu.Main.Important.OK.MouseButton1Click)
task.wait(1)
firesignal(MainMenu.Main.Play.MouseButton1Click)
task.wait(1)

MainMenu.RemoteEvent:FireServer("LoadChar1")
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Requeue script for next teleport
queue_on_teleport("loadstring(game:HttpGet('" .. url .. "', true))()")
game:GetService("TeleportService"):Teleport((game.PlaceId == 17067673356) and 76053362197989 or 17067673356)
