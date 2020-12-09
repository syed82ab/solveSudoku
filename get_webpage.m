% Open up a webpage
url = 'https://www.websudoku.com/?level=4'; % Look familiar?
[~, webHandle] = web(url,'-new','-notoolbar');
% Wait until the web page is loaded. There may be a way to do this
% programatically, I haven't looked into this
pause(5);
% Get the web page location in the screen space
location = webHandle.getLocationOnScreen();
% Create and set the java rectangle object dimensions
rect = java.awt.Rectangle();
rect.x = location.x;
rect.y = location.y;
rect.width = webHandle.getWidth();
rect.height = webHandle.getHeight();
% Get a screen capture of the window space using a java robot
robot = java.awt.Robot();
capture = robot.createScreenCapture(rect);
% Data time!
rawData = reshape(capture.getRaster().getDataBuffer().getData(), rect.width, rect.height); % Returns an int32 where RGB is store in 8 bytes of each int
rgb = zeros(rect.height, rect.width, 3); % Buffer for RGB triplets so Matlab can plot it. Note how the dimensions are seemingly reversed
rgb(:, :, 1) = bitshift(bitand(rawData', hex2dec('ff0000')), -16); % Red
rgb(:, :, 2) = bitshift(bitand(rawData', hex2dec('ff00')), -8); % Green
rgb(:, :, 3) = bitand(rawData', hex2dec('ff')); % Blue
% Scale from 0-255 to 0-1, because Matlab is just weird
rgb = rgb / 255;
% Plot the image
figure;
image(rgb);

