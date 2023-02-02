n_health = n_health or {}

if SERVER or game.SinglePlayer() then
    print("Loading n_health...")
    
    // shared


    include("n_health/sh/sh_main.lua")
    AddCSLuaFile("n_health/sh/sh_main.lua")
    include("n_health/sh/config.lua")
    AddCSLuaFile("n_health/sh/config.lua")

    // client
    AddCSLuaFile("n_health/cl/cl_defaultconfig.lua")
    AddCSLuaFile("n_health/cl/cl_main.lua")
    AddCSLuaFile("n_health/cl/cl_guipanels.lua")
    AddCSLuaFile("n_health/cl/cl_gui.lua")

    // server
    include("n_health/sv/sv_player.lua")
    include("n_health/sv/sv_main.lua")
    
else

    print("Loading n_health...")
    include("n_health/sh/config.lua")
    include("n_health/sh/sh_main.lua")
    include("n_health/cl/cl_defaultconfig.lua")
    include("n_health/cl/cl_main.lua")
    include("n_health/cl/cl_guipanels.lua")
    include("n_health/cl/cl_gui.lua")

end

// language
for _, v in pairs(file.Find("n_health/lang/*", "LUA")) do
	include("n_health/lang/" .. v)
	if SERVER then AddCSLuaFile("n_health/lang/" .. v) end
end

