
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

resultOnDeath = {}
-- dPad
local buttonAmount = 12
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
--results = {0, 0, 0, 0, 0, 0, 0}

local i = 1
inputRequestGranted = false
resultRequestGranted = false

function SetInputCPP(index, boolean)
	i = index
	input = 0
	buttonInput[index] = boolean
	if buttonInput[index] == true 
	then
		input = 1
	local files = io.open("ButtonInput.txt", "w")
	files:write(input.."\n")
	files:close()
		print("[LUA: InputOutput SetInputCPP: buttonInput["..index.. "] is true\n")
		
	else
		print("[LUA: InputOutput temp: buttonInput["..index.. "] is false\n")
		input = 0
		local files = io.open("ButtonInput.txt", "w")
		files:write(input.."\n")
		files:close()
		
	end
	inputRequestGranted = true
	return
end

function RequestInput()
	return inputRequestGranted 
end

function GetInput(index)
	--if inputRequestGranted == true
	--then
		--inputRequestGranted = false
	--end

	return buttonInput[index]
end
function GetJoypadStrings()
	return joypadString
end

--function SetResults(resultsTable)
--	results = resultsTable	
--	resultRequestGranted = true
--end

function RequestResults()
	return resultRequestGranted
end

function GetResults()
	return results 
end
function GetDeathTable()
	return resultOnDeath
end