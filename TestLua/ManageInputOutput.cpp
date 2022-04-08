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
	//if (file == NULL)
	//	std::cout << "LuaScript/ButtonInput.txt is null" << std::endl;
	int genomeSize = geneOutput.size();
	
	emulatorInput.resize(genomeSize);
	for(int i = 0; i < genomeSize; i++)
	{
		file << ((geneOutput[i] > pressButtonLimit) ? "1" : "0") << std::endl;

		//if(geneOutput[i] > 0.5f)
		//	file << std::endl << 1;
		//else
		//	file << std::endl << 0;
		emulatorInput[i] = geneOutput[i] > pressButtonLimit;
		//std::cout << "geneOutput i: " << i << " Gene output " << geneOutput[i] << std::endl;
	}
		file.close();

}