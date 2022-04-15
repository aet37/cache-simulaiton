classdef (ConstructOnLoad = true) Cache
    %CACHE Object containing a customizable level of cache
    
    properties
        LayerSize
        AccessLatency
        BlockSize
        SetAssociativity
        Policy
        
        Valid
        Tag
        Data
    end
    
    methods
        function obj = Cache(LayerSize, AccessLatency, BlockSize, SetAssociativity, Policy)
            %CACHE Construct an instance of this class
            %   Notes: LayerSize is total capacity of cache in bytes
            %
            %          Data initialization should be 3D Matrix with:
            %              [LayerSize/BlockSize, BlockSize/SetAssociativity, SetAssociativity]
            %
            
            % Setup variables
            obj.LayerSize = LayerSize;
            obj.AccessLatency = AccessLatency;
            obj.BlockSize = BlockSize;
            obj.SetAssociativity = SetAssociativity;
            obj.Policy = Policy;
            obj.Data = zeros([LayerSize/BlockSize BlockSize/SetAssociativity SetAssociativity]);
            obj.Valid = false([LayerSize/BlockSize SetAssociativity]);
            obj.Tag = zeros([LayerSize/BlockSize SetAssociativity]);
            
        end
        
        % Example Method
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

