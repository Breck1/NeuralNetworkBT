#include "Darwin.h"

Darwin::Darwin()
{
	hf = new HelperFuncs();
}

Darwin::~Darwin()
{
	delete hf;
	hf = nullptr;
}

#pragma region genome methods

std::vector<Gene> Darwin::InitGenes(int topology)
{
	std::vector<int> layers = { 8, 12, 12, 12 };
	std::vector<Gene> genePerPop;

	for(size_t i = 0; i < topology; i++)
	{
		Gene g;
		g.fitness = 0;
		g.index = i;

		for(int j = 0; j < hf->GetNumWeights(layers); j++) // fix with proper vector.
		{
			g.weight.push_back(hf->GetRandomNumber(j));
			//std::cout << g.weight[j] << " lmao" << std::endl;
		}
			genePerPop.push_back(g);

	}
	
	hf->Save("ReadWriteTest.txt", genePerPop);
	return genePerPop;
}

std::vector<Gene> Darwin::LoadGenes(int topology)
{
	std::vector<int> layers = { 0, 0, 0, 0 };
	std::vector<Gene> genePerPop;

	for(size_t i = 0; i < topology; i++)
	{
		Gene g;
		g.fitness = 0;
		g.index = i;
		//läs varje rad typ
		g.weight = hf->Load("ReadWriteTest.txt", g.weight);

		for(size_t i = 0; i < g.weight.size(); i++)
		{
			std::cout << i << " " << g.weight[i] << std::endl;
		}
	}
	return std::vector<Gene>();
}

std::vector<Gene> Darwin::ByMutation(Population source)
{
	std::vector<Gene> gene = source.genes;
	for(int i = 0; i < gene.size(); i++)
	{
		if(hf->GetRandomNumber(i) < source.mutRate)
		{
			for(int j = 0; j < gene[i].weight.size(); j++)
			{
				gene[i].weight[j] += hf->GetRandomNumber() * source.mutMax;
				gene[i].weight[j] -= hf->GetRandomNumber(i) * source.mutMax;

				//clamp value
				gene[i].weight[j] > 1 ? 1 : gene[i].weight[j];
				gene[i].weight[j] < -1 ? -1 : gene[i].weight[j];

			}
		}
	}

	return gene;
}

std::vector<Gene> Darwin::ByCrossover(Population mother, Population father)
{
	std::vector<Gene> genes;
	int length = mother.genes.size();
	int point = hf->GetRandomNumber();
	genes.resize(length);
	if(length != father.genes.size())
		return std::vector<Gene>();
	for(int i = 0; i < length; i++)
	{
		if(i < point)
			genes[i] = mother.genes[i];
		else
			genes[i] = father.genes[i];
	}
	return genes;
}

#pragma endregion

#pragma region population methods

void Darwin::InitPopulation(int popSize)
{
	Population p;
	p.mutMax = 0.5f;
	p.mutRate = 0.2f;
	p.numElites = 2;
	p.crossRate = 0.7f;

	p.selection = E_Selection::roulette; //rand 1-2 ??
	p.name = "";
	p.genes = InitGenes(popSize);

	activePopulation = p;
}

void Darwin::LoadPopulation(int popSize)
{
	Population p;
	p.mutMax = 0.5f;
	p.mutRate = 0.2f;
	p.numElites = 2;
	p.crossRate = 0.7f;

	p.selection = E_Selection::roulette; //rand 1-2 ??
	p.name = "";
	p.genes = LoadGenes(popSize);

	activePopulation = p;
}

Gene Darwin::SelectGenome(Population pop)
{

	std::vector<Gene> selectedGenome;
	selectedGenome.resize(pop.genes.size());

	if(pop.selection == E_Selection::roulette)
	{
		float target = hf->GetRandomNumber() * pop.totalFitness;
		float passedFitness = 0;
		for(int i = 0; i < pop.genes.size(); i++)
		{
			passedFitness += pop.genes[i].fitness;
			if(passedFitness >= target)
			{
				selectedGenome.push_back(pop.genes[i]);
				break;
			}
		}
	}
	else if(pop.selection == E_Selection::tournament)
	{
		for(int i = 0; i < 3; i++)
		{
			selectedGenome.push_back(pop.genes[hf->GetRandomNumber(i)]);
		}
		//sortera 
	}
	return selectedGenome.back();
}

void Darwin::RecalculatePopulationFitness(Population pop)
{
	float tempMinFit = 10000; //big because might use float max later
	float tempMaxFit = -1; //might use epsilon later

	for(int i = 0; i < pop.genes.size(); i++)
	{
		pop.totalFitness += pop.genes[i].fitness;

		if(pop.genes[i].fitness > tempMaxFit)
			tempMaxFit = pop.genes[i].fitness;
		if(pop.genes[i].fitness < tempMinFit)
			tempMinFit = pop.genes[i].fitness;
	}

	pop.avgFitness = pop.totalFitness / pop.genes.size();
	pop.maxFitness = tempMaxFit;
	pop.minFitness = tempMinFit;
	//sort

}

void Darwin::EvolvePopulation(Population elites)
{

	Population newPopulation;
	int numElites = elites.numElites;

	// copy elites
	for(int i = 0; i < numElites; i++)
	{
		newPopulation.genes.push_back(elites.genes[i]);
	}

	Population mutated;
	// create the rest by mutation and crossover
	while(newPopulation.genes.size() < elites.genes.size())
	{
		Population mother;
		Population father;
		Population child;
		mother.genes.push_back(SelectGenome(elites));
		father.genes.push_back(SelectGenome(elites));
		child = mother;

		if(hf->GetRandomNumber() < elites.crossRate)
			child.genes = ByCrossover(mother, father);

		mutated.genes = ByMutation(child);

		newPopulation = mutated;
	}

	elites.genes = newPopulation.genes;
	generations++;
}
#pragma endregion


#pragma region gettersNsetters
Population Darwin::GetActivePopulation()
{
	return activePopulation;
}


int Darwin::GetGeneration()
{
	return generations;
}
std::string Darwin::GetGenerationString(Population pop)
{
	std::string generationString = "Generations: ";
	generationString += std::to_string(generations);
	generationString += " max: ";
	generationString += std::to_string(pop.maxFitness);
	generationString += " avg: ";
	generationString += std::to_string(pop.avgFitness);
	return generationString;
}
Gene Darwin::GetBestGenome(Population pop)
{
	return pop.genes[0];
}
Gene Darwin::GetWorstGenome(Population pop)
{
	return pop.genes.back();
}
#pragma endregion

