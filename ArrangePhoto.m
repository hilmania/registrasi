function I = ArrangePhoto(InputI,I,Nrol,Ncol)
% Arrange the photos into a big printable photo

[Hs,Ws,z]=size(InputI);
[H,W,z]=size(I);

if ((Hs*Nrol == H)||(Ws*Ncol==W))
    InputI = imresize(InputI,[Hs-1,Ws-1]);
    [Hs,Ws,z]=size(InputI);
end

Srol=ceil((H-Hs*Nrol)/(Nrol+1));
Scol=ceil((W-Ws*Ncol)/(Ncol+1));
if Srol<2
I = ones((Hs+Srol)*Nrol+Srol,size(I,2),3);
end

if Scol<2
I = ones(size(I,1),(Ws+Scol)*Ncol+Scol,3);
end

for j=1:Nrol
    for k=1:Ncol
        I((Hs+Srol)*(j-1)+Srol+1:(Hs+Srol)*(j-1)+Hs+Srol,(Ws+Scol)*(k-1)+Scol+1:(Ws+Scol)*(k-1)+Ws+Scol,:)=InputI;
    end
end
