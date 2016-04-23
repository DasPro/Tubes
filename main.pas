program ReservasiTiketBioskop;

uses uFilm, uJadwal, uKapasitas, uMember, uTanggal, uGeneral,
	sysutils, crt;

var
	tFilm	: dbFilm;
	tTayang	: dbTayang;
	tKapasitas: dbKapasitas;
	tMember : dbMember;
	tPemesanan : dbPemesanan;
	tgl : Tanggal;
	Fx : string;
	stopProgram : boolean;
	idx : integer;
	
begin
	// -- Proses Inisiasi -- //
	loadFile(tFilm,tTayang,tKapasitas,tMember,tPemesanan,tgl);
	persiapan;
	stopProgram:= false;
	idx := 0;
	
	repeat
		clrscr;
		layarUtama;
		write('> ');readln(Fx);
		case Fx of
			'load'			: loadFile(tFilm,tTayang,tKapasitas,tMember,tPemesanan,tgl);
			'nowPlaying'	: nowPlaying(tKapasitas,tgl);
			'upcoming'		: upcoming(tKapasitas,tgl);
			'schedule'		: schedule(tTayang);
			'genreFilter'	: genreFilter(tFilm);
			'ratingFilter'	: ratingFilter(tFilm);
			'searchMovie'	: searchMovie(tFilm);
			'showMovie'		: showMovie(tFilm);
			'showNextDay'	: showNextDay(TTayang, tgl);
			'selectMovie'	: selectMovie(TKapasitas, TPemesanan); 
			'payCreditCard' : payCreditCard(tPemesanan,tFilm);
			'payMember'		: payMember(tPemesanan, tFilm, tMember, idx);
			'loginMember'	: loginMember(tMember, idx);
			'register'		: 
			begin
				register(tMember);
				clrscr; 
				layarUtama;
				writeln('> Selamat Akun Member anda sudah terdaftar');
			end;

			'exit'			: begin
									F15Exit(tKapasitas,tMember,tPemesanan);
									stopProgram:=true;
							  end;
		end; 
		write('press Enter to continue..');readln();
	until stopProgram;
end.
