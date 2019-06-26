itr=size(response.disjas_master_test,1)
allidtest=[];
for k=1:itr
    stridtest=response.disjas_master_test(k).id_test
    allidtest=cat(1,allidtest,str2double(stridtest));
end
allidtest