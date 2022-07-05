if SERVER then
    PerformanceFix = {}
    PerformanceFix.Path = table.pack(...)[1]

    if not File.Exists(PerformanceFix.Path .. "/config.json") then
        File.Write(PerformanceFix.Path .. "/config.json", json.serialize(dofile(PerformanceFix.Path .. "/Lua/defaultconfig.lua")))
    end

    PerformanceFix.Config = json.parse(File.Read(PerformanceFix.Path .. "/config.json"))

    dofile(PerformanceFix.Path .. "/Lua/performancefix.lua")
end
