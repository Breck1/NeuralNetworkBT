#pragma once
#include <vector>
#include <fstream>
#include <sstream>
#include "Genome.h"
#include "Population.h"

class HelperFuncs
{
	std::vector<float> megamanValues;

public:

	template <typename T>
	void Swap(T& a, T& b)
	{
		T temp = a;
		a = b;
		b = temp;
	}

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

	int GetRandomIntNumber()
	{
		return (int)rand() / RAND_MAX;
	}

	int GetRandomIntNumber(int max, int min)
	{
		return (int)rand() % (max - min + 1) + min;
	}

	E_Selection GetRandomSelection()
	{
		E_Selection val = static_cast<E_Selection>(GetRandomIntNumber(1, 0));
		return val;
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

		return genes;
	}

	std::vector<float> GenerateOutputs(std::vector<int> layers, std::vector<Gene> weights, std::vector<float> inputs)
	{
		std::vector<float> activations;
		std::vector<float> nextActivations;
		int weightIndex = 0;

		activations = inputs;
		nextActivations;  //.resize(activations.size());

		for(int i = 0; i < layers.size() - 1; i++)
		{
			for(int j = 0; j < layers[i + 1]; j++)
			{
				//set neuron activation to bias value
				nextActivations.push_back(weights[j].weight[weightIndex]);
				weightIndex++;

				for(int k = 0; k < layers[i]; k++)
				{
					//add inputs * weight 
					nextActivations[j] = weights[j].weight[weightIndex] * activations[k];
					weightIndex++;
				}

				//sigmoid
				nextActivations[j] = 1 / (1 + exp(-nextActivations[j]));
			}
			//go to next layer
			activations = nextActivations;
			nextActivations.clear();
		}

		return activations;
	}

	std::vector<float> SetMegamanXOutput()
	{
		std::vector<float> megamanXoutput;
		std::ifstream readLuaFile("LuaScript/MegamanStatus.txt");
		std::string luaLine;
		int k = 0;
		while(std::getline(readLuaFile, luaLine))
		{
			float value;

			std::stringstream ss(luaLine);

			ss >> value;
			megamanXoutput.push_back(value);
			//std::cout << "MegamanStatus.txt Line: " << " Value: " << value << std::endl;

		//for(size_t j = 0; j < 8; j++)
		//{
		//	std::cout << "MegamanStatus.txt Line: " << j << " Value: " << value << std::endl;
		//	//std::cout << j << " " << genes[k].weight[j] << std::endl;

		//}

			k++;

		}
		megamanValues = megamanXoutput;
		return megamanXoutput;

	}

	std::vector<float> GetMegamanXOutput()
	{
		return megamanValues;
	}

	std::vector<Gene> SortGenes(std::vector<Gene>& genes)
	{
		if(genes.size() == 0)
			return std::vector<Gene>();

		Gene gene = genes.front();

		int i, j;
		for(i = 0; i < genes.size() - 1; i++)
			for(j = 0; j < genes.size() - i - 1; j++)
				if(genes[j].weight < genes[j + 1].weight)
					Swap(genes[j], genes[j + 1]);
		return genes;
	}
	void LoadEmuSaveState()
	{
		std::ofstream file("LuaScript/LoadState.txt");
		std::string line = "0";

		file << line << std::endl;
		file.close();
	}
};

// Megaman State, 6 = rising, 8 = falling 14 = dashing 2 = walking
// megamanBitflags, 4 = Standing, 2 = hanging on left wall, 1 = hanging on right wall
/*
output.enemyPositionX
output.enemyPositionY
output.MX
output.MY
output.megamanHealth
output.megamanState
output.megamanBitflags
*/