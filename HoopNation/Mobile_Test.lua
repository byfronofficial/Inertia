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
        
    end,
})
