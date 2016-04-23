unit uTanggal;

interface

type Tanggal = record
	Hari : string;
	Tanggal,
	Bulan,
	Tahun : integer;
end;

procedure load (var f:text;p:string);
procedure loadTanggal(var tgl: Tanggal);

procedure makeTanggal(Tanggal,Bulan,Tahun :integer; var tgl : Tanggal);
function isKabisat(Tahun: integer) : boolean;
function nameBulan(Bulan: integer): string;
function getDay(Tanggal, Bulan, Tahun : integer) : string ;
function tanggalMax(Bulan,Tahun : integer) : integer;
function afterXDay(tgl : Tanggal; x : integer ) : Tanggal ;
procedure writeTanggal(tgl :Tanggal);
function isTanggalValid(Tanggal, Bulan, Tahun : integer) : boolean;


implementation
// --- Load File untuk tanggal.txt --- //
procedure load (var f:text;p:string);
begin
	assign(f,p);
	reset(f);
end;
procedure loadTanggal(var tgl: Tanggal);
var 
	dTanggal: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	load(dTanggal,'database\tanggal.txt');
	while not Eof(dTanggal) do
	begin
		readln(dTanggal,f);
			for i:=1 to 4 do
			begin
				pos1:=pos('|',f);
				l:=length(copy(f,1,pos1+1));
				case i of
				1:val(copy(f,1,pos1-2),tgl.Tanggal);
				2:val(copy(f,1,pos1-2),tgl.Bulan);
				3:val(copy(f,1,pos1-2),tgl.Tahun);
				4:tgl.Hari:=copy(f,1,pos1-2);
				end;
        		delete(f,1,l);
        	end;
        j:=j+1;
    end;
	close(dTanggal);
end;
// --- Selesai Load --- //

	function getDay(Tanggal, Bulan, Tahun : integer) : string ;
	var
		i : integer;
		jml : longint;
	begin
		// Senin => 1 Januari 1990 || deafult
		jml:=0;
		for i:=1990 to ((Tahun)-1) do
		begin
			if ((i mod 4) = 0) then
				jml:=jml+366
			else
				jml:=jml+365;
		end;
		for i:=1 to ((Bulan)-1) do
		begin
			if ( (i=1)or(i=3)or(i=5)or(i=7)or(i=8)or(i=10)or(i=12) ) then
				jml:=jml+31
			else 
				if ( (i = 2) and ((Tahun mod 4) = 0) ) then
					jml:=jml+29
				else if ( (i = 2) and ((Tahun mod 4) <> 0) ) then
					jml:=jml+28
				else
					jml:=jml+30;
		end;
		jml:=jml+ ( (Tanggal) - 1 );
		
		case (jml mod 7) of
			0 : getDay:=('Senin');
			1 : getDay:=('Selasa');
			2 : getDay:=('Rabu');
			3 : getDay:=('Kamis');
			4 : getDay:=('Jumat');
			5 : getDay:=('Sabtu');
			6 : getDay:=('Minggu');
		end;
	end;

	procedure makeTanggal(Tanggal, Bulan, Tahun :integer; var tgl : Tanggal);
	begin
		tgl.Hari:=getDay(Tanggal, Bulan, Tahun);
		tgl.Tanggal:=Tanggal;
		tgl.Bulan:=Bulan;
		tgl.Tahun:=Tahun;
	end;

	function isKabisat(tahun: integer) : boolean;
	begin
		if tahun mod 4 = 0 then
			isKabisat:=true
		else
			isKabisat:=false;
	end;

	function nameBulan(bulan: integer): string;
	begin
		case (bulan) of
		1: nameBulan:='Januari';
		2: nameBulan:='Februari';
		3: nameBulan:='Maret';
		4: nameBulan:='April';
		5: nameBulan:='Mei';
		6: nameBulan:='Juni';
		7: nameBulan:='Juli';
		8: nameBulan:='Agustus';
		9: nameBulan:='September';
		10: nameBulan:='Oktober';
		11: nameBulan:='November';
		12: nameBulan:='Desember';
		end;
	end;

	function tanggalMax(bulan,tahun : integer) : integer;
	begin
		case (bulan) of
		1: tanggalMax:=31;
		2: if ( (tahun mod 4) = 0) then
				tanggalMax:=29
			else tanggalMax:=28;
		3: tanggalMax:=31;
		4: tanggalMax:=30;
		5: tanggalMax:=31;
		6: tanggalMax:=30;
		7: tanggalMax:=31;
		8: tanggalMax:=31;
		9: tanggalMax:=30;
		10: tanggalMax:=31;
		11: tanggalMax:=30;
		12: tanggalMax:=31;
		end;
	end;

	function afterXDay(tgl : Tanggal; x : integer ) : Tanggal ;
	var
		Tanggal, Bulan, Tahun : integer;
		hari: integer;
		
	begin
		Tanggal:=tgl.Tanggal;
		Bulan:=tgl.Bulan;
		Tahun:=tgl.Tahun;
		hari:=Tanggal+x;
		if (x<0) then
		begin
			while ( hari<0 ) do
			begin
				hari:=hari+tanggalMax(Bulan, Tahun);
				Bulan:=Bulan-1;
				if Bulan=0 then
				begin
					Bulan:=12;
					Tahun:=Tahun-1;
				end;
			end;
			makeTanggal(Tanggal,Bulan,Tahun, tgl);
			afterXDay:=tgl;
		end else begin
			while ( (hari>366) or (hari>365) )  do
			begin
				if ( (Tahun mod 4) = 0) then
				begin
					Tahun:=Tahun+1;
					hari:=hari-366;
				end
				else 
				begin
					Tahun:=Tahun+1;
					hari:=hari-365;
				end;	
			end;
			while hari>tanggalMax(Bulan,Tahun) do
			begin
				hari:=hari-tanggalMax(Bulan,Tahun);
				Bulan:=Bulan+1;
			end;
			makeTanggal(hari,Bulan,Tahun, tgl);
			afterXDay:=tgl;
		end;
	end;

	procedure writeTanggal(tgl :Tanggal);
	begin
		writeln(getDay(tgl.Tanggal, tgl.Bulan, tgl.Tahun),', ', tgl.Tanggal , ' ' , nameBulan(tgl.bulan) ,' ', tgl.tahun);
	end;

	function isTanggalValid(Tanggal, Bulan, Tahun :integer) : boolean;
	begin
		if Tahun>0 then
			if ( (Bulan>0) and (Bulan<=12) ) then
				if ( (Tanggal>0) and (Tanggal<=tanggalMax(Bulan,Tahun)) ) then 
					isTanggalValid:=True
				else
					isTanggalValid:=false
			else
				isTanggalValid:=false
		else
			isTanggalValid:=false;	
	end;

end.
