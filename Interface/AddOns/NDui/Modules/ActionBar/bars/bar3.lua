local B, C, L, DB = unpack(select(2, ...))
local Bar = NDui:GetModule("Actionbar")
local cfg = C.bars.bar3
local padding, margin = 2, 2

function Bar:CreateBar3()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = NDuiDB["Actionbar"]["Style"]
	if layout == 4 then cfg = C.bars.bar2 end

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "NDui_ActionBar3", UIParent, "SecureHandlerStateTemplate")
	if layout ~= 4 then
		frame:SetWidth(19*cfg.size + 17*margin + 2*padding)
		frame:SetHeight(2*cfg.size + margin + 2*padding)
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 0, 26}
	else
		frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
		frame:SetHeight(cfg.size + 2*padding)
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 0, 96}
	end
	frame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	MultiBarBottomRight:SetParent(frame)
	MultiBarBottomRight:EnableMouse(false)

	for i = 1, num do
		local button = _G["MultiBarBottomRightButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			if layout ~= 4 then
				button:SetPoint("TOPLEFT", frame, padding, -padding)
			else
				button:SetPoint("LEFT", frame, padding, 0)
			end
		elseif layout ~= 4 and i == 4 then
			local previous = _G["MultiBarBottomRightButton1"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		elseif layout ~= 4 and i == 7 then
			local previous = _G["MultiBarBottomRightButton3"]
			button:SetPoint("LEFT", previous, "RIGHT", 13*cfg.size+13*margin, 0)
		elseif layout ~= 4 and i == 10 then
			local previous = _G["MultiBarBottomRightButton7"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		else
			local previous = _G["MultiBarBottomRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create drag frame and drag functionality
	if C.bars.userplaced then
		B.Mover(frame, SHOW_MULTIBAR2_TEXT, "Bar3", frame.Pos)
	end

	--create the mouseover functionality
	if cfg.fader then
		NDui.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end