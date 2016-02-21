function [adjMatrix,nodeNames] = getDAGasia()
load('asia.mat');
adjMatrix = double(adjMatrix);
nodeNames = nodeNames';
