unit uKapasitas;

interface
type Kapasitas = record
		Nama,
		Jam : string;
		Tanggal,
		Bulan,
		Tahun,
		Kapasitas : integer;
end;

type dbKapasitas = record
	Kapasitas : array[1..1000] of Kapasitas;
	Neff : integer;
end;

procedure load (var f:text;p:string);
procedure loadKapasitas(var dK: dbKapasitas);

implementation
procedure load (var f:text;p:string);
begin
	assign(f,p);
	reset(f);
end;
procedure loadKapasitas(var dK: dbKapasitas);
var 
	dKapasitas: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	load(dKapasitas,'database\kapasitas.txt');
	while not Eof(dKapasitas) do
	begin
		readln(dKapasitas,f);
			for i:=1 to 6 do
			begin
				pos1:=pos('|',f);
				l:=length(copy(f,1,pos1+1));
				case i of
				1:dK.Kapasitas[j].Nama:=copy(f,1,pos1-2);
				2:val(copy(f,1,pos1-2),dK.Kapasitas[j].Tanggal);
				3:val(copy(f,1,pos1-2),dK.Kapasitas[j].Bulan);
				4:val(copy(f,1,pos1-2),dK.Kapasitas[j].Tahun);
				5:dK.Kapasitas[j].Jam:=copy(f,1,pos1-2);
				6:val(copy(f,1,pos1-2),dK.Kapasitas[j].Kapasitas);
				end;
        		delete(f,1,l);
        	end;
        j:=j+1;
    end;
    dK.Neff:=j-1;
	close(dKapasitas);
end;

	
end.
