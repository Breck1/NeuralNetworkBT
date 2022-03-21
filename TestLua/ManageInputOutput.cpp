#include "ManageInputOutput.h"

#include <stdlib.h>

#ifdef _WIN64
#pragma comment(lib, "liblua54.a")
#endif 

bool ManageInputOutput::CheckLua(lua_State* L, int r)
{
	if (r != LUA_OK)
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

EmulatorOutput ManageInputOutput::GetEmulatorOutput()
{
	return emulatorOutput;
}

void ManageInputOutput::SetButtonInput(std::vector<Gene> geneOutput)
{
	int genomeSize = geneOutput.size();
	emulatorInput.resize(genomeSize);
	for (int i = 0; i < genomeSize; i++)
	{
		for (int j= 0; j < geneOutput[i].weight.size(); j++)
			emulatorInput[i] = geneOutput[i].weight[j] > 0.5f;
	}
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	
	if (CheckLua(L, luaL_dofile(L, "LuaScript/InputOutput.lua")))
	{		
		luaL_openlibs(L);
		for (int i = 0; i < genomeSize; i++)
		{
			lua_getglobal(L, "SetInputCPP");

			lua_pushnumber(L, (i + 1));
			lua_pushboolean(L, emulatorInput[i]);

			CheckLua(L, lua_pcall(L, 2, 1, 0));
					
		}
		lua_getglobal(L, "results");



		for (int index = 0; index < getOutput.size(); index++)
		{
			int actualIndex = index + 1;
			
			lua_pushinteger(L, actualIndex);
			lua_gettable(L, -2);
			
			if (lua_type(L, -1) == LUA_TNIL) 
				break;
			
			getOutput[index] = luaL_checknumber(L, -1);
			lua_pop(L, 1);

		}
		lua_close(L);

	}


}