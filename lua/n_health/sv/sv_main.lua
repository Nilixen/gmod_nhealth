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
hook.Add("ScalePlayerDamage","n_health",function(ply, hitgroup, dmg)
    
    n_health:HandleDamage(ply,dmg,hitgroup)

    // return true to prevent from taking damage
    return true
end)

// hook to detect other damage
hook.Add("EntityTakeDamage","n_health",function(target, dmg)
    // have to check if it's a player or a npc, cuz' entitytakedamage will also trigger for every entity
    if not target:IsPlayer() or target:IsNPC() then return end

    n_health:HandleDamage(target,dmg)
    // return true to prevent from taking damage
    return true
end)

function n_health:HandleDamage(target,dmg,hitgroup)
    // just to be sure that we're dealing with player or npc (bot)
    if not target:IsPlayer() or target:IsNPC() then return end

    // if hitgroup is passed then we know that we're dealing with ScalePlayerDamage, and that it's a bullet damage
    if hitgroup then
        // if the hitgroup is generic then we might be dealing with npc dmg eg. combine soldier
        if hitgroup == HITGROUP_GENERIC then
            // if the attacker is a npc then randomize the hitpos
            local attacker = dmg:GetAttacker()
            if attacker:IsNPC() or attacker:IsNextBot() then
                // TODO: ^
            end
        // hit head, get the weapon type - blunt, sharp, bullet(if bullet then get the damage that it inflicted,
        // to calculate the possibilty of bleeding, fracture or concussion)
        elseif hitgroup == HITGROUP_HEAD then
            
        end
    else    
        // TODO: check if damagetypes are not the same, not wanna multiply the damage

        print("other: "..dmg:GetDamageType())

    end

end