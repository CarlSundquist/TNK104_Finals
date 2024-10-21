%% Assignment 4, Carl Sundquist (carsu621), TNK104, 2024-10-21
%Greedy algorithm for the generalized assignment problem (GAP)
clear all; clc;
% Input Data for the problem
m = 3;  % number of machines
n = 5;  % number of jobs

% Costs matrix (c_ij)
% costs = [6 12 15 10 8;
%          10 12 4 3 9;
%          1 5 3 8 5];

costs = [7 13 15 11 9;
        11 13 5 4 10;
        10 6 4 12 6];

% Capacity requirements (r_ij)
% requirements = [5 14 10 8 6;
%                 7 8 6 4 12;
%                 2 7 14 15 5];

requirements = [6 15 11 9 7;
                8 9 7 5 13;
                3 8 13 15 6];

% Capacity of each machine
capacities = [15, 15, 15];

% Initialize variables
assignments = zeros(m, n); % To store the assignments of jobs to machines
remaining_capacity = capacities; % Track the remaining capacity of each machine

%Greedy Assignment Algorithm
total_cost = 0;

for j = 1:n
    % Find the machine with the minimum cost that can handle the job
    min_cost = inf;
    chosen_machine = -1;
    
    for i = 1:m
        if requirements(i, j) <= remaining_capacity(i) && costs(i, j) < min_cost
            min_cost = costs(i, j);
            chosen_machine = i;
        end
    end
    
    if chosen_machine ~= -1
        assignments(chosen_machine, j) = 1; % Assign the job to the chosen machine
        remaining_capacity(chosen_machine) = remaining_capacity(chosen_machine) - requirements(chosen_machine, j);
        total_cost = total_cost + costs(chosen_machine, j); % Update total cost
    else
        disp(['No feasible assignment for job ', num2str(j)]);
    end
end

%Output the assignment and total cost
disp('Greedy Assignments:')
disp(assignments)
disp(['Total Cost: ', num2str(total_cost)]);

%Exhaustive Search for Optimal Solution
all_assignments = dec2base(0:(m^n)-1, m) - '0' + 1; % Generate all possible assignments
best_assignment = [];
min_cost = inf;

for k = 1:size(all_assignments, 1)
    current_assignment = all_assignments(k, :); % Current assignment configuration
    remaining_capacity = capacities; % Reset remaining capacity for each configuration
    feasible = true;
    total_cost = 0;
    
    for j = 1:n
        machine = current_assignment(j);
        if requirements(machine, j) <= remaining_capacity(machine)
            remaining_capacity(machine) = remaining_capacity(machine) - requirements(machine, j);
            total_cost = total_cost + costs(machine, j);
        else
            feasible = false;
            break;
        end
    end
    
    if feasible && total_cost < min_cost
        min_cost = total_cost;
        best_assignment = current_assignment;
    end
end

%Output the optimal solution
disp('Exhaustive Search Optimal Assignment:')
disp(best_assignment)
disp(['Optimal Cost: ', num2str(min_cost)]);
