classdef CacheHeirarchy < handle
    %CACHEHEIRARCHY Object containing multiple Cache objects, used to run
    %simulation
    %
    %   cacheVector - vector containing all levels of cache
    %   numCache - number of caches in simulation
    %
    
    properties
        cacheVector
        numCache

        currentCycle
    end
    
    methods
        function obj = CacheHeirarchy(numCache, cacheInits)
            %CACHEHEIRARCHY Construct an instance of this class
            %
            %   numCache   - number of caches for CacheHeirarchy to contain
            %   cacheInits - is vector of Nx5, where N is the number of
            %                caches (in rows) and 5 are the inputs to Cache
            %                class in columns (as str matrix)
            %
            %   Note: initialization of data in chaches must take place
            %   after creation of CacheHeirarchy object
            %

            obj.numCache = numCache;
            obj.currentCycle = 0;

            % Initialize caches
            for ii = 1:numCache
                c = Cache(double(cacheInits(ii, 1)), double(cacheInits(ii, 2)), double(cacheInits(ii, 3)), ...
                          double(cacheInits(ii, 4)), char(cacheInits(ii, 5)));
                obj.cacheVector = [obj.cacheVector c];
            end
        end

        % Function to parse any input for simulation
        function command(obj, op, tag, l2_l1, l1, offset, arrival_time, varargin)
            % Additional inputs
            p = inputParser;
            addOptional(p, 'l3_l2', 0, @isnumeric);
            parse(p, varargin{:});

            l3_l2 = p.Results.l3_l2;

            %command Run specified command
            
            if offset ~= 'x'
                dispy('Warning: Offset not used ... ')
            end

            if op == 'w'
                for ii = 1:obj.numCache
                    if ii == 1  % For l1 cache
                        res = obj.cacheVector(ii).write(bin2dec([dec2bin(tag) dec2bin(l2_l1)]), l1);
                    elseif ii == 2  % For l2 cache
                        res = obj.cacheVector(ii).write(tag, bin2dec([dec2bin(l2_l1) dec2bin(l1)]));
                    elseif ii == 3  % For l3 cache
                        res = obj.cacheVector(ii).write(tag, bin2dec([dec2bin(l3_l2) dec2bin(l2_l1) dec2bin(l1)]));
                    else
                        print('Warning: Not configured for over L3 (reusults may be innacurate) ...')
                        break;
                    end
    
                    % Add cycle time
                    if arrival_time > obj.currentCycle
                        obj.currentCycle = arrival_time + obj.cacheVector(ii).AccessLatency;
                    else
                        obj.currentCycle = obj.currentCycle + obj.cacheVector(ii).AccessLatency;
                    end
                    
                    % If there is hit, break out of loop
                    if res
                        break;
                    end
                end
            elseif op == 'r'
                for ii = 1:obj.numCache
                    if ii == 1  % For l1 cache
                        res = obj.cacheVector(ii).read(bin2dec([dec2bin(tag) dec2bin(l2_l1)]), l1);
                    elseif ii == 2  % For l2 cache
                        res = obj.cacheVector(ii).read(tag, bin2dec([dec2bin(l2_l1) dec2bin(l1)]));
                    elseif ii == 3  % For l3 cache
                        res = obj.cacheVector(ii).read(tag, bin2dec([dec2bin(l3_l2) dec2bin(l2_l1) dec2bin(l1)]));
                    else
                        print('Warning: Not configured for over L3 (reusults may be innacurate) ...')
                        break;
                    end
    
                    % Add cycle time
                    if arrival_time > obj.currentCycle
                        obj.currentCycle = arrival_time + obj.cacheVector(ii).AccessLatency;
                    else
                        obj.currentCycle = obj.currentCycle + obj.cacheVector(ii).AccessLatency;
                    end
                    
                    % If there is hit, break out of loop
                    if res
                        break;
                    end
                end
            else
                error('Invalid Cache access command');
            end
        end
    end
end

