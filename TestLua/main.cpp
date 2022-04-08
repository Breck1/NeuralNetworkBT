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

Darwin darwin;
std::vector<int> layers
{ 
	darwin.layerGeneCount[0],
	darwin.layerGeneCount[1], 
	darwin.layerGeneCount[2], 
	darwin.layerGeneCount[3] 
}; // input - x - x - outputs
std::vector<int> numWeights;
std::vector<float> randomTest;
std::vector<float> pressButton;
std::vector<float> inputs;
int currentPopulation;
int currentSaveStateIndex = 1;
int currentStateIndex;
int currentGenomeIndex;

#pragma region Checking progress
int buttonAmount = 10;
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
int MHealth = 0;

#pragma endregion

int globalFitnessScore = 0;

#pragma endregion

Darwin* d = new Darwin();
HelperFuncs* h = new HelperFuncs;
ManageInputOutput* m = new ManageInputOutput;

void CompleteTest();
void InitNextTest();

clock_t oldTime = 0;
clock_t curTime;
clock_t deltaTime;
int testCounter = 0;
int populationCounter = 0;
bool firstTest = true;
#pragma region loop
void Update()
{
	deltaTime = clock() - oldTime;

	inputs = h->SetMegamanXOutput();

	if (inputs.size() > 0)
	{
		pressButton = h->GenerateOutputs(layers, d->activePopulation.genes[testCounter], inputs);
		m->SetButtonInput(pressButton);
		MX = h->GetMegamanXOutput()[0];
		MY = h->GetMegamanXOutput()[1];
		MHealth = h->GetMegamanXOutput()[2];
	}

	//h->Load("ReadWriteTest.txt", genePerPop, 12);
	//----------------------------------------------
	totalFrames++;

	if(MX == 0 && MY == 0)//Kanske m�ste �ndra v�rden f�r megaman
		CompleteTest(); //"death or completed level" -- kan inte se skillnad p� dem?

	if(MX > maxMX)
	{
		lastProgressCounter = 0; //best in test
	}
	else
	{
		lastProgressCounter+= deltaTime;
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
		lastMovementCounter += deltaTime;
		if(lastMovementCounter > MOVEMENT_TIMEOUT)
			CompleteTest(); //Movement timeout
	}
	oldTime = clock();
}

void CompleteTest() //klar
{
	testCounter++;

	if (testCounter >= populationSize)
		testCounter = 0;
	std::cout << "Population number " << populationCounter + 1 << " has finsihed their " << testCounter << " test" << std::endl;
	for (int i = 0; i < pressButton.size(); i++)
	{
		std::cout << "At index: " << i << " pressButton is: " << pressButton[i] << std::endl;
	}
	firstTest = false;
	float fitness = maxMX - startMX;
	if(currentGenomeIndex < d->activePopulation.genes.size())
		d->activePopulation.genes[currentGenomeIndex].fitness += fitness;

	if(currentSaveStateIndex == savestates)
	{
		if(currentGenomeIndex < d->activePopulation.genes.size())
			globalFitnessScore = std::max((int)std::floorf(d->activePopulation.genes[currentGenomeIndex].fitness), globalFitnessScore);
	}

	InitNextTest();
}

void InitNextTest()
{
	h->LoadEmuSaveState();
	inputs = h->SetMegamanXOutput();
	if(currentSaveStateIndex >= savestates)
	{
		if(currentGenomeIndex >= d->activePopulation.genes.size()) // fel kolla p� den sen
		{
			d->RecalculatePopulationFitness(d->activePopulation);
			d->EvolvePopulation(d->activePopulation);
			populationCounter++;

			std::cout << "New population generated\n";
			std::cout << "Population number: " << populationCounter << std::endl;

			currentGenomeIndex = 1;
		}
		else
		{
			currentGenomeIndex++;
		}
		if(currentGenomeIndex < d->activePopulation.genes.size())
			d->activePopulation.genes[currentGenomeIndex].fitness = 0;
		
		currentStateIndex = 1;
	}
	else
	{
		currentStateIndex++;
	}

	inputs = h->GetMegamanXOutput();

	if (inputs.size() > 0)
	{

		MX = inputs[0];
		MY = inputs[1];
		lastMX = MX;
		lastMY = MY;
		maxMX = MX;
		maxMY = MY;
		startMX = MX;
		startMY = MY;

	}
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
	InitNextTest();
	
	while(true) //update until you lose or stand still too long
	{
		Update();
		//lua emu. frameadvance
	}
	
	delete d;
	d = nullptr; //TODO cleaner klass ??
	return 0;
}
