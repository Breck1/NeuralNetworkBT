--Author Pasky13
---------------
----GLOBALS----

buttonInput = {
left = false,
right = false,
up = false,
down = false,

b = false,
a = false,
y = false,
x = false,

l = false,
r = false,

start = false,
select = false,
}
--require "buttonInputTester"
function SetInputCPP(index, boolean)
	i = index
	buttonInput = {}
	input = 0
	buttonInput[index] = boolean

	return
end

local tileStart = 0x0300
local tileFinish = 0x04FF
local enemyStart = 0x0E68 -- 3688
local enemyFinish = 0x1228 -- 4648

local bulletsOnScreen = 0x08BB
local enemySpotted = true



local megamanPosX = 0
local megamanPosY = 0

local enemyPosX = 0
local enemyPosY = 0

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

local xm
local ym


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
	if memory ~= nil
	then
		memory.usememorydomain("CARTROM")
	end
output = {}
output.MX = 0
output.MY = 0
output.megamanHealth = 0
output.enemyPositionX = 0
output.enemyPositionY = 0
output.megamanState = 0
output.megamanBitflags = 0
output.deathPositionX = 0
function output.GetOutput()
	return self.MX
end


local megamanFalling = 8

local dead = false
function megaman()
	if mainmemory ~= nil
	then
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
			local megamanHealthAddress = 0x0BCF

			local health = mainmemory.read_u8(megamanHealthAddress)
			output.currentLevel = memory.read_s8(currentLevelData)

			output.megamanState = memory.read_s8(stateAddress)
			output.megamanBitflags = memory.read_s8(bitflags)
				megamanPosX = x + camx
				megamanPosY = y + camy

				output.megamanHealth = health

			if mainmemory.read_u8(stateAddress) ~= megamanFalling
			then
				output.MX = megamanPosX
				output.MY = megamanPosY
			end
			if facing > 0x45 
			then
				xoff = xoff * -1
			local file = io.open( "MegamanStatus.txt", "w" )
			end
		if file ~= nil
		then
			file:write(output.enemyPositionX.."\n")
			file:write(output.enemyPositionY.."\n")
			file:write(output.MX.."\n")
			file:write(output.MY.."\n")
			file:write(output.megamanHealth.."\n")
			file:write(output.megamanState.."\n") -- Megaman State address 6 = rising, 8 = falling 14 = dashing 2 = walking
			file:write(output.megamanBitflags.."\n") -- 04 = Standing, 02 = hanging on left wall, 01 = hanging on right wall
			file:close()
		end
		if gui ~= nil
		then
			gui.drawBox(x + xoff +xrad,y + yoff + yrad, x + xoff - xrad, y + yoff - yrad,0xFF0000FF,0x400000FF)
		end
	end
end

function enemies()
	if mainmemory ~= nil
	then
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
	
			if mainmemory.read_u8(base) ~= 0 -- om minnet inte är laddat så finns de inte. 
			then 
	
				if i > 14 and i < 21 
				then
					if draw_projectiles == true 
					then
						fill = 0x40FFFFFF -- vitt
						outl = 0xFFFFFFFF -- egna skott
					else
						fill = 0x40000000 -- svart
						outl = 0xFF000000 -- gör ingenting
					end
				else
					fill = 0x40FF0000 -- red
					outl = 0xFFFF0000 -- super bad enemies
				end
	
				if i > 21 
				then
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
	
				if facing > 0x45 
				then
					xoff = xoff * -1
				end
				gui.drawBox(x + xoff +xrad,y + yoff + yrad, x + xoff - xrad, y + yoff - yrad,outl, fill)
	
				if draw_hpvalues == true and mainmemory.read_u8(base+0x27) > 0 
				then
					if i < 15 or i > 20 
					then
						gui.text((x-5) * xm,(y-5) * ym,"HP: " .. mainmemory.read_u8(base+0x27))
					end
				end
			end
		end
	end
end
local function tileData()

	local tileTest = 0x2420
	local x
	local xoff
	local xtestoff
	local xrad
	local xtestrad
	local y
	local yoff
	local ytestoff
	local yrad
	local ytestrad
	local camx = mainmemory.read_u16_le(cx)
	local camy = mainmemory.read_u16_le(cy)
	local base
	local boxpointer
	local facing
	local fill
	local outl
	local start = 0x0300 --3688
	local oend = 64

	x = mainmemory.read_u16_le(base + 5) - camx
	y = mainmemory.read_u16_le(base + 8) - camy
	boxpointer = mainmemory.read_u16_le(base +0x20) + 0x28000

	fill = 0x40000000 -- svart
	outl = 0xFF000000 -- gör ingenting
	for i = 0, 0x028, 1 
	do
		testPointer = memory.read_u16_le(tileTest + i);
		print("for loop i value: " ..i)
		print("TestPointer: "..testPointer)
	end

	xtestoff = memory.read_s8(testPointer + 0)
	ytestoff = memory.read_s8(testPointer + 1)
	xtestrad = memory.read_u8(testPointer + 2)
	ytestrad = memory.read_u8(testPointer + 3)
	gui.drawBox(x + xtestoff +xtestrad,y + ytestoff + ytestrad,x + xtestoff - xtestrad,y + ytestoff - ytestrad,outl, fill)

end
function scaler()
	if client ~= nil
	then
		xm = client.screenwidth() / 256
		ym = client.screenheight() / 224
	end
end
--dofile("InputOutput.lua")
getJoypadString = {}
joypadString = {}
joypadString[1] = "Up"
joypadString[2] = "Down"
joypadString[3] = "Left"
joypadString[4] = "Right"

joypadString[5] = "B"
joypadString[6] = "A"
joypadString[7] = "Y"
joypadString[8] = "X"

joypadString[9] = "L"
joypadString[10] = "R"

joypadString[11] = "Start"
joypadString[12] = "Select"

local function SetJoypadInput()

		getJoypadString = joypadString

		local getInput = {}
		--getInput = buttonInput
		local buttonsPressed = {}
		index = 1
		for i, v in pairs(buttonInput)
		do
			getInput[index] = v
			index = index + 1
		end

		for i = 1, 12
		do
			buttonsPressed[getJoypadString[i]] = getInput[i]
			print(getInput[i])
			if gui ~= nil
			then
				gui.text(2, 64 + i * 8, string.upper(getJoypadString[i]))
			end
		end
		if joypad ~= nil
		then
			joypad.set(buttonsPressed, 1)
		end
end

--local binput2 = ButtonInput2.new(12)
if mainmemory ~= nil
then
while true do
	scaler()
	if draw_megaman == true then
		megaman()
		SetJoypadInput()
	end
	if draw_enemies == true 
	then
		enemySpotted = draw_enemies
		enemies()
	end
	if emu ~= nil
	then
		emu.frameadvance()
	end
	end
end