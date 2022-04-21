%% Test Cases - ECE 1110 Project 2
% Andrew Toader, Collin Hough, Zach Hartman

close all; clear; clc;
addpath funct/

% Setup for cache

setup_params = [32000 1 32 4 "write-back+write-allocate";
                64000 50 32 8 "write-back+write-allocate"
               ];

% setup_params = [32000 1 32 4 "write-through+write-nonallocate";
%                 64000 50 32 8 "write-through+write-nonallocate"
%                ];

% Define cache object
cache_sim = CacheHeirarchy(2, setup_params);

%% Warmup

cache_sim.command('r', 408, 1, 54, 'x', 1);
cache_sim.command('r', 409, 1, 54, 'x', 2);
cache_sim.command('r', 410, 1, 54, 'x', 3);
cache_sim.command('r', 411, 1, 54, 'x', 4);
cache_sim.command('r', 412, 1, 54, 'x', 5);
cache_sim.command('r', 413, 1, 54, 'x', 6);
cache_sim.command('r', 414, 1, 54, 'x', 7);
cache_sim.command('r', 415, 1, 54, 'x', 8);
cache_sim.command('r', 416, 1, 54, 'x', 9);
cache_sim.command('r', 417, 1, 54, 'x', 10);
cache_sim.command('r', 418, 1, 54, 'x', 11);
cache_sim.command('r', 419, 1, 54, 'x', 12);
cache_sim.command('r', 420, 1, 54, 'x', 13);
cache_sim.command('r', 421, 1, 54, 'x', 14);
cache_sim.command('r', 422, 1, 54, 'x', 15);
cache_sim.command('r', 423, 1, 54, 'x', 16);
cache_sim.command('r', 408, 2, 54, 'x', 17);
cache_sim.command('r', 409, 2, 54, 'x', 18);
cache_sim.command('r', 410, 2, 54, 'x', 19);
cache_sim.command('r', 411, 2, 54, 'x', 20);
cache_sim.command('r', 412, 2, 54, 'x', 21);
cache_sim.command('r', 413, 2, 54, 'x', 22);
cache_sim.command('r', 414, 2, 54, 'x', 23);
cache_sim.command('r', 415, 2, 54, 'x', 24);
cache_sim.command('r', 416, 2, 54, 'x', 25);
cache_sim.command('r', 417, 2, 54, 'x', 26);
cache_sim.command('r', 418, 2, 54, 'x', 27);
cache_sim.command('r', 419, 2, 54, 'x', 28);
cache_sim.command('r', 420, 2, 54, 'x', 29);
cache_sim.command('r', 421, 2, 54, 'x', 30);
cache_sim.command('r', 422, 2, 54, 'x', 31);
cache_sim.command('r', 423, 2, 54, 'x', 32);

disp('--------------------------------------------------')
for ii = 1:cache_sim.numCache
    disp(['L', num2str(ii), ' Hit Rate: ', num2str(cache_sim.cacheVector(ii).HitRate * 100), '%'])
    disp(['L', num2str(ii), ' Miss Rate: ', num2str(cache_sim.cacheVector(ii).MissRate * 100), '%'])
    disp(' ')
end

%% Test Case 1: Random Read

cache_sim.command('r', 423, 2, 54, 'x', 10000);
cache_sim.command('r', 417, 2, 54, 'x', 10001);
cache_sim.command('r', 417, 2, 54, 'x', 10002);
cache_sim.command('r', 423, 2, 54, 'x', 10152);
cache_sim.command('r', 416, 1, 54, 'x', 10153);
cache_sim.command('r', 414, 2, 54, 'x', 10154);
cache_sim.command('r', 422, 2, 54, 'x', 10304);
cache_sim.command('r', 418, 2, 54, 'x', 10305);
cache_sim.command('r', 413, 2, 54, 'x', 10306);
cache_sim.command('r', 417, 1, 54, 'x', 10456);
cache_sim.command('r', 431, 3, 54, 'x', 10457);
cache_sim.command('r', 431, 2, 54, 'x', 10458);
cache_sim.command('r', 429, 3, 54, 'x', 10459);
cache_sim.command('r', 424, 2, 54, 'x', 10609);
cache_sim.command('r', 426, 3, 54, 'x', 10610);
cache_sim.command('r', 426, 3, 54, 'x', 10611);
cache_sim.command('r', 430, 2, 54, 'x', 10761);
cache_sim.command('r', 427, 3, 54, 'x', 10762);
cache_sim.command('r', 430, 3, 54, 'x', 10763);
cache_sim.command('r', 428, 2, 54, 'x', 10913);

disp('--------------------------------------------------')
for ii = 1:cache_sim.numCache
    disp(['L', num2str(ii), ' Hit Rate: ', num2str(cache_sim.cacheVector(ii).HitRate * 100), '%'])
    disp(['L', num2str(ii), ' Miss Rate: ', num2str(cache_sim.cacheVector(ii).MissRate * 100), '%'])
    disp(' ')
end

%% Test Case 2: Random Read/Write

cache_sim.command('w', 420, 2, 54, 'x', 10000);
cache_sim.command('r', 412, 2, 54, 'x', 10001);
cache_sim.command('w', 417, 1, 54, 'x', 10002);
cache_sim.command('r', 415, 1, 54, 'x', 10152);
cache_sim.command('w', 416, 2, 54, 'x', 10153);
cache_sim.command('r', 416, 1, 54, 'x', 10154);
cache_sim.command('r', 419, 2, 54, 'x', 10304);
cache_sim.command('r', 416, 2, 54, 'x', 10305);
cache_sim.command('w', 412, 2, 54, 'x', 10306);
cache_sim.command('w', 415, 1, 54, 'x', 10456);

disp(' ')
disp('--------------------------------------------------')
for ii = 1:cache_sim.numCache
    disp(['L', num2str(ii), ' Hit Rate: ', num2str(cache_sim.cacheVector(ii).HitRate * 100), '%'])
    disp(['L', num2str(ii), ' Miss Rate: ', num2str(cache_sim.cacheVector(ii).MissRate * 100), '%'])
    disp(' ')
end

%% Test Case 3: Random write (L2 miss)

cache_sim.command('w', 428, 2, 54, 'x', 10000);
cache_sim.command('w', 429, 3, 54, 'x', 10001);
cache_sim.command('r', 428, 3, 54, 'x', 10002);
cache_sim.command('r', 428, 2, 54, 'x', 10152);
cache_sim.command('w', 427, 2, 54, 'x', 10153);
cache_sim.command('r', 424, 2, 54, 'x', 10154);
cache_sim.command('r', 427, 3, 54, 'x', 10304);
cache_sim.command('r', 431, 3, 54, 'x', 10305);
cache_sim.command('w', 426, 3, 54, 'x', 10306);
cache_sim.command('r', 428, 3, 54, 'x', 10456);
cache_sim.command('r', 428, 2, 54, 'x', 10457);
cache_sim.command('w', 427, 3, 54, 'x', 10458);
cache_sim.command('r', 429, 3, 54, 'x', 10608);
cache_sim.command('w', 428, 3, 54, 'x', 10609);
cache_sim.command('w', 428, 3, 54, 'x', 10610);

disp('--------------------------------------------------')
for ii = 1:cache_sim.numCache
    disp(['L', num2str(ii), ' Hit Rate: ', num2str(cache_sim.cacheVector(ii).HitRate * 100), '%'])
    disp(['L', num2str(ii), ' Miss Rate: ', num2str(cache_sim.cacheVector(ii).MissRate * 100), '%'])
    disp(' ')
end
