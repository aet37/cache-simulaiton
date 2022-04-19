classdef (ConstructOnLoad = true) Cache < handle
    %CACHE Object containing a customizable level of cache
    
    properties
        LayerSize
        AccessLatency
        BlockSize
        SetAssociativity
        Policy
        writeFcn
        
        Valid
        Tag
        Dirty
        LRU
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

            if Policy == "write-back+write-allocate"
                obj.writeFcn = @write_back_allocate;
            else
                obj.writeFcn = @write_through_nonallocate;
            end

            obj.Valid = false([LayerSize/BlockSize SetAssociativity]);
            obj.Tag = zeros([LayerSize/BlockSize SetAssociativity]);
            obj.Dirty = false([LayerSize/BlockSize SetAssociativity]);
            obj.LRU = ones([LayerSize/BlockSize SetAssociativity]) * SetAssociativity;
            
        end
        
        % Function to perform the proper write as defined from readFcn
        % var
        function res = write(obj, tag, set_index)
            %read Function to perform the proper read/write as defined from
            %readFcn
            res = obj.writeFcn(obj, tag, set_index);
        end

        % Function to perform the read function
        function res = read(obj, tag, set_index)
            %read Function to perform the proper read
            res = 0;
            
        end
        
        % Write Method: Write Back & Write Allocate
        function result = write_back_allocate(obj,tag,set_index)
            % write_back_allocate Write function implementing the Write
            % Back and Write Allocate policies
            %
            % Inputs:
            %       - tag: Tag number of input data
            %       - set_index: Cache Set Index
            % Outputs:
            %       - result: Integer representing result
            %                 0 == MISS; 1 == HIT
            %       - cycles: Amount of cycles passed during operation
            %           Should this be returned from this function?
            
            % Determine if a hit takes place
            % Get all tags in set and compare to input tag
            disp('Func Called')
            tags = obj.Tag(set_index,:);
            index = find(tags == tag);
            hit = size(index,2);
            if hit == 0
                disp('MISS')
                % MISS Condition
                % Find LRU block index
                LRU_index = find(obj.LRU(set_index,:) == obj.SetAssociativity);
                sprintf('LRU_index = %d',LRU_index(1))
                sprintf('tag = %d',tag)
                % Check if block is dirty
                if obj.Dirty(set_index, LRU_index(1)) == true
                    disp('Block is Dirty)')
                    % Write tag to lower level
                    % Should this be done in loop of cache hierarchy
                    % after a miss is returned?
                end
                % Write to LRU block
                sprintf('Tag Before = %d',obj.Tag(set_index,LRU_index(1)))
                obj.Tag(set_index,LRU_index(1)) = tag;
                sprintf('Tag After = %d',obj.Tag(set_index,LRU_index(1)))
                % Set Result = MISS
                result = 0;
            else
                disp('HIT')
                % HIT Condition
                % Replace data held in block (Mark as Valid and change Tag)
                obj.Tag(set_index,index) = tag;
                % Set Result = HIT
                result = 1;
            end
            % Update LRU
            update_LRU = find(obj.LRU(set_index,:) ~= obj.SetAssociativity);
            obj.LRU(set_index,update_LRU) = obj.LRU(update_LRU) + 1;
            obj.LRU(set_index,index) = 1;
            % Regardless of result, update valid and dirty
            obj.Valid(set_index,index) = true;
            obj.Dirty(set_index,index) = true;
        end

        % Write Method: Write Through & Non- Write Allocate
        function result = write_through_nonallocate(obj,tag,set_index)
            % write_through_nonallocate Write function implementing the Write
            % Through and Non- Write Allocate policies
            %
            % Inputs:
            %       - tag: Tag number of input data
            %       - set_index: Cache Set Index
            % Outputs:
            %       - result: Integer representing result
            %                 0 == MISS; 1 == HIT
            tags = obj.Tag(set_index,:);
            index = find(tags == tag);
            hit = size(index,2);
            if hit == 0
                disp("MISS")
                % do nothing - for a non-allocate policy, only the main
                % memory is updated in the event of a miss
                result = 0;
            else
                disp("HIT")
                % Replace data held in block (Mark as Valid and change Tag)
                obj.Tag(set_index,index) = tag;
                result = 1;
            end


        end
    end
end

