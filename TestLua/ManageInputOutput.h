#pragma once
#include <vector>
#include <iostream>
#include "Genome.h"
extern "C"
{
#include "Lua542/include/lua.h"
#include "Lua542/include/lauxlib.h"
#include "Lua542/include/lualib.h"
}
struct EmulatorOutput
{
	float enemyPositionX = 0;
	float enemyPositionY = 0;
	float currentLevel = 0;

	float megamanState = 0;
	float megamanBitflags = 0;
	float tileDirection = 0;

	float distanceFromStartPosition = 0;
};
class ManageInputOutput
{
public:
	void SetEmulatorResults();
	EmulatorOutput GetEmulatorOutput();
	void SetButtonInput(std::vector<class Gene> geneOutput);
private:
	bool CheckLua(lua_State* L, int r);

	EmulatorOutput emulatorOutput;
	std::vector<float>getOutput{ 0, 0, 0, 0, 0, 0, 0 };
	std::vector<bool> emulatorInput;
};