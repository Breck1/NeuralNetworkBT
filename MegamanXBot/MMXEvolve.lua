dofile("MMXHelperFunctions.lua")

temp = 0
generations = 0
activePopulation = {}
activePopulation = Population
function InitGenes(topology)

	if topology ~= nil
	then	
		--number = topology
	end
		layers = { layerGeneCount[1], layerGeneCount[2], layerGeneCount[3], layerGeneCount[4] }
		genePerPopulation = {}
		for t = 1, topology
		do
			
			gene = {}
			gene.fitness = 0
			gene.index = t
			gene.weight = {}
			for j = 0, GetNumWeights(layers)--fix with proper vector.
			do
				table.insert(gene.weight, math.random())
				
			end	
			table.insert(genePerPopulation, gene)
		end
		return genePerPopulation;
end

function InitPopulation(populationSize)

	population = {}
	population.avgFitness = 0
	population.maxFitness = 0
	population.minFitness = 0
	population.totalFitness = 0
	population.mutMax = 0.5
	population.mutRate = 0.2
	population.numElites = 2
	population.crossRate = 0.7

	population.selection = math.random()
	population.name = ""
	population.genes = InitGenes(populationSize)

	activePopulation = population
end

function LoadPopulation(populationSize)

	population = {}

	population.mutMax = 0.5
	population.mutRate = 0.2
	population.numElites = 2
	population.crossRate = 0.7


	population.selection = GetRandomSelection()
	population.name = ""
	population.genes = LoadGenes(populationSize)

	activePopulation = population
end


function InitNewPopulation(populationSize)

	population = {}
	population.avgFitness = 0
	population.maxFitness = 0
	population.minFitness = 0
	population.totalFitness = 0
	population.mutMax = 0.5
	population.mutRate = 0.2
	population.numElites = 2
	population.crossRate = 0.7

	population.selection = math.random(0, 1);
	population.name = ""
	population.genes = InitGenes(populationSize)

	activePopulation = population

	return population
end
function SelectGenome(population)


    selectedGenome = {}
	selectedGenome.resize(popopulation.genes.size())

	if popopulation.selection == E_Selection.roulette
	then
		target = GetRandomNumber() * popopulation.totalFitness
		passedFitness = 0
		for i = 1, i < #popopulation, 1
		do
			passedFitness = passedFitness + popopulation.genes[i].fitness
			if passedFitness >= target
			then
				 table.insert(selectedGenome, popopulation.genes[i])
				break
            end
		end
	
	elseif popopulation.selection == E_Selection.tournament
	then
		for i = 1, i < 4, 1
		do
			table.insert(selectedGenome, popopulation.genes[GetRandomNumber(i)])
        end
		helpFunctions.SortGenes(selectedGenome) --Otestat
	end
	return selectedGenome[#selectedGenome]
end
function ByMutation(source)
	gene = source.genes;
	for i = 1, i < #gene, 1
	do
		if helpFunctions.GetRandomNumber(i) < source.mutRate
		then
			for j = 0, j < #gene[i].weight, 1  
			do
				gene[i].weight[j] = gene[i].weight[j] + GetRandomNumber() * source.mutMax
				gene[i].weight[j] = gene[i].weight[j] - GetRandomNumber(i) * source.mutMax

				--clamp value
                
				if gene[i].weight[j] > 1 
                then 
                    gene[i].weight[j] = 1
                end
				if gene[i].weight[j] < -1 
                then
                    gene[i].weight[j] = -1
                end
            end
		end
	end

	return gene;
end

function ByCrossover(mother, father)
	genes = {}
	length = #mother.genes
	point = GetRandomNumber()
	
	if length ~= #father.genes
    then
        Gene = {}
		return Gene
    end
	for i = 1, i < length, 1
	do
		if i < point
        then
			genes[i] = mother.genes[i]
		else
			genes[i] = father.genes[i]
        end
    end
	return genes;
end
function EvolvePopulation(populationElites)


	newPopulation = {}
	
	numElites = #populationElites
	--copy elites
	mutated = InitNewPopulation(30);
	for i = 1, numElites
	do
		newPopulation.genes.push_back(elites.genes[i]);
		mother = InitNewPopulation(30);
		father = InitNewPopulation(30);
		child = {}
		mother.genes[#mother.genes - 1] = SelectGenome(elites);
		father.genes[#father.genes - 1] = SelectGenome(elites);
		child = mother;

		if GetRandomNumber() < elites.crossRate
        then
			child.genes = ByCrossover(mother, father)
        end
		mutated.genes = ByMutation(child)

		newPopulation = mutated;
    end 

	genes = newPopulation.genes
	generations = generations + 1
end