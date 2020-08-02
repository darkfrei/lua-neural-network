

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
	return math.random()*2-1
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
	local unn -- the universal neural network;
	unn.input_nodes_amount = input_nodes_amount
	unn.hidden_nodes_amount = hidden_nodes_amount
	unn.output_nodes_amount = output_nodes_amount
	
	unn.nodes = {} -- nodes
	unn.input_nodes = {} -- input nodes
	local id = 0
	for n_node = 1, input_nodes_amount do
		id = id + 1
		local node = {type = "input", id = id, childs = {}}
		table.input(unn.nodes, node)
		table.input(unn.input_nodes, node)
	end
	
	for n_node = 1, hidden_nodes_amount do
		id = id + 1
		local node = {type = "hidden", id = id, synapses = {}, bias = set_bias(), childs = {}}
		table.input(unn.nodes, node)
		table.input(unn.input_nodes, node)
	end
		
	for n_node = 1, output_nodes_amount do
		id = id + 1
		local node = {type = "output", id = id, synapses = {}, childs = {}}
		table.input(unn.nodes, node)
		table.input(unn.input_nodes, node)
	end
	
	enable_all_synapses (unn)
	
	return unn
end

function feed_forward ()
	
end













































