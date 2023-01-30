n_health = n_health or {}

if SERVER or game.SinglePlayer() then
    print("Loading n_health...")
    
    // shared


    include("n_health/sh/sh_main.lua")
    AddCSLuaFile("n_health/sh/sh_main.lua")
    include("n_health/sh/config.lua")
    AddCSLuaFile("n_health/sh/config.lua")

    // client
    AddCSLuaFile("n_health/cl/cl_main.lua")

    // server
    include("n_health/sv/sv_player.lua")
    include("n_health/sv/sv_main.lua")
    
else

    print("Loading n_health...")
    include("n_health/sh/config.lua")
    include("n_health/sh/sh_main.lua")
    include("n_health/cl/cl_main.lua")

end