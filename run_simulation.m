%% Simulation of Cache
close all; clc;
addpath funct

%% Start sim

% Example declaration of Cache Heirarchy object

% Define cache setup details (columns are each an input into Cache()
% object, and rows are number of cache objects to be created
setup_params = [32000 1 64 2 "write-back+write-allocate";
                64000 50 64 4 "write-back+write-allocate";
                128000 100 128 8 "write-back+write-allocate"
               ];

% Call the CacheHeirarchy constuctor with 3 classes
cache_sim1 = CacheHeirarchy(3, setup_params);

%% Remove functions folder from path
rmpath funct