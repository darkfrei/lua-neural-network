--	(c) darkfrei, 2020-08-02
--	MIT License

require('save')

--[[



node.value = unn.nodes[n_node] -- node
node.value -- node value

-- The node can be defined as input, hidden or output;
node.type = "input"
node.type = "hidden"
node.type = "output"

-- Only hidden and output nodes have biases and synapses;

if (node.type == "hidden") or (node.type == "output") then 
	node.bias = set_bias (-1, 1, 0.1)
	node.synapses
end

]]

function set_bias ()
	return math.random(200)/200-1
end

function set_weight ()
	local weights = {-2, -1, -0.5, -0.25, 0.25, 0.5, 1, 2}
	return weights[math.random(#weights)]
end

function enable_synapse (unn, id_parent, node_id)
	local parent = unn.nodes[id_parent]
	local node = unn.nodes[node_id]
	local synapses = node.synapses
	synapses[id_parent] = set_weight()
	table.insert (parent.childs, node_id)
end

function enable_all_synapses (unn)
	for node_id, node in pairs (unn.nodes) do
		if node.synapses and (node_id > 1) then
			for id_parent = 1, (node_id-1) do
				enable_synapse (unn, id_parent, node_id)
			end
		end
	end
end

function create_unn (input_nodes_amount, hidden_nodes_amount, output_nodes_amount)
	local unn = {} -- the universal neural network;
--	unn.input_nodes_amount = input_nodes_amount
--	unn.hidden_nodes_amount = hidden_nodes_amount
--	unn.output_nodes_amount = output_nodes_amount
	
	unn.nodes = {} -- nodes
	unn.input_nodes = {} -- input nodes
	local id = 0
	for n_node = 1, input_nodes_amount do
		id = id + 1
		local node = {id = id, type = "input", childs = {}}
		table.insert(unn.nodes, node)
		table.insert(unn.input_nodes, node)
	end
	
	for n_node = 1, hidden_nodes_amount do
		id = id + 1
		local node = {id = id, type = "hidden", bias = set_bias(), synapses = {}, childs = {}}
		table.insert(unn.nodes, node)
		table.insert(unn.input_nodes, node)
	end
		
	for n_node = 1, output_nodes_amount do
		id = id + 1
		local node = {id = id, type = "output", bias = set_bias(), synapses = {}, childs = {}}
		table.insert(unn.nodes, node)
		table.insert(unn.input_nodes, node)
	end
	
	enable_all_synapses (unn)
	
	return unn
end

--	test
local nn = create_unn (3, 4, 2)
save(nn.nodes, 'nn.tabl')


function activation (value)
	-- my logarithmic ReLU also NLReLU
	return math.log(1+math.max(0, value))
end


function deactivation (value)
	return (value>0) and 1/(value+1) or 0
end




function feed_forward (unn, input_values)
	local values = {}
	local summs = {}
	local result_values = {}
	for i, node in pairs (unn.nodes) do
		if input_values[i] then 
			values[i] = input_values[i]
		else
			local summ = node.bias
			for parent_id, weight in pairs (node.synapses) do
				summ = summ + weight*values[parent_id]
			end
			summs[i] = summ
			local value = activation (summ)
			values[i] = value
			if node.type == "output" then
--				table.insert (result_values, summ)
				table.insert (result_values, value)
			end
		end
	end
	return result_values, values, summs
end

local result_values, values, summs = feed_forward (nn, {11, 2, 5})

local str = ''
for i, v in pairs (result_values) do
	print (i .. ' ' .. v)
end

save({result_values=result_values, values=values, summs=summs}, 'result.tabl')








































