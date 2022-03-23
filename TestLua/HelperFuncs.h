#pragma once
#include <vector>
#include <fstream>
#include <sstream>
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
			for(size_t j = 0; j < genes[i].weight.size(); j++)
			{
				file << genes[i].weight[j] << " ";

			}
			file << std::endl;
		}

		file.close();
	}


	std::vector<Gene> Load(std::string path, std::vector<Gene> genes, int size)
	{
		//Fixa så den läser varje rad
		std::ifstream file(path);
		std::string line;
		genes.resize(size);
		int i = 0;
		while(std::getline(file, line))
		{
			float value;
			
			std::stringstream ss(line);
			
				for (size_t j = 0; j < 420; j++)
				{
					ss >> value;
					genes[i].weight.push_back(value);
					std::cout << j << " " << genes[i].weight[j] << std::endl;

				}
				i++;
			
		}


		return genes;
	}

};
