classdef TiffVolumeViewer
    properties
        Lookup struct = struct()

        Threshold
        Brightness
        Contrast
    end

    methods
        function obj = TiffVolumeViewer()
            obj.Lookup = FileLookup('tif');


            
        end
    end
end