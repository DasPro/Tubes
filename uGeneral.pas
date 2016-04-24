unit uGeneral;

interface

uses crt,sysutils,uJadwal,uTanggal,uMember,uKapasitas,uFilm,uKata;

const Nmax = 1000;
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
		Pemesanan : array [1..Nmax] of Pemesanan;
		Neff : integer;
end;

procedure load (var f:text;p:string);
procedure loadPemesanan(var dP : dbPemesanan);
procedure loadFile(var dF : dbFilm; var dT : dbTayang; var dK: dbKapasitas; var dM : dbMember; var dP : dbPemesanan; var tgl : Tanggal);
procedure layarUtama;
procedure persiapan;

procedure showNextDay(TJadwal : dbTayang; tgl : Tanggal);
procedure selectMovie(var TKapasitas : dbKapasitas; var TPemesanan : dbPemesanan; TFilm : dbFilm);

procedure nowPlaying(dT: dbKapasitas;tgl:tanggal);	
{Procedure yang menampilkan film hari ini
  I.S : dT terdefinisi
  F.S : Menuliskan judul film yang tayang}
  
procedure upcoming(dT: dbTayang;tgl:tanggal);	
{Procedure yang menampilkan film yang tayang minggu depan atau h+7
  I.S : dT terdefinisi
  F.S : Menuliskan judul film yang tayang}
  
procedure F15Exit (T1 : dbKapasitas; T3 : dbMember; T2 : dbPemesanan);
{* Procedure F15Exit digunakan untuk menyalin semua hasil perubahan file eksternal
   yang ditampung di dalam array ke dalam file eksternal awal tersebut
   I.S : T1, T2, dan T3 telah terdefinisi
   F.S : File eksternal kapasitas.txt, pemesanan.txt, dan member.txt telah di-update *}

procedure loginMember(T: dbMember; var idx: integer);
{I.S : Terdefinisi
F.S: idx > 0 sebagai penanda login}

procedure payMember (var T1 : dbPemesanan ; T2 : dbFilm ;var T3: dbMember ;var idx : integer); 
{I.S : T1, T2, dan T3 terdefinisi
 F.S : pembayaran sukses}
 
procedure payCreditCard(var T1: dbPemesanan; T2: dbFilm);
{I.S : T1 dan T2 terdefinisi
F.S : Jenis pembayaran terupdate}
 
function cariIndeks(Tab1 : dbFilm; Tab2 :dbPemesanan) : integer;
{I.S : Tab1 dan Tab2 terdefinisi}
{F.S : indeks untuk array terdefinisi}
 
implementation
procedure load (var f:text;p:string);
begin
	assign(f,p);
	reset(f);
end;
procedure loadPemesanan(var dP : dbPemesanan);
var 
	dPemesanan: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	load(dPemesanan,'database\pemesanan.txt');
	while not Eof(dPemesanan) do
	begin
		readln(dPemesanan,f);
			for i:=1 to 9 do
			begin
				pos1:=pos('|',f);
				l:=length(copy(f,1,pos1+1));
				case i of
				1:val(copy(f,1,pos1-2),dP.Pemesanan[j].No);
				2:dP.Pemesanan[j].Nama:=copy(f,1,pos1-2);
				3:val(copy(f,1,pos1-2),dP.Pemesanan[j].Tanggal);
				4:val(copy(f,1,pos1-2),dP.Pemesanan[j].Bulan);
				5:val(copy(f,1,pos1-2),dP.Pemesanan[j].Tahun);
				6:dP.Pemesanan[j].Jam:=copy(f,1,pos1-2);
				7:val(copy(f,1,pos1-2),dP.Pemesanan[j].Jumlahkursi);
				8:val(copy(f,1,pos1-2),dP.Pemesanan[j].Total);
				9:dP.Pemesanan[j].Jenis:=copy(f,1,pos1-2);
				end;
        		delete(f,1,l);
        	end;
        j:=j+1;
    end;
    dP.Neff:=j-1;
	close(dPemesanan);
