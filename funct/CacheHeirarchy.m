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
        Set_Indices
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
            
            % Assign Indices
            L1_index = l1;
            L2_index = bin2dec([dec2bin(l2_l1) dec2bin(l1)]);
            L3_index = bin2dec([dec2bin(l3_l2) dec2bin(l2_l1) dec2bin(l1)]);
            obj.Set_Indices = [L1_index L2_index L3_index];

            if op == 'w'
                for ii = 1:obj.numCache
                    if ii == 1  % For l1 cache
                        [res, evict_flag, evicted_tag, to_display] = obj.cacheVector(ii).write(bin2dec([dec2bin(tag) dec2bin(l2_l1)]), L1_index);
                    elseif ii == 2  % For l2 cache
                        [res, evict_flag, evicted_tag, to_display] = obj.cacheVector(ii).write(tag, L2_index);
                    elseif ii == 3  % For l3 cache
                        [res, evict_flag, evicted_tag, to_display] = obj.cacheVector(ii).write(tag, L3_index);
                    else
                        print('Warning: Not configured for over L3 (reusults may be innacurate) ...')
                        break;
                    end
    
                    % Add cycle time
                    start_op = obj.currentCycle;
                    if arrival_time > obj.currentCycle
                        obj.currentCycle = arrival_time + obj.cacheVector(ii).AccessLatency;
                    else
                        obj.currentCycle = obj.currentCycle + obj.cacheVector(ii).AccessLatency;
                    end
                    end_op = obj.currentCycle;

                    to_display = ['(w) S: ', num2str(start_op), ', R: ', num2str(end_op), '; L', num2str(ii), ' ', to_display];
                    disp(to_display)

                    % Check if an eviction needs to take place
                    if evict_flag
                        to_disp_evict = ['  Eviction Occured at Tag: ', num2str(tag)];

                        % Assuming we can only evict to L2 or MM
                        if ~(ii + 1 > obj.numCache)
                            eviction_cycles = obj.evict(ii+1,evicted_tag);
                        else
                            eviction_cycles = 100;
                        end
                        
                        start_e = obj.currentCycle;
                        obj.currentCycle = obj.currentCycle + eviction_cycles;
                        end_e = obj.currentCycle;
                        to_disp_evict = [to_disp_evict, 'S: ', num2str(start_e), ', R: ', num2str(end_e)];
                        disp(to_disp_evict)
                    end
                    
                    % If there is hit, break out of loop
                    if res && obj.cacheVector(ii).Policy == "write-back+write-allocate"
                        break;
                    end
                end
            elseif op == 'r'
                for ii = 1:obj.numCache
                    if ii == 1  % For l1 cache
                        [res, evict_flag, evicted_tag, to_display] = obj.cacheVector(ii).read(bin2dec([dec2bin(tag) dec2bin(l2_l1)]), l1);
                    elseif ii == 2  % For l2 cache
                        [res, evict_flag, evicted_tag, to_display] = obj.cacheVector(ii).read(tag, bin2dec([dec2bin(l2_l1) dec2bin(l1)]));
                    elseif ii == 3  % For l3 cache
                        [res, evict_flag, evicted_tag, to_display] = obj.cacheVector(ii).read(tag, bin2dec([dec2bin(l3_l2) dec2bin(l2_l1) dec2bin(l1)]));
                    else
                        print('Warning: Not configured for over L3 (reusults may be innacurate) ...')
                        break;
                    end
                    
                    % Add cycle time
                    if arrival_time > obj.currentCycle
                        start_op = arrival_time;
                        obj.currentCycle = arrival_time + obj.cacheVector(ii).AccessLatency;
                    else
                        start_op = obj.currentCycle;
                        obj.currentCycle = obj.currentCycle + obj.cacheVector(ii).AccessLatency;
                    end
                    end_op = obj.currentCycle;

                    to_display = ['(r) S: ', num2str(start_op), ', R: ', num2str(end_op), '; L', num2str(ii), ' ', to_display];
                    disp(to_display)
                 
                    % Check if an eviction needs to take place
                    if evict_flag & obj.cacheVector(ii).Policy == "write-back+write-allocate"
                        to_disp_evict = ['  Eviction Occured at Tag: ', num2str(tag), '; '];
                        disp(obj.cacheVector(ii).Policy)
                        % Assuming we can only evict to L2 or MM
                        if ~(ii + 1 > obj.numCache)
                            eviction_cycles = obj.evict(ii+1, evicted_tag);
                            disp(evicted_tag)
                        end

                        start_e = obj.currentCycle;
                        obj.currentCycle = obj.currentCycle + eviction_cycles;
                        end_e = obj.currentCycle;
                        to_disp_evict = [to_disp_evict, 'S: ', num2str(start_e), ', R: ', num2str(end_e)];
                        disp(to_disp_evict)
                    end

                    % If there is hit, break out of loop
                    if res
                        break;
                    end
                end
            else
                error('Invalid Cache access command');
            end
            disp(' ')
        end
        
        function [cycle_time] = evict(obj, cache_index,tag)
            %evict Enact evictions for cache layers
            %
            % Inputs:
            %       cache_index - index of cache that data is being evicted to
            %       set_index   - index of set that data is being evicted to
            %       tag         - tag address value that is being evicted
            %
            % Outputs:
            %       cycle_time - total cycle time passed from evictions
            %
            disp(tag);
            cycle_time = 0;
            if cache_index > obj.numCache
                cycle_time = cycle_time + 100;
            else
                [~, evict_flag, evicted_tag, ~] = obj.cacheVector(cache_index).write(tag, obj.Set_Indices(cache_index));
                % Call for write
                if evict_flag && cache_index <= obj.numCache
                    % If another function is needed, evict necessary block
                    cycle_time = obj.evict(cache_index + 1, evicted_tag);
                else
                    if cache_index <= obj.numCache
                        % Evicting to L2 or L3
                        cycle_time = cycle_time + obj.cacheVector(cache_index).AccessLatency;
                    else
                        % Evicting to main memory
                        cycle_time = cycle_time + 100;
                    end

                end
            end
        end
    end
end

