// initialize n_health table to be used later and setup limbs
// HAVE TO MOVE THIS TO CHECK BEFORE ANY COMMAND EXECUTION DUE TO THE LOCALPLAYER LOADING DELAY
--[[LocalPlayer().n_health = {}
for k,v in pairs(n_health.limbs) do
    LocalPlayer().n_health[v] = {}
end
]]--

hook.Add( "InitPostEntity", "n_health_clientready", function()
	net.Start( "n_health_networking" )
        net.WriteInt(1,4)
	net.SendToServer()
end )





// networking for syncing
net.Receive("n_health_networking",function()
    if not IsValid(LocalPlayer()) then return end

    local tbl = net.ReadTable()
    LocalPlayer().n_health = tbl
    LocalPlayer():SetHealth(tbl.health or LocalPlayer():Health())

end)