end;

procedure loadFile(var dF : dbFilm; var dT : dbTayang; var dK: dbKapasitas; var dM : dbMember; var dP : dbPemesanan; var tgl : Tanggal);
begin
	loadFilm(dF);
	loadTayang(dT);
	loadKapasitas(dK);
	loadMember(dM);
	loadPemesanan(dP);
	loadTanggal(tgl);
	writeln('> File telah di load');
end;

procedure layarUtama;
begin
	writeln('===========================================================');
	writeln('    Selamat Datang di Pelayan Pemesanan Tiker Bioskop X    ');
	writeln('===========================================================');
	writeln;
	writeln('Berikut adalah Fungsi yang bisa digunakan:                 ');
	writeln(' 1. load            6. ratingFilter   11. payCreditCard    ');
	writeln(' 2. nowPlaying      7. searchMovie    12. payMember        ');
	writeln(' 3. upcoming        8. showMovie      13. loginMember      ');
	writeln(' 4. schedule        9. showNextDay    14. register         ');
	writeln(' 5. genreFilter    10. selectMovie    15. exit             ');
	writeln();
end;

procedure persiapan;
begin
	writeln('> Sedang malakukan proses loading..');
	write('> Menyiapkan program');delay(300);write('.');delay(400);write('.');delay(400);writeln('.');delay(700);
	writeln('> Semua telah siap!');
end;

//menampilkan jadwal tayang hari berikutnya (F9)
procedure showNextDay(TJadwal : dbTayang; tgl : Tanggal);
var
	i : integer;
	judul : string;
begin
	tgl := afterXDay(tgl, 1);
	i := 1;
	while (i <= TJadwal.Neff) do
	begin
		if ((tgl.tanggal = TJadwal.Tayang[i].tanggal) 
		and (tgl.bulan = TJadwal.Tayang[i].bulan)
		and (tgl.tahun = TJadwal.Tayang[i].tahun)) then
		begin
			write('> ', TJadwal.Tayang[i].Nama, ' | ');
			judul := TJadwal.Tayang[i].Nama;
			while (TJadwal.Tayang[i].Nama = Judul) do
			begin
				write(Tjadwal.Tayang[i].Jam,' | ');
				i := i+1;
			end; // looping untuk penulisan jam tayang Film
			writeln;
		end else i:=i+1;
	end;
end;

//memilih movie
procedure selectMovie(var TKapasitas : dbKapasitas; var TPemesanan : dbPemesanan; TFilm : dbFilm);
var
	film : string;
	i, idx : integer;
	tanggal, jam, hari : string;
	tgl, bln, thn, tiket, N : integer;
	cek, stop, berhenti : boolean;
	terminate : Char;
