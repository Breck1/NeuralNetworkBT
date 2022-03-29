#include <iostream>
#include <fstream>
#include "HelperFuncs.h"
#include "Darwin.h"
#include "ManageInputOutput.h"

#pragma region lmao globals
//struct it up
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

std::vector<float> randomTest;
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
HelperFuncs* h = new HelperFuncs;
ManageInputOutput* m = new ManageInputOutput;

void CompleteTest();
void InitNewTest();


#pragma region loop
void Update()
{
	//Some GUI stuff ??

	/*
	106 - 121 IN LUA PROJECT


	Gör inputs = std::vector<float>inputs;
	skicka till NN
	set joystick
	lessgo
	*/
	//----------------------------------------------


	//TESTING
	//----------------------------------------------


	for(int i = 0; i < 12; i++)
	{
		randomTest.push_back(h->GetRandomNumber());
	}


	m->SetButtonInput(h->GenerateOutputs(layers, d->activePopulation.genes, randomTest));
	MX = m->GetEmulatorOutput()[2];
	MY = m->GetEmulatorOutput()[3];
	//h->Load("ReadWriteTest.txt", genePerPop, 12);
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
	if (currentGenomeIndex < d->activePopulation.genes.size())

	d->activePopulation.genes[currentGenomeIndex].fitness += fitness;

	if(currentSaveStateIndex == savestates)
	{

		if (currentGenomeIndex < d->activePopulation.genes.size())
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
		if(currentGenomeIndex < d->activePopulation.genes.size())
		d->activePopulation.genes[currentGenomeIndex].fitness = 0;
		//TODO Lägg in NN här

		//--------------------------------- Random nummer för test
		for(int i = 0; i < 12; i++)
		{
			randomTest.push_back(h->GetRandomNumber());
		}


		h->GenerateOutputs(layers, d->activePopulation.genes, randomTest);
		//---------------------------------
		currentStateIndex = 1;
	}
	else
	{
		currentStateIndex++;
	}


	MX = m->GetEmulatorOutput()[2];
	MY = m->GetEmulatorOutput()[3];
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

int main()
{
	srand((unsigned)3 * time(NULL));


	//-------------------------------------------------------------------

	int topology = h->GetNumWeights(layers); // weights
	d->InitPopulation(populationSize);
	//d->LoadPopulation(populationSize);
	InitNewTest();
	while(true) //update until you lose or stand still too long
	{
	Update();
		//lua emu. frameadvance
	}
	delete d;
	d = nullptr; //TODO cleaner klass ??
	return 0;
}
