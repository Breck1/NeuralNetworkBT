--Author Pasky13

---------------
----GLOBALS----
buttonInput = {}

tileStart = 0x0300
tileFinish = 0x04FF
enemyStart = 0x0E68 -- 3688
enemyFinish = 0x1228 -- 4648

bulletsOnScreen = 0x08BB
-- DPad input
buttonInput.left = false;
buttonInput.right = false;
buttonInput.up = false;
buttonInput.down = false;

-- actionButton input
buttonInput.b = false;
buttonInput.a = false;
buttonInput.y = false;
buttonInput.x = false;

-- shoulder button input
buttonInput.l = false;
buttonInput.r = false;
---------------
enemySpotted = true



megamanPosX = 0
megamanPosY = 0

enemyPosX = 0
enemyPosY = 0

local pbase = 0xBA8
local px = 0xBAD
local py = 0xBB0
local cx = 0x00B4
local cy = 0x00B6

local stateAddress = 0x0BAA -- Megaman State address 6 = rising, 8 = falling 14 = dashing 2 = walking
local bitflags = 0x0C06 -- 04 = Standing, 02 = hanging on left wall, 01 = hanging on right wall

local previousBitflah
local currentBitflag

local currentState = 04
local previousState = 04

local currentLevelData = 0x1F7A
---------------
----TOGGLES----
---------------
local draw_megaman = true
local draw_enemies = true
local draw_hpvalues = true
local draw_projectiles = true
--local draw_instantbox = false  -- Bizhawk doesnt support breakpoints

local xm
local ym

-- Breakpoints not yet implemented in bizhawk
-- local function draw_instabox(base)

	-- local camx = mainmemory.read_u16_le(cx)
	-- local camy = mainmemory.read_u16_le(cy)
	-- local facing = mainmemory.read_u8(base + 0x11)
	-- local x = mainmemory.read_u16_le(base + 5) - camx
	-- local y = mainmemory.read_u16_le(base + 8) - camy
	-- local boxpointer = mainmemory.read_u16_le(base +0x20) + 0x860000
	-- local xoff = mainmemory.read_s8(boxpointer + 0)
	-- local yoff = mainmemory.read_s8(boxpointer + 1)
	-- local xrad = mainmemory.read_u8(boxpointer + 2)
	-- local yrad = mainmemory.read_u8(boxpointer + 3)

	-- if facing > 0x45 then
		-- xoff = xoff * -1
	-- end

	-- gui.drawBox(x + xoff +xrad,y + yoff + yrad, x + xoff - xrad, y + yoff - yrad,0xFFFF0000,0x05FF0000)
-- end

function setMegamanXInput(buttonIndex, buttonPressed)
	buttonInput[buttonIndex] = buttonPressed
	print("[LUA Megaman X: setMegamanXInput called\n")
end

function MegamnPositionX()
print("[LUA EnemyPositionY called \n")

	return megamanPosX
end
function MegamanPositionY()
	return megamanPosY
end
function EnemyPositionX()
	return enemyPosX
end
function EnemyPositionY()
print("[LUA EnemyPositionY called \n")
	return enemyPosY
end


memory.usememorydomain("CARTROM")


output = {}
--output.enemyPosition = {}
output.enemyPositionX = 0
output.enemyPositionY = 0
output.currentLevel = 0
output.megamanState = 0
output.megamanBitflags = 0
--output.tile = {}
output.tileDirection = 0
output.distanceFromStartPosition = 0


local function megaman()

	local camx = mainmemory.read_u16_le(cx)
	local camy = mainmemory.read_u16_le(cy)
	local x = mainmemory.read_u16_le(px) - camx
	local y = mainmemory.read_u16_le(py) - camy
	local facing = mainmemory.read_u8(pbase + 0x11)
	local boxpointer = mainmemory.read_u16_le(pbase + 0x20) + 0x28000
	local xoff = memory.read_s8(boxpointer + 0)
	local yoff = memory.read_s8(boxpointer + 1)
	local xrad = memory.read_u8(boxpointer + 2)
	local yrad = memory.read_u8(boxpointer + 3)

	output.currentLevel = memory.read_s8(currentLevelData)

	output.megamanState = memory.read_s8(stateAddress)
	output.megamanBitflags = memory.read_s8(bitflags)
	--print("Camera Pos X: " ..camx)
	--print("Camera Pos Y: " ..camy)
	megamanPosX = x + camx
	megamanPosY = y + camy
	if facing > 0x45 then
		xoff = xoff * -1
	end

	gui.drawBox(x + xoff +xrad,y + yoff + yrad, x + xoff - xrad, y + yoff - yrad,0xFF0000FF,0x400000FF)
end

