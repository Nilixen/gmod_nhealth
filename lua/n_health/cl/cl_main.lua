
// setup and load client config if exists, if not then create one
local dir = n_health.config.directory
file.CreateDir(dir)
if !file.Exists(dir.."/cl_config.txt", "DATA") then
    file.Write(dir.."/cl_config.txt",util.TableToJSON(n_health.cl_config))
else
    local newConfig = util.JSONToTable(file.Read(dir.."/cl_config.txt","DATA"))
    for k,v in pairs(n_health.cl_config) do
        if not newConfig[k] then
            newConfig[k] = v
        end
    end
    n_health.cl_config = newConfig
end


hook.Add( "InitPostEntity", "n_health_clientready", function()
	net.Start( "n_health_networking" )
        net.WriteInt(1,4)
	net.SendToServer()
end )

// concommand for opening the gui
concommand.Add("n_health_gui",function()

    n_health:OpenClientGUI()

end)



// networking for syncing
net.Receive("n_health_networking",function()
    if not IsValid(LocalPlayer()) then return end
    local tbl = net.ReadTable()
    LocalPlayer().n_health = tbl
    LocalPlayer().n_health.drawTime = CurTime() + n_health.cl_config.clientHUDDrawTime

end)