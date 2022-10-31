--[[

	Crillion Map Editor

	copy&paste
	Level-Select
	episoden
	
	
	895
	col: 6f6
	rep: 5f6
	both: 53a

	level controllieren 17,12,20,21

--]]

MEMADR = 0x1300
MEMSIZE = 0x2000-0x300
FIELDWIDTH = 15
FIELDHEIGHT = 11
MAXEPISODE = 10


local _bitsAdr
local _bitsBit
local _bitsStart

function BitsPosition(adr)
	_bitsAdr = adr
	_bitsStart = adr
	_bitsBit = 1	
end

function BitsLen()
	return _bitsAdr - _bitsStart + 1 - (_bitsBit == 1 and 1 or 0)
end

function Bits(srcSize,b)
	local ret=0
	for i = 0, srcSize - 1 do
		if b then
			activePico:Poke(_bitsAdr, activePico:Peek(_bitsAdr) & ~(_bitsBit * (~b&1)) | (b&1) *_bitsBit )
			b>>=1
		else
			ret |= activePico:Peek(_bitsAdr) & _bitsBit != 0 and 1<<i or 0
		end
		_bitsAdr += _bitsBit\128 -- when bits was on 128, next would be 256 -> next byte
		_bitsBit = (_bitsBit<<1)%255 -- overflow 256 to 1
	end
	return ret
end


modules = modules or {}
local m = {
		name = "crillion",
		sort = 200,
	}
table.insert(modules, m)


local _episodes = nil
local _levelData = nil
local _currentLevel = nil
local _usedSize = 0
local _valid = false

