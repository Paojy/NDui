local B, C, L, DB = unpack(select(2, ...))
local cr, cg, cb = DB.cc.r, DB.cc.g, DB.cc.b

-- Gradient Frame
B.CreateGF = function(f, w, h, o, r, g, b, a1, a2)
	f:SetSize(w, h)
	f:SetFrameStrata("BACKGROUND")
	local gf = f:CreateTexture(nil, "BACKGROUND")
	gf:SetPoint("TOPLEFT", f, -1, 1)
	gf:SetPoint("BOTTOMRIGHT", f, 1, -1)
	gf:SetTexture(DB.normTex)
	gf:SetVertexColor(r, g, b)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

-- Create Backdrop
B.CreateBD = function(f, a, s)
	f:SetBackdrop({
		bgFile = DB.bdTex, edgeFile = DB.glowTex, edgeSize = s or 3,
		insets = {left = s or 3, right = s or 3, top = s or 3, bottom = s or 3},
	})
	f:SetBackdropColor(0, 0, 0, a or .5)
	f:SetBackdropBorderColor(0, 0, 0)
end

-- Create Shadow
B.CreateSD = function(f, m, s)
	if f.Shadow then return end
	local frame = f
	if f:GetObjectType() == "Texture" then frame = f:GetParent() end
	local lvl = frame:GetFrameLevel()

	f.Shadow = CreateFrame("Frame", nil, frame)
	f.Shadow:SetPoint("TOPLEFT", f, -m, m)
	f.Shadow:SetPoint("BOTTOMRIGHT", f, m, -m)
	f.Shadow:SetBackdrop({
		edgeFile = DB.glowTex, edgeSize = s })
	f.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	return f.Shadow
end

-- Create Background
B.CreateBG = function(f, m)
	local frame = f
	if f:GetObjectType() == "Texture" then frame = f:GetParent() end
	local offset = m
	if not m then offset = 1.2 end
	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", f, offset, -offset)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	return bg
end

-- Create Skin
B.CreateTex = function(f)
	if f.Tex then return end
	local frame = f
	if f:GetObjectType() == "Texture" then frame = f:GetParent() end

	f.Tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.Tex:SetAllPoints()
	f.Tex:SetTexture(DB.bgTex, true, true)
	f.Tex:SetHorizTile(true)
	f.Tex:SetVertTile(true)
	f.Tex:SetBlendMode("ADD")
end

-- Frame Text
B.CreateFS = function(f, size, text, classcolor, anchor, x, y)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(DB.Font[1], size, DB.Font[3])
	fs:SetText(text)
	fs:SetWordWrap(false)
	if classcolor then
		fs:SetTextColor(cr, cg, cb)
	end
	if anchor and x and y then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	return fs
end

-- GameTooltip
B.CreateGT = function(f, anchor, text, color)
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, anchor)
		GameTooltip:ClearLines()
		if color == "class" then
			GameTooltip:AddLine(text, cr, cg, cb)
		elseif color == "system" then
			GameTooltip:AddLine(text, 1, .8, 0)
		else
			GameTooltip:AddLine(text, 1, 1, 1)
		end
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", GameTooltip_Hide)
end
B.CreateAT = function(f, value)
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
		GameTooltip:ClearLines()
		if type(value) == "string" then
			GameTooltip:SetUnitAura("player", value)
		else
			GameTooltip:SetSpellByID(value)
		end
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", GameTooltip_Hide)
end

-- Button Color
B.CreateBC = function(f, a)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	f:SetScript("OnEnter", function()
		f:SetBackdropBorderColor(cr, cg, cb, 1)
	end)
	f:SetScript("OnLeave", function()
		f:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	f:SetScript("OnMouseDown", function()
		f:SetBackdropColor(cr, cg, cb, a or .3)
	end)
	f:SetScript("OnMouseUp", function()
		f:SetBackdropColor(0, 0, 0, a or .3)
	end)
end

-- Checkbox
B.CreateCB = function(f, a)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(DB.bdTex)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(cr, cg, cb, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel() - 1)
	B.CreateBD(bd, a, 2)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(cr, cg, cb)
end

-- Movable Frame
B.CreateMF = function(f, parent)
	local frame = parent or f
	frame:SetMovable(true)
	frame:SetUserPlaced(true)
	frame:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() frame:StartMoving() end)
	f:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
end

