#include <iostream>
#include <mlpack/core.hpp>
#include "HelperFuncs.h"
#include "Darwin.h"
#include "ManageInputOutput.h"
int main()
{
	srand((unsigned)M_PI * time(NULL));

	const float MOVEMENT_TIMEOUT = 1;
	const float PROGRESS_TIMEOUT = 1;

	std::vector<int> savestates;

	int inputRadius = 6;
	int populationSize = 30;
	std::vector<Gene> genePerPop;


	std::vector<int> buttonIndex; // = 14;

	std::vector<int> numInputs; //
	std::vector<int> numOutputs; // = 14 -- buttons

	std::vector<int> layers{8, 12 , 12 , 12}; // input - x - x - outputs
	std::vector<int> numWeights;

	int currentPopulation;
	int currentStateIndex;
	int currentGenomeIndex;

#pragma region Checking progress
	
	int totalFrames;
	int lastMovementCounter;
	int lastProgressCounter;
	int lastMX;
	int lastMY;
	int maxMX;
	int maxMY;
	int startMX;
	int startMY;
	int MX;
	int MY;

#pragma endregion

	int globalFitnessScore;
	
	
	//-------------------------------------------------------------------
	ManageInputOutput* inputOutput = new ManageInputOutput();


	Darwin* d = new Darwin();
	HelperFuncs* h = new HelperFuncs;

	int topology = h->GetNumWeights(layers);
	d->InitPopulation(populationSize, topology);
	//d->ByMutation(d->activePopulations[0]);
	d->ByCrossover(d->activePopulations[0], d->activePopulations[12]);
	inputOutput->SetButtonInput(genePerPop);
	delete inputOutput;
	inputOutput = nullptr;
	delete d;
	d = nullptr; //TODO cleaner klass ??

	return 0;
}

#pragma region loop
void Update()
{

}

void CompleteTest()
{

}

void InitNewTest()
{

}
#pragma endregion


