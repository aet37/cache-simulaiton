classdef CacheHeirarchy
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
        function command(obj, op, tag, l2_l1, l1, offset, arrival_time)
            %command Run specified command
            
            if offset ~= 'x'
                dispy('Warning: Offset not used ... ')
            end

            if op == 'r'
                for ii = 1:obj.numCache
                    if ii == 1  % For l1 cache
                        res = obj.cacheVector(ii).read(bin2dec([dec2bin(tag) dec2bin(l2_l1)]), l1);
                    elseif ii == 2  % For l2 cache
                        res = obj.cacheVector(ii).read(tag, bin2dec([dec2bin(l2_l1) dec2bin(l1)]));
                    else
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
            elseif op == 'w'

            else
                error('Invalid Cache write command');
            end

            
        end
        
%         function write_back_allocate(addr,arrive_time)
%             % write_back_allocate Perform write from cache
%             %
%             % Write Back Policy:
%             %   Main Memory is not updated until a cache block needs to be
%             %   replaced
%             %
%             % Write Allocate Policy:
%             %   Any newly written data is loaded into the cache instead of
%             %   main memory
%             %
%             % Inputs:
%             %       - addr: array that holds [tag L2-L1_index L1_index
%             %       offset]
%             %       - arrive_time: Time by which the write operation needs 
%             %           to be completed by
%             %
%             
%             
%             for ii = 1:obj.numCache
%                 res = obj.cacheVector(ii).write_back_allocate(addr(1),addr(3));
% 
%                 % Check if hit took place
%                 if res == 1
%                     break
%                 end
%                 % Add cycle time
%                 % Check if latency is valid for the given layer
%                 % If not, throw error
%             end
%         end
    end
end

