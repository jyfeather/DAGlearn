function [adjMatrix,nodeNames] = getDAGhailfinder()
load('hailfinder.mat');
adjMatrix = double(adjMatrix);
nodeNames = nodeNames';