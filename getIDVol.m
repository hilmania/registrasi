function idVol=getIDVol

[s, out] = dos('vol');
sc = strsplit(out,'\n');
idVol = sc{2}(end-8:end);