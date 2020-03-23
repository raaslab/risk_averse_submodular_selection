clear all; close all;

FILE = 'campus';

IMG = imread([FILE,'.png']);
imshow(IMG);
title({'Click on the vertices of an obstacle in clockwise order.', ...
    'Hit enter when done with one obstacle. Hit enter twice when done with all obstacles.'})
env = [];

done = false;
while ~done
    x = [];
    y = [];
    [x, y] = getpts();
    if numel(x)==0
        done = true;
    else
        env{length(env)+1} = [x,y];
        patch(x,y,'y');
    end
end
save([FILE,'.mat'],'env');