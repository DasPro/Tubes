unit uFilm;

interface
uses uKata;

const Nmax = 1000;
type Film = record
    Nama:string;
    Genre:string;
    Rating:string;
    Durasi:string;
    Sin:ansistring;
    hDay:longint;
    hEnd:longint;
end;

type dbFilm = record
	Film : array[1..Nmax] of Film;
	Neff : integer;
end;

procedure loadFilm(var dF: dbFilm);
{* procedure untuk me-load data dari File external dataFilm.txt 
   dan dimasukkan kedalam variable internal
I.S : variable dataFilm internal kosong, dataFilm.txt sudah ada
F.S : dataFilm.txt sudah masuk ke File Internal, dataFilm *}
procedure genreFilter(dF: dbFilm); 		//F5-genreFilter
{*	procedure untuk menampilkan List Judul Film berdasarkan Genre.
I.S	: dataFilm sudah siap dipilih dan dipilah berdasarkan Genre, Genre di Input oleh User
F.S	: menampilkan List Judul Film yang sesuai dengan Genre Input dari User *}
procedure ratingFilter(dF: dbFilm);		//F6-ratingFilter
{*	procedure untuk menampilkan List Judul Film berdasarkan RatingViewer.
I.S	: dataFilm sudah Siap. RatingViewer di Input oleh User
F.S	: menampilkan List Judul Film yang sesuai dengan RatingViewer Input dari User *}
procedure searchMovie(dF : dbFilm); 	//F7-searchMovie
{*	procedure untuk mencari keyword berdasarkan Nama Film, Genre Film, Sinopsis.
I.S	: dataFilm sudah terdefinisi, input dan f telah terdefinisi
F.S : menampilkan Nama Film yang sesuai dengan keyword yang dimasukkan	*}
procedure showMovie(TFilm : dbFilm);

implementation
// -------------- Load untuk dataFilm.txt --------------- //
procedure loadFilm(var dF: dbFilm);
var 
	dfilm: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	assign(dfilm,'database\datafilm.txt');
	reset(dfilm);
	while not Eof(dfilm) do
	begin
		readln(dfilm,f);
			for i:=1 to 7 do
			begin
				pos1:=pos('|',f);
				l:=length(copy(f,1,pos1+1));
				case i of
				1:dF.Film[j].Nama:=copy(f,1,pos1-2);
				2:dF.Film[j].Genre:=copy(f,1,pos1-2);
				3:dF.Film[j].Rating:=copy(f,1,pos1-2);
				4:dF.Film[j].Durasi:=copy(f,1,pos1-2);
				5:dF.Film[j].Sin:=copy(f,1,pos1-2);
				6:val(copy(f,1,pos1-2),dF.Film[j].hDay);
				7:val(copy(f,1,pos1-2),dF.Film[j].hEnd);
				end;
        		delete(f,1,l);
        	end;
        j:=j+1;
    end;
    dF.Neff:=j-1;
	close(dfilm);
end;

	//F5-genreFilter
	procedure genreFilter(dF: dbFilm);
	var
		pilihan: string; i: integer;
	begin
		write('> Genre: ');readln(pilihan);
		for i:=1 to dF.Neff do
		begin
			if lowAll(pilihan)=lowAll(dF.Film[i].Genre) then
				writeln('> ',dF.Film[i].nama);
		end;
	end;

	//F6-ratingFilter
	procedure ratingFilter(dF: dbFilm);
	var 
		pilihan: string; i: integer;
	begin
		write('> Rating Viewer: ');readln(pilihan);
		for i:=1 to dF.Neff do
		begin
			if lowAll(pilihan)=lowAll(dF.Film[i].Rating) then
				writeln('> ',dF.Film[i].nama);
		end;
	end;

	//F7-searchMovie
	procedure searchMovie(dF : dbFilm);
	{Kamus}
	var
		i,idx1, idx2, idx3 : integer;
		input : string;
		
	{Algoritma}
	begin
		write('> Masukkan pencarian berdasarkan sinopsis, judul, atau genre : ');
		readln(input);
		writeln('> Daftar film yang sesuai dengan pencarian : ');
		//Mekanisme Pencarian Daftar Film
		for i:= 1 to dF.Neff do
		begin
			idx1 := pos(lowAll(input), lowAll(dF.Film[i].Nama));
			idx2 := pos(lowAll(input), lowAll(dF.Film[i].Genre));
			idx3 := pos(lowAll(input), lowAll(dF.Film[i].Sin));
			if ( idx1<>0 ) or ( idx2<>0 ) or ( idx3<>0 ) then
				writeln('> ',dF.Film[i].Nama);
		end;
	end;
	
	//F8-showMovie
	Procedure showMovie(TFilm : dbFilm);

	var
		judul : string;
		i : integer;
		found : boolean;
		
	begin
		repeat
			write('> Judul Film : ');
			readln(judul);
			i := 1;
			found := False;
			while (i <= TFilm.Neff) and (found=False) do
			begin
				if (lowAll(judul)=lowAll(TFilm.Film[i].Nama)) then
					found := True
				else
					i := i + 1;
			end;
			if (found = False) then
			begin
				writeln('Masukkan judul film salah');
			end else
			begin
			writeln('> ', TFilm.Film[i].Nama);
			writeln('> ', TFilm.Film[i].Genre); 
			writeln('> ', TFilm.Film[i].Rating);
			writeln('> ', TFilm.Film[i].Durasi);
			writeln('> ', TFilm.Film[i].Sin);
			end;
		until (found=True);
	end;

end.
