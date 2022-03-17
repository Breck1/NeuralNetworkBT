#pragma once
#include <vector>
#include <cmath>
#include <time.h>
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
	std::vector<Gene> SelectGenome(Population pop);
	void RecalculatePopulationFitness(Population pop); //klar 
	void EvolvePopulation();
#pragma endregion

private:
	HelperFuncs* hf;

};

