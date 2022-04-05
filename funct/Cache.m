classdef (ConstructOnLoad = true) Cache
    %CACHE Object containing a customizable level of cache
    
    properties
        LayerSize
        AccessLatency
        BlockSize
        SetAssociativity
        Policy
        
        Data
    end
    
    methods
        function obj = Cache(LayerSize, AccessLatency, BlockSize, SetAssociativity, Policy, varargin)
            %CACHE Construct an instance of this class
            %   Notes: LayerSize is total capacity of cache in bytes
            
            % Parse input for data initialization
            p = inputParser;
            addOptional(p, 'DataInit', -1);
            parse(p, varargin{:});
            D_in = p.Results.DataInit;
            
            % Setup variables
            obj.LayerSize = LayerSize;
            obj.AccessLatency = AccessLatency;
            obj.BlockSize = BlockSize;
            obj.SetAssociativity = SetAssociativity;
            obj.Policy = Policy;
            
            % Initialize data
            if D_in == -1       % Initalize to all 0s if no initialization matrix specified
                obj.Data = zeros([LayerSize/BlockSize BlockSize]);
            else                % Initalize to all initalization array specified
                obj.Data = D_in;
            end
            
        end
        
        % Example Method
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

