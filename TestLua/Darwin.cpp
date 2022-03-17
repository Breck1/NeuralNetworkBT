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
//Initializes all the populations
void Darwin::InitPopulation(int popSize, int topology)
{
	for(int i = 0; i < popSize; i++)
	{
		Population p;
		p.mutMax = 0.5f;
		p.mutRate = 0.2f;
		p.numElites = 2;
		p.crossRate = 0.7f;

		p.selection = selection::roulette;
		p.name = "abc " + i;
		p.genes = InitGenes(topology);
		
		activePopulations.push_back(p);

	}
}

