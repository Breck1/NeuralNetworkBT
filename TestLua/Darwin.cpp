#include "Darwin.h"
#include <iostream>
#include <string>

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
	std::vector<int> layers = { layerGeneCount[0], layerGeneCount[1], layerGeneCount[2], layerGeneCount[3] };
	std::vector<Gene> genePerPop;

	for(size_t i = 0; i < topology; i++)
	{
		Gene g;
		g.fitness = 0;
		g.index = i;

		for(int j = 0; j < hf->GetNumWeights(layers); j++) // fix with proper vector.
		{
			g.weight.push_back(hf->GetRandomNumber(j));
		}
		genePerPop.push_back(g);

	}

	hf->Save("ReadWriteTest.txt", genePerPop);
	return genePerPop;
}

std::vector<Gene> Darwin::LoadGenes(int topology)
{
	std::vector<int> layers = { layerGeneCount[0], layerGeneCount[1], layerGeneCount[2], layerGeneCount[3] };
	std::vector<Gene> genePerPop;

	for(size_t i = 0; i < topology; i++)
	{
		Gene g;
		g.fitness = 0;
		g.index = i;
	}
	genePerPop = hf->Load("ReadWriteTest.txt", genePerPop, hf->GetNumWeights(layers));
	return genePerPop;
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
	p.avgFitness = 0;
	p.maxFitness = 0;
	p.minFitness = 0;
	p.totalFitness = 0;
	p.mutMax = 0.5f;
	p.mutRate = 0.2f;
	p.numElites = 2;
	p.crossRate = 0.7f;

	p.selection = hf->GetRandomSelection();
	p.name = "";
	p.genes = InitGenes(popSize);

	activePopulation = p;
}

Population Darwin::InitNewPopulation(int popsize)
{
	Population p;
	p.avgFitness = 0;
	p.maxFitness = 0;
	p.minFitness = 0;
	p.totalFitness = 0;
	p.mutMax = 0.5f;
	p.mutRate = 0.2f;
	p.numElites = 2;
	p.crossRate = 0.7f;

	p.selection = hf->GetRandomSelection();
	p.name = "";
	p.genes = InitGenes(popsize);

	activePopulation = p;

	return p;
}

void Darwin::LoadPopulation(int popSize)
{
	Population p;

	p.mutMax = 0.5f;
	p.mutRate = 0.2f;
	p.numElites = 2;
	p.crossRate = 0.7f;


	p.selection = hf->GetRandomSelection();
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
		hf->SortGenes(selectedGenome); //Otestat
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
	if(pop.totalFitness != 0)
		pop.avgFitness = pop.totalFitness / pop.genes.size();

	pop.maxFitness = tempMaxFit;
	pop.minFitness = tempMinFit;
	hf->SortGenes(pop.genes); //Otestat

}

void Darwin::EvolvePopulation(Population elites)
{

	Population newPopulation;
	int numElites = elites.numElites;

	// copy elites
	Population mutated = InitNewPopulation(30);
	for(int i = 0; i < numElites; i++)
	{
		newPopulation.genes.push_back(elites.genes[i]);
		Population mother = InitNewPopulation(30);
		Population father = InitNewPopulation(30);
		Population child;
		mother.genes[mother.genes.size() - 1] = SelectGenome(elites);
		father.genes[father.genes.size() - 1] = SelectGenome(elites);
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


