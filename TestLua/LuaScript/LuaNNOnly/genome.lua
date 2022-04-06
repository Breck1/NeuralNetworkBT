Genome = {}


function Genome.new(genes)
    local self = {}

    -- public variables:
    self.fitness = 0

    -- public functions:
    function self.get_genes()
        return genes
    end

    function self.get_gene(index)
        return genes[index]
    end

    function self.get_length()
        return #genes
    end

    function self.tostring()
        for k, v in pairs(genes) do
            print(k, v)
        end
        print("fitness", self.fitness)
    end

    return self
end

function Genome.random(length)
    local genes = {}

    for i = 1, length 
    do
        genes[i] = math.random() - math.random()   
    end

    return Genome.new(genes)
end

function Genome.ByMutation(source, mutRate, mutMax)
    local genes = {}

    for i = 1, source.get_length() do
        genes[i] = source.get_gene(i)
        if mqath.random() < mutRate 
        then
            genes[i] = genes[i] + math.random() * mutMax
            genes[i] = genes[i] - math.random() * mutMax
            if genes[i] > 1 then genes[i] = 1; end
            if genes[i] < 1 then genes[i] = -1; end
        end
    end
    return Genome.new(genes)
end

function Genome.ByCrossover(mother, father)
    local genes = {}
    local length = mother.get_length()
    local point = math.random(point)

    


    return Genome.new(genes)
end