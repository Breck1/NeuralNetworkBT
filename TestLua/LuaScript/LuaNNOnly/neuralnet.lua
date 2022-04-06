Neuralnet = {}

function Neuralnet.new(layer_sizes, weights)
    local self = {}

    function self.genOutputs(inputs)

        local activations = {}
        local next_activations = {}
        local weight_index = 1

        for i = 1, #inputs do
            activations[i] = inputs[i]
        end

        for i = 1, #layer_sizes - 1 do
            for j = 1, layer_sizes[i + 1] do

                -- set neuron activation to bias value
                next_activations[j] = weights[weight_index]
                weight_index = weight_index + 1

                -- add inputs * weight
                for k = 1, layer_sizes[i] do
                    next_activations[j] = next_activations[j] + weights[weight_index] * activations[k]
                    weight_index = weight_index + 1
                end

                -- sigmoid
                next_activations[j] = 1 / (1 + math.exp(-next_activations[j]))
            end

            -- goto next layer
            activations = next_activations
            next_activations = {}
        end

        return activations
    end

    return self
end

function Neuralnet.getNumWeights(layer_sizes)
    local num = 0
    for i = 1, #layer_sizes - 1 do
        num = num + ((layer_sizes[i] + 1) * layer_sizes[i + 1])
    end
    return num
end