#pragma once
#include <cmath>
#include <vector>
#include <cstdlib>
#include <mlpack/core.hpp>



class NeuralNetwork //??
{

public:


	std::vector<float> GenerateOutputs(int layers, std::vector<float> weights, std::vector<float> inputs)
	{
		std::vector<float> activations;
		std::vector<float> nextActivations;
		int weightIndex = 0;

		activations = inputs;
		nextActivations.resize(activations.size());

		for(int i = 0; i < layers - 1; i++)
		{
			for(int j = 0; j < layers + 1; j++)
			{
				//set neuron activation to bias value
				nextActivations[j] = weights[weightIndex];
				weightIndex++;

				for(int k = 0; k < layers; k++)
				{
					//add inputs * weight 
					nextActivations[j] = nextActivations[j] + weights[weightIndex] * activations[k];
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

};

