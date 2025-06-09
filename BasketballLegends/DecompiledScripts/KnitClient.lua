local u1 = {
    ["ServicePromises"] = true,
    ["Middleware"] = nil,
    ["PerServiceMiddleware"] = {}
}
local u2 = nil
local v3 = {
    ["Player"] = game:GetService("Players").LocalPlayer,
    ["Util"] = script.Parent.Parent
}
local u4 = require(v3.Util.Promise)
local u5 = require(v3.Util.Comm).ClientComm
local u6 = {}
local u7 = {}
local u8 = nil
local u9 = false
local u10 = false
local u11 = Instance.new("BindableEvent")
function v3.CreateController(p12) --[[Anonymous function at line 175]]
    --[[
    Upvalues:
        [1] = u6
    --]]
    local v13 = type(p12) == "table"
    local v14 = ("Controller must be a table; got %*"):format((type(p12)))
    assert(v13, v14)
    local v15 = p12.Name
    local v16 = type(v15) == "string"
    local v17 = p12.Name
    local v18 = ("Controller.Name must be a string; got %*"):format((type(v17)))
    assert(v16, v18)
    local v19 = #p12.Name > 0
    assert(v19, "Controller.Name must be a non-empty string")
    local v20 = u6[p12.Name] ~= nil
    local v21 = ("Controller %* already exists"):format(p12.Name)
    assert(not v20, v21)
    u6[p12.Name] = p12
    return p12
end
function v3.AddControllers(p22) --[[Anonymous function at line 192]]
    local v23 = {}
    for _, v24 in p22:GetChildren() do
        if v24:IsA("ModuleScript") then
            local v25 = require
            table.insert(v23, v25(v24))
        end
    end
    return v23
end
function v3.AddControllersDeep(p26) --[[Anonymous function at line 206]]
    local v27 = {}
    for _, v28 in p26:GetDescendants() do
        if v28:IsA("ModuleScript") then
            local v29 = require
            table.insert(v27, v29(v28))
        end
    end
    return v27
end
function v3.GetService(p30) --[[Anonymous function at line 269]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u9
        [3] = u8
        [4] = u2
        [5] = u5
    --]]
    local v31 = u7[p30]
    if v31 then
        return v31
    end
    local v32 = u9
    assert(v32, "Cannot call GetService until Knit has been started")
    local v33 = type(p30) == "string"
    local v34 = ("ServiceName must be a string; got %*"):format((type(p30)))
    assert(v33, v34)
    if not u8 then
        u8 = script.Parent:WaitForChild("Services")
    end
    local v35 = u8
    local v36 = u2.Middleware == nil and {} or u2.Middleware
    local v37 = u2.PerServiceMiddleware[p30]
    if v37 == nil then
        v37 = v36
    end
    local v38 = u5.new(v35, u2.ServicePromises, p30):BuildObject(v37.Inbound, v37.Outbound)
    u7[p30] = v38
    return v38
end
function v3.GetController(p39) --[[Anonymous function at line 283]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u9
    --]]
    local v40 = u6[p39]
    if v40 then
        return v40
    end
    local v41 = u9
    assert(v41, "Cannot call GetController until Knit has been started")
    local v42 = type(p39) == "string"
    local v43 = ("ControllerName must be a string; got %*"):format((type(p39)))
    assert(v42, v43)
    error(("Could not find controller \"%*\". Check to verify a controller with this name exists."):format(p39), 2)
end
function v3.Start(p44) --[[Anonymous function at line 310]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u4
        [3] = u2
        [4] = u1
        [5] = u6
        [6] = u10
        [7] = u11
    --]]
    if u9 then
        return u4.reject("Knit already started")
    end
    u9 = true
    if p44 == nil then
        u2 = u1
    else
        local v45 = typeof(p44) == "table"
        local v46 = ("KnitOptions should be a table or nil; got %*"):format((typeof(p44)))
        assert(v45, v46)
        u2 = p44
        for v47, v48 in u1 do
            if u2[v47] == nil then
                u2[v47] = v48
            end
        end
    end
    local v49 = u2.PerServiceMiddleware
    if type(v49) ~= "table" then
        u2.PerServiceMiddleware = {}
    end
    return u4.new(function(p50) --[[Anonymous function at line 332]]
        --[[
        Upvalues:
            [1] = u6
            [2] = u4
        --]]
        local v51 = {}
        for _, u52 in u6 do
            local v53 = u52.KnitInit
            if type(v53) == "function" then
                local v54 = u4.new
                table.insert(v51, v54(function(p55) --[[Anonymous function at line 340]]
                    --[[
                    Upvalues:
                        [1] = u52
                    --]]
                    debug.setmemorycategory(u52.Name)
                    u52:KnitInit()
                    p55()
                end))
            end
        end
        p50(u4.all(v51))
    end):andThen(function() --[[Anonymous function at line 350]]
        --[[
        Upvalues:
            [1] = u6
            [2] = u10
            [3] = u11
        --]]
        for _, u56 in u6 do
            local v57 = u56.KnitStart
            if type(v57) == "function" then
                task.spawn(function() --[[Anonymous function at line 354]]
                    --[[
                    Upvalues:
                        [1] = u56
                    --]]
                    debug.setmemorycategory(u56.Name)
                    u56:KnitStart()
                end)
            end
        end
        u10 = true
        u11:Fire()
        task.defer(function() --[[Anonymous function at line 364]]
            --[[
            Upvalues:
                [1] = u11
            --]]
            u11:Destroy()
        end)
    end)
end
function v3.OnStart() --[[Anonymous function at line 382]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u4
        [3] = u11
    --]]
    if u10 then
        return u4.resolve()
    else
        return u4.fromEvent(u11.Event)
    end
end
return v3
