%%Project networks
clear all; clc;

%a)
% Read the file
filename = '1_data.txt';

fid = fopen(filename, 'r');
num_arcs = fscanf(fid, '%d', 1);
arcs = fscanf(fid, '%d %d', [2, num_arcs])';
fclose(fid);

% Determine the number of nodes
nodes = unique(arcs);
num_nodes = max(nodes);

% Initialize adjacency list and in-degree array
adj_list = cell(num_nodes, 1);
in_degree = zeros(1, num_nodes);

% Populate the adjacency list and in-degree array
for i = 1:num_arcs
    from_node = arcs(i, 1);
    to_node = arcs(i, 2);
    adj_list{from_node} = [adj_list{from_node}, to_node];
    in_degree(to_node) = in_degree(to_node) + 1;
end

% Initialize the queue with nodes that have in-degree 0
queue = find(in_degree == 0);
ordering = [];

% Process the queue
while ~isempty(queue)
    current = queue(1);
    queue(1) = [];  % Dequeue the first element
    ordering = [ordering, current];
    
    % For each neighbor, reduce in-degree and add to queue if in-degree becomes 0
    for neighbor = adj_list{current}
        in_degree(neighbor) = in_degree(neighbor) - 1;
        if in_degree(neighbor) == 0
            queue = [queue, neighbor];
        end
    end
end

%B)
% Check if there is a cycle
if length(ordering) ~= num_nodes
    error('The project network has a cycle, and it is impossible to complete the tasks.');
end
disp(ordering)
