unit uGeneral;

interface

uses sysutils,uJadwal,uTanggal,uMember,uKapasitas,uFilm;

type Pemesanan = record
	No : integer;
	Nama : string;
	Tanggal, Bulan, Tahun : integer;
	Jam : string;
	Jumlahkursi : integer;
	Total : longint;
	Jenis : string;
end;

type dbPemesanan = record
		Pemesanan : array [1..1000] of Pemesanan;
		Neff : integer;
end;

procedure F15Exit (T1 : dbKapasitas; T3 : dbMember; T2 : dbPemesanan);
{* Procedure F15Exit digunakan untuk menyalin semua hasil perubahan file eksternal
   yang ditampung di dalam array ke dalam file eksternal awal tersebut
   I.S : T1, T2, dan T3 telah terdefinisi
   F.S : File eksternal kapasitas.txt, pemesanan.txt, dan member.txt telah di-update *}

procedure loginMember(T: dbMember; var idx: integer);
{I.S : Terdefinisi
F.S: idx > 0 sebagai penanda login}

procedure payMember (T1 : dbPemesanan ; T2 : dbFilm ; T3: dbMember ; idx : integer); 
{I.S : T1, T2, dan T3 terdefinisi
 F.S : pembayaran sukses}
 
procedure payCreditCard(T1: dbPemesanan; T2: dbFilm);
{I.S : T1 dan T2 terdefinisi
F.S : Jenis pembayaran terupdate}
 
function cariIndeks(Tab1 : dbFilm; Tab2 :dbPemesanan) : integer;
{I.S : Tab1 dan Tab2 terdefinisi}
{F.S : indeks untuk array terdefinisi}
 
implementation

//F-15Exit
procedure F15Exit (T1 : dbKapasitas; T3 : dbMember; T2 : dbPemesanan);


{Kamus Lokal}
var
	i,j,k : integer;
	fin1,fin2,fin3 : text;
	tanggal, bulan, tahun, nomor, total, saldo, kapasitas, jumlahkursi : string;

{Algoritma}
begin
		assign(fin1, 'database/kapasitas.txt');
		rewrite(fin1);
		for i := 1 to T1.Neff do
		begin
			Str(T1.Kapasitas[i].Tanggal, tanggal);
			Str(T1.Kapasitas[i].Bulan, bulan);
			Str(T1.Kapasitas[i].Tahun, tahun);
			Str(T1.Kapasitas[i].Kapasitas, kapasitas);
			writeln(fin1, T1.Kapasitas[i].Nama,' | ',tanggal,' | ',bulan,' | ',tahun,' | ',T1.Kapasitas[i].Jam,' | ',kapasitas,' | ')
		end;
		assign(fin3, 'database/member.txt');
		rewrite(fin3);
		for k := 1 to T3.Neff do
		begin
			Str(T3.Member[k].Saldo, saldo);
			writeln(fin3, T3.Member[k].UserName,' | ',T3.Member[k].Password,' | ',saldo,' | ')
		end;
		assign(fin2, 'database/datapemesanan.txt');
		rewrite(fin2);
		for j := 1 to T2.Neff do
		begin
			Str(T2.Pemesanan[i].No, nomor);
			Str(T2.Pemesanan[i].Tanggal, tanggal);
			Str(T2.Pemesanan[i].Bulan, bulan);
			Str(T2.Pemesanan[i].Tahun, tahun);
			Str(T2.Pemesanan[i].Total, total);
			Str(T2.Pemesanan[i].Jumlahkursi, jumlahkursi);
			writeln(fin2, nomor,' | ',tanggal,' | ',bulan,' | ',tahun,' | ',T2.Pemesanan[i].Jam,' | ',jumlahkursi,' | ',total,' | ',T2.Pemesanan[i].Jenis,' | ')
		end;
		close(fin1);
		close(fin2);
		close(fin3);
