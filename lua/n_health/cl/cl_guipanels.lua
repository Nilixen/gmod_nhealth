local guiColors = {
	accentColor = Color(0,133,80),
    boxes = {
        blended = Color(0,0,0,120),
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
		blended = Color(0,0,0,200),
    },
}
//textEntryWithLabel																--------------NOT USED--------------
local TEXTENTRY = {}
function TEXTENTRY:Init()
	self.label = self:Add("DLabel")
	local label = self.label
	label:Dock(TOP)
	label:SetFont("n_health.15")
	
	self.textEntry = self:Add("DTextEntry")
	local textEntry = self.textEntry
	textEntry:Dock(FILL)
	textEntry:DockMargin(0,4,0,0)
	textEntry:SetDrawBorder( false )
	textEntry:SetPaintBackground( false )
	textEntry:SetFont("n_health.20")
	textEntry:SetTextColor(guiColors.text.secondary)
	textEntry.PaintOver = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,guiColors.boxes.blended)
	end
end
function TEXTENTRY:Paint(w,h)

end
function TEXTENTRY:PerformLayout(w,h)
	self.label:SizeToContentsY(4)
end
vgui.Register("n_health.textEntry",TEXTENTRY,"DPanel")



local SLIDER = {}

function SLIDER:Init()
	self.percentage = false

	self.Paint = function(s,w,h) end

	self.Scratch:SetVisible( false )
	self.Label:SetVisible( false )
	self:SetDecimals( 0 )
	local textArea = self.TextArea
	textArea:Dock(LEFT)
	textArea:DockMargin(0,0,4,0)
	textArea:SetFont("n_health.20")
	textArea:SetTextColor(JNVoiceMod.clgui.text.primary)
	textArea.PaintOver = function(s,w,h)
		

		if self.percentage then
			surface.SetFont(s:GetFont())
			local x,_ = surface.GetTextSize(tostring(math.Round(self:GetValue())))
			draw.SimpleText("%",s:GetFont(),4+x,h*.5,s:GetTextColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
		draw.RoundedBox(6,0,0,w,h,guiColors.boxes.blended)
	end
	local slider = self.Slider
	slider.PaintOver = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,guiColors.boxes.blended)
	end
	slider.Knob.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w*.5,h,guiColors.accentColor)
	end
end

function SLIDER:PerformLayout()

	local decimals = self:GetDecimals()
	local str = (decimals > 0 and "." or "")
	str = str .. (self.percentage and "%" or "")
	for i = 1, decimals do 
		str = str.."0"
	end
	surface.SetFont("n_health.20")
	local x,_ = surface.GetTextSize(tostring(self:GetMax())..str)
	self.TextArea:SetWide(x+8)

end

function SLIDER:Percentage(bool)
	self.percentage = bool
	if bool then
		self:SetMinMax(0,100)
		self:InvalidateLayout()
	end
end


vgui.Register("n_health.slider",SLIDER,"DNumSlider")





// configlabel
local CONFIGLABEL = {}
function CONFIGLABEL:Init()
	self:Dock(TOP)
	self:DockMargin(8,0,8,4)
	self:SetFont("n_health.20")
	self:SetTextColor(guiColors.text.secondary)
end
vgui.Register("n_health.configLabel",CONFIGLABEL,"DLabel")

// sectionlabel
n_health:CreateFont("25Heavy",25,500)

local SECTIONLABEL = {}
function SECTIONLABEL:Init()
	self:Dock(TOP)
	self:SetContentAlignment(5)
	self:DockMargin(8,8,8,0)
	self:SetFont("n_health.25Heavy")
	self:SetTextColor(guiColors.text.secondary)
end

function SECTIONLABEL:PerformLayout(w,h)
	self:SizeToContentsY(4)
end

vgui.Register("n_health.sectionLabel",SECTIONLABEL,"DLabel")
// combobox
local COMBOBOX = {}
n_health:CreateFont("15",15)

function COMBOBOX:Init()
	self:SetTextColor(guiColors.text.tertiary)
	self.Paint = function(s,w,h)
		local bool = not s:IsMenuOpen()
		draw.RoundedBoxEx(6,0,0,w,h,guiColors.boxes.tertiary,true,true,bool,bool)
		s:SetTextColor(s:IsHovered() and guiColors.text.primary or guiColors.text.secondary)
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
					s:SetTextColor(s:IsHovered() and guiColors.text.primary or guiColors.text.secondary)
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
function FRAME:PaintOver(w,h)
	draw.SimpleText(n_health.config.version,"n_health.15",w-8,h-4,guiColors.text.blended,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
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
		cl_config.HUDDrawTime = self.drawTimeHUD:GetValue()
		cl_config.idleAlphaHUD = self.idleAlphaHUD:GetValue()
		cl_config.drawAlphaHUD = self.drawAlphaHUD:GetValue()
		
		n_health:SaveClientConfig()
		// close the menu
		n_health.cl_config.gui.frame:Remove()	
	end

	self.generalSettingsSectionLabel = self:Add("n_health.sectionLabel")
	self.generalSettingsSectionLabel:SetText(n_health:GetPhrase("generalsettings"))

	self.langLabel = self:Add("n_health.configLabel")
	self.langLabel:SetText(n_health:GetPhrase("lang"))

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

	self.hudSettingsSectionLabel = self:Add("n_health.sectionLabel")
	self.hudSettingsSectionLabel:SetText(n_health:GetPhrase("hudsettings"))

	// idle alpha
	self.idleAlphaLabel = self:Add("n_health.configLabel")
	self.idleAlphaLabel:SetText(n_health:GetPhrase("idlehudalpha"))

	self.idleAlphaHUD = self:Add("n_health.slider")
	local idleAlphaHUD = self.idleAlphaHUD
	idleAlphaHUD:Dock(TOP)
	idleAlphaHUD:DockMargin(8,0,8,0)
	idleAlphaHUD:SetMinMax(0,255)
	idleAlphaHUD:SetValue(n_health.cl_config.idleAlphaHUD)
	idleAlphaHUD:SetDefaultValue(n_health.cl_config.idleAlphaHUD)

	// update alpha
	self.drawAlphaLabel = self:Add("n_health.configLabel")
	self.drawAlphaLabel:SetText(n_health:GetPhrase("drawhudalpha"))

	self.drawAlphaHUD = self:Add("n_health.slider")
	local drawAlphaHUD = self.drawAlphaHUD
	drawAlphaHUD:Dock(TOP)
	drawAlphaHUD:DockMargin(8,0,8,0)
	drawAlphaHUD:SetMinMax(0,255)
	drawAlphaHUD:SetValue(n_health.cl_config.drawAlphaHUD)
	drawAlphaHUD:SetDefaultValue(n_health.cl_config.drawAlphaHUD)


	// draw time
	self.drawTimeLabel = self:Add("n_health.configLabel")
	self.drawTimeLabel:SetText(n_health:GetPhrase("drawtimehud"))

	self.drawTimeHUD = self:Add("n_health.slider")
	local drawTimeHUD = self.drawTimeHUD
	drawTimeHUD:Dock(TOP)
	drawTimeHUD:DockMargin(8,0,8,0)
	drawTimeHUD:SetMinMax(0,10)
	drawTimeHUD:SetValue(n_health.cl_config.HUDDrawTime)
	drawTimeHUD:SetDefaultValue(n_health.cl_config.HUDDrawTime)

end
function CONFIGPANEL:Paint(w,h)
	draw.RoundedBoxEx(6,0,0,w,h,guiColors.boxes.secondary,false,false,true,true)
end

vgui.Register("n_health.configPanel",CONFIGPANEL,"EditablePanel")
