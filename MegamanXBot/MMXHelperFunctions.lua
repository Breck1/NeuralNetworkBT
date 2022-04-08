

Gene =
{

	fitness = 0,
	index = 0,
	weight = {},
}

Population =
{
	maxFitness,
	minFitness,
	avgFitness,
	totalFitness,

	numElites, --bästa boisen
	crossRate,
	mutRate,
	mutMax,

	name,

	selection,
	genes = {}

}
topologyCount = 0
	
function Swap(a, b)
	
	temp = a;
	a = b;
	b = temp;

    return a, b
end

function GetNumWeights(topology)
	num = 0

	for i = 1, #topology - 1, 1
	do
		num = num + ((topology[i] + 1) * topology[i + 1])
    end 
	return num;
end

	
function GenerateOutputs(layers, weights, inputs)
	local activations = {}
	local nextActivations = {}
	local weightIndex = 0

    activations = inputs

	for i = 1, #layers - 1, 1
	do
		for j = 1, layers[i + 1], 1
		do
			--set neuron activation to bias value
			table.insert(nextActivations, weights.weight[weightIndex])
			weightIndex = weightIndex + 1
			for k = 1, k < layers[i], 1
			do
				--add inputs * weight 
				nextActivations[j] = weights.weight[weightIndex] * activations[k]
				weightIndex = weightIndex + 1
            end

				--sigmoid
			nextActivations[j] = 1 / (1 + math.exp(-nextActivations[j]))
		end
		--go to next layer
		activations = nextActivations;
		nextActivations = {}
	end
	return activations
end

function GetMegamanXOutput()
	return megamanValues
end

function SortGenes(genes)
	
	if #genes == 0
    then
        local Genes = {}
		return Genes
    end
    
	local gene = genes[1]

	for i = 1,#genes - 1
    do
		for j = 1, #genes - i - 1	
        do
			if genes[j].weight < genes[j + 1].weight
			then	
                Swap(genes[j], genes[j + 1])
            end
        end
    end
	return genes
end

-- Megaman State, 6 = rising, 8 = falling 14 = dashing 2 = walking
-- megamanBitflags, 4 = Standing, 2 = hanging on left wall, 1 = hanging on right wall