end;
//Procedur F13-loginMember
	procedure loginMember(T: dbMember; var idx: integer);
	//kamus
	var a : integer;
		sandi, user : string;
		found: boolean;

	//algoritma lokal
	begin
		repeat
			a := 1 ;
			found := false;
			write('> Masukkan username :');
			readln(user);
			write('> Masukkan password :');
			readln(sandi);
			while (Found = False) and (a <= T.Neff) do
			begin
				if (user = T.Member[a].UserName) and (sandi = T.Member[a].Password) then
				begin
					found:= True;
					writeln('> Halo ! Anda login sebagai ', T.Member[a].UserName);
					writeln('> Sisa Saldo anda adalah ', T.Member[a].Saldo);
				end else
				begin 
					a:= a + 1;
				end;
			end;
			
			if (found = False) then
			begin
				writeln('> Username atau password salah');
				a := 0
			end;
		until (Found = True);
		idx := a
	end;
	

//Fungsi Cari indeks
	function cariIndeks(Tab1 : dbFilm; Tab2 :dbPemesanan) : integer;
	//kamus lokal
	var
	i: integer;
	cek : boolean;
	//Algoritme lokal
	begin
		i:= 1;
		cek := false;
		while (i <= 1000) and (cek=False) do
		begin
			if (Tab1.Film[i].Nama = Tab2.Pemesanan[i].Nama) then
			begin
				cek := True;
			end else
				i:= i + 1;
		end;
		cariIndeks := i;
	end;
	
//F11-payCreditCard
	procedure payCreditCard(T1: dbPemesanan; T2: dbFilm);
	//kamus lokal
	var
	c, idx, DD, MM, YY : integer;
	kkredit, nopesan : string;
	harga, X, Y: longint;
	//Algoritma lokal
	begin
	write('> Nomor Pemesanan: ');
	readln(nopesan);
	Val(copy(nopesan,3,1), c);
	
	DD := T1.Pemesanan[c].Tanggal;
	MM := T1.Pemesanan[c].Bulan;
	YY := T1.Pemesanan[c].Tahun;
	
	idx := cariIndeks(T2,T1);
	//mengubah isi dari tabel ke long int dan menampungnya ke suatu variable 
	X := T1.Pemesanan[c].Total; 
	Y := T2.Film[idx].hEnd;
	if (getDay(DD,MM,YY) = 'Sabtu') and ( T1.Pemesanan[c].Jumlahkursi > 1) then
	begin
		 harga:= x - y;
	end else
		harga:= x;
	
	writeln('> Harga yang harus dibayar: ',harga);
	write('> Nomor kartu kredit: ');
	//asumsi input selalu valid 15 digit
	readln(kkredit);									
	writeln('> Pembayaran sukses!'); 
	//mmengganti status pencatatan di array
	T1.Pemesanan[c].Jenis := 'Credit Card';
	end;
		
//F12-payMember
	procedure payMember (T1 : dbPemesanan ; T2 : dbFilm ; T3: dbMember ; idx : integer); 
	//kamus lokal
	var
	sisaSaldo, hargamember, harga : longint;
	i, c : integer;
	nopesan, pilihan : string;
	//algoritma
	begin
			if (idx=0) then
				loginMember(T3, idx)
			else
			begin
				writeln('> Anda akan melakukan pembayaran menggunakan saldo member');
				write('> Nomor pesanan: ');
				readln(nopesan);
				c := StrToInt(nopesan[3]); 
				harga := T1.Pemesanan[c].Total;
				hargamember := 9 * harga div 10 ;
				writeln('> Harga yang harus dibayar: ',hargamember);
				if (T3.Member[idx].Saldo >= hargamember) then
					begin
						sisaSaldo:= T3.Member[idx].Saldo - hargamember;
						writeln('> Sisa saldo anda adalah : ',sisaSaldo);
						writeln('> Pembayaran sukses!'); 
						//mmengganti status pencatatan di array
						T1.Pemesanan[c].Jenis := 'Member';
					end else
					begin
							writeln('> Sisa saldo anda tidak mencukupi');
							writeln('> Silahkan pilih metode pembayaran lain. Metode pembayaran yang dapat anda lakukan:');
							writeln('> 1 Tunai');
							writeln('> 2 Pay Member');
							readln(pilihan);
							if (pilihan = 'Tunai') then
							begin
								writeln('> Kode booking anda adalah ', nopesan);
								writeln('> Silahkan melakukan pembayaran di bioskop');
								T1.Pemesanan[c].Jenis := 'Tunai';
							end else if (pilihan = 'Pay Member') then 
							begin
								payCreditCard(T1, T2);
							end;
					end;
				end;
		
	end;
	
end.
