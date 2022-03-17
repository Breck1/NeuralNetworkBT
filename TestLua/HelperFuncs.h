#pragma once
#include <vector>
#include "Genome.h"
class HelperFuncs
{

public:

	int GetNumWeights(std::vector<int> topology)
	{
		int num = 0;

		for(size_t i = 0; i < topology.size() - 1; i++)
		{
			num = num + ((topology[i] + 1) * topology[i + 1]);
		}

		return num;
	}

	float GetRandomNumber(int i)
	{
		return (float)rand() / RAND_MAX;

	}
	float GetRandomNumber()
	{

		return (float)rand() / RAND_MAX;

	}
	std::vector<Gene> SortGenes(std::vector<Gene>& genes)
	{
		if (genes.size() == 0)
			return std::vector<Gene>();
		Gene gene = genes.front();
		
		int i, j;
		for (i = 0; i < genes.size() - 1; i++)
			for (j = 0; j < genes.size() - i - 1; j++)
				if (genes[j].value < genes[j + 1].value)
					std::swap(genes[j], genes[j + 1]);
		return genes;
	}
};
