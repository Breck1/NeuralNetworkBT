#include <iostream>
#include "HelperFuncs.h"
#include "Darwin.h"

#pragma region lmao globals

const float MOVEMENT_TIMEOUT = 1;
const float PROGRESS_TIMEOUT = 1;

int savestates = 1;

int inputRadius = 6;
int populationSize = 30;
std::vector<Gene> genePerPop;


std::vector<int> buttonIndex; // = 14;

std::vector<int> numInputs; //
std::vector<int> numOutputs; // = 14 -- buttons

std::vector<int> layers{ 8, 12 , 12 , 12 }; // input - x - x - outputs
std::vector<int> numWeights;

int currentPopulation;
int currentSaveStateIndex = 1;
int currentStateIndex;
int currentGenomeIndex;

#pragma region Checking progress

int totalFrames = 0;
int lastMovementCounter = 0;
int lastProgressCounter = 0;
int lastMX = 0;
int lastMY = 0;
int maxMX = 0;
int maxMY = 0;
int startMX = 0;
int startMY = 0;
int MX = 0;
int MY = 0;

#pragma endregion

int globalFitnessScore = 0;

#pragma endregion

Darwin* d = new Darwin();

int main()
{
	srand((unsigned)M_PI * time(NULL));


	//-------------------------------------------------------------------



	HelperFuncs* h = new HelperFuncs;

	int topology = h->GetNumWeights(layers); // weights
	d->InitPopulation(populationSize);
	//d->ByMutation(d->activePopulations[0]);
	//d->ByCrossover(d->activePopulations[0], d->activePopulations[12]);
	delete d;
	d = nullptr; //TODO cleaner klass ??

	/*
	InitNewTest();
	while(true) //update until you lose or stand still too long
	{
		Update();

		//lua emu. frameadvance
	}
	*/
	


	return 0;
}

#pragma region loop
void Update()
{
	//Some GUI stuff ??

	/*
	106 - 121 IN LUA PROJECT
	mx, my = getMegaManPos;

	Gör inputs = std::vector<float>inputs;
	skicka till NN
	set joystick
	lessgo
	*/

	//----------------------------------------------
	totalFrames++;

	if(MX == 0 && MY == 0)//Kanske måste ändra värden för megaman
		CompleteTest(); //"death or completed level" -- kan inte se skillnad på dem?

	if(MX > maxMX)
	{
		lastProgressCounter = 0; //best in test
	}
	else
	{
		lastProgressCounter++;
		if(lastProgressCounter > PROGRESS_TIMEOUT)
			CompleteTest(); //Progress timeout
	}

	if(MX > maxMX)
		maxMX = MX;
	if(MY > maxMY)
		maxMY = MY;

	if(lastMX != MX || lastMY != MY)
	{
		lastMX = MX;
		lastMY = MY;
		lastMovementCounter = 0;
	}
	else
	{
		lastMovementCounter++;
		if(lastMovementCounter > MOVEMENT_TIMEOUT)
			CompleteTest(); //Movement timeout
	}
}

void CompleteTest() //klar
{
	float fitness = maxMX - startMX;

	d->activePopulation.genes[currentGenomeIndex].fitness += fitness;

	if(currentSaveStateIndex == savestates)
	{
		globalFitnessScore = std::max((int)std::floorf(d->activePopulation.genes[currentGenomeIndex].fitness), globalFitnessScore);
	}

	InitNewTest();
}

void InitNewTest()
{

	if(currentSaveStateIndex >= savestates)
	{
		if(currentGenomeIndex >= d->activePopulation.genes.size()) // fel kolla på den sen
		{
			d->RecalculatePopulationFitness(d->activePopulation);
			d->EvolvePopulation(d->activePopulation);

			currentGenomeIndex = 1;
		}
		else
		{
			currentGenomeIndex++;
		}
		d->activePopulation.genes[currentGenomeIndex].fitness = 0;
		//TODO Lägg in NN här
		currentStateIndex = 1;
	}
	else
	{
		currentStateIndex++;
	}

	//mx, my = getMegamanPos
	lastMX = MX;
	lastMY = MY;
	maxMX = MX;
	maxMY = MY;
	startMX = MX;
	startMY = MY;

	totalFrames = 0;
	lastMovementCounter = 0;
	lastProgressCounter = 0;



}
#pragma endregion


