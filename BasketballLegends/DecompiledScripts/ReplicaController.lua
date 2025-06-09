local u1 = {
    ["RequestDataRepeat"] = 10,
    ["SetterError"] = "[ReplicaController]: Replica setters can only be called inside write functions"
}
local u2 = game:GetService("RunService")
local function u10(p3, u4, p5) --[[Anonymous function at line 127]]
    --[[
    Upvalues:
        [1] = u2
    --]]
    local u6 = p3:FindFirstChild(u4, true)
    if u6 ~= nil then
        return u6
    end
    local v7 = os.clock()
    local v9 = p3.DescendantAdded:Connect(function(p8) --[[Anonymous function at line 132]]
        --[[
        Upvalues:
            [1] = u4
            [2] = u6
        --]]
        if p8.Name == u4 then
            u6 = p8
        end
    end)
    while u6 == nil do
        if v7 ~= nil and (os.clock() - v7 > 1 and (u2:IsServer() == true or game:IsLoaded() == true)) then
            warn("[" .. script.Name .. "]: Missing " .. p5 .. " \"" .. u4 .. "\" in " .. p3:GetFullName() .. "; Please check setup documentation")
            v7 = nil
        end
        task.wait()
    end
    v9:Disconnect()
    return u6
end
local u11
if u2:IsServer() == true then
    u11 = Instance.new("Folder")
    u11.Name = "ReplicaRemoteEvents"
    u11.Parent = game:GetService("ReplicatedStorage")
else
    u11 = u10(game:GetService("ReplicatedStorage"), "ReplicaRemoteEvents", "folder")