local function enemies()

	local x
	local xoff
	local xrad
	local y
	local yoff
	local yrad
	local camx = mainmemory.read_u16_le(cx)
	local camy = mainmemory.read_u16_le(cy)
	local base
	local boxpointer
	local facing
	local fill
	local outl
	local start = 0xE68 --3688
	local oend = 32

	for i = 0, oend,1 do

		base = start + (i * 0x40) -- 3688 + (i * 64) || läser en fiende i taget

		if i == 0 then
			base = start
		end

		if mainmemory.read_u8(base) ~= 0 then -- om minnet inte är laddat så finns de inte.

			if i > 14 and i < 21 then
				if draw_projectiles == true then
					fill = 0x40FFFFFF -- vitt
					outl = 0xFFFFFFFF -- egna skott
				else
					fill = 0x00000000 -- svart
					outl = 0x00000000 -- gör ingenting
				end
			else
				fill = 0x40FF0000 -- red
				outl = 0xFFFF0000 -- super bad enemies
			end

			if i > 21 then
				fill = 0x40FFFF00 -- Gul = bad
				outl = 0xFFFFFF00 -- skott och drops
			end

			facing = mainmemory.read_u8(base + 0x11)
			x = mainmemory.read_u16_le(base + 5) - camx -- unsigned 2 byte value
			y = mainmemory.read_u16_le(base + 8) - camy
			boxpointer = mainmemory.read_u16_le(base +0x20) + 0x28000
			xoff = memory.read_s8(boxpointer + 0)
			yoff = memory.read_s8(boxpointer + 1)
			xrad = memory.read_u8(boxpointer + 2)
			yrad = memory.read_u8(boxpointer + 3)

			output.enemyPositionX = x
			output.EnemyPositionY = y
<<<<<<< HEAD
			print(x)
			print(y)
		
=======

>>>>>>> main
		if facing > 0x45 then
				xoff = xoff * -1
		end

		--Breakpoints not yet implemented in Bizhawk
		-- if draw_instantbox == true then
			-- memory.registerwrite(0x7E0000 + base + 0x20,2,function ()
				-- draw_instabox(memory.getregister("D"))
			-- end)
		-- end


		--gui.text(x,y,string.format("%X",base))  -- Debug
		gui.drawBox(x + xoff +xrad,y + yoff + yrad, x + xoff - xrad, y + yoff - yrad,outl, fill)

			if draw_hpvalues == true and mainmemory.read_u8(base+0x27) > 0 then
				if i < 15 or i > 20 then
					gui.text((x-5) * xm,(y-5) * ym,"HP: " .. mainmemory.read_u8(base+0x27))
				end
			end

		end
	end
end
function tileData()
for i = 0, oend,1 do
	
		base = start + (i * tileStart)
		
		if i == 0 then
			base = start
		end
		
		if mainmemory.read_u8(base) ~= 0 then
			
			if i > 14 and i < 21 then
				if draw_projectiles == true then
					fill = 0x40FFFFFF
					outl = 0xFFFFFFFF
					else
						fill = 0x00000000
						outl = 0x00000000
				end
			else
				fill = 0x40FF0000
				outl = 0xFFFF0000
			end	
			
			if i > 21 then
				fill = 0x40FFFF00
				outl = 0xFFFFFF00
			end
			
			facing = mainmemory.read_u8(base + 0x11)
			x = mainmemory.read_u16_le(base + 5) - camx
			y = mainmemory.read_u16_le(base + 8) - camy
			boxpointer = mainmemory.read_u16_le(base +0x20) + 0x28000
			xoff = memory.read_s8(boxpointer + 0)
			yoff = memory.read_s8(boxpointer + 1)
			xrad = memory.read_u8(boxpointer + 2)
			yrad = memory.read_u8(boxpointer + 3)
			
			output.enemyPositionX = x
			output.EnemyPositionY = y
			print(x)
			print(y)
		
		if facing > 0x45 then
				xoff = xoff * -1
		end
		
		--Breakpoints not yet implemented in Bizhawk
		-- if draw_instantbox == true then
			-- memory.registerwrite(0x7E0000 + base + 0x20,2,function ()
				-- draw_instabox(memory.getregister("D"))
			-- end)
		-- end

		
		--gui.text(x,y,string.format("%X",base))  -- Debug
		gui.drawBox(x + xoff +xrad,y + yoff + yrad, x + xoff - xrad, y + yoff - yrad,outl, fill)	
			
			if draw_hpvalues == true and mainmemory.read_u8(base+0x27) > 0 then
				if i < 15 or i > 20 then
					gui.text((x-5) * xm,(y-5) * ym,"HP: " .. mainmemory.read_u8(base+0x27))
				end
			end

		end
	end
end
local function scaler()
	xm = client.screenwidth() / 256
	ym = client.screenheight() / 224
end
dofile("InputOutput.lua")

getInput = {}
getJoypadString = {}

local function SetJoypadInput()
	if RequestInput()
	then
		getInput = GetInput()
		getJoypadString = GetJoypadStrings()

		local buttonsPressed = {}
		for i = 1, 12
		do
            buttonsPressed[getJoypadString[i]] = getInput[i]
			if getInput[i] == true
			then
				--output.buttonPressDuraton[i] = emu.framecount()
				gui.text(2, 64 + i * 8, string.upper(getJoypadString[i]))
			end
			--else
			--output.buttonPressDuraton[i] = emu.framecount() - output.buttonPressDuraton[i]
			--end

		end
		joypad.set(buttonsPressed, 1)
    end
end


function PopulateTable()
end

function SendData()
end

while true do
	scaler()
	if draw_megaman == true then
		megaman()
		SetJoypadInput()
		SetResults(output)
		-- SetJoypadInput()
		-- print("megaman Position X: " .. megamanPosX)
		-- print("megaman Position Y: " .. megamanPosY)
	end
	if draw_enemies == true then
	enemySpotted = draw_enemies

		enemies()
	end
	emu.frameadvance()
end