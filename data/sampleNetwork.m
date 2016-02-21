function [X,clamped,dag,nodeNames,mynet] = sampleNetwork(name,nSamples,discrete,probInt,verbose)
%
% name:
%   'chain'
%   'alarm'
%   'insurance'
%   etc.
%
% nSamples:
%   number of samples to generate from network
%
% discrete:
%   0: sample from Gaussian Belief Net
%   1: sample from Sigmoid Belief Net
%
% probInt:
%   for each sample, intervene
%       on a randomly chosen node with this probability

if nargin < 3
    discrete = 0;
end
if nargin < 4
    probInt = 0;
end
if nargin < 5
    verbose = 1;
end

if verbose
if probInt == 0
    fprintf('Generating Observational Data\n');
else
    fprintf('Generating Data w/ Interventions\n');
end
end

if verbose
if discrete == 0
    fprintf('Generating from Gaussian Belief Net\n');
else
    fprintf('Generating from Sigmoid Belief Net\n');
end
end

% Get DAG
dagFunc = str2func(strcat('getDAG',name));
[dag,nodeNames] = dagFunc();
n = length(dag);

% Make CPDs
for i = 1:n
    if discrete == 0
        mynet.mu{i} = 0;
        mynet.sigma{i} = 1;
        mynet.weights{i} = dag(:,i).*(sign(rand(n,1)-.5)+randn(n,1)/4);
    else
        mynet.bias{i} = 0;
        mynet.weights{i} = dag(:,i).*(sign(rand(n,1)-.5)+randn(n,1)/4);
    end
end

% Generate Samples
clamped = zeros(nSamples,n);
X = zeros(nSamples,n);
interventional = rand(nSamples,1) < probInt;
clampedNode = ceil(rand(nSamples,1)*n);
for i = 1:nSamples

    % Perform Random PerfectIntervention
    if interventional(i)
        clamped(i,clampedNode(i)) = 1;
    end

end

for j = 1:n
    % Sample (assumes 'dag' is upper triangular)
    if discrete == 0
        X(:,j) = normrnd(mynet.mu{j}+X*mynet.weights{j},mynet.sigma{j});
        for i = 1:nSamples
            if clamped(i,j)
                X(i,j) = n*randn;
            end
        end
    else
        X(:,j) = sign(rand(nSamples,1) - 1./(1+exp(-X*mynet.weights{j}-mynet.bias{j})));
        for i = 1:nSamples
            if clamped(i,j)
                X(i,j) = sign(rand-.5);
            end
        end
    end
end


% Standardize if Gaussian
if discrete == 0
    if verbose
    fprintf('Standardizing Columns\n');
    end
    X = standardizeCols(X);
end