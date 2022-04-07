#pragma once
#include <vector>
#include <cmath>
#include <time.h>
#include <iostream>
#include <string>
#include "Population.h"
#include "Genome.h"
#include "HelperFuncs.h"



class Darwin
{
public:
	Population activePopulation;
	Darwin();
	~Darwin();
#pragma region genome methods

	std::vector<Gene> InitGenes(int topology);
	std::vector<Gene> LoadGenes(int topology);
	std::vector<Gene> ByMutation(Population source);
	std::vector<Gene> ByCrossover(Population mother, Population father);

#pragma endregion

#pragma region population methods

	void InitPopulation(int popSize);
	Population InitNewPopulation(int popSize);
	void LoadPopulation(int popSize);
	Gene SelectGenome(Population pop);
	void RecalculatePopulationFitness(Population pop); //klar 
	void EvolvePopulation(Population elites);
#pragma endregion

#pragma region get genomes

	Population GetActivePopulation();
	int GetGeneration();
	std::string GetGenerationString(Population pop);
	Gene GetBestGenome(Population pop);
	Gene GetWorstGenome(Population pop);
#pragma endregion
	const int layerGeneCount[4] = { 7, 12, 12, 12 };
private:
	HelperFuncs* hf;
	int generations = 0;
};

