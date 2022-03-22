

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
results = {0, 0, 0, 0, 0, 0, 0}

local i = 1
inputRequestGranted = false
resultRequestGranted = false

function SetInputCPP(index, boolean)

	i = index
	buttonInput[index] = boolean
	if buttonInput[index] == true 
	then
		print("[LUA: InputOutput SetInputCPP: buttonInput["..index.. "] is true\n")
		
	else
		print("[LUA: InputOutput temp: buttonInput["..index.. "] is false\n")
		print(buttonInput.left)
		
	end
	inputRequestGranted = true
	return
end

function RequestInput()
	return inputRequestGranted 
end

function GetInput()
	if inputRequestGranted == true
	then
		inputRequestGranted = false
	end
	return buttonInput
end
function GetJoypadStrings()
	return joypadString
end

function SetResults(resultsTable)
	results = resultsTable	
	resultRequestGranted = true
end

function RequestResults()
	return resultRequestGranted
end

function GetResults()
	if resultRequestGranted == true
	then
		resultRequestGranted = false
	end
	return results 
end
function GetDeathTable()
	return resultOnDeath
end
function SetOnDeath(deathTable)
	resultOnDeath = deathTable
end