function [ContrastIm,Patch] = localhisteq(I,windowSize)

[height,width] = size(I);
TopBottom = flip(I,1);
LeftRight = flip(I,2);
Corner = flip(TopBottom,2);
ConcIm = [Corner,TopBottom,Corner;LeftRight,I,LeftRight;Corner,TopBottom,Corner];

HistEdges = -0.5:1:255.5; % 256 bins of width 1
startX = width+1; endX = width*2; startY = height+1; endY = height*2; % Defining the center image among the 9.
padY = (windowSize(1) - 1)/2; padX = (windowSize(2)-1)/2;
ContrastIm = zeros(height,width);
indY = 1;

for i = startY:endY
    indX = 1;
    for j = startX:endX
        Patch = ConcIm(i-padY:i+padY,j-padX:j+padX);
        Counts = histcounts(Patch,HistEdges);
        PDF = Counts/sum(Counts);
        CDF = zeros(1,length(PDF)+1); % CDF gives the mapping for the histogram equalization.
        for k = 1:length(PDF)
            CDF(k+1) = CDF(k) + PDF(k);
        end
        curI = Patch(padY+1,padX+1); % Find intensity of center pixel in the patch
        newI = floor(CDF(curI+1+1)*(255)); % +1 since CDF starts from 0 & +1 since intensity starts from 0
        ContrastIm(indY,indX) = newI;
        indX = indX + 1;
    end
    indY = indY + 1;
end    

ContrastIm = uint8(ContrastIm);
end

