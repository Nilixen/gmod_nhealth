local playerMeta = FindMetaTable("Player")

// Player:SetHealth() do not mix up with Entity:SetHealth(), this one is custom made
function playerMeta:SetHealth(health,limb)
    // check if it is actually player(have to be) and if alive
    if not self:IsPlayer() then return end
    if not self:Alive() then return end
    
    local limbs = n_health.limbs
    if IsValid(limb) then
        
        if table.HasValue(limbs,limb) then
            local _limb = self.n_health[limb]
            _limb.health = health * (_limb.multiplier or n_health.config.limbs.multipliers[limb])
        end
    else
        for k,v in pairs(limbs) do
            local _limb = self.n_health[v]
            _limb.health = health * (_limb.multiplier or n_health.config.limbs.multipliers[v])
        end
    end

    n_health:UpdateClient(self,"health")

end

// Player:Heal(limb<"head","torso","leftarm","rightarm","leftleg","rightleg">)
// this will only heal fractures, concussion and bleeding
function playerMeta:Heal(limb)
    if not self:IsPlayer() then return end
    if not self:Alive() then return end

    // if you're trying to heal selected limb and if it exists then go ahead
    local limbs = n_health.limbs
    if IsValid(limb) then
        if table.HasValue(limbs,limb) then
            local _limb = self.n_health[limb]
            _limb.bleeding = false
            _limb.fracture = false 
        end
    else
        for k,v in pairs(limbs) do
            local _limb = self.n_health[v]
            _limb.bleeding = false
            _limb.fracture = false
        end
    end

    n_health:UpdateClient(self,"heal")

end

// Player:SetHealthMultiplier(int Multiplier)
// this will multiply the config's one to achieve desired output
function playerMeta:SetHealthMultiplier(multiplier, limb)
    if not self:IsPlayer() then return end
    if not self:Alive() then return end

    // make sure multiplier is a possitive value
    multiplier = math.abs(multiplier)

    // if only one limb is specified go through that

    if IsValid(limb) then
        local _limb = self.n_health[limb]
        _limb.multiplier = n_health.config.limbs.multipliers[limb] * multiplier
    else
        // go through each limb and set a correct multiplier
        local limbs = n_health.limbs
        for k,v in pairs(limbs) do
            local _limb = self.n_health[v]
            _limb.multiplier = n_health.config.limbs.multipliers[v] * multiplier
        end
    end

    n_health:UpdateClient(self,"multiplier")

end


// Player:Health(detailed)
// this will return a health based on health of limbs(usefull for huds or any other things), detailed will return 
// whole health tab to further investigate
function playerMeta:Health(detailed)

    // check if it is actually player(have to be) and if alive
    if not self:IsPlayer() then return end
    if not self:Alive() then return 0 end
    
    if not detailed then
        //  return overall percentage of health based on total limbs health
        local limbs = n_health.limbs
        local maxLimbsHealth = 0
        local currentLimbsHealth = 0
        
        // find total limbs max health to calculate percentage 0-100%
        for k,v in pairs(limbs) do
            local _limb = self.n_health[v]
            maxLimbsHealth = maxLimbsHealth + 100 * (_limb.multiplier or n_health.config.limbs.multipliers[v])
        end
        
        // find total current health
        for k,v in pairs(limbs) do
            local _limb = self.n_health[v]
            currentLimbsHealth = currentLimbsHealth + _limb.health
        end

        return (currentLimbsHealth/maxLimbsHealth*100)
    else
        // return all in a table
        return self.n_health
    end

end
