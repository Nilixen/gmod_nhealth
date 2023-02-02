local guiColors = {
    boxes = {
        blended = Color(0,0,0,70),
        primary = Color(53,55,55),
        red = Color(200,50,50),
    },
    text = {
        primary = Color(201,201,201),
    },
}


// frame

local FRAME = {}
n_health:CreateFont("20",20)
n_health:CreateFont("20Heavy",20,1500)

function FRAME:Init()

	// header
	self.header = self:Add("Panel")
	local header = self.header
    header:Dock(TOP)
    header.Paint = function (panel,w,h)
        draw.RoundedBoxEx(6,0,0,w,h,guiColors.boxes.primary,true,true,false,false)
		draw.RoundedBox(0,0,h-3,w,3,guiColors.boxes.blended)
    end

	// close button
	self.header.closeBtn = self.header:Add("DButton")
	local closeBtn = self.header.closeBtn
	closeBtn:DockMargin(2,2,2,6)
	closeBtn:Dock(RIGHT)
	closeBtn.DoClick = function(s)
		self:Remove()
	end
	closeBtn:SetText("")
	closeBtn.fill = 0
	closeBtn.tempo = 5
	closeBtn.posx,closeBtn.posy = 0,0
	closeBtn.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,guiColors.boxes.red)
		draw.SimpleText(n_health:GetPhrase("close"),"n_health.20Heavy",w/2,h/2,guiColors.text.primary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		if s:IsHovered() then
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,1.1)
			s.posx,s.posy = s:CursorPos()
		else
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,0)
		end
		draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,guiColors.boxes.blended)
	end

	// title
	self.header.title = self.header:Add("DLabel")
	local label = self.header.title
	label:DockMargin(2,0,0,6)
	label:Dock(LEFT)
	label:SetFont("n_health.20")
	label:SetTextColor(guiColors.text.primary)

end
function FRAME:PerformLayout(w,h)

	self.header:SetTall(28)
    self.header.title:SizeToContentsX(8)

end
function FRAME:SetTitle(title)

	local label = self.header.title
	if IsValid(label) then
		label:SetText(title or "Nil")
	end

	self:InvalidateLayout()

end



vgui.Register("n_health.frame",FRAME,"EditablePanel")