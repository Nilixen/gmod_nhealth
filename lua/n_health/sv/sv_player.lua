local entityMeta = FindMetaTable("Entity")


local oldSetHealth = oldSetHealth or entityMeta.SetHealth
function entityMeta:SetHealth(health,bool)
    if self:IsPlayer() then
        if not bool then
            n_health:SetPlayerHealth(self,health)
        else
            n_health:UpdateClient(self,"health")
        end
    end
    oldSetHealth(self,health)
end


// n_health:SetHealth()
function n_health:SetPlayerHealth(target,health,limb)
    // check if it is actually player(have to be) and if alive
    if not target:IsPlayer() then return end
    if not target:Alive() then return end
    
    local limbs = n_health.limbs
    if IsValid(limb) then
        
        if table.HasValue(limbs,limb) then
            local _limb = target.n_health[limb]
            _limb.health = health * (_limb.multiplier or n_health.config.limbs.multipliers[limb])
        end
    else
        for k,v in pairs(limbs) do
            local _limb = target.n_health[v]
            _limb.health = health * (_limb.multiplier or n_health.config.limbs.multipliers[v])
        end
    end

    n_health:UpdateClient(target,"health")

end


local playerMeta = FindMetaTable("Player")

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
// Player:Damage(damage,type,limb)
// this will damage selected limb
function playerMeta:Damage(damage,limb)
    if not damage then return false end
    
    // if limb is passed with a function
    if limb then 
        local _limb = self.n_health[limb]
        local dmg = _limb.health - damage
        _limb.health = math.max(dmg,0)
        // if damage is more than a body part can withstand it will split the rest of the damage to the whole body
        if dmg < 0 then
            dmg = math.abs(dmg)
            self:Damage(dmg)
        end
    // if limb is not passed split the damage to all viable body parts that have more than x health
    else

        // i know that some damage will be lost, but i have to do it this way or it will crash gmod XD
        local avaibleLimbs = table.Copy(n_health.limbs) // copy the table to be able to work on it without messing every other thing up

        // first for loop is for determining the avaible body parts that the damage can be split to
        for k,v in pairs(avaibleLimbs) do
            _limb = self.n_health[v]
            if _limb.health <= 0 then
                avaibleLimbs[k] = nil
            end
        end

        local dmg = (damage)/table.Count(avaibleLimbs)  // split damage
        for k,v in pairs(avaibleLimbs) do
            local _limb = self.n_health[v]
            _limb.health = math.max(0,(_limb.health - dmg))
        end

    end

    self:SetHealth(self:Health(),true)
    n_health:UpdateClient(self,"damage",damage)

end


// Player:Health(detailed)
// this will return a health based on health of limbs(usefull for huds or any other things), detailed will return 
// whole health tab to further investigate
local lastTimeCached = {}
function playerMeta:Health(detailed)

    // check if it is actually player(have to be) and if alive
    if not self:IsPlayer() then return end
    if not self:Alive() then return 0 end

    if not detailed then

        // if cached exists then return that to prevent excesive calcuations
        lastTimeCached[self] = lastTimeCached[self] and lastTimeCached[self] or 0

        if (self.n_health.cachedHealth and lastTimeCached[self] >= CurTime()) then
            return self.n_health.cachedHealth
        end
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
        local newHealth = (currentLimbsHealth/maxLimbsHealth*100)
        self.n_health.cachedHealth = newHealth
        lastTimeCached[self] = CurTime()+0.015
        return newHealth
    else
        // return all in a table
        return self.n_health
    end

end
