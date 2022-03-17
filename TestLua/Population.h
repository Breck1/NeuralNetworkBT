#pragma once
#include "Genome.h"
#include <vector>
#include <iostream>

enum E_Selection : int
{
	roulette,
	tournament
};

struct Population
{
public:

	float maxFitness;
	float minFitness;
	float avgFitness;
	float totalFitness;

	int numElites; //bästa boisen
	float crossRate;
	float mutRate;
	float mutMax;

	std::string name;

	E_Selection selection;
	std::vector<Gene> genes;

};