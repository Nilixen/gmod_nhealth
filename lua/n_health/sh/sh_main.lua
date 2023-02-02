n_health.lang = {}

n_health.limbs = {"head","chest","stomach","leftarm","rightarm","leftleg","rightleg"}

// damage types for ScalePlayerDamage 
// bleeding, fracture, concussion, burn

// n_health:GetPhrase(name,...) will return a formated string
function n_health:GetPhrase(name,...) 
	if CLIENT then
		if n_health.lang[n_health.cl_config.selectedLanguage or "EN-en"][name] then
    		return string.format(n_health.lang[n_health.cl_config.selectedLanguage or "EN-en"][name],...) 
		else
			return name
		end
	else
		if n_health.lang[n_health.config.serverLanguage or "EN-en"][name] then
			return string.format(n_health.lang[n_health.config.serverLanguage or "EN-en"][name],...) 
		else
			return name
		end
	end
end