local function _ReadLevelData()
	if activePico:PeekString(0x30f8,8) == "CRILLION" then
		_valid = true
	else
		_valid = false
		return false
	end

	local selEpisode = 1
	if _levelData then selEpisode = _levelData.index end

	local selLevel = 1
	if _currentLevel then selLevel = _currentLevel.index end
	
	
	_episodes = {}
	BitsPosition(MEMADR)
	for eNb = 1,MAXEPISODE do
		local _levelData = {}
		repeat
			local x,y = Bits(4), Bits(4)
			if x == 0 and y == 0 then break end
			local col = Bits(3)
			local lev = {ballX = x, ballY = y, ballCol = col, field = {}, index = #_levelData +1}
			
			local count = FIELDWIDTH * FIELDHEIGHT
			while count > 0 do
				local what = Bits(3)
				if what == 0 then --0 leer
					table.insert(lev.field, 0x03)
					count -= 1
				elseif what == 1 then  --totenkopf
					table.insert(lev.field, 0x01)
					count -= 1
				elseif what == 2 then -- stein
					table.insert(lev.field, 0x02)
					count -= 1
				elseif what == 3 then -- block
					--local col = Bits(3)
					table.insert(lev.field, 0x10 + col)
					count -= 1
				elseif what == 4 then -- disc
					--local col = Bits(3)
					table.insert(lev.field, 0x18 + col)
					count -= 1
				elseif what == 5 then -- färb
					--local col = Bits(3)
					table.insert(lev.field, 0x20 + col)
					count -= 1
				elseif what == 6 then -- color
					col = Bits(3)
				
				elseif what == 7 then -- repeat
					local rep = Bits(3) + 3
					local c = lev.field[#lev.field]
					for i = 1, rep do
						table.insert(lev.field, c)
						count -= 1
					end
				end		
			end

			table.insert(_levelData, lev)		
		until (false)
		
		
				
		while #_levelData < 25 do
			local lev = {ballX = 1, ballY = 1, ballCol = 0, field = {}, index = #_levelData +1}
			for i = 1, FIELDWIDTH * FIELDHEIGHT do
				table.insert(lev.field, 0x03)
			end
			table.insert(_levelData, lev)
		end
		
		_levelData.index = #_episodes + 1
		table.insert(_episodes, _levelData)
	end
	
	print(_episodes, _levelData, _currentLevel, selEpisode, selLevel)
	
	_levelData = _episodes[selEpisode]
	
	_currentLevel = _levelData[selLevel]
	_usedSize = BitsLen()
end

local function _WriteLevelData()
	if not _valid then return false end
	
	BitsPosition(MEMADR)
	
	for eNb, _levelData in pairs(_episodes) do
		for nb = 1, #_levelData do	
			local lev = _levelData[nb]
			local ok = false
			for i = 1, FIELDWIDTH * FIELDHEIGHT do
				if lev.field[i] != 0x03 then
					ok = true
					break
				end
			end
			
			if ok then 
				Bits(4, lev.ballX)
				Bits(4, lev.ballY)
				Bits(3, lev.ballCol)
				
				local col = lev.ballCol
				local CheckColor = function(c)
					if c != col then
						col = c
						Bits(3,6)
						Bits(3,c)
					end
				end
				
			
				local i = 1
				while i <= FIELDWIDTH * FIELDHEIGHT do
					if lev.field[i] == 0x03 then -- leer
						Bits(3, 0)
						i += 1
					elseif lev.field[i] == 0x01 then -- totekopf
						Bits(3, 1)
						i += 1
					elseif lev.field[i] == 0x02 then -- stein
						Bits(3, 2)
						i += 1
					elseif lev.field[i] >= 0x10 and lev.field[i] <= 0x17 then -- block
						CheckColor(lev.field[i] - 0x10)				
						Bits(3, 3)
						--Bits(3, lev.field[i] - 0x10)
						i += 1
					elseif lev.field[i] >= 0x18 and lev.field[i] <= 0x1f then -- disc
						CheckColor(lev.field[i] - 0x18)
						Bits(3, 4)
						--Bits(3, lev.field[i] - 0x18)
						i += 1
					elseif lev.field[i] >= 0x20 and lev.field[i] <= 0x27 then -- färb
						CheckColor(lev.field[i] - 0x20)
						Bits(3, 5)
						--Bits(3, lev.field[i] - 0x20)					
						i += 1
					else
						print("WRONG LEVEL DATA!",nb)
						i += 1
					end

					-- repeat check
					---[[
					local count = 0
					while lev.field[i - 1 + count] == lev.field[i + count] do 
						count += 1
					end
					
					while count >= 3 do
						local m = math.min(7 + 3,count)
						Bits(3, 7) -- repeat
						Bits(3, m - 3) -- count
						count -= m
						i += m				
					end
					--]]
					
					
				end		
			end
		end
		Bits(4,0)
		Bits(4,0)
	end	
	_usedSize = BitsLen()
	
	if _usedSize < MEMSIZE then
		activePico:MemorySet(MEMADR + _usedSize,0,MEMSIZE - _usedSize)	
	end
end


-- set a character in map-areaRect
local _changed
local function _MapSet(x, y, v)
	if not _valid then return false end
	
	if (v == 0 and overArea.buttons.AreaCopy00:IsSelected() == false) or x < overArea.cellRect.x or x >= overArea.page.w + overArea.cellRect.x or y < overArea.cellRect.y or y >= overArea.page.h + overArea.cellRect.y then
		return false				-- out of visible areaRect
	end
	
	if (v >= 0x01 and v <= 0x03) or (v >= 0x10 and v <= 0x27) then	
		_currentLevel.field[x + y * FIELDWIDTH + 1] = v
		_changed = true
		return v
	elseif (v >= 0x08 and v <= 0x0f) then
		_currentLevel.ballX = x + 1
		_currentLevel.ballY = y + 1
		_currentLevel.ballCol = v - 0x08
		_changed = true
		return v
	end

end

-- Get a character in map-areaRect
local function _MapGet(x, y)
	if not _valid then return 0 end 
	return _currentLevel.field[x + y * FIELDWIDTH + 1] or 0x03 -- leer
end

-- here same as _MapGet
local function _MapGetInfo(x, y)
	if not _valid then return 0,0 end
	return _currentLevel.field[x + y * FIELDWIDTH + 1] or 0x03, 0
end

-- Draw a character in map-areaRect
local function _MapDraw(x,y,char,alpha)
	tex = TexturesGetSprite()
	tex:SetAlphaMod(alpha)
	tex:SetBlendMode("BLEND")
	
	if char != 0 or overArea.buttons.AreaCopy00:IsSelected() then 
		renderer:Copy(
			tex,
			{x = (char & 0xf) * 8, y = ((char >> 4) & 0xf) * 8, w = 8, h = 8},
			{x, y, overArea.csize, overArea.csize}
		)	
	end
end


local function _MapSize()
	if not _valid then return 0,0,0 end
	return MEMSIZE,FIELDWIDTH,FIELDHEIGHT
end


-- activate map editing
local function _EnableMapEditing()
		
	overArea.OnRecalc = _EnableMapEditing
	
	-- a screen in Pico8 has 16x16 blocks
	overArea.gridBlock = 16

	-- size of the map
	_,overArea.cellRect.w,overArea.cellRect.h = _MapSize()
					
	-- set handling functions
	overArea.AreaSet = _MapSet
	overArea.AreaGet = _MapGet
	overArea.AreaGetInfo = _MapGetInfo
	overArea.AreaDrawFast = nil
	overArea.AreaDraw = _MapDraw
	overArea.copy.use = overArea.copy.icon
	
	overArea.OnOverviewPicoGenTex = TexturesGetSprite
	overArea.OnOverviewAdr = function(x,y)
		return activePico:SpriteAdr(x*8,y*8)
	end
	
	overArea:BasicLayout()
	
	overArea.buttons.AreaFlags.visible = true
	overArea.buttons.AreaBackground.visible = true
	overArea.buttons.MAPPOS.visible = true
	overArea.buttons.MAPWIDTH.visible = true
	overArea.buttons.OverviewFlags.visible = true
	overArea.buttons.OverviewCount.visible = true
	overArea.buttons.OverviewId.visible = true
	overArea.buttons.AreaHiSel.visible = true
	
end

-- free everything
function m.Quit(m)
	overArea:Quit()
end

-- Initalize
function m.Init(m)


---[[
	--color reduce

	for d=0.25,0.75,0.25 do
	local str = ""
	for c=0,15 do
		str..= Pico:ColorNearest( Pico.RGB[c].r*d,Pico.RGB[c].g*d,Pico.RGB[c].b*d)..","
	end
	print("color",d,str)
	end

--]]



	overArea:Init()
	-- we have a custom menu
	
	m.menuBar = menu:CreateBar()
	m.menuBar:AddFile()
	local men = m.menuBar:AddEdit()	
	men:Add()
	men:Add("clipboardAsHex", "Use hex values for clipboard", 
		function (e)	
			config.clipboardAsHex = e.checked
			men:SetCheck("clipboardAsHex", config.clipboardAsHex)
		end,
		nil,
		"TOOGLE"
	)
	m.menuBar:AddPico8()
	m.menuBar:AddZoom()
	m.menuBar:AddSettings()
	m.menuBar:AddModule()
	
	men = m.menuBar:Add("Episode")
	men:Add("epiplus", "next episode\tdown",
		function(e)
			if not _valid then return false end
			_WriteLevelData()
			local lev = _currentLevel.index
			local epi = math.clamp(1, #_episodes, _levelData.index + 1)
			_levelData = _episodes[epi]
			_currentLevel = _levelData[lev]
		end,
		"DOWN"
	)
	men:Add("epiminus", "previous episode\tup",
		function(e)
			if not _valid then return false end
			_WriteLevelData()
			local lev = _currentLevel.index
			local epi = math.clamp(1, #_episodes, _levelData.index - 1)
			_levelData = _episodes[epi]
			_currentLevel = _levelData[lev]
		end,
		"UP"
	)
	
	for i = 1, MAXEPISODE do
		men:Add("Episode"..i, "Episode "..i, 
			function(e)
				if not _valid then return false end
				_WriteLevelData()
				local lev = _currentLevel.index
				_levelData = _episodes[e.index]
				_currentLevel = _levelData[lev]
				e:SetRadio()
			end,
			nil,
			"episodeselect"
		).index = i
	end
	
	men = m.menuBar:Add("Level")
	men:Add("levplus", "next level\tright", 
		function(e)
			if not _valid then return false end
			local lev = math.clamp(1, #_levelData, _currentLevel.index + 1)
			_currentLevel = _levelData[lev]
			_WriteLevelData()
			e:SetRadio()			
		end,
		"RIGHT"
	)
	men:Add("levminus", "previous level\tleft", 
		function(e)
			if not _valid then return false end
			local lev = math.clamp(1, #_levelData, _currentLevel.index - 1)
			_currentLevel = _levelData[lev]
			_WriteLevelData()
			e:SetRadio()			
		end,
		"LEFT"
	)
	men:Add()
		
	for i = 1, 25 do
		men:Add("Level"..i, "Level "..i, 
			function (e)
				if not _valid then return false end
				_currentLevel = _levelData[e.index]
				_WriteLevelData()
				e:SetRadio()
			end, 
			nil,
			"levelselect"	
		).index = i
	end
	
	m.menuBar:AddDebug()
	
	m.MenuUpdate = function (m,bar)
		bar:Set("clipboardAsHex", config.clipboardAsHex)		
	end
	
	m.buttons = overArea.buttons
	m.inputs = overArea.inputs
	m.scrollbar = overArea.scrollbar
	m.shortcut = overArea.shortcut
	return true
end

-- Focus got
function m.FocusLost(m)
	-- save some values
	m.oa_size = overArea.csize
	m.oa_cell_x = overArea.cellRect.x
	m.oa_cell_y = overArea.cellRect.y
	_WriteLevelData()
end

-- Focus lost
function m.FocusGained(m)
	-- restore old settings
	_ReadLevelData()
	overArea.cellRect.x = m.oa_cell_x or 0
	overArea.cellRect.y = m.oa_cell_y or 0
	overArea.csize = m.oa_size or 32
	_EnableMapEditing()
	MenuSetZoom(overArea.csize)
	if _valid then
		m.menuBar:Set("Level".._currentLevel.index)
		m.menuBar:Set("Episode".._levelData.index)
	end
	m:Resize()
end

-- wheel change zoom
function m.ZoomChange(m, zoom)
	overArea.csize = zoom
	m:Resize()
end

-- Resize
function m.Resize(m)
	if overArea.OnRecalc then overArea.OnRecalc() end
	_ReadLevelData()
end

-- draw
function m.Draw(m,mx,my)
	overArea:DrawOverview(mx,my)
	overArea:DrawArea(mx,my)		
	overArea:DrawInfoBar()
	
	if not _valid then
		return
	end
	-- draw map size
	DrawText(overArea.infoMapSize.x, overArea.infoMapSize.y, string.format("  %01d-%02d ",_levelData.index,_currentLevel.index))		

	DrawText(overArea.infoMapSizeByte.x, overArea.infoMapSizeByte.y, string.format( config.sizeAsHex and " %04x/%04x " or "%05i/%05i", _usedSize , MEMSIZE))
	
	-- ball zeichnen	
	
	if _valid then
		_MapDraw(overArea.areaRect.x + (_currentLevel.ballX - 1) * overArea.csize,
				overArea.areaRect.y + (_currentLevel.ballY - 1) * overArea.csize,
				0x08 + _currentLevel.ballCol,
				255)
	end
end

-- mouse click
function m.MouseDown(m, mx, my, mb, mbclicks)
	if SDL.Keyboard.GetModState():hasflag("CTRL") > 0 then
		if mb == "LEFT" and overArea.copy.icon.charEnd >=0 and SDL.Rect.ContainsPoint(overArea.overviewRect, {mx, my}) then
			-- CTRL + Click EXCANGE
			-- CTRL + SHIFT + CLICK without map change
			local doMapChange = SDL.Keyboard.GetModState():hasflag("SHIFT") == 0
			local x = (mx - overArea.overviewRect.x) \ overArea.osize
			local y = (my - overArea.overviewRect.y) \ overArea.osize

			for dy = 1,#overArea.copy.icon.a do
				for dx =1, #overArea.copy.icon.a[1] do					
					local posFrom = overArea.copy.icon.a[dy][dx]
					local posTo = (x + (y<<4) + (dy - 1) * 16 + (dx - 1)) % 255
					local adrFrom = activePico:SpriteAdr(posFrom)
					local adrTo = activePico:SpriteAdr(posTo)
					
					for m =0,7 do
						local a = activePico:Peek32(adrFrom)
						activePico:Poke32(adrFrom, activePico:Peek32(adrTo) )
						activePico:Poke32(adrTo, a)
						adrFrom += 64
						adrTo += 64
					end
					
					if doMapChange then 
						for yy = 0, overArea.cellRect.h -1 do
							for xx = 0, overArea.cellRect.w - 1 do
								local a = activePico:MapGet(xx,yy)
								if a == posTo then
									activePico:MapSet(xx,yy,posFrom)
								elseif a == posFrom then
									activePico:MapSet(xx,yy,posTo)
								end
							end
						end
					end
					
					if overArea.copy.icon.char == posFrom then
						overArea.copy.icon.char = posTo
					end
					if overArea.copy.icon.charEnd == posFrom then
						overArea.copy.icon.charEnd = posTo
					end
					overArea.copy.icon.a[dy][dx] = posTo
					
				end
			end
			
			
			
		end
		
		overArea:MouseDownArea(mx, my, mb, mbclicks)

	else
		overArea:MouseDownOverview(mx, my, mb, mbclicks)
		overArea:MouseDownArea(mx, my, mb, mbclicks)
	end
end

-- mouse move
function m.MouseMove(m, mx, my, mb)
	overArea:MouseMoveOverview(mx, my, mb)
	overArea:MouseMoveArea(mx, my, mb)
end

-- mouse up
function m.MouseUp(m, mx,my,mb, mbclicks)
	overArea:MouseUpOverview(mx, my, mb, mbclicks)
	overArea:MouseUpArea(mx, my, mb, mbclicks)
	if _changed then
		_changed = false
		_WriteLevelData()
	end
end

-- set a color in sprite-areaRect
local function _SpriteSet(x, y, v)
	if x < 0 or x >= #overArea.copy.icon.a[1] * 8 or y < 0 or y >= #overArea.copy.icon.a * 8 then
		return false			-- outside the sprite
	end
	
	local char = overArea.copy.icon.a[ y \ 8 + 1 ][ x \ 8 + 1 ]	-- get the sprite out of sprite-copy

	activePico:SpriteSetPixel(
		(char & 0xf) * 8 + (x % 8),
		((char >> 4) & 0xf) * 8 + (y % 8),
		v
	)
	
	return true
end

-- get a color in sprite-areaRect
local function _SpriteGet(x,y)
	if x < 0 or x >= #overArea.copy.icon.a[1] * 8 or y < 0 or y >= #overArea.copy.icon.a * 8 then
		return 0				-- outside - always black
	end
	
	local char = overArea.copy.icon.a[ y \ 8 + 1 ][ x \ 8 + 1 ]	-- get the sprite out of sprite-copy

	return activePico:SpriteGetPixel(
		(char & 0xf) * 8 + (x % 8),
		((char >> 4) & 0xf) * 8 + (y % 8)
	)
end

-- copy sprite to clipboard
function m.Copy(m)
	local w,h = math.min(128,#overArea.copy.icon.a[1] * 8) , math.min(128, #overArea.copy.icon.a * 8)
	local ret = string.format("[gfx]%02x%02x",w,h )
	for y = 0, h - 1 do 
		for x = 0, w - 1 do
			ret ..= string.format("%01x", _SpriteGet(x,y))
		end
	end
	
	ret ..="[/gfx]"
	
	InfoBoxSet("Copied "..w.."x"..h.." sprite.")
	
	return ret
end

-- paste sprite from clipboard
function m.Paste(m,str)
	if str:sub(1,5) != "[gfx]" or str:sub(-6,-1) != "[/gfx]" then
		return nil
	end
	local w, h = tonumber("0x" .. str:sub(6,7)) or 0, tonumber("0x" .. str:sub(8,9)) or 0
	
	local xs,ys = overArea.copy.icon.char & 0xf , overArea.copy.icon.char >> 4 
	local xe,ye = math.clamp(0, 15, xs + w \ 8 - 1), math.clamp(0,15, ys + h \ 8 - 1)
	overArea.copy.icon.charEnd = xe + (ye << 4)
	
	overArea.copy.icon.a = {}
	for y = ys, ye do
		local t = {}
		for x = xs, xe do
			table.insert(t, x + (y << 4))
		end
		table.insert(overArea.copy.icon.a, t)
	end
	
	local pos = 10	
	for y = 0,  h - 1 do
		for x = 0,  w - 1 do
			_SpriteSet(x, y, tonumber("0x"..str:sub(pos,pos)) or 0 )
			pos += 1
		end
	end

end

-- Delete sprites
function m.Delete(m)	
	local w,h = math.min(128,#overArea.copy.icon.a[1] * 8) , math.min(128, #overArea.copy.icon.a * 8)
	for y = 0, h - 1 do 
		for x = 0, w - 1 do
			_SpriteSet(x, y, 0)
		end
	end
end

-- wheel change zoom
function m.MouseWheel(m,x,y,mx,my)
	MenuRotateZoom(y > 0) 
end

-- copy complete map to hex
function m.CopyHex(m)
	return moduleHex:API_CopyHex(MEMADR,MEMSIZE)
end

-- paste complete map 
function m.PasteHex(m,str)
	return moduleHex:API_PasteHex(str,MEMADR,MEMSIZE)
end


return m
