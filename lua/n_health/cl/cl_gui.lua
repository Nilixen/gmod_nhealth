// Draw health, will disappear after time set in the config

local x,y = 30,10
local scale = 0.40
local w,h = 183,532
w = w * scale
h = h * scale

local lerp = 0
hook.Add( "HUDPaintBackground", "n_healthHUD", function()
    if n_health and LocalPlayer().n_health then
        lerp = math.Clamp(Lerp(15*FrameTime(),lerp,(LocalPlayer().n_health.drawTime >= CurTime() and 1.1 or 0.2)),0,1)
        for k,v in pairs(n_health.limbs) do
            local mat = Material("nhealth/"..v..".png")
            local color = HSVToColor((LocalPlayer().n_health[v].health/n_health.config.limbs.multipliers[v]),0.8,0.5)
            color.a = lerp*230
            surface.SetMaterial(mat)
            surface.SetDrawColor(color)
            surface.DrawTexturedRect(x,y,w,h)
        end
        
    end

end )


// to not make a mess with gui's
n_health.cl_config.gui = n_health.cl_config.gui or {}

function n_health:OpenClientGUI()
    // if the frame already exists then remove it to prevent multiple instances of frame (also useful for debugging)
    if IsValid(n_health.cl_config.gui.frame) then n_health.cl_config.gui.frame:Remove() end
	
    n_health.cl_config.gui.frame = vgui.Create("n_health.frame")
    local frame = n_health.cl_config.gui.frame
    frame:SetSize(600,800)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(n_health:GetPhrase("guiFrame"))

    n_health.cl_config.gui.configPanel = vgui.Create("n_health.configPanel",frame)
    local configPanel = n_health.cl_config.gui.configPanel
    configPanel:Dock(FILL)
    
  

    // TODO continue

end