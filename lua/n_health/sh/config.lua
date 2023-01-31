n_health.config = {}
local c = n_health.config
c.limbs = {
    // this will be a multiplier for each body part's health (eg. Player:SetHealth(100), will set head's hp to 35hp, and torso's hp to 95hp )
    multipliers = {
        ["head"] = 0.35,
        ["torso"] = 0.95,
        ["leftarm"] = 0.55,
        ["rightarm"] = 0.55,
        ["leftleg"] = 0.65,
        ["rightleg"] = 0.65,
    },
}

// this enables realistic fall damage (damage = (speed/8))
// you can disable this if you're using custom one
n_health.config.realisticfalldamage = true

// this will scale provided damage types
// be careful! if weapon has more than 1 damage type it will scale for every one! (or I think it will... TODO: check <<)
c.damageTypeScale = {
    [DMG_FALL] = 0.5,
}
