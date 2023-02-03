local guiColors = {
    boxes = {
        blended = Color(0,0,0,70),
        primary = Color(53,55,55),
		secondary = Color(43,43,43),
		tertiary = Color(33,33,33),
        blue = Color(50,50,200),
        green = Color(50,100,50),
        red = Color(200,50,50),
    },
    text = {
        primary = Color(201,201,201),
        secondary = Color(144,144,144),
		hovered = Color(100,100,100),

    },
}

// configlabel
local CONFIGLABEL = {}
function CONFIGLABEL:Init()
	self:Dock(TOP)
	self:DockMargin(8,8,8,4)
	self:SetFont("n_health.20")
	self:SetTextColor(guiColors.text.secondary)
end
function CONFIGLABEL:Paint(w,h)

end

vgui.Register("n_health.configLabel",CONFIGLABEL,"DLabel")
// combobox
local COMBOBOX = {}
n_health:CreateFont("15",15)

function COMBOBOX:Init()
	self:SetTextColor(guiColors.text.tertiary)
	self.Paint = function(s,w,h)
		local bool = not s:IsMenuOpen()
		draw.RoundedBoxEx(6,0,0,w,h,guiColors.boxes.tertiary,true,true,bool,bool)
		s:SetTextColor(s:IsHovered() and guiColors.text.primary or guiColors.text.hovered)
	end
	local once = true
	self.Think = function(s)
		if s:IsMenuOpen() and once then
			s.Menu:SetPaintBackground(false)
			s.Menu:SetDrawBorder( false )
			local count = s.Menu:ChildCount()
			for i = 1, count do
				local child = s.Menu:GetChild(i)
				s.Menu:GetCanvas().Paint = function() end
				child:SetFont("n_health.15")
				child:SetTextColor(JNVoiceMod.clgui.text.primary)
				child.Paint = function(s,w,h)
					s:SetTextColor(s:IsHovered() and guiColors.text.primary or guiColors.text.hovered)
					draw.RoundedBoxEx((i == count and 6 or 0),0,0,w,h,guiColors.boxes.tertiary,false,false,true,true)
				end
			end
		else
			once = true
		end
	end

end

vgui.Register("n_health.comboBox",COMBOBOX,"DComboBox")



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
	closeBtn:DockMargin(4,2,4,6)
	closeBtn:Dock(RIGHT)
	closeBtn:SetText(n_health:GetPhrase("close"))
	closeBtn:SetTextColor(guiColors.text.primary)
	closeBtn:SetFont("n_health.20Heavy")
	closeBtn.DoClick = function(s)
		self:Remove()
	end
	closeBtn.fill = 0
	closeBtn.tempo = 5
	closeBtn.posx,closeBtn.posy = 0,0
	closeBtn.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,guiColors.boxes.red)
		if s:IsHovered() then
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,1.1)
			s.posx,s.posy = s:CursorPos()
		else
			s.fill = Lerp(s.tempo * FrameTime(),s.fill,0)
		end
		draw.RoundedBox(s:GetWide(),s.posx-(s:GetWide()*s.fill),s.posy-(s:GetWide()*s.fill),(s:GetWide()*s.fill)*2,(s:GetWide()*s.fill)*2,guiColors.boxes.blended)
	end

	// save button
	self.header.saveBtn = self.header:Add("DButton")
	local saveBtn = self.header.saveBtn
	saveBtn:DockMargin(4,2,4,6)
	saveBtn:Dock(RIGHT)
	saveBtn:SetText(n_health:GetPhrase("save"))
	saveBtn:SetTextColor(guiColors.text.primary)
	saveBtn:SetFont("n_health.20Heavy")
	saveBtn.color = guiColors.boxes.green
	saveBtn.fill = 0
	saveBtn.tempo = 5
	saveBtn.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,s.color)
		s.fill = Lerp(s.tempo * FrameTime(),s.fill,s:IsHovered() and 1.1 or 0)
		draw.RoundedBox(6,0,h-(s.fill*h),w,s.fill*h,guiColors.boxes.blended)
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
	self.header.closeBtn:SizeToContentsX(8)
	self.header.saveBtn:SizeToContentsX(8)


end
function FRAME:SetTitle(title)

	local label = self.header.title
	if IsValid(label) then
		label:SetText(title or "Nil")
	end

	self:InvalidateLayout()
end

vgui.Register("n_health.frame",FRAME,"EditablePanel")


local CONFIGPANEL = {}
function CONFIGPANEL:Init()
	// get the frame to be able to override the save button function...
	local saveButton = self:GetParent().header.saveBtn
	saveButton.DoClick = function(s)
		local cl_config = n_health.cl_config

		local _,newSelectedLanguage = self.langComboBox:GetSelected()
		cl_config.selectedLanguage = newSelectedLanguage
		n_health:SaveClientConfig()
		// close the menu
		n_health.cl_config.gui.frame:Remove()	
	end

	self.langLabel = self:Add("n_health.configLabel")
	local langLabel = self.langLabel
	langLabel:SetText(n_health:GetPhrase("lang"))

	self.langComboBox = self:Add("n_health.comboBox")
	local langComboBox = self.langComboBox
	langComboBox:Dock(TOP)
	langComboBox:DockMargin(8,0,8,0)
	langComboBox:SetFont("n_health.20")

	local i = 1
	for k,v in pairs(n_health.lang) do
		langComboBox:AddChoice(v.language,k)
		if n_health.cl_config.selectedLanguage == k then langComboBox:ChooseOptionID(i) end
		i = i + 1
	end


end
function CONFIGPANEL:Paint(w,h)
	draw.RoundedBoxEx(6,0,0,w,h,guiColors.boxes.secondary,false,false,true,true)
end


vgui.Register("n_health.configPanel",CONFIGPANEL,"EditablePanel")
