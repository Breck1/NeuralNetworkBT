require "genome"

Population = {}

function Population.new(size, genome_length)
    local self = {}

    local generation = 1
    local genomes = {}


    -- public variables:
    self.max_fitness = 0
    self.min_fitness = 0
    self.avg_fitness = 0
    self.total_fitness = 0

    self.num_elites = 2
    self.cross_rate = 0.7
    self.mut_rate = 0.2
    self.mut_max = 0.5


    self.selection = "roulette"


    genomes = {}
    for i = 1, size do
        genomes[i] = Genome.random(genome_length)
    end


    local function selectGenome()
        if self.selection == "roulette"
        then

            local target = math.random() * self.total_fitness
            local passedFitness = 0

            for i, v in ipairs(genomes)
            do
                passedFitness = passedFitness + v.fitness
                if passedFitness >= target
                then
                    return v
                end
            end

            return genomes[1]
        elseif self.selection == "tournament"
        then

            local competitors = {}
            while #competitors < 4
            do
                table.insert(competitors, genomes[math.random(#genomes)])
            end

            table.sort(competitors, function(a,b) return a.fitness > b.fitness end)

            return competitors[1]
        end

        return nil

    end

    function self.evolve()

        local newPopulation = {}

        for i = 1, self.num_elites
        do
            newPopulation[i] = genomes[i]
        end

        -- create the rest by mutation and crossover
        while #newPopulation < #genomes do
            local mother = selectGenome()
            local father = selectGenome()
            local child = mother

            if math.random() < self.cross_rate then
                child = Genome.by_crossover(mother, father)
            end
            local mutated = Genome.by_mutation(child, self.mut_rate, self.mut_max)
            table.insert(newPopulation, mutated)
        end

        genomes = newPopulation
        generation = generation + 1
    end

    function self.recalculateFitness()

        table.sort(genomes, function(a,b) return a.fitness > b.fitness end)

        self.max_fitness = genomes[1].fitness
        self.min_fitness = genomes[#genomes].fitness

        self.total_fitness = 0

        for _, v in ipairs(genomes)
        do
            self.total_fitness = self.total_fitness + v.fitness
        end

        self.avg_fitness = self.total_fitness / #genomes
    end

    function self.getGenomes()
        return genomes
    end

    function self.getGenome(index)
        return genomes[index]
    end

    function self.getSize()
        return #genomes
    end

    function self.getGeneration()
        return generation
    end

    function self.tostring()
        return "generation: "..generation.." max: "..self.max_fitness.." avg: "..self.avg_fitness;
    end

    function self.getBestGenome()
        return genomes[1]
    end

    function self.getWorstGenome()
        return genomes[#genomes]
    end

    return self
end
