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
    end
end

