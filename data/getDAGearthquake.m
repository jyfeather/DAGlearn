function [adjMatrix,nodeNames] = getDAGearthquake()
load('earthquake.mat');
adjMatrix = double(adjMatrix);
nodeNames = nodeNames';