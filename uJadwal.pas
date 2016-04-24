unit uJadwal;

interface
uses uKata;

const Nmax = 1000;
type Tayang = record
		Nama,
		Jam : string;
		Tanggal,
		Bulan,
		Tahun,
		LamaTayang : integer;
end;

type dbTayang = record
	Tayang : array[1..Nmax] of Tayang;
	Neff : integer;
end;

procedure load (var f:text;p:string);
{* procedure yang digunakan untuk meng-assign nama lojik ke nama fisik
I.S	: f terdefinisi
F.S	: p telah di-assign dengan variabel f *}
procedure loadTayang(var dT: dbTayang);
{* procedure yang digunakan untuk me-load data dari file eksternal jadwal.txt ke dalam variabel internal
I.S	: file eksternal jadwal.txt telah terdefinisi
F.S	: data di jadwal.txt telah ditampung ke dalam dT *}

function idx ( f : string; T : dbTayang) : integer;
{Fungsi yang digunakan untuk mencari index pertama dari suatu film}

procedure TulisJam (idx : integer; f : string; T : dbTayang; tanggal : string);
{*	Procedure TulisJam digunakan untuk menuliskan Jam Tayang dari suatu Film pada tanggal tertentu
	I.S : idx, f, T, dd, mm, yy telah terdefinisi
	F.S : Menuliskan Jam Tayang kepada user 	*}

procedure schedule( T : dbTayang);
{*	Procedure schedule digunakan untuk menampilkan Jam Tayang dari input user
	I.S : T terdefinisi
	F.S : Menuliskan Jam Tayang Film kepada user	*}
	
	
implementation
procedure load (var f:text;p:string);
begin
	assign(f,p);
	reset(f);
end;
procedure loadTayang(var dT: dbTayang);
var 
	dTayang: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	load(dTayang,'database\jadwal.txt');
	while not Eof(dTayang) do
	begin
		readln(dTayang,f);
			for i:=1 to 6 do
			begin
				pos1:=pos('|',f);
				l:=length(copy(f,1,pos1+1));
				case i of
				1:dT.Tayang[j].Nama:=copy(f,1,pos1-2);
				2:dT.Tayang[j].Jam:=copy(f,1,pos1-2);
				3:val(copy(f,1,pos1-2),dT.Tayang[j].Tanggal);
				4:val(copy(f,1,pos1-2),dT.Tayang[j].Bulan);
				5:val(copy(f,1,pos1-2),dT.Tayang[j].Tahun);
				6:val(copy(f,1,pos1-2),dT.Tayang[j].LamaTayang);
				end;
        		delete(f,1,l);
        	end;
        j:=j+1;
    end;
    dT.Neff:=j-1;
	close(dTayang);
end;

function idx ( f : string; T : dbTayang) : integer;

{Kamus}
var
	i : integer;
	cek : boolean;
{Algoritma}
begin
	i := 1;
	cek := False;
	while (cek=False) and (i<=T.Neff) do
	begin
		if (lowAll(T.Tayang[i].Nama)=lowAll(f)) then
			cek := True;
		i := i + 1;
	end;
	if (cek=True) then
		idx := i - 1
	else
		idx := 0;
end;
	
procedure TulisJam (idx : integer; f : string; T : dbTayang; tanggal : string);

{Kamus}
var
	j, i, k, a : integer;
	h,b,y : integer;
	dd,mm,yy : integer;
	cek : boolean;
	
	
{Algoritma}
begin
	cek := False;
repeat
	y := T.Tayang[idx].Tahun;
	b := T.Tayang[idx].Bulan;
	h := T.Tayang[idx].Tanggal;
	//Konversi input user dari String to Integer
	val(copy(tanggal,1,2), dd);
	val(copy(tanggal,4,2), mm);
	val(copy(tanggal,7,4), yy);
	if (mm<10) and (dd<10) then
		writeln('> Daftar Jam Tayang Film ',T.Tayang[idx].Nama,' pada tanggal 0',dd,'-0',mm,'-',yy,' :')
	else if (mm<10) then
		writeln('> Daftar Jam Tayang Film ',T.Tayang[idx].Nama,' pada tanggal ',dd,'-0',mm,'-',yy,' :')
	else if (dd<10) then
		writeln('> Daftar Jam Tayang Film ',T.Tayang[idx].Nama,' pada tanggal 0',dd,'-',mm,'-',yy,' :')
	else
		writeln('> Daftar Jam Tayang Film ',T.Tayang[idx].Nama,' pada tanggal ',dd,'-',mm,'-',yy,' :');
	k := h + 6;
	if (k>tanggalMax(b,y)) then
	begin
		if (yy = y) and ((mm = b) or (mm = b+1)) then
			begin
					a := k - tanggalMax(b,y);			
					for j := h  to tanggalMax(b,y) do
					begin
						if ( j = dd ) then 
						begin
							for i := idx to (idx+3) do
							begin
								cek := true;
								if (lowAll(T.Tayang[i].Nama)=lowAll(f)) then
									writeln('> ',T.Tayang[i].Jam);
							end;
						end;
					end;
					for j := 1  to a do
					begin
						if ( j = dd ) then 
						begin
							for i := idx to (idx+3) do
							begin
								cek := true;
								if (lowAll(T.Tayang[i].Nama)=lowAll(f)) then
									writeln('> ',T.Tayang[i].Jam);
							end;
						end;
					end;
			end;
	end else			
	begin
		if (yy = y) and (mm = b) then
		begin
					for j := h  to (h+6) do
					begin
						if ( j = dd ) then 
						begin
							for i := idx to (idx+3) do
							begin
								cek := true;
								if (lowAll(T.Tayang[i].Nama)=lowAll(f)) then
									writeln('> ',T.Tayang[i].Jam);
							end;
						end;
					end;
		end;
	end;
		
		if cek=false then 
		begin
			writeln('> Jadwal tak tersedia ');
			writeln('> Ulangi input tanggal');
			write('> Tanggal tayang : ');
			readln(tanggal);
		end;
until cek = True;
end;

procedure schedule( T : dbTayang);

{Kamus}
var
	tanggal, f : string;
	index	: integer;
		
{Algoritma}
begin
	repeat
		write('> Film : ');
		readln(f);
		write('> Tanggal tayang : ');
		readln(tanggal);
		
		
		//Pencarian Film dan Penampilan Jam
		index := idx(f,T);
		if(index=0) then
		begin
			writeln('> Masukkan nama film atau tanggal tayang salah');
			writeln('> Silahkan ulang masukkan');
		end else
			TulisJam(index,f,T,tanggal);
	until (index>0) 
end;
	
end.