begin
	repeat	
		berhenti := false;
		stop := false;
		repeat
			write('> Judul Film : ');
			readln(film); 
			i:= 1;
			cek := False;
			while (i < TKapasitas.Neff) and (cek = False) do
			begin
				if (lowAll(film) = lowAll(TKapasitas.Kapasitas[i].nama)) then
				begin
					stop := true; cek:=true;
				end else i:=i+1;
			end;
			if cek = false then
			begin
				writeln('> input judul salah');
				writeln('> Apakah anda ingin melanjutkan pencarian');
				write('> Y/N : ');
				readln(terminate);
				if (terminate='N') then
				begin
					berhenti:=true;
				end else if (terminate='Y') then 
				begin
					berhenti:= false;
				end else 
					berhenti:=false;
			end;
		until (stop=true) or (berhenti=true); // indeks pertama dari judul film sudah ditemukan (i)	
				
		if berhenti = false then
		begin
			stop := false;
			idx := i;
			repeat	
				i := idx;
				cek := false;
				write('> Tanggal Tayang : ');
				readln(tanggal);
				val(copy(tanggal, 1 , 2),tgl);
				val(copy(tanggal, 4, 2), bln);
				val(copy(tanggal, 7, 4), thn);
				while (cek = false) and (i <= TKapasitas.Neff) and (lowall(TKapasitas.Kapasitas[i].Nama) = lowall(Film)) do
				begin
					if ((tgl = TKapasitas.Kapasitas[i].tanggal) and (bln = TKapasitas.Kapasitas[i].bulan) and (thn = TKapasitas.Kapasitas[i].tahun)) then
					begin
						cek := true;
					end else 
					begin
						i := i + 1;
					end;
				end;
				if (cek = false) then
				begin
					writeln('> input tanggal salah');
					writeln('> Apakah anda ingin melanjutkan pencarian');
					write('> Y/N : ');
					readln(terminate);
					if (low(terminate)='n') then
					begin
						berhenti:=true;
					end else 
					if (low(terminate)='y') then 
					begin
						berhenti:= false;
					end;
				end else 
					stop := true;
			until ((stop = true) or (berhenti = true)); // indeks pada tanggal yang benar sudah didapatkan
			end;
		
			if berhenti = false then
			begin
				//setting jam tayang
				stop := false;
				idx :=i;
				repeat
					i := idx;
					cek := false;
					write('> Jam Tayang : '); readln(jam);
					while (cek = false) and (i <= TKapasitas.Neff) and (lowall(film) = lowall(TKapasitas.Kapasitas[i].Nama)) do
					begin
						if (jam = TKapasitas.Kapasitas[i].Jam) then
						begin
							cek := true;
						end else 
						begin
							i := i +1;
						end;	
					end;
					if cek = false then
					begin
						writeln('> input jam tayang salah, ulangi input jam tayang!');
						writeln('> Apakah anda ingin melanjutkan pencarian');
						write('> Y/N : ');
						readln(terminate);
						if (low(terminate)='n') then
						begin
							berhenti:=true;
							stop:= true;
						end else 
						if (low(terminate)='y') then 
						begin
							berhenti:= false;
						end;
					end else 
						stop := true;
				until stop=true or berhenti=true; // indeks pada film yang diinginkan sudah didapatkan
			end;
			
			if berhenti=false then
			begin
				//pemrosesan pembelian kursi
				writeln('> Kapasitas Tersisa ', TKapasitas.Kapasitas[i].Kapasitas ,' orang');
				write('> Masukkan jumlah tiket yang ingin dibeli : '); readln(tiket);
				if tiket > 0 then
				begin 
					while (tiket > TKapasitas.Kapasitas[i].Kapasitas) or (tiket <= 0) do
					begin
						write('> Masukkan kembali jumlah tiket yang ingin dibeli : '); readln(tiket);
					end;
					TKapasitas.Kapasitas[i].Kapasitas := TKapasitas.Kapasitas[i].Kapasitas - tiket;
					N := TPemesanan.Neff;
					TPemesanan.Neff := N + 1;
					TPemesanan.Pemesanan[N+1].Nama:= TKapasitas.Kapasitas[i].Nama;
					TPemesanan.Pemesanan[N+1].Jam:= jam;
					TPemesanan.Pemesanan[N+1].Tanggal:= tgl;
					TPemesanan.Pemesanan[N+1].Bulan:= bln;
					TPemesanan.Pemesanan[N+1].Tahun:= thn;
					TPemesanan.Pemesanan[N+1].Jenis:= 'Belum Dibayar';
					TPemesanan.Pemesanan[N+1].JumlahKursi := tiket;
					TPemesanan.Pemesanan[N+1].No := TPemesanan.Neff;
					hari := getDay(tgl, bln, thn);
					cek := false;
					i := 1;
					if ((hari = 'Sabtu') or (hari = 'Minggu')) then
					begin
						while (i < TFilm.Neff) and (cek = False) do
						begin
							if TFilm.Film[i].Nama = film then
							begin
								cek := True;
							end else i := i +1;
						end;
						TPemesanan.Pemesanan[N+1].Total := (TFilm.Film[i].hEnd) * tiket;
					end else
					begin
						TPemesanan.Pemesanan[N+1].Total := (TFilm.Film[i].hDay) * tiket;
					end;
					
					write('> Pemesanan sukses, nomor pemesanan Anda adalah: ' );
					if TPemesanan.Neff < 10 then writeln('00',TPemesanan.Neff) else
					if (TPemesanan.Neff<100) then writeln('0',TPemesanan.Neff) else
					writeln(TPemesanan.Neff);
				end;
			writeln('> Apakah Anda Ingin Melanjutkan Pemesanan?');
			write('> Y/N : '); readln(terminate);
			if low(terminate)='n' then 
				berhenti := true 
			else 
				berhenti:=false;	
		end;
	until (berhenti = True);