end
local u16 = {
    ["GetShared"] = function(_, p12) --[[Function name: GetShared, line 163]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        return u10(game:GetService("ReplicatedStorage"), p12, "module")
    end,
    ["GetModule"] = function(_, p13) --[[Function name: GetModule, line 167]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        return u10(game:GetService("ServerScriptService"), p13, "module")
    end,
    ["SetupRemoteEvent"] = function(p14) --[[Function name: SetupRemoteEvent, line 170]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u11
            [3] = u10
        --]]
        if u2:IsServer() ~= true then
            return u10(u11, p14, "remote event")
        end
        local v15 = Instance.new("RemoteEvent")
        v15.Name = p14
        v15.Parent = u11
        return v15
    end,
    ["Shared"] = {}
}
local v17 = require(u16.GetShared("Madwork", "MadworkScriptSignal"))
u16.NewScriptSignal = v17.NewScriptSignal
u16.NewArrayScriptConnection = v17.NewArrayScriptConnection
local u18 = {
    ["NewReplicaSignal"] = u16.NewScriptSignal(),
    ["InitialDataReceivedSignal"] = u16.NewScriptSignal(),
    ["InitialDataReceived"] = false,
    ["_replicas"] = {},
    ["_class_listeners"] = {},
    ["_child_listeners"] = {}
}
local u19 = require(u16.GetShared("Madwork", "MadworkMaid"))
local u20 = nil
local u21 = u18._replicas
local u22 = u18.NewReplicaSignal
local u23 = u18._class_listeners
local u24 = u18._child_listeners
local u25 = u16.SetupRemoteEvent("Replica_ReplicaRequestData")
local v26 = u16.SetupRemoteEvent("Replica_ReplicaSetValue")
local v27 = u16.SetupRemoteEvent("Replica_ReplicaSetValues")
local v28 = u16.SetupRemoteEvent("Replica_ReplicaArrayInsert")
local v29 = u16.SetupRemoteEvent("Replica_ReplicaArraySet")
local v30 = u16.SetupRemoteEvent("Replica_ReplicaArrayRemove")
local v31 = u16.SetupRemoteEvent("Replica_ReplicaWrite")
local u32 = u16.SetupRemoteEvent("Replica_ReplicaSignal")
local v33 = u16.SetupRemoteEvent("Replica_ReplicaSetParent")
local v34 = u16.SetupRemoteEvent("Replica_ReplicaCreate")
local v35 = u16.SetupRemoteEvent("Replica_ReplicaDestroy")
local u36 = false
local u37 = {}
local u38 = false
local function u45(p39, p40, p41) --[[Anonymous function at line 300]]
    --[[
    Upvalues:
        [1] = u45
    --]]
    for v42, v43 in pairs(p40) do
        if type(v43) == "table" then
            u45(p39, v43, p41 .. v42 .. ".")
        elseif type(v43) == "function" then
            local v44 = { p41 .. v42, v43 }
            table.insert(p39, v44)
        else
            error("[ReplicaController]: Invalid write function value \"" .. tostring(v43) .. "\" (" .. typeof(v43) .. "); name_stack = \"" .. p41 .. "\"")
        end
    end
end
local function u56(p46) --[[Anonymous function at line 312]]
    --[[
    Upvalues:
        [1] = u37
        [2] = u45
    --]]
    local v47 = u37[p46]
    if v47 ~= nil then
        return v47
    end
    local v48 = {}
    u45(v48, require(p46), "")
    table.sort(v48, function(p49, p50) --[[Anonymous function at line 323]]
        return p49[1] < p50[1]
    end)
    local v51 = {}
    local v52 = {}
    for v53, v54 in ipairs(v48) do
        v51[v53] = v54[2]
        v52[v54[1]] = v53
    end
    local v55 = { v51, v52 }
    u37[p46] = v55
    return v55
end
local function u60(p57) --[[Anonymous function at line 342]]
    local v58 = {}
    if p57 ~= "" then
        for v59 in string.gmatch(p57, "[^%.]+") do
            table.insert(v58, v59)
        end
    end
    return v58
end
local function u66(p61, p62) --[[Anonymous function at line 352]]
    --[[
    Upvalues:
        [1] = u66
        [2] = u21
        [3] = u24
    --]]
    for _, v63 in ipairs(p61.Children) do
        u66(v63, true)
    end
    local v64 = p61.Id
    u21[v64] = nil
    p61._maid:Cleanup()
    if p62 ~= true and p61.Parent ~= nil then
        local v65 = p61.Parent.Children
        table.remove(v65, table.find(v65, p61))
    end
    u24[v64] = nil
end
local function u74(p67, p68, p69) --[[Anonymous function at line 374]]
    local v70 = p67._table_listeners
    for v71 = 1, #p68 do
        local v72 = v70[1][p68[v71]]
        if v72 == nil then
            v72 = {
                {}
            }
            v70[1][p68[v71]] = v72
        end
        v70 = v72
    end
    local v73 = v70[p69]
    if v73 == nil then
        v73 = {}
        v70[p69] = v73
    end
    return v73
end
local function u83(p75) --[[Anonymous function at line 395]]
    local v76 = p75[1]
    local v77 = p75[2]
    local v78 = { v76 }
    for v79 = 1, #v77 do
        v76 = v76[1][v77[v79]]
        table.insert(v78, v76)
    end
    for v80 = #v78, 2, -1 do
        local v81 = v78[v80]
        if next(v81[1]) ~= nil then
            return
        end
        for v82 = 2, 6 do
            if v81[v82] ~= nil and #v81[v82] > 0 then
                return
            end
        end
        v78[v80 - 1][1][v77[v80 - 1]] = nil
    end
end
local function u114(p84, p85) --[[Anonymous function at line 420]]
    --[[
    Upvalues:
        [1] = u21
        [2] = u56
        [3] = u19
        [4] = u20
    --]]
    local v86 = {}
    for v87, v88 in pairs(p84) do
        v88[6] = tonumber(v87)
        table.insert(v86, v88)
    end
    table.sort(v86, function(p89, p90) --[[Anonymous function at line 428]]
        return p89[6] < p90[6]
    end)
    local v91 = {}
    local v92 = p85 or {}
    for _, v93 in ipairs(v86) do
        local v94 = v93[6]
        local v95 = v93[4]
        local v96 = false
        local v97
        if v95 == 0 then
            v97 = nil
        else
            v97 = u21[v95]
            if v97 == nil then
                v96 = true
            end
        end
        local v98, v99
        if v93[5] == nil then
            v98 = nil
            v99 = nil
        else
            local v100 = u56(v93[5])
            v98 = v100[1]
            v99 = v100[2]
        end
        local v101 = {
            ["Data"] = v93[3],
            ["Id"] = v94,
            ["Class"] = v93[1],
            ["Tags"] = v93[2],
            ["Parent"] = v97,
            ["Children"] = {},
            ["_write_lib"] = v98,
            ["_write_lib_dictionary"] = v99,
            ["_table_listeners"] = {
                {}
            },
            ["_function_listeners"] = {},
            ["_raw_listeners"] = {},
            ["_signal_listeners"] = {},
            ["_maid"] = u19.NewMaid()
        }
        local v102 = u20
        setmetatable(v101, v102)
        if v97 == nil then
            if v96 == true then
                local v103 = v91[v95]
                if v103 == nil then
                    v103 = {}
                    v91[v95] = v103
                end
                table.insert(v103, v101)
            end
        else
            local v104 = v97.Children
            table.insert(v104, v101)
        end
        u21[v94] = v101
        table.insert(v92, v101)
        local v105 = v91[v94]
        if v105 ~= nil then
            v91[v94] = nil
            for _, v106 in ipairs(v105) do
                v106.Parent = v101
                local v107 = v101.Children
                table.insert(v107, v106)
            end
        end
    end
    if next(v91) ~= nil then
        local v108 = "[ReplicaService]: BRANCH REPLICATION ERROR - Missing parents: "
        for v109, v110 in pairs(v91) do
            local v111 = v108 .. "[" .. tostring(v109) .. "]: {"
            for v112, v113 in ipairs(v110) do
                v111 = v111 .. (v112 == 1 and "" or ", ") .. v113:Identify()
            end
            v108 = v111 .. "}; "
        end
        error(v108)
    end
    return v92
end
local function u128(p115, p116, p117) --[[Anonymous function at line 514]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    local v118 = u21[p115]
    local v119 = v118.Data
    local v120 = v118._table_listeners
    for v121 = 1, #p116 - 1 do
        v119 = v119[p116[v121]]
        if v120 ~= nil then
            v120 = v120[1][p116[v121]]
        end
    end
    local v122 = p116[#p116]
    local v123 = v119[v122]
    v119[v122] = p117
    if v123 ~= p117 and v120 ~= nil then
        if v123 == nil and v120[3] ~= nil then
            for _, v124 in ipairs(v120[3]) do
                v124(p117, v122)
            end
        end
        local v125 = v120[1][p116[#p116]]
        if v125 ~= nil and v125[2] ~= nil then
            for _, v126 in ipairs(v125[2]) do
                v126(p117, v123)
            end
        end
    end
    for _, v127 in ipairs(v118._raw_listeners) do
        v127("SetValue", p116, p117)
    end
end
local function u143(p129, p130, p131) --[[Anonymous function at line 553]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    local v132 = u21[p129]
    local v133 = v132.Data
    local v134 = v132._table_listeners
    for v135 = 1, #p130 do
        v133 = v133[p130[v135]]
        if v134 ~= nil then
            v134 = v134[1][p130[v135]]
        end
    end
    for v136, v137 in pairs(p131) do
        local v138 = v133[v136]
        v133[v136] = v137
        if v138 ~= v137 and v134 ~= nil then
            if v138 == nil and v134[3] ~= nil then
                for _, v139 in ipairs(v134[3]) do
                    v139(v137, v136)
                end
            end
            local v140 = v134[1][v136]
            if v140 ~= nil and v140[2] ~= nil then
                for _, v141 in ipairs(v140[2]) do
                    v141(v137, v138)
                end
            end
        end
    end
    for _, v142 in ipairs(v132._raw_listeners) do
        v142("SetValues", p130, p131)
    end
end
local function u154(p144, p145, p146) --[[Anonymous function at line 594]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    local v147 = u21[p144]
    local v148 = v147.Data
    local v149 = v147._table_listeners
    for v150 = 1, #p145 do
        v148 = v148[p145[v150]]
        if v149 ~= nil then
            v149 = v149[1][p145[v150]]
        end
    end
    table.insert(v148, p146)
    local v151 = #v148
    if v149 ~= nil and v149[4] ~= nil then
        for _, v152 in ipairs(v149[4]) do
            v152(v151, p146)
        end
    end
    for _, v153 in ipairs(v147._raw_listeners) do
        v153("ArrayInsert", p145, p146, v151)
    end
    return v151
end
local function u165(p155, p156, p157, p158) --[[Anonymous function at line 623]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    local v159 = u21[p155]
    local v160 = v159.Data
    local v161 = v159._table_listeners
    for v162 = 1, #p156 do
        v160 = v160[p156[v162]]
        if v161 ~= nil then
            v161 = v161[1][p156[v162]]
        end
    end
    v160[p157] = p158
    if v161 ~= nil and v161[5] ~= nil then
        for _, v163 in ipairs(v161[5]) do
            v163(p157, p158)
        end
    end
    for _, v164 in ipairs(v159._raw_listeners) do
        v164("ArraySet", p156, p157, p158)
    end
end
local function u176(p166, p167, p168) --[[Anonymous function at line 650]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    local v169 = u21[p166]
    local v170 = v169.Data
    local v171 = v169._table_listeners
    for v172 = 1, #p167 do
        v170 = v170[p167[v172]]
        if v171 ~= nil then
            v171 = v171[1][p167[v172]]
        end
    end
    local v173 = table.remove(v170, p168)
    if v171 ~= nil and v171[6] ~= nil then
        for _, v174 in ipairs(v171[6]) do
            v174(p168, v173)
        end
    end
    for _, v175 in ipairs(v169._raw_listeners) do
        v175("ArrayRemove", p167, p168, v173)
    end
    return v173
end
u20 = {}
u20.__index = u20
function u20.ListenToChange(p177, p178, p179) --[[Anonymous function at line 686]]
    --[[
    Upvalues:
        [1] = u60
        [2] = u74
        [3] = u16
        [4] = u83
    --]]
    if type(p179) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToChange()")
    end
    if type(p178) == "string" then
        p178 = u60(p178) or p178
    end
    if #p178 < 1 then
        error("[ReplicaController]: Passed empty path - a value key must be specified")
    end
    local v180 = u74(p177, p178, 2)
    table.insert(v180, p179)
    return u16.NewArrayScriptConnection(v180, p179, u83, { p177._table_listeners, p178 })
end
function u20.ListenToNewKey(p181, p182, p183) --[[Anonymous function at line 702]]
    --[[
    Upvalues:
        [1] = u60
        [2] = u74
        [3] = u16
        [4] = u83
    --]]
    if type(p183) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToNewKey()")
    end
    if type(p182) == "string" then
        p182 = u60(p182) or p182
    end
    local v184 = u74(p181, p182, 3)
    table.insert(v184, p183)
    if #p182 == 0 then
        return u16.NewArrayScriptConnection(v184, p183)
    else
        return u16.NewArrayScriptConnection(v184, p183, u83, { p181._table_listeners, p182 })
    end
end
function u20.ListenToArrayInsert(p185, p186, p187) --[[Anonymous function at line 719]]
    --[[
    Upvalues:
        [1] = u60
        [2] = u74
        [3] = u16
        [4] = u83
    --]]
    if type(p187) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArrayInsert()")
    end
    if type(p186) == "string" then
        p186 = u60(p186) or p186
    end
    local v188 = u74(p185, p186, 4)
    table.insert(v188, p187)
    if #p186 == 0 then
        return u16.NewArrayScriptConnection(v188, p187)
    else
        return u16.NewArrayScriptConnection(v188, p187, u83, { p185._table_listeners, p186 })
    end
end
function u20.ListenToArraySet(p189, p190, p191) --[[Anonymous function at line 736]]
    --[[
    Upvalues:
        [1] = u60
        [2] = u74
        [3] = u16
        [4] = u83
    --]]
    if type(p191) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArraySet()")
    end
    if type(p190) == "string" then
        p190 = u60(p190) or p190
    end
    local v192 = u74(p189, p190, 5)
    table.insert(v192, p191)
    if #p190 == 0 then
        return u16.NewArrayScriptConnection(v192, p191)
    else
        return u16.NewArrayScriptConnection(v192, p191, u83, { p189._table_listeners, p190 })
    end
end
function u20.ListenToArrayRemove(p193, p194, p195) --[[Anonymous function at line 753]]
    --[[
    Upvalues:
        [1] = u60
        [2] = u74
        [3] = u16
        [4] = u83
    --]]
    if type(p195) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArrayRemove()")
    end
    if type(p194) == "string" then
        p194 = u60(p194) or p194
    end
    local v196 = u74(p193, p194, 6)
    table.insert(v196, p195)
    if #p194 == 0 then
        return u16.NewArrayScriptConnection(v196, p195)
    else
        return u16.NewArrayScriptConnection(v196, p195, u83, { p193._table_listeners, p194 })
    end
end
function u20.ListenToWrite(p197, p198, p199) --[[Anonymous function at line 770]]
    --[[
    Upvalues:
        [1] = u16
    --]]
    if type(p199) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToWrite()")
    end
    if p197._write_lib == nil then
        error("[ReplicaController]: _write_lib was not declared for this replica")
    end
    local v200 = p197._write_lib_dictionary[p198]
    if v200 == nil then
        error("[ReplicaController]: Write function \"" .. p198 .. "\" not declared inside _write_lib of this replica")
    end
    local v201 = p197._function_listeners[v200]
    if v201 == nil then
        v201 = {}
        p197._function_listeners[v200] = v201
    end
    table.insert(v201, p199)
    return u16.NewArrayScriptConnection(v201, p199)
end
function u20.ListenToRaw(p202, p203) --[[Anonymous function at line 794]]
    --[[
    Upvalues:
        [1] = u16
    --]]
    local v204 = p202._raw_listeners
    table.insert(v204, p203)
    return u16.NewArrayScriptConnection(v204, p203)
end
function u20.ConnectOnClientEvent(p205, p206) --[[Anonymous function at line 801]]
    --[[
    Upvalues:
        [1] = u16
    --]]
    if type(p206) ~= "function" then
        error("[ReplicaController]: Only functions can be passed to Replica:ConnectOnClientEvent()")
    end
    local v207 = p205._signal_listeners
    table.insert(v207, p206)
    return u16.NewArrayScriptConnection(p205._signal_listeners, p206)
end
function u20.FireServer(p208, ...) --[[Anonymous function at line 809]]
    --[[
    Upvalues:
        [1] = u32
    --]]
    u32:FireServer(p208.Id, ...)
end
function u20.ListenToChildAdded(p209, p210) --[[Anonymous function at line 814]]
    --[[
    Upvalues:
        [1] = u21
        [2] = u24
        [3] = u16
    --]]
    if type(p210) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener")
    end
    if u21[p209.Id] ~= nil then
        local v211 = u24[p209.Id]
        if v211 == nil then
            v211 = {}
            u24[p209.Id] = v211
        end
        table.insert(v211, p210)
        return u16.NewArrayScriptConnection(v211, p210)
    end
end
function u20.FindFirstChildOfClass(p212, p213) --[[Anonymous function at line 832]]
    for _, v214 in ipairs(p212.Children) do
        if v214.Class == p213 then
            return v214
        end
    end
    return nil
end
function u20.Identify(p215) --[[Anonymous function at line 842]]
    local v216 = ""
    for v217, v218 in pairs(p215.Tags) do
        v216 = v216 .. "" .. tostring(v217) .. "=" .. tostring(v218)
    end
    local v219 = p215.Id
    return "[Id:" .. tostring(v219) .. ";Class:" .. p215.Class .. ";Tags:{" .. v216 .. "}]"
end
function u20.IsActive(p220) --[[Anonymous function at line 853]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    return u21[p220.Id] ~= nil
end
function u20.AddCleanupTask(p221, p222) --[[Anonymous function at line 857]]
    return p221._maid:AddCleanupTask(p222)
end
function u20.RemoveCleanupTask(p223, p224) --[[Anonymous function at line 861]]
    p223._maid:RemoveCleanupTask(p224)
end
function u20.SetValue(p225, p226, p227) --[[Anonymous function at line 867]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u1
        [3] = u60
        [4] = u128
    --]]
    if u38 == false then
        error(u1.SetterError)
    end
    if type(p226) == "string" then
        p226 = u60(p226) or p226
    end
    u128(p225.Id, p226, p227)
end
function u20.SetValues(p228, p229, p230) --[[Anonymous function at line 875]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u1
        [3] = u60
        [4] = u143
    --]]
    if u38 == false then
        error(u1.SetterError)
    end
    if type(p229) == "string" then
        p229 = u60(p229) or p229
    end
    u143(p228.Id, p229, p230)
end
function u20.ArrayInsert(p231, p232, p233) --[[Anonymous function at line 883]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u1
        [3] = u60
        [4] = u154
    --]]
    if u38 == false then
        error(u1.SetterError)
    end
    if type(p232) == "string" then
        p232 = u60(p232) or p232
    end
    return u154(p231.Id, p232, p233)
end
function u20.ArraySet(p234, p235, p236, p237) --[[Anonymous function at line 891]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u1
        [3] = u60
        [4] = u165
    --]]
    if u38 == false then
        error(u1.SetterError)
    end
    if type(p235) == "string" then
        p235 = u60(p235) or p235
    end
    u165(p234.Id, p235, p236, p237)
end
function u20.ArrayRemove(p238, p239, p240) --[[Anonymous function at line 899]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u1
        [3] = u60
        [4] = u176
    --]]
    if u38 == false then
        error(u1.SetterError)
    end
    if type(p239) == "string" then
        p239 = u60(p239) or p239
    end
    return u176(p238.Id, p239, p240)
end
function u20.Write(p241, p242, ...) --[[Anonymous function at line 907]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u1
    --]]
    if u38 == false then
        error(u1.SetterError)
    end
    local v243 = p241._write_lib_dictionary[p242]
    local v244 = table.pack(p241._write_lib[v243](p241, ...))
    local v245 = p241._function_listeners[v243]
    if v245 ~= nil then
        for _, v246 in ipairs(v245) do
            v246(...)
        end
    end
    return table.unpack(v244)
end
function u18.RequestData() --[[Anonymous function at line 925]]
    --[[
    Upvalues:
        [1] = u36
        [2] = u25
        [3] = u1
        [4] = u18
    --]]
    if u36 ~= true then
        u36 = true
        task.spawn(function() --[[Anonymous function at line 930]]
            --[[
            Upvalues:
                [1] = u25
                [2] = u1
                [3] = u18
            --]]
            while game:IsLoaded() == false do
                task.wait()
            end
            u25:FireServer()
            while task.wait(u1.RequestDataRepeat) and u18.InitialDataReceived ~= true do
                u25:FireServer()
            end
        end)
    end
end
function u18.ReplicaOfClassCreated(u247, p248) --[[Anonymous function at line 944]]
    --[[
    Upvalues:
        [1] = u23
        [2] = u16
    --]]
    if type(u247) ~= "string" then
        error("[ReplicaController]: replica_class must be a string")
    end
    if type(p248) ~= "function" then
        error("[ReplicaController]: Only a function can be set as listener in ReplicaController.ReplicaOfClassCreated()")
    end
    local u249 = u23[u247]
    if u249 == nil then
        u249 = u16.NewScriptSignal()
        u23[u247] = u249
    end
    return u249:Connect(p248, function() --[[Anonymous function at line 957]]
        --[[
        Upvalues:
            [1] = u249
            [2] = u23
            [3] = u247
        --]]
        if u249:GetListenerCount() == 0 and u23[u247] == u249 then
            u23[u247] = nil
        end
    end)
end
function u18.GetReplicaById(p250) --[[Anonymous function at line 965]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    return u21[p250]
end
u25.OnClientEvent:Connect(function() --[[Anonymous function at line 972]]
    --[[
    Upvalues:
        [1] = u18
    --]]
    u18.InitialDataReceived = true
    u18.InitialDataReceivedSignal:Fire()
end)
v26.OnClientEvent:Connect(u128)
v27.OnClientEvent:Connect(u143)
v28.OnClientEvent:Connect(u154)
v29.OnClientEvent:Connect(u165)
v30.OnClientEvent:Connect(u176)
v31.OnClientEvent:Connect(function(p251, p252, ...) --[[Anonymous function at line 989]]
    --[[
    Upvalues:
        [1] = u21
        [2] = u38
    --]]
    local v253 = u21[p251]
    u38 = true
    v253._write_lib[p252](v253, ...)
    u38 = false
    local v254 = v253._function_listeners[p252]
    if v254 ~= nil then
        for _, v255 in ipairs(v254) do
            v255(...)
        end
    end
end)
u32.OnClientEvent:Connect(function(p256, ...) --[[Anonymous function at line 1005]]
    --[[
    Upvalues:
        [1] = u21
    --]]
    local v257 = u21[p256]._signal_listeners
    for _, v258 in ipairs(v257) do
        v258(...)
    end
end)
v33.OnClientEvent:Connect(function(p259, p260) --[[Anonymous function at line 1015]]
    --[[
    Upvalues:
        [1] = u21
        [2] = u24
    --]]
    local v261 = u21[p259]
    local v262 = v261.Parent.Children
    local v263 = u21[p260]
    table.remove(v262, table.find(v262, v261))
    local v264 = v263.Children
    table.insert(v264, v261)
    v261.Parent = v263
    local v265 = u24[p260]
    if v265 ~= nil then
        for v266 = 1, #v265 do
            v265[v266](v261)
        end
    end
end)
v34.OnClientEvent:Connect(function(p267, p268) --[[Anonymous function at line 1032]]
    --[[
    Upvalues:
        [1] = u114
        [2] = u24
        [3] = u22
        [4] = u23
    --]]
    local v269 = {}
    if type(p267) == "table" then
        table.sort(p267, function(p270, p271) --[[Anonymous function at line 1046]]
            return p270[1] < p271[1]
        end)
        for _, v272 in ipairs(p267) do
            u114(v272[2], v269)
        end
    elseif p268[1] == nil then
        u114(p268, v269)
    else
        u114({
            [tostring(p267)] = p268
        }, v269)
    end
    table.sort(v269, function(p273, p274) --[[Anonymous function at line 1058]]
        return p273.Id < p274.Id
    end)
    for _, v275 in ipairs(v269) do
        local v276 = v275.Parent
        if v276 ~= nil then
            local v277 = u24[v276.Id]
            if v277 ~= nil then
                for v278 = 1, #v277 do
                    v277[v278](v275)
                end
            end
        end
    end
    for _, v279 in ipairs(v269) do
        u22:Fire(v279)
        local v280 = u23[v279.Class]
        if v280 ~= nil then
            v280:Fire(v279)
        end
    end
end)
v35.OnClientEvent:Connect(function(p281) --[[Anonymous function at line 1084]]
    --[[
    Upvalues:
        [1] = u21
        [2] = u66
    --]]
    u66(u21[p281])
end)
return u18
