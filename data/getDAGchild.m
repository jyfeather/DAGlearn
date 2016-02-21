function [adjMatrix,nodeNames] = getDAGchild()
load('child.mat');
adjMatrix = double(adjMatrix);
nodeNames = nodeNames';