end;

procedure nowPlaying(dT: dbKapasitas;tgl:tanggal);

{Kamus}
Var
  i:integer;
  
{Algoritma}
Begin
	i:=1;
	While (i<=dT.Neff) do
	Begin  
		If (tgl.Tanggal=dT.Kapasitas[i].Tanggal) and (tgl.Bulan=dT.Kapasitas[i].Bulan) and (tgl.Tahun=dT.Kapasitas[i].Tahun) then
		Begin
			Writeln('> ',dT.Kapasitas[i].Nama);
			i:=i+1;
			while (dT.Kapasitas[i].Nama=dT.Kapasitas[i-1].Nama) and (i<=dT.Neff) do
			i:=i+1;
		End
	Else
		i:=i+1;
	End;
End;

procedure upcoming(dT: dbTayang; tgl: Tanggal);

{Kamus}
Var
  i, j, a, count :integer;
  
{Algoritma}
Begin
	a := 0;
	tgl:=afterXDay(tgl,7);
	writeln('> Film yang akan tayang :');
	for j:=1 to 7 do
	Begin
		count:=0;
		tgl:=afterXDay(tgl,1);
		write('> ');
		writeTanggal(tgl);
		i:=1;
		While (i<=dT.Neff) do
		Begin
			If (tgl.Tanggal=dT.Tayang[i].Tanggal) and (tgl.Bulan=dT.Tayang[i].Bulan) and (tgl.Tahun=dT.Tayang[i].Tahun) then
			Begin
				Writeln('> ',dT.Tayang[i].Nama);
				count:=count+1;
				i:=i+1;
				while (dT.Tayang[i].Nama=dT.Tayang[i-1].Nama) and (i<=dT.Neff) do
				begin
					i:=i+1;
				end;
				a := a+1;
			End
			Else
				i:=i+1;
		End;
		if count<1 then
		begin
			writeln('> Tidak ada Film baru');
		end;
		writeln();
	End;
	if a=0 then
	begin
		writeln('> Tidak ada');
	end;
End;

//F-15Exit
procedure F15Exit (T1 : dbKapasitas; T3 : dbMember; T2 : dbPemesanan);


{Kamus Lokal}
var
	i,j,k : integer;
	fin1,fin2,fin3 : text;
	tanggal, bulan, tahun, nomor, total, saldo, kapasitas, jumlahkursi, no : string;

