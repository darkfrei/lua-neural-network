--	totally new universal neural network; version 04; 2020-12-27

--	license: MIT https://opensource.org/licenses/MIT

--	Copyright 2020 darkfrei

--	Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
--	and associated documentation files (the "Software"), to deal in the Software without restriction, 
--	including without limitation the rights to use, copy, modify, merge, publish, distribute, 
--	sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
--	is furnished to do so, subject to the following conditions:

--	The above copyright notice and this permission notice shall be included in all copies 
--	or substantial portions of the Software.

--	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
--	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE 
--	AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
--	DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
--	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

serpent = require('serpent')



do_activation = {}

do_activation[#do_activation+1] = function (value, derivative)
	-- 1. ReLU [++-: monotonic, monotonic derivative, appr. identity near origin]
	if not derivative then
		return value>0 and value or 0
	else
		return value>0 and 1 or 0
	end
end

do_activation[#do_activation+1] = function (value, derivative)
	-- 2. Leaky ReLU [++-]
	if not derivative then
		return value>0 and value or 0.01*value
	else
		return value>0 and 1 or 0.01
	end
end

do_activation[#do_activation+1] = function (value, derivative)
	-- 3. TanH [+-+]
	local f = math.tanh(value)
	if not derivative then
		return f
	else
		return 1-f^2
	end
end

do_activation[#do_activation+1] = function (value, derivative)
	-- 4. ISRLU [+++]
	if not derivative then
		local f = value/math.sqrt(1+value^2)
		return (value>0) and value or f
	else
		local f = (1+value^2)^(-3/2)
		return (value>0) and 1 or f
	end
end

do_activation[#do_activation+1] = function (value, derivative)
	-- 5. ELU
	local a = 1
	local f = a*(math.exp(value)-1)
	if not derivative then
		return (value>0) and value or f
	else
		return (value>0) and 1 or (f+a)
	end
end

do_activation[#do_activation+1] = function (value, derivative)
	-- 6. sin
	if not derivative then
		return math.sin(value)
	else
		return math.cos(value)
	end
end

do_activation[#do_activation+1] = function (value, derivative)
	-- 7. gauss
	local f = math.exp(-value^2)
	if not derivative then
		return f
	else
		return (-2*value*f)
	end
end

-------------- functions

function new_weight ()
	return 4*math.random()-2 -- from -2 to 2
end

function random_n_activation ()
	return math.random(#do_activation) -- number of activation
end


function create_nn (input, middle, output)
	local nn = {n_inputs = input, n_middles = middle, n_outputs = output}
	local weights = {}
	local connections = {}
	local activations = {}
--	local connection = {from = 1, to = 4, nweight = 3, activation = 1}
	for from = 1, (input+middle) do -- from: from first to last middle
		for to = math.max((input+1), (from+1)), (input+middle+output) do -- to: from first middle to last output
			local weight = new_weight ()
			table.insert(weights, weight)
			local n_activation = random_n_activation ()
			table.insert (activations, n_activation)
			local connection={from=from, to=to, nweight=#weights, activation=#activations}
			table.insert(connections, connection)
		end
	end
	nn.weights=weights
	nn.activations=activations
	nn.connections=connections
	return nn
end


function update_nn (nn, input)
	local output = {}
	local nodes = {}
	for i, input_value in pairs (input) do -- copy values from input
		nodes[i] = input[i]
	end
	for i, connection in ipairs (nn.connections) do
		local weight = nn.weights[connection.nweight]
		local from = connection.from
--		print ('activations '..serpent.serialize(nn.activations, {indent = '	', sortkeys = false, comment = false}))
--		print ('connection.activation' .. connection.activation)
		local n_activation = nn.activations[connection.activation]
--		print ('n_activation'..n_activation)
		local func = do_activation[n_activation]
		local value = func(nodes[from])
		value = weight*value
		local to = connection.to
		if to < (nn.n_inputs+nn.n_middles+1) then -- write to middle node
			
			nodes[to] = nodes[to] and nodes[to] + value or value
		else -- write to output node
			print('i'..i..' to'..to)
			to = to - (nn.n_inputs+nn.n_middles)
			output[to] = output[to] and (output[to] + value) or value
		end
	end
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
local example = {{0, 1},{1, 0}} -- example with two inputs and one output values
local nn = create_nn (#example[1], 2, #example[2]) -- 
print (serpent.serialize(nn, {indent = '	', sortkeys = false, comment = false}))

local output = update_nn (nn, example[1])

--print ('weights '.. #nn.weights)



--print (serpent.block(nn), {comment =false, sortkeys=false})
--print (serpent.line(nn), {comment =false, sortkeys=false})
--print (serpent.dump(nn), {comment =false, sortkeys=false})
print ('output '..serpent.serialize(output, {indent = '	', sortkeys = false, comment = false}))
