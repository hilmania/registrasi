function [namaFile, flag] = GarjasSaveOffline(id_user, namaPeserta, tinggi, berat, usia)

header1 = 'Nomor_Peserta';
header2 = 'Nama_Peserta';
header3 = 'Tinggi';
header4 = 'Berat';
header5 = 'Usia';

tanggal = date;
namaFile = [tanggal '_registrasi.dat'];
% [~, nama] = GarjasGetNama(id_user);
namaPeserta = strrep(namaPeserta,' ','_');

if exist(namaFile, 'file') == 2
    try
        fid=fopen(namaFile, 'a+');
        fprintf(fid, '\n %12s %12s %12s %12s %12s \n', [id_user ' ' namaPeserta ' ' tinggi ' ' berat ' '  int2str(usia) ' ']);
        fclose(fid);
        flag = true;
    catch
        warning('Cannot write a file!');
        flag = false;
    end
else
    try
        fid=fopen(namaFile, 'w');
        fprintf(fid, [ header1 ' ' header2 ' ' header3 ' ' header4 ' ' header5 '\n' ]);
        fprintf(fid, '\n %12s %12s %12s %12s %12s \n', [id_user ' ' namaPeserta ' ' tinggi ' ' berat ' '  int2str(usia) ' ']);
        fclose(fid);
        flag = true;
    catch
        warning('Cannot write a file!');
        flag = false;
    end
end