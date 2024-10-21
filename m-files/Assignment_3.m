%% Assignment 3, Carl Sundquist (carsu621), TNK104, 2024-10-21
%Cutting Plane Method for Binary Knapsack Problem with Cover Inequalities
clear all; clc;

% Coefficients for the knapsack problem
c = [6 4 6 7 5 8 8];  % Objective coefficients (profits)
a = [5 6 8 6 4 6 5];  % Weights of the items
b = 21;               % Knapsack capacity

% Number of variables (items)
n = length(c);

% Bounds for x (binary variables)
lb = zeros(n,1);
ub = ones(n,1);

% Linear Programming Relaxation without integer constraints
f = -c; % We are maximizing, so negate the objective for minimization
A = a;  % Constraint matrix
b = 21; % Capacity

% Solve LP relaxation
[x_lp, fval_lp] = linprog(f, A, b, [], [], lb, ub);

fprintf('LP solution: x = %.4f\n', x_lp);
fprintf('LP objective value: %.4f\n', -fval_lp); % Undo negation of objective


%Separation Problem to Find Violated Cover Inequality
% Apply heuristic or greedy algorithm to identify cover set
% For simplicity, sort items by weight/cost and check feasibility
% Sort by descending value-to-weight ratio
ratio = c ./ a;
[~, idx] = sort(ratio, 'descend');

% Attempt to find a cover
cover_set = [];
cover_weight = 0;

for i = 1:n
    if cover_weight + a(idx(i)) <= b
        cover_set = [cover_set, idx(i)];
        cover_weight = cover_weight + a(idx(i));
    else
        break;
    end
end

% Check if cover inequality is violated
cover_sum = sum(x_lp(cover_set));
if cover_sum > (length(cover_set) - 1)
    fprintf('Cover inequality violated.\n');
    % Add cover inequality to LP
    A = [A; zeros(1,n)];
    A(end, cover_set) = 1;
    b = [b; length(cover_set) - 1];
else
    fprintf('No violated cover inequality found.\n');
end


%Re-solve LP with the new constraint (if any)
[x_new, fval_new] = linprog(f, A, b, [], [], lb, ub);

fprintf('New LP solution after adding cover inequality: x = %.4f\n', x_new);
fprintf('New objective value: %.4f\n', -fval_new);


%Rounding to Integer Solution (Heuristic)
x_rounded = round(x_new);
if all(a*x_rounded <= 21)
    fprintf('Integer solution found by rounding: x = %.4f\n', x_rounded);
    fprintf('Integer objective value: %.4f\n', c*x_rounded);
else
    fprintf('Rounded solution is not feasible.\n');
end


%Summary of Results
fprintf('Final LP solution: x = %.4f\n', x_new);
fprintf('Final LP objective value: %.4f\n', -fval_new);
fprintf('Rounded solution (heuristic): x = %.4f\n', x_rounded);


