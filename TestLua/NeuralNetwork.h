#pragma once
#include <cmath>
#include <vector>
#include <cstdlib>
#include <mlpack/core.hpp>


inline float Sigmoid(float x)
{
	return 1.0f / (1 + exp(-x));
}

inline float DSigmoid(float x)
{
	return (x * (1 - x));
}

class NeuralNetwork //??
{

public:


	void GenerateOutputs(int layers, int weights)
	{


	}
};

