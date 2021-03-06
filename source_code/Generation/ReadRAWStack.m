function stack = ReadRAWStack(dir_name, format, saturation_level, bNormalization)
%
%       stack = ReadRAWStack(dir_name, format, saturation_level, bNormalization)
%
%
%        Input:
%           -dir_name: the folder name where the stack is stored.
%           -format: an LDR format for reading LDR images.
%           -saturation_level: when the camera satures for RAW files.
%           -bNormalization: is a flag for normalizing or not the stack in
%           [0, 1].
%
%        Output:
%           -stack: a stack of exposure values from images in dir_name
%
%     Copyright (C) 2015  Francesco Banterle
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

if(~exist('bNormalization', 'var'))
    bNormalization = 0;
end

if(~exist('saturation_level', 'var'))
    saturation_level = 2^12 - 1;
end

list = dir([dir_name, '/*.', format]);
n = length(list);

if(n > 0)
    info = read_raw_info([dir_name, '/', list(1).name]);
      
    stack = zeros(info.Height, info.Width, info.NumberOfSamples, n, 'single');

    for i=1:n
        name = [dir_name, '/', list(i).name];
        %read an image, and convert it into floating-point
        [img, ~, saturation_level] = read_raw(name, saturation_level);
        
        img = ClampImg(single(img), 0, saturation_level);
        
        if(bNormalization)
            img = img / saturation_level;
        end

        %store in the stack
        stack(:,:,:,i) = img;    
    end
end

end