-- Icon Style
B.CreateIF = function(f, HL)
	B.CreateSD(f, 3, 3)
	f.Icon = f:CreateTexture(nil, "ARTWORK")
	f.Icon:SetAllPoints()
	f.Icon:SetTexCoord(unpack(DB.TexCoord))
	f.CD = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
	f.CD:SetAllPoints()
	f.CD:SetReverse(true)
	if HL then
		f:EnableMouse(true)
		f.HL = f:CreateTexture(nil, "HIGHLIGHT")
		f.HL:SetColorTexture(1, 1, 1, .3)
		f.HL:SetAllPoints(f.Icon)
	end
end

-- Statusbar
B.CreateSB = function(f, spark, r, g, b)
	f:SetStatusBarTexture(DB.normTex)
	if r and g and b then
		f:SetStatusBarColor(r, g, b)
	else
		f:SetStatusBarColor(cr, cg, cb)
	end
	B.CreateSD(f, 3, 3)
	f.BG = f:CreateTexture(nil, "BACKGROUND")
	f.BG:SetAllPoints()
	f.BG:SetTexture(DB.normTex)
	f.BG:SetVertexColor(0, 0, 0, .5)
	B.CreateTex(f.BG)
	if spark then
		f.Spark = f:CreateTexture(nil, "OVERLAY")
		f.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		f.Spark:SetBlendMode("ADD")
		f.Spark:SetAlpha(.8)
		f.Spark:SetPoint("TOPLEFT", f:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
		f.Spark:SetPoint("BOTTOMRIGHT", f:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
	end
end

-- Numberize
B.Numb = function(n)
	if NDuiDB["Settings"]["Format"] == 1 then
		if n >= 1e9 then
			return ("%.2fb"):format(n / 1e9)
		elseif n >= 1e6 then
			return ("%.1fm"):format(n / 1e6)
		elseif n >= 1e3 then
			return ("%.1fk"):format(n / 1e3)
		else
			return ("%.0f"):format(n)
		end
	elseif NDuiDB["Settings"]["Format"] == 2 then
		if n >= 1e8 then
			return ("%.1f"..L["NumberCap2"]):format(n / 1e8)
		elseif n >= 1e4 then
			return ("%.1f"..L["NumberCap1"]):format(n / 1e4)
		else
			return ("%.0f"):format(n)
		end
	else
		return ("%.0f"):format(n)
	end
end

-- Color code
B.HexRGB = function(r, g, b)
	if r then
		if (type(r) == "table") then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
	end
end

B.ClassColor = function(class)
	local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
	if not color then return 1, 1, 1 end
	return color.r, color.g, color.b
end

B.UnitColor = function(unit)
	local r, g, b = 1, 1, 1
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then
			r, g, b = B.ClassColor(class)
		end
	elseif UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = FACTION_BAR_COLORS[reaction]
			r, g, b = color.r, color.g, color.b
		end
	end
	return r, g, b
end

-- Disable function
B.Dummy = function() end

-- Smoothy
local smoothing = {}
local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end
local SmoothUpdate = CreateFrame("Frame")
SmoothUpdate:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)/8, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if (cur == value or math.abs(new - value) < .01) then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)
B.SmoothBar = function(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = Smooth
	end
end

-- Guild Check
B.UnitInGuild = function(unit)
	for i = 1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i)
		if name and name == unit then
			return true
		end
	end
	return false
end

-- Timer Format
B.FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%d"..DB.MyColor.."d", s/day), s % day
	elseif s >= hour then
		return format("%d"..DB.MyColor.."h", s/hour), s % hour
	elseif s >= minute then
		return format("%d"..DB.MyColor.."m", s/minute), s % minute
	elseif s < 3 then
		if NDuiDB["Actionbar"]["DecimalCD"] then
			return format("|cffff0000%.1f|r", s), s - format("%.1f", s)
		else
			return format("|cffff0000%d|r", s + .5), s - floor(s)
		end
	elseif s < 10 then
		return format("|cffffff00%d|r", s), s - floor(s)
	end
	return format("|cffcccc33%d|r", s), s - floor(s)
end

-- Table Backup
B.CopyTable = function(source, target)
	for key, value in pairs(source) do
		if type(value) == "table" then
			target[key] = {}
			for k, v in pairs(value) do
				target[key][k] = value[k]
			end
		else
			target[key] = value
		end
	end
end