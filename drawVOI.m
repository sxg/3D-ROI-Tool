function drawVOI(vol)
%drawVOI GUI tool to draw a volume of interest (VOI) on a volume.

slice = floor(size(vol, 3) / 2);
nSlices = size(vol, 3);
figureHandle = figure('Position', [300, 300, 1500, 1000]);
im(vol(:, :, slice));
guiHandle = guihandles(figureHandle);
guiHandle.voi = zeros(size(vol));
guidata(figureHandle, guiHandle);

% Properties
rotations = 0;
lrFlips = 0;

% Rotate button
uicontrol(gcf, 'Style', 'pushbutton', 'String', 'Rotate 90º', ...
    'Position', [50, 50, 100, 30], 'Callback', @rotate, 'UserData', ...
    struct('roiRotationAngle', 0));
% Flip button
uicontrol(gcf, 'Style', 'pushbutton', 'String', 'Flip', ...
    'Position', [50, 100, 100, 30], 'Callback', @flip);
% Next slice button
uicontrol(gcf, 'Style', 'pushbutton', 'String', 'Next Slice', ...
    'Position', [50, 150, 100, 30], 'Callback', @nextSlice);
% Previous slice button
uicontrol(gcf, 'Style', 'pushbutton', 'String', 'Previous Slice', ...
    'Position', [50, 200, 100, 30], 'Callback', @prevSlice);
% Draw VOI button
uicontrol(gcf, 'Style', 'pushbutton', 'String', 'Draw VOI', ...
    'Position', [50, 250, 100, 30], 'Callback', @draw);
% Save VOI button
uicontrol(gcf, 'Style', 'pushbutton', 'String', 'Save VOI', ...
    'Position', [50, 300, 100, 30], 'Callback', @save);
sliceText = uicontrol(gcf, 'Style', 'text', 'String', sprintf('%i/%i', ...
    slice, nSlices), 'Position', [50, 350, 100, 30], 'FontSize', 20);

% Pause
uiwait();

    function rotate(~, ~)
        rotations = mod(rotations + 1, 4);
        vol = rot90(vol, 1);
        im(vol(:, :, slice));
    end

    function flip(~, ~)
        lrFlips = mod(lrFlips + 1, 2);
        vol = fliplr(vol);
        im(vol(:, :, slice));
    end

    function nextSlice(~, ~)
        if slice < size(vol, 3)
            slice = slice + 1;
        end
        im(vol(:, :, slice))
        sliceText.String = sprintf('%i/%i', slice, nSlices);
    end
    
    function prevSlice(~, ~)
        if slice > 1
            slice = slice - 1;
        end
        im(vol(:, :, slice))
        sliceText.String = sprintf('%i/%i', slice, nSlices);
    end

    function draw(buttonHandle, ~)
        % Rotate and flip the VOI to match the image before storing
        tempVOI = roipoly;
        tempVOI = rot90(tempVOI, rotations + 3);
        if lrFlips == 0
            tempVOI = fliplr(tempVOI);
        end
        guiHandle = guidata(buttonHandle);
        guiHandle.voi(:, :, slice) = tempVOI;
        guidata(buttonHandle, guiHandle);
    end

    function save(buttonHandle, ~)
        guiHandle = guidata(buttonHandle);
        voi = guiHandle.voi;
        uisave('voi', 'VOI.mat');
    end

end