{Algoritma}
begin
		assign(fin1, 'database\kapasitas.txt');
		rewrite(fin1);
		for i := 1 to T1.Neff do
		begin
			Str(T1.Kapasitas[i].Tanggal, tanggal);
			Str(T1.Kapasitas[i].Bulan, bulan);
			Str(T1.Kapasitas[i].Tahun, tahun);
			Str(T1.Kapasitas[i].Kapasitas, kapasitas);
			writeln(fin1, T1.Kapasitas[i].Nama,' | ',tanggal,' | ',bulan,' | ',tahun,' | ',T1.Kapasitas[i].Jam,' | ',kapasitas,' | ')
		end;
		assign(fin3, 'database\member.txt');
		rewrite(fin3);
		for k := 1 to T3.Neff do
		begin
			Str(T3.Member[k].Saldo, saldo);
			writeln(fin3, T3.Member[k].UserName,' | ',T3.Member[k].Password,' | ',saldo,' | ')
		end;
		assign(fin2, 'database\pemesanan.txt');
		rewrite(fin2);
		for j := 1 to T2.Neff do
		begin
			Str(T2.Pemesanan[j].No, no);
			if (T2.Pemesanan[j].No) < 10 then 
				nomor := '00'+ no
			else if (T2.Pemesanan[j].No < 100) then 
				nomor := '0'+ no
			else
				nomor := no;
			Str(T2.Pemesanan[j].Tanggal, tanggal);
			Str(T2.Pemesanan[j].Bulan, bulan);
			Str(T2.Pemesanan[j].Tahun, tahun);
			Str(T2.Pemesanan[j].Total, total);
			Str(T2.Pemesanan[j].Jumlahkursi, jumlahkursi);
			writeln(fin2, nomor,' | ',T2.Pemesanan[j].Nama,' | ',tanggal,' | ',bulan,' | ',tahun,' | ',T2.Pemesanan[j].Jam,' | ',jumlahkursi,' | ',total,' | ',T2.Pemesanan[j].Jenis,' | ')
		end;
		close(fin1);
		close(fin2);
		close(fin3);
		write('> Sedang menyimpan data'); delay(200);
		write('.');delay(200);
		write('.');delay(500);
		writeln('.');delay(500);
		writeln;
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
	procedure payCreditCard(var T1: dbPemesanan; T2: dbFilm);
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
	
	while c>T1.Neff do
	begin
		writeln('> Maaf No pemesanan tidak ada dalam data base. Ulangi Input!');
		write('> Nomor pesanan: ');
		readln(nopesan);
		c := StrToInt(nopesan[3]); 
	end;
	if (T1.Pemesanan[c].Jenis<>'Belum Dibayar') then
		writeln('> Nomor pesanan telah dibayar')
	else
	begin
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
	end;
		
//F12-payMember
	procedure payMember (var T1 : dbPemesanan ; T2 : dbFilm ;var T3: dbMember ;var idx : integer); 
	//kamus lokal
	var
	sisaSaldo, hargamember, harga : longint;
	c : integer;
	stop: boolean;
	nopesan, pilihan : string;
	//algoritma
	begin
		if (idx=0) then
		begin
			loginMember(T3, idx);
		end else
		begin
			writeln('> Halo ! Anda login sebagai ', T3.Member[idx].UserName);
			writeln('> Sisa Saldo anda adalah ', T3.Member[idx].Saldo);
		end;
		
		writeln('> Anda akan melakukan pembayaran menggunakan saldo member');
		write('> Nomor pesanan: ');
		readln(nopesan);
		c := StrToInt(nopesan[3]); 
		while c>T1.Neff do
		begin
			writeln('> Maaf No pemesanan tidak ada dalam data base. Ulangi Input!');
			write('> Nomor pesanan: ');
			readln(nopesan);
			c := StrToInt(nopesan[3]); 
		end;
		if (T1.Pemesanan[c].Jenis<>'Belum Dibayar') then
			writeln('> Nomor pesanan telah dibayar')
		else
		begin
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
				T3.Member[idx].Saldo:=sisaSaldo;
			end else
			begin
				writeln('> Sisa saldo anda tidak mencukupi');
				writeln('> Silahkan pilih metode pembayaran lain.');
				writeln('> Metode pembayaran yang dapat anda lakukan:');
				writeln('> 1 Tunai');
				writeln('> 2 payCreditCard');
				stop:=false;
				repeat
					write('> ');readln(pilihan);
					if (pilihan = 'Tunai') then
					begin
						writeln('> Kode booking anda adalah ', nopesan);
						writeln('> Silahkan melakukan pembayaran di bioskop');
						T1.Pemesanan[c].Jenis := 'Tunai';
						stop:=true;
					end else if (pilihan = 'payCreditCard') then 
					begin
						payCreditCard(T1, T2);
						stop:=true;
					end else
					begin
						writeln('> Input salah!');
					end;
				until stop=true;
			end;
		end;	
	end;
	
	
end.
