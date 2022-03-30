#include "ManageInputOutput.h"
#include <fstream>
#include <sstream>
#include <stdlib.h>

#ifdef _WIN64
#pragma comment(lib, "liblua54.a")
#endif 

bool ManageInputOutput::CheckLua(lua_State* L, int r)
{
	if(r != LUA_OK)
	{
		std::string errormsg = lua_tostring(L, -1);
		std::cout << errormsg << std::endl;
		return false;
	}
	return true;
}
void ManageInputOutput::SetEmulatorResults()
{

}

std::vector<float> ManageInputOutput::GetEmulatorOutput()
{
	return getOutput;
}

void ManageInputOutput::SetButtonInput(std::vector<float> geneOutput)
{
	std::ofstream file("LuaScript/ButtonInput.txt");
	std::string line;
	
	int genomeSize = geneOutput.size();
	
	emulatorInput.resize(genomeSize);

	for(int i = 0; i < genomeSize; i++)
	{

		if(geneOutput[i] > 0.6f)
			file << 1 << std::endl;
		else
			file << 0 << std::endl;
		emulatorInput[i] = geneOutput[i] > 0.6f;
		//std::cout << "geneOutput i: " << geneOutput[i] << std::endl;

	}

}