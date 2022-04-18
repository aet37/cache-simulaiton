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

            % Initialize caches
            for ii = 1:numCache
                c = Cache(double(cacheInits(ii, 1)), double(cacheInits(ii, 2)), double(cacheInits(ii, 3)), ...
                          double(cacheInits(ii, 4)), char(cacheInits(ii, 5)));
                obj.cacheVector = [obj.cacheVector c];
            end
        end
        
        function read(addr, arrive_time)
            %read Perform read from cache
            %   Detailed explanation goes here

            for ii = 1:obj.numCache
                res = obj.cacheVector(ii).read(arg);

                % Logic here

                % Add cycle time

            end
        end
        
        function write_back_allocate(addr,arrive_time)
            % write_back_allocate Perform write from cache
            %
            % Write Back Policy:
            %   Main Memory is not updated until a cache block needs to be
            %   replaced
            %
            % Write Allocate Policy:
            %   Any newly written data is loaded into the cache instead of
            %   main memory
            %
            % Inputs:
            %       - addr: array that holds [tag L2-L1_index L1_index
            %       offset]
            %       - arrive_time: Time by which the write operation needs 
            %           to be completed by
            %
            
            
            for ii = 1:obj.numCache
                res = obj.cacheVector(ii).write_back_allocate(addr(1),addr(3));

                % Check if hit took place
                if res == 1
                    break
                end
                % Add cycle time
                % Check if latency is valid for the given layer
                % If not, throw error
            end
        end
    end
end

