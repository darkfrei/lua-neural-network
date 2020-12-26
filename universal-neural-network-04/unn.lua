-- totally new universal neural network; version 04
serpent = require('serpent')

function new_weight ()
	return 4*math.random()-2 -- from -2 to 2
end

function create_nn (input, middle, output)
	local nn = {n_inputs = input, n_middles = middle, n_outputs = output}
	local weights = {}
	local connections = {}
--	local connection = {from = 1, to = 4, nweight = 3, activation = 1}
	for from = 1, (input+middle) do -- from: from first to last middle
		for to = math.max((input+1), (from+1)), (input+middle+output) do -- to: from first middle to last output
			local weight = new_weight ()
			table.insert(weights, weight)
			local connection={from=from, to=to, nweight=#weights, activation=1}
			table.insert(connections, connection)
		end
	end
	nn.weights=weights
	nn.connections=connections
	return nn
end


function update_nn (nn, input)
	local output = {}
	
	return output
end

function mutate_nn (nn)
	local new_nn = {}
	
	return new_nn
end

function get_total_error (output, target)
	local Etotal = 0
	for i, v in pairs (output) do
		local err = 0.5*(output[i]-target[i])^2
		Etotal = Etotal + err
	end
	return Etotal
end

function backpropagation (nn, output, target)
	local errors = {}
	local Etotal = 0
	for i, v in pairs (output) do
		local err = 0.5*(output[i]-target[i])^2
		errors[i] = err
		Etotal = Etotal + err
	end
end


------ test
local nn = create_nn (1, 3, 1) -- 
print (#nn.weights)

--print (serpent.block(nn), {comment =false, sortkeys=false})
--print (serpent.line(nn), {comment =false, sortkeys=false})
--print (serpent.dump(nn), {comment =false, sortkeys=false})
--print (serpent.serialize(nn, {indent = '	', sortkeys = false, comment = false}))
