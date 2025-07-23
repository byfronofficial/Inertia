local shoot_function;
local old_hook;

for index, value in next, getgc(false) do
    if type(value) == "function" and islclosure(value) and not isexecutorclosure(value) then
        if debug.getinfo(value).source:find("Client") then
            local consts = debug.getconstants(value)
            local upvalues = debug.getupvalues(value)

--[[
            for number, object in next, consts do
                if object == "Shoot" then
                    
                end
            end
            ]]
            if #upvalues == 9 then
                for number, object in next, consts do
                    if object == "Shoot" then
                        shoot_function = value
                    end
                end
            end
        end
    end
end


old_hook = hookfunction(shoot_function, function(...)
    game.ReplicatedStorage.Events.Shoot:FireServer(nil, -1, nil, nil)
    game.ReplicatedStorage.Events.Shoot:FireServer(nil, -1, nil)
end)

