// Draw health
hook.Add( "HUDPaintBackground", "n_healthHUD", function()
    local w,h = 183,532
	// head
    local headMat = Material("nhealth/head.png")
    surface.SetMaterial(headMat)
    surface.DrawTexturedRect(50,50,w,h)

end )