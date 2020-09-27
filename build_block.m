function [block] = build_block(blocksize, block_center)
%BUILD_BLOCK Creates the block to be picked up by the robot
%   Detailed explanation goes here


% If no arguments provided, use defaults
if ~exist('blocksize','var')
    blocksize = 3;
end
if ~exist('block_center','var')
    block_center = [10, 30];
end

block = [0  , 0; ...
         blocksize  , 0; ...
         blocksize  , blocksize; ...
         0  , blocksize; ...
         0  , 0];

block = block-blocksize/2;

block = pos_update(block_center, 0, block);

end

