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
	idx, x : integer;
	
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
			'upcoming'		: upcoming(tTayang,tgl);
			'schedule'		: schedule(tTayang);
			'genreFilter'	: genreFilter(tFilm);
			'ratingFilter'	: ratingFilter(tFilm);
			'searchMovie'	: searchMovie(tFilm);
			'showMovie'		: showMovie(tFilm);
			'showNextDay'	: showNextDay(TTayang, tgl);
			'selectMovie'	: selectMovie(TKapasitas, TPemesanan, TFilm); 
			'payCreditCard' : payCreditCard(tPemesanan,tFilm);
			'payMember'		: 
			begin
				payMember(tPemesanan, tFilm, tMember, idx);
			end;
			'loginMember'	: loginMember(tMember, idx);
			'register'		: 
			begin
				F14Register(tMember);
				clrscr; 
				layarUtama;
				writeln('> Selamat Akun Member anda sudah terdaftar');
			end;

			'exit'			: 
			begin
				F15Exit(tKapasitas,tMember,tPemesanan);
				stopProgram:=true;
			end;

			//Fungsi Tambahan
			'cekTanggal'	: writeTanggal(tgl);
			'tambahTanggal'	: 
			begin
				write('> Input X: ');readln(x);
				tgl:=afterXDay(tgl,x);
			end;
			
		end; 
		write('press Enter to continue..');readln();
	until stopProgram;
end.
