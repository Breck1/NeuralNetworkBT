dofile("MMXHelperFunctions.lua")
dofile("MMXEvolve.lua")
StateName = "MMX.state"
activePopulation = Population
layerGeneCount= { [1] = 7, [2] = 12, [3] = 12, [4] = 12 };
MOVEMENT_TIMEOUT = 60
PROGRESS_TIMEOUT = 60
testCounter = 0
populationCounter = 0
savestates = 1

inputRadius = 6
populationSize = 30
genePerPop = {}

buttonIndex = {} 

numInputs = {}
numOutputs = {} -- buttons

layers =
{ 
	layerGeneCount[1],
	layerGeneCount[2], 
	layerGeneCount[3], 
	layerGeneCount[4] 
} -- input - x - x - outputs
numWeights = {}
randomTest = {}
pressButton = {}
pressButton[1] = 0
pressButton[2] = 0
pressButton[3] = 0
pressButton[4] = 0
pressButton[5] = 0
pressButton[6] = 0
pressButton[7] = 0
pressButton[8] = 0
pressButton[9] = 0
pressButton[10] = 0

inputs = {}
currentPopulation = 0
currentSaveStateIndex = 1
currentStateIndex = 0
currentGenomeIndex = 0 

buttonAmount = 10
totalFrames = 0
lastMovementCounter = 0
lastProgressCounter = 0
lastMX = 0
lastMY = 0
maxMX = 0
maxMY = 0
startMX = 0
startMY = 0
MX = 0
MY = 0
MHealth = 0

function RecalculatePopulationFitness(population)

	tempMinFit = 10000 --big because might use float max later
	tempMaxFit = -1 --might use epsilon later

	for i = 1, #population
	do
		population.totalFitness = population.totalFitness + population.genes[i].fitness

		if population.genes[i].fitness > tempMaxFit 
        then
			tempMaxFit = population.genes[i].fitness
        end
		if population.genes[i].fitness < tempMinFit
        then
			tempMinFit = population.genes[i].fitness
        end
	end
	if population.totalFitness ~= 0
    then
		population.avgFitness = population.totalFitness / #population
    end
	population.maxFitness = tempMaxFit
	population.minFitness = tempMinFit
	SortGenes(population.genes); --Otestat

end

function GetActivePopulation()
	return activePopulation
end


function GetGeneration()

	return generations
end
function GetGenerationString(population)

	generationString = "Generations: "
	generationString = generationString..generations
	generationString = generationString.." max: "
	generationString = generationString..popopulation.maxFitness
	generationString = generationString.." avg: "
	generationString = generationString..popopulation.avgFitness
	return generationString;
end
function GetBestGenome(population)

	return popopulation.genes[1]
end
function GetWorstGenome(population) 
	return population[#popopulation]
end

function Update()
	
    
	if (#output > 0)
	then
		pressButton =  GenerateOutputs(layers, activePopulation.genes[testCounter], output)
		MX = output[1]
		MY = output[2]
		MHealth = output[3]
    end

	--helpFunctions.Load("ReadWriteTest.txt", genePerPop, 12);
	----------------------------------------------
	totalFrames = totalFrames + 1;

	if MX == 0 and MY == 0 -- Kanske m�ste �ndra v�rden f�r megaman
    then
		CompleteTest() --"death or completed level" -- kan inte se skillnad p� dem?
    end
	if MX > maxMX
	then
		lastProgressCounter = 0 --best in test	
	else
		lastProgressCounter = lastProgressCounter + 1
		if lastProgressCounter > PROGRESS_TIMEOUT
        then
			CompleteTest() --Progress timeout
        end
    end 

	if MX > maxMX
    then
		maxMX = MX
    end
	if MY > maxMY
    then
		maxMY = MY
    end
	if lastMX ~= MX or lastMY ~= MY
	then
		lastMX = MX;
		lastMY = MY;
		lastMovementCounter = 0
	
	else
	
		lastMovementCounter = lastMovementCounter + 1
		if lastMovementCounter > MOVEMENT_TIMEOUT
		then
			CompleteTest() --Movement timeout
    	end 	
	end
end

function InitNextTest()

	savestate.load(StateName)
	
	if currentSaveStateIndex >= savestates
	then
		if currentGenomeIndex >= #activePopulation.genes -- fel kolla p� den sen
		then
			RecalculatePopulationFitness(activePopulation);
			EvolvePopulation(activePopulation);
			populationCounter = populationCounter + 1

			print("New population generated")
			print( "Population number: "..populationCounter)

			currentGenomeIndex = 1
		
		else
		
			currentGenomeIndex = currentGenomeIndex + 1
        end
		if currentGenomeIndex < #activePopulation.genes
        then
			activePopulation.genes[currentGenomeIndex].fitness = 0
		end
		currentStateIndex = 1
	else
        
        currentStateIndex = currentStateIndex + 1
        
    end

	

	if #output > 0
	then

		MX = output[1]
		MY = inputs[2]
		lastMX = MX
		lastMY = MY
		maxMX = MX
		maxMY = MY
		startMX = MX
		startMY = MY

    end 

	totalFrames = 0
	lastMovementCounter = 0
	lastProgressCounter = 0

end

function CompleteTest() --klar

	testCounter = testCounter + 1

	if testCounter >= populationSize
    then
		testCounter = 1
	end
    print("Population number "..populationCounter.." has finsihed their "..testCounter.." test\n")
	for i = 1, #pressButton
	do
		print("At index: "..i.." pressButton is: "..pressButton[i])
    end 
	firstTest = false
	fitness = maxMX - startMX
	if currentGenomeIndex < #activePopulation.genes
    then
        activePopulation.genes[currentGenomeIndex].fitness = activePopulation.genes[currentGenomeIndex].fitness + fitness
    end
	if currentSaveStateIndex == savestates 
	then
		if currentGenomeIndex < #activePopulation.genes
		then	
            globalFitnessScore = math.max(activePopulation.genes[currentGenomeIndex].fitness, globalFitnessScore)
        end
	end
	InitNextTest()
end