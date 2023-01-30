util.AddNetworkString( "n_health_networking" )


hook.Add("PlayerInitialSpawn","n_health_initial",function(ply)

    ply.n_health = {}
    for k,v in pairs(n_health.limbs) do
        ply.n_health[v] = {}
    end

end)

// function to update client and give him the required information
function n_health:UpdateClient(ply,type)
    // copying over the table cuz we dont want the health to be there
    local tbl = table.Copy(ply.n_health)
    if type == "health" then
        tbl.health = ply:Health()
    end
    net.Start("n_health_networking")
        net.WriteTable(tbl)
    net.Send(ply)

end

// executed when client joins and loads...
net.Receive("n_health_networking", function(len,ply)

    local id = net.ReadInt(4)
    // client loaded
    if id == 1 then
        n_health:UpdateClient(ply)
    end
end)


// hook to detect bullet damage, forward to another function
hook.Add("ScalePlayerDamage","n_health",function(ply, hitgroup, dmginfo)
    
    print("bullet "..hitgroup)
    return true
end)

// hook to detect other damage
hook.Add("EntityTakeDamage","n_health",function(target, dmg)
    if not target:IsPlayer() or target:IsNPC() then return end

    // may not be the cleanest but this is how it'll be
        // TODO
    print(dmg:GetDamageType())
    local damageTypeBan = {""}
    // not detecting bullet damage due to the fact that i dont know the hit groupt that's why I have another hook ^
    if table.HasValue()  then return end

    print("other")
    return true

    
    
end)
