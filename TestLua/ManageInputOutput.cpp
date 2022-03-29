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
		std::cout << "geneOutput i: " << geneOutput[i] << std::endl;

	}

	lua_State* L = luaL_newstate();
	luaL_openlibs(L);

	if(CheckLua(L, luaL_dofile(L, "LuaScript/buttonInputTester.lua")))

	{
		luaL_openlibs(L);
		for(int i = 0; i < genomeSize; i++)
		{
			lua_getglobal(L, "SetInputCPP");

			lua_pushnumber(L, (i + 1));
			lua_pushboolean(L, emulatorInput[i]);

			CheckLua(L, lua_pcall(L, 2, 1, 0));

		}
		lua_getglobal(L, "ButtonInput2");



		for(int index = 0; index < getOutput.size(); index++)
		{
			int actualIndex = index + 1;

			lua_pushinteger(L, actualIndex);
			lua_gettable(L, -2);

			if(lua_type(L, -1) == LUA_TNIL)
				break;

			getOutput[index] = luaL_checknumber(L, -1);
			lua_pop(L, 1);
			std::cout << getOutput[index] << std::endl;
		}
		lua_close(L);

	}


}