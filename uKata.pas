unit uKata;

interface
function low(C : char) : Char;
function cap(C : char) : Char;
function lowAll(Str :String) : string;
function capAll(Str :String) : string;
function capFirst(Str :string) : string;
function capEach(Str :String) : string;

implementation
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
end.
