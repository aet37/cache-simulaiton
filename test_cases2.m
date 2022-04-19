%% Test Cases 2: L3 Cache - ECE 1110 Project 2
% Andrew Toader, Collin Hough, Zach Hartman

close all; clear; clc;
addpath funct/

% Setup for cache
setup_params = [32000 1 32 4 "write-back+write-allocate";
                64000 50 32 8 "write-back+write-allocate";
                128000 100 32 16 "write-back+write-allocate"
               ];

% Define cache object
cache_sim = CacheHeirarchy(3, setup_params);

%% Warmup Test cases

cache_sim.command('r', 408, 1, 54, 'x', 1, 'l3_l2', 5);
cache_sim.command('r', 409, 1, 54, 'x', 2, 'l3_l2', 5);
cache_sim.command('r', 410, 1, 54, 'x', 3, 'l3_l2', 5);
cache_sim.command('r', 411, 1, 54, 'x', 4, 'l3_l2', 5);
cache_sim.command('r', 412, 1, 54, 'x', 5, 'l3_l2', 5);
cache_sim.command('r', 413, 1, 54, 'x', 6, 'l3_l2', 5);
cache_sim.command('r', 414, 1, 54, 'x', 7, 'l3_l2', 5);
cache_sim.command('r', 415, 1, 54, 'x', 8, 'l3_l2', 5);
cache_sim.command('r', 416, 1, 54, 'x', 9, 'l3_l2', 5);
cache_sim.command('r', 417, 1, 54, 'x', 10, 'l3_l2', 5);
cache_sim.command('r', 418, 1, 54, 'x', 11, 'l3_l2', 5);
cache_sim.command('r', 419, 1, 54, 'x', 12, 'l3_l2', 5);
cache_sim.command('r', 420, 1, 54, 'x', 13, 'l3_l2', 5);
cache_sim.command('r', 421, 1, 54, 'x', 14, 'l3_l2', 5);
cache_sim.command('r', 422, 1, 54, 'x', 15, 'l3_l2', 5);
cache_sim.command('r', 423, 1, 54, 'x', 16, 'l3_l2', 5);
cache_sim.command('r', 408, 2, 54, 'x', 17, 'l3_l2', 5);
cache_sim.command('r', 409, 2, 54, 'x', 18, 'l3_l2', 5);
cache_sim.command('r', 410, 2, 54, 'x', 19, 'l3_l2', 5);
cache_sim.command('r', 411, 2, 54, 'x', 20, 'l3_l2', 5);
cache_sim.command('r', 412, 2, 54, 'x', 21, 'l3_l2', 5);
cache_sim.command('r', 413, 2, 54, 'x', 22, 'l3_l2', 5);
cache_sim.command('r', 414, 2, 54, 'x', 23, 'l3_l2', 5);
cache_sim.command('r', 415, 2, 54, 'x', 24, 'l3_l2', 5);
cache_sim.command('r', 416, 2, 54, 'x', 25, 'l3_l2', 5);
cache_sim.command('r', 417, 2, 54, 'x', 26, 'l3_l2', 5);
cache_sim.command('r', 418, 2, 54, 'x', 27, 'l3_l2', 5);
cache_sim.command('r', 419, 2, 54, 'x', 28, 'l3_l2', 5);
cache_sim.command('r', 420, 2, 54, 'x', 29, 'l3_l2', 5);
cache_sim.command('r', 421, 2, 54, 'x', 30, 'l3_l2', 5);
cache_sim.command('r', 422, 2, 54, 'x', 31, 'l3_l2', 5);
cache_sim.command('r', 423, 2, 54, 'x', 32, 'l3_l2', 5);

%% Test case: L3 Cache, Random Read/Write

cache_sim.command('w', 420, 2, 54, 'x', 10000, 'l3_l2', 5);
cache_sim.command('r', 412, 2, 54, 'x', 10001, 'l3_l2', 5);
cache_sim.command('w', 417, 1, 54, 'x', 10002, 'l3_l2', 5);
cache_sim.command('r', 415, 1, 54, 'x', 10152, 'l3_l2', 5);
cache_sim.command('w', 416, 2, 54, 'x', 10153, 'l3_l2', 5);
cache_sim.command('r', 416, 1, 54, 'x', 10154, 'l3_l2', 5);
cache_sim.command('r', 419, 2, 54, 'x', 10304, 'l3_l2', 5);
cache_sim.command('r', 416, 2, 54, 'x', 10305, 'l3_l2', 5);
cache_sim.command('w', 412, 2, 54, 'x', 10306, 'l3_l2', 5);
cache_sim.command('w', 415, 1, 54, 'x', 10456, 'l3_l2', 5);