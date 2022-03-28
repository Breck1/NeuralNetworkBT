

ButtonInput2 = {}


function ButtonInput2.new(resultSize)

    local self = {}


    self.left = false
    self.right = false
    self.up = false
    self.down = false

    self.b = false
    self.a = false
    self.y = false
    self.x = false

    self.l = false
    self.r = false

    self.start = false
    self.select = false


    local results = {}
    function SetInputCPP(index, boolean)

        results[index] = boolean
        if results[index] == true
        then
            print("[LUA: InputOutput SetInputCPP: buttonInput["..index.. "] is true\n")
        else
            print("[LUA: InputOutput temp: buttonInput["..index.. "] is false\n")
        end
        return results
    end

    function self.SetResults(resultsTable)
        --print("resultsTable")
        results = resultsTable
        print("results")
        return results
    end

    return self

end