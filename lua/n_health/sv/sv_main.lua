util.AddNetworkString( "n_health_networking" )


hook.Add("PlayerInitialSpawn","n_health_initial",function(ply)

    ply.n_health = {}
    for k,v in pairs(n_health.limbs) do
        ply.n_health[v] = {}
    end

end)

// function to update client and give him the required information
function n_health:UpdateClient(ply,type,...)
    local args = {...}
    // copying over the table cuz we dont want the health to be there
    local tbl = table.Copy(ply.n_health)
    if type == "damage" then
        tbl.damage = args[1] or 0
    end
    tbl.health = ply:Health()
    net.Start("n_health_networking")
        net.WriteTable(tbl)
    net.Send(ply)

end

// realistic fall damage, can be disabled in config
hook.Add( "GetFallDamage", "n_health_realisticfalldamage", function( ply, speed )
    if n_health.config.realisticfalldamage then
        return ( speed / 8 )
    end
end )


// executed when client joins and loads...
net.Receive("n_health_networking", function(len,ply)

    local id = net.ReadInt(4)
    // client loaded
    if id == 1 then
        n_health:UpdateClient(ply)
    end
end)


// hook to detect damage
hook.Add("EntityTakeDamage","n_health",function(target, dmg)
    // have to check if it's a player or a npc, cuz' entitytakedamage will also trigger for every entity
    if not target:IsPlayer() then return end

    n_health:HandleDamage(target,dmg,target:LastHitGroup())
    // return true to prevent from taking damage
    return true
end)

function n_health:HandleDamage(target,dmg,hitgroup)
    // just to be sure that we're dealing with player or npc (bot)
    if not target:IsPlayer() then return end

    // scaling damage with respect to config file
    for k,v in pairs(n_health.config.damageTypeScale) do
        if bit.band(dmg:GetDamageType(),k) then
            local damage = dmg:GetDamage()
            dmg:ScaleDamage(v)
            print("scaled damage of type "..k.. " by a value of "..v.." (from "..damage.." to "..dmg:GetDamage()..")")
        end
    end
    

    // if hitgroup is passed then we know that we're dealing with ScalePlayerDamage, and that it's a bullet damage
    if hitgroup then
        // if the hitgroup is generic then we might be dealing with npc dmg eg. combine soldier
        if hitgroup == HITGROUP_GENERIC then
            // if the attacker is a npc then randomize the hitpos
            local attacker = dmg:GetAttacker()
            if attacker:IsNPC() or attacker:IsNextBot() then
                target:Damage(dmg:GetDamage())
            end
            // check for fall damage
            if dmg:IsDamageType(DMG_FALL) then
                target:Damage(dmg:GetDamage(),"rightleg")
                target:Damage(dmg:GetDamage(),"leftleg")
            end
        // hit head, get the weapon type - blunt, sharp, bullet(if bullet then get the damage that it inflicted,
        // to calculate the possibilty of bleeding, fracture or concussion)
        elseif hitgroup == HITGROUP_HEAD then
            
        end
    end

end