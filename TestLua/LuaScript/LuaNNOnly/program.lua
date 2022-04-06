require "genome"
require "helperfuncs"
require "neuralnet"
require "population"


dofile("helperfuncs.lua")
local enemies = Megaman_io.enemies()


local function updateEnemies()
    enemies = Megaman_io.enemies()
end

while true
do
    updateEnemies()
    emu.frameadvance()
end