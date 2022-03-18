#pragma once
#include <vector>
#include <cmath>
#include <time.h>
#include <iostream>
#include "Population.h"
#include "Genome.h"
#include "NeuralNetwork.h"
#include "HelperFuncs.h"

class Darwin
{
public:
	std::vector<Population> activePopulations;
	Darwin();
	~Darwin();
#pragma region genome methods

	std::vector<Gene> InitGenes(int topology);
	std::vector<Gene> ByMutation(Population source);
	std::vector<Gene> ByCrossover(Population mother, Population father);

#pragma endregion

#pragma region population methods

	void InitPopulation(int popSize, int topology);
	Gene SelectGenome(Population pop);
	void RecalculatePopulationFitness(Population pop); //klar 
	void EvolvePopulation(Population elites);
#pragma endregion

#pragma region get genomes

    std::vector<Population>GetActivePopulations();
    Population GetActivePopulation(int index);
    int GetActivePopulationSize();
    int GetGeneration();
	std::string GetGenerationString(Population pop);
	Gene GetBestGenome(Population pop);
	Gene GetWorstGenome(Population pop);
#pragma endregion
private:
	HelperFuncs* hf;
	int generations = 0;
};

