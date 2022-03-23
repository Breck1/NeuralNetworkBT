#pragma once
#include <vector>
#include <fstream>
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

	void Save(std::string name, std::vector<Gene> genes)
	{
		std::ofstream file(name);


		if(!file.is_open())
			return;
		
		for(size_t i = 0; i < genes.size(); i++)
		{
			for (size_t j = 0; j < genes[i].weight.size(); j++)
			{
				file << genes[i].weight[j] << " ";

			}
			file << std::endl;
		}
		
		file.close();
	}


	std::vector<float> Load(std::string path, std::vector<float> weights)
	{
		//Fixa så den läser varje rad
		std::ifstream file(path);

		float value;
		while(file >> value) // returns file
		{
			weights.push_back(value);
		}
		return weights;
	}

};
