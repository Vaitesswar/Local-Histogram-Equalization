%% Local Histogram Equalization
I = imread('Lena.bmp');
windowSize = [101,101]; % Assumed to be odd-numbered window
[ContrastIm,Patch] = localhisteq(I,windowSize);
HistEdges = -0.5:1:255.5; % 256 bins of width 1

Counts = histcounts(Patch,HistEdges);
PDF = Counts/sum(Counts);
CDF = zeros(1,length(PDF)+1); % CDF gives the mapping for the histogram equalization.
for k = 1:length(PDF)
    CDF(k+1) = CDF(k) + PDF(k);
end

[height,width] = size(Patch);
TransIm = zeros(size(Patch));
for i = 1:height
    for j = 1:width
        intensity = Patch(i,j);
        TransIm(i,j) = floor(CDF(intensity+1)*255); % +1 since CDF starts from 0 & +1 since intensity starts from 0
    end
end

figure('Name','Local Histogram Equalization','NumberTitle','off');
imshow(ContrastIm)
figure('Name','Histogram - Contrast image','NumberTitle','off');
histogram(ContrastIm,HistEdges)