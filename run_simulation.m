%% Simulation of Cache
close all; clc;
addpath funct

%% Start sim

% Example declaration of cache
c2 = Cache(32000, 50, 64, 4, 'write-back+write-allocate');
