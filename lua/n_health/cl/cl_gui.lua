// Draw health

local x,y = 30,10
local scale = 0.40
local w,h = 183,532
w = w * scale
h = h * scale

hook.Add( "HUDPaintBackground", "n_healthHUD", function()
    if n_health and LocalPlayer().n_health then
        for k,v in pairs(n_health.limbs) do
            local mat = Material("nhealth/"..v..".png")
            local color = HSVToColor((LocalPlayer().n_health[v].health/n_health.config.limbs.multipliers[v]),0.8,0.5)
            surface.SetMaterial(mat)
            surface.SetDrawColor(color)
            surface.DrawTexturedRect(x,y,w,h)
        end
    end

end )