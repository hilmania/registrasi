function i = ResizePhoto(i,a)
% Crop the input photo into specified size

[h,w,z] = size(i);

if h/w>a
    ho = a*w;
    d = ceil((h-ho)/2);
    i = i(d+1:end-d,:,:);
else
    wo = h/a;
    d = ceil((w-wo)/2);
    i = i(:,d+1:end-d,:);
end