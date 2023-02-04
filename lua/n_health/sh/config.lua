n_health.config = {}
local c = n_health.config

c.version = "version: Alpha-0.1"

c.limbs = {
    // this will be a multiplier for each body part's health (eg. Player:SetHealth(100), will set head's hp to 35hp, and chest's hp to 95hp )
    multipliers = {
        ["head"] = 0.35,
        ["chest"] = 0.95,
        ["stomach"] = 0.75,
        ["leftarm"] = 0.55,
        ["rightarm"] = 0.55,
        ["leftleg"] = 0.65,
        ["rightleg"] = 0.65,
    },
}

// sets the directory name for client settings and others
c.directory = "n_health"


// this enables realistic fall damage (damage = (speed/8))
// you can disable this if you're using custom one
n_health.config.realisticfalldamage = true

// this will scale provided damage types
// be careful! if weapon has more than 1 damage type it will scale for every one! (or I think it will... TODO: check <<)
c.damageTypeScale = {
    [DMG_CRUSH] = 0,
    [DMG_FALL] = 1,
    [DMG_BURN] = 2,
}
// after what time(seconds) player will be able to respawn
n_health.config.respawnTimer = 0

// after how many ticks will the buffer for syncing data with clientside trigger
c.clientUpdate = 4

c.serverLanguage = "EN-en"
// font used by gui's
c.font = "Tahoma"