unit uMember;

interface
type Member = record
		UserName,
		Password : string;
		Saldo : longint;
end;

type dbMember = record
		Member : array[1..1000] of Member;
		Neff : integer;
end;

procedure load (var f:text;p:string);
procedure loadMember(var dM: dbMember);

procedure F14Register(var dM : dbMember);

implementation
procedure load (var f:text;p:string);
begin
	assign(f,p);
	reset(f);
end;
procedure loadMember(var dM: dbMember);
var 
	dMember: text;
	f:ansistring; 
	pos1,l,i,j:integer;
begin
	j:=1;
	load(dMember,'database\member.txt');
	while not Eof(dMember) do
	begin
		readln(dMember,f);
			for i:=1 to 3 do
			begin
				pos1:=pos('|',f);
				l:=length(copy(f,1,pos1+1));
				case i of
				1:dM.Member[j].UserName:=copy(f,1,pos1-2);
				2:dM.Member[j].Password:=copy(f,1,pos1-2);
				3:val(copy(f,1,pos1-2),dM.Member[j].Saldo);
				end;
        		delete(f,1,l);
        	end;
        j:=j+1;
    end;
    dM.Neff:=j-1;
	close(dMember);    
end;

procedure F14Register(var dM : dbMember);
// Kamus Lokal
Var
	username,password : string;
	i : integer;
	found,stop : boolean;
	
// Algoritma	
begin
	stop:=false;
	repeat
		write('> Buat UserName Anda: ');
		readln(username);
		i:=1;
		found:=false;
		while (found=false) and (i<=dM.Neff) do
		begin
			if username=dM.Member[i].UserName then
			begin
				found:=true;
				writeln('> Maaf UserName sudah digunakan');
			end;
			i:=i+1;
		end;
		if found=false then 
			stop:=true;
	until (stop=true);
	write('> Masukkan password Anda: ');readln(password);
	dM.Neff:= dM.Neff+1;
	dM.Member[dM.Neff].UserName:=username;
	dM.Member[dM.Neff].Password:=password;
	dM.Member[dM.Neff].Saldo:=100000;
end;

	
end.
