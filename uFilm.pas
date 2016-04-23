unit uFilm;

interface

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
	Film : array[1..1000] of Film;
	Neff : integer;
end;

// untuk pengatur karakter String (pembantu untuk search) //
	function low(C : char) : Char;				// pengecil Char
	function cap(C : char) : Char;				// pengkapital Char
	function lowAll(Str :String) : string;		// pengecil seluruh String
	function capAll(Str :String) : string;		// pengkapital seluruh String
	function capFirst(Str :string) : string;	// pengkapital Huruf diawal String
	function capEach(Str :String) : string;		// pengkapital setiap Kata
// ------------------------------------------------------ //

procedure load (var f:text;p:string);
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

implementation
// ------------------------------------------------------ //
// untuk pengatur karakter String (pembantu untuk search) //
function low(C : char) : Char;
begin
case C of
	'A' : C:='a';
	'B' : C:='b';
	'C' : C:='c';
	'D' : C:='d';
	'E' : C:='e';
	'F' : C:='f';
	'G' : C:='g';
	'H' : C:='h';
	'I' : C:='i';
	'J' : C:='j';
	'K' : C:='k';
	'L' : C:='l';
	'M' : C:='m';
	'N' : C:='n';
	'O' : C:='o';
	'P' : C:='p';
	'Q' : C:='q';
	'R' : C:='r';
	'S' : C:='s';
	'T' : C:='t';
	'U' : C:='u';
	'V' : C:='v';
	'W' : C:='w';
	'X' : C:='x';
	'Y' : C:='y';
	'Z' : C:='z';
end;

low:=C;
end;

function cap(C : char) : Char;
begin
case C of
	'a' : C:='A';
	'b' : C:='B';
	'c' : C:='C';
	'd' : C:='D';
	'e' : C:='E';
	'f' : C:='F';
	'g' : C:='G';
	'h' : C:='H';
	'i' : C:='I';
	'j' : C:='J';
	'k' : C:='K';
	'l' : C:='L';
	'm' : C:='M';
	'n' : C:='N';
	'o' : C:='O';
	'p' : C:='P';
	'q' : C:='Q';
	'r' : C:='R';
	's' : C:='S';
	't' : C:='T';
	'u' : C:='U';
	'v' : C:='V';
	'w' : C:='W';
	'x' : C:='X';
	'y' : C:='Y';
	'z' : C:='Z';
end;

cap:=C;
end;

function lowAll(Str :String) : string;
var n, i : longint;
begin
	n:=length(Str);
	for i:=1 to n do
		Str[i]:=low(Str[i]);
	lowAll:=Str;
end;

function capAll(Str :String) : string;
var n, i : longint;
begin
	n:=length(Str);
	for i:=1 to n do
		Str[i]:=cap(Str[i]);
	capAll:=Str;
end;

function capFirst(Str :String) : string;
begin
	Str:=lowAll(Str);
	Str[1]:=cap(Str[1]);
	capFirst:=Str;
end;

function capEach(Str :String) : string;
var n,i,m,j : longint;
	tempPos : array[1..256] of integer;
begin
n:= length(Str);
j:=1;
Str:=lowAll(Str);
	for i:=1 to n do
	begin
		if Str[i]=' ' then
		begin
			tempPos[j]:=i+1;
			j:=j+1;
		end;
		
		Str[1]:=cap(Str[1]);
		m:=j;
		for j:=1 to m do
			Str[tempPos[j]] := cap(Str[tempPos[j]]);
		
	end;
capEach:=Str;
end;
// ------------------------------------------------------ //

// -------------- Load untuk dataFilm.txt --------------- //
procedure load (var f:text;p:string);
begin
	assign(f,p);
	reset(f);
end;

procedure loadFilm(var dF: dbFilm);
var 
	dfilm: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	load(dfilm,'database\datafilm.txt');
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
	writeln('> Data Film sudah di load, banyak Film ada ',dF.Neff);
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
		write('> Masukkan Pencarian : ');
		readln(input);
		writeln('> Daftar Film : ');
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
end.
