util.AddNetworkString( "n_health_networking" )


hook.Add("PlayerInitialSpawn","n_health_initial",function(ply)

    ply.n_health = {}
    for k,v in pairs(n_health.limbs) do
        ply.n_health[v] = {}
    end

end)

// function to update client and give him the required information
local buffer = {}
function n_health:UpdateClient(ply,type,...)
    local args = {...}
    local updateData = table.Copy(ply.n_health)

    // copying over the table cuz we dont want the health to be there
    if type == "damage" then
        updateData.damage = args[1] or 0
    end
    updateData.health = ply:Health()
    buffer[ply] = {
        data = updateData,
        time = (buffer[ply] and buffer[ply].time or CurTime()+(0.015*n_health.config.clientUpdate)),
    }
end

timer.Create("n_health_UpdateClientBuffer",0.01,0,function()
    for k,v in pairs(buffer) do
        if v.time < CurTime() then
            if IsValid(k) then  // if player leaves server
                net.Start("n_health_networking")
                    net.WriteTable(v.data)
                net.Send(k)
            end
            buffer[k] = nil
        end
    end
end)



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

//  n_health:chanceTrauma(table types(bleeding = chance,fracture))
function n_health:chanceTrauma(ply,types)

end

// hook to detect damage
hook.Add("EntityTakeDamage","n_health",function(target, dmg)
    // have to check if it's a player or a npc, cuz' entitytakedamage will also trigger for every entity
    if not target:IsPlayer() then return end
    if target:HasGodMode() then return end

    return n_health:HandleDamage(target,dmg,target:LastHitGroup())
    // return true to prevent from taking damage
end)

function n_health:HandleDamage(target,dmg,hitgroup)
    // just to be sure that we're dealing with player or npc (bot)
    PrintTable(target.n_health)
    if not target:IsPlayer() then return end
    local bool = true
    // scaling damage with respect to config file
    for k,v in pairs(n_health.config.damageTypeScale) do
        if bit.band(dmg:GetDamageType(),k) == k then
            local damage = dmg:GetDamage()
            dmg:ScaleDamage(v)
            print("scaled damage of type "..k.. " by a value of "..v.." (from "..damage.." to "..dmg:GetDamage()..")")
        end
    end
    
    local hitgroups = {
        [HITGROUP_HEAD] = {limb = "head",func = function() end},
        [HITGROUP_CHEST] = {limb = "chest",func = function() end},
        [HITGROUP_STOMACH] = {limb = "stomach",func = function() end},
        [HITGROUP_LEFTARM] = {limb = "leftarm",func = function() end},
        [HITGROUP_RIGHTARM] = {limb = "rightarm",func = function() end},
        [HITGROUP_LEFTLEG] = {limb = "leftleg",func = function() end},
        [HITGROUP_RIGHTLEG] = {limb = "rightleg",func = function() end},
    }
    print("damageType: "..math.IntToBin(dmg:GetDamageType())..": "..dmg:GetDamageType())
    print("hitgroup: "..hitgroup)
    print("damage: "..dmg:GetDamage())
    if hitgroup then
        // if the hitgroup is generic then we might be dealing with npc dmg eg. combine soldier
        if hitgroup == HITGROUP_GENERIC then
            // check for fall damage
            if dmg:IsDamageType(DMG_FALL) then
                target:Damage(dmg:GetDamage(),"rightleg")
                target:Damage(dmg:GetDamage(),"leftleg")
            else
                target:Damage(dmg:GetDamage())
            end
            

        else
            // get the weapon type - blunt, sharp, bullet(if bullet then get the damage that it inflicted,
            // to calculate the possibilty of bleeding, fracture or concussion)
            if hitgroups[hitgroup] then
                local _hitgroup = hitgroups[hitgroup]
                _hitgroup.func(target,damage)
                
                target:Damage(dmg:GetDamage(),_hitgroup.limb)
            end
        end
    end

    // check for damage of head and chest and if one of them is 0 then kill player
    local limbs = {"head","chest"}
    for k,v in pairs(limbs) do
        if target.n_health[v].health <= 0 then
            target:SetHealth(0)
            bool = false
        end
    end

    // set targets LastHitGroup to generic to fix some things eg. damage that should be dealt globally is dealt to last hit body part
    target:SetLastHitGroup(HITGROUP_GENERIC)
    return bool

end


// PlaverDeathThink, to prevent player from respawning
hook.Add("PlayerDeath","n_health_playerdeath",function(ply)
    if ply.n_health then
        ply.n_health.deathTime = CurTime()
    end
end)
local debugT = CurTime()
hook.Add("PlayerDeathThink","n_health_playerdeaththink",function(ply)
    if not ply.n_health then return true end
    if ply.n_health.deathTime then
        if ply.n_health.deathTime + n_health.config.respawnTimer  <= CurTime() then
            return 
        end
    end
    return false
end)

