game:GetService("Players").LocalPlayer.Values.Stamina:GetPropertyChangedSignal("Value"):Connect(function()
    if game:GetService("Players").LocalPlayer.Values.Stamina.Value ~= 1 then
        game:GetService("Players").LocalPlayer.Values.Stamina.Value = 1
    end
end)
