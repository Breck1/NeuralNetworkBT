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
	std::vector<Gene> genePerPop;
	float rrandomNum = hf->GetRandomNumber();
	for(size_t i = 0; i < topology; i++)
	{
		Gene g;
		g.fitness = 0;
		g.index = i;

		g.value = hf->GetRandomNumber(i);
		genePerPop.push_back(g);


	}
	return genePerPop;
}

std::vector<Gene> Darwin::ByMutation(Population source)
{
	std::vector<Gene> gene = source.genes;
	for(int i = 0; i < gene.size(); i++)
	{
		if(hf->GetRandomNumber(i) < source.mutRate)
		{
			gene[i].value += hf->GetRandomNumber() * source.mutMax;
			gene[i].value -= hf->GetRandomNumber(i) * source.mutMax;

			//clamp value
			gene[i].value > 1 ? 1 : gene[i].value;
			gene[i].value < -1 ? -1 : gene[i].value;
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

void Darwin::InitPopulation(int popSize, int topology)
{
	for(int i = 0; i < popSize; i++)
	{
		Population p;
		p.mutMax = 0.5f;
		p.mutRate = 0.2f;
		p.numElites = 2;
		p.crossRate = 0.7f;

		p.selection = E_Selection::roulette;
		p.name = "abc " + i;
		p.genes = InitGenes(topology);

		activePopulations.push_back(p);

	}
}

std::vector<Gene> Darwin::SelectGenome(Population pop)
{

	std::vector<Gene> lmao;
	lmao.resize(pop.genes.size());

	if(pop.selection == E_Selection::roulette)
	{
		float target = hf->GetRandomNumber() * pop.totalFitness;
		float passedFitness = 0;
		for(int i = 0; i < pop.genes.size(); i++)
		{
			passedFitness += pop.genes[i].fitness;
			if(passedFitness >= target)
			{
				lmao.push_back(pop.genes[i]);
			}
		}

		return lmao;
	}
	else if(pop.selection == E_Selection::tournament)
	{
		//Hämta 4 random gener och returna
		return lmao;
	}
	return lmao;
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

}

void Darwin::EvolvePopulation(Population elites)
{	

	Population newPopulation;
	int numElites = elites.numElites;
	
	// copy elites
	for (int i = 0; i < numElites; i++)
	{
		newPopulation.genes.push_back(elites.genes[i]);
	}

	// create the rest by mutation and crossover
	while (newPopulation.genes.size() < elites.genes.size())
	{
		Population mother;
		Population father;
		Population child;
		mother.genes = SelectGenome(elites);
		father.genes = SelectGenome(elites);
		child = mother;

		if (hf->GetRandomNumber() < elites.crossRate)
			child.genes = ByCrossover(mother, father);
		
		Population mutated;
		mutated.genes = ByMutation(child);


		newPopulation = mutated;
		generations++;
	}
}
#pragma endregion

std::vector<Population> Darwin::GetActivePopulations()
{
	return activePopulations;
}
Population Darwin::GetActivePopulation(int index)
{
	return activePopulations[index];
}
int Darwin::GetActivePopulationSize()
{
	return activePopulations.size();
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

