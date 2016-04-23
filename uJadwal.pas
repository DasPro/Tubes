unit uJadwal;

interface
type Tayang = record
		Nama,
		Jam : string;
		Tanggal,
		Bulan,
		Tahun,
		LamaTayang : integer;
end;

type dbTayang = record
	Tayang : array[1..1000] of Tayang;
	Neff : integer;
end;

procedure load (var f:text;p:string);
procedure loadTayang(var dT: dbTayang);

function idx ( f : string; T : dbTayang) : integer;
{Fungsi yang digunakan untuk mencari index pertama dari suatu film}

procedure TulisJam (idx : integer; f : string; T : dbTayang; tanggal : string);
{	Procedure TulisJam digunakan untuk menuliskan Jam Tayang dari suatu Film pada tanggal tertentu
	I.S : idx, f, T, dd, mm, yy telah terdefinisi
	F.S : Menuliskan Jam Tayang kepada user 	}

procedure schedule( T : dbTayang);
{	Procedure schedule digunakan untuk menampilkan Jam Tayang dari input user
	I.S : T terdefinisi
	F.S : Menuliskan Jam Tayang Film kepada user	}
	
procedure nowPlaying(dT: dbKapasitas;tgl:tanggal);	
{Procedure yang menampilkan film hari ini
  I.S : dT terdefinisi
  F.S : Menuliskan judul film yang tayang}
  
procedure upcoming(dT: dbKapasitas;tgl:tanggal);	
{Procedure yang menampilkan film yang tayang minggu depan atau h+7
  I.S : dT terdefinisi
  F.S : Menuliskan judul film yang tayang}
	
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
	writeln('> Data JadwalTayang sudah di load, banyak Jadwal Tayang ada ',dT.Neff);

    begin
    	writeln('Nama :',dT.Tayang[1].Nama);
    	writeln('Jam Tayang :',dT.Tayang[1].Jam);
    	writeln('Tanggal :',dT.Tayang[1].Tanggal);
    	writeln('Bulan :',dT.Tayang[1].Bulan);
    	writeln('Tahun :',dT.Tayang[1].Tahun);
    	writeln('Lama Tayang :',dT.Tayang[1].LamaTayang);
    	writeln;
    end;

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
	idx := i - 1;
end;
	
procedure TulisJam (idx : integer; f : string; T : dbTayang; tanggal : string);

{Kamus}
var
	j, i : integer;
	h,b,y : integer;
	dd,mm,yy : integer;
	
{Algoritma}
begin
	y := T.Tayang[idx].Tahun;
	b := T.Tayang[idx].Bulan;
	h := T.Tayang[idx].Tanggal;
	//Konversi input user dari String to Integer
	val(copy(tanggal,1,2), dd);
	val(copy(tanggal,4,2), mm);
	val(copy(tanggal,7,4), yy);
	writeln('> Daftar Jam Tayang Film ',T.Tayang[idx].Nama,' pada tanggal ',dd,'-0',mm,'-',yy,' :');
	if (yy = y) and (mm = b) then
		begin
			for j := h  to (h+6) do
			begin
				if ( j = dd ) then 
				begin
					for i := idx to (idx+3) do
					begin
						if (lowAll(T.Tayang[i].Nama)=lowAll(f)) then
							writeln('> ',T.Tayang[i].Jam);
					end;
				end;
			end;
		end;
end;

procedure schedule( T : dbTayang);

{Kamus}
var
	tanggal : string;
	f	: string;
	i : integer;
	index	: integer;
		
{Algoritma}
begin
	write('> Film : ');
	readln(f);
	write('> Tanggal tayang : ');
	readln(tanggal);
	
	
	//Pencarian Film dan Penampilan Jam
	index := idx(f,T);
	TulisJam(index,f,T,tanggal);
	
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
      Writeln('>',dT.Kapasitas[i].Nama);
      i:=i+1;
      while (dT.Kapasitas[i].Nama=dT.Kapasitas[i-1].Nama) and (i<=dT.Neff) do
        i:=i+1;
    End
    Else
    i:=i+1;
  End;
End;

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
      Writeln('>',dT.Kapasitas[i].Nama);
      i:=i+1;
      while (dT.Kapasitas[i].Nama=dT.Kapasitas[i-1].Nama) and (i<=dT.Neff) do
        i:=i+1;
    End
    Else
    i:=i+1;
  End;
End;

procedure upcoming(dT: dbKapasitas;tgl:tanggal);

{Kamus}
Var
  i:integer;
  
{Algoritma}
Begin
  tgl:=afterXDay(tgl,7);
  nowPlaying(dT,tgl);
End;
	
end.
