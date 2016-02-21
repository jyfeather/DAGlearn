function [adjMatrix,nodeNames] = getDAGmildew()
load('mildew.mat');
adjMatrix = double(adjMatrix);
nodeNames = nodeNames';