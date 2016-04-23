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
	stopProgram:= false;
	idx := 0;
	
	repeat
		clrscr;
		writeln('===========================================================');
		writeln('    Selamat Datang di Pelayan Pemesanan Tiker Bioskop X    ');
		writeln('===========================================================');
		writeln();
		writeln('Berikut adalah Fungsi yang bisa digunakan:                 ');
		writeln(' 1. load            6. ratingFilter   11. payCreditCard    ');
		writeln(' 2. nowPlaying      7. searchMovie    12. payMember        ');
		writeln(' 3. upcoming        8. showMovie      13. loginMember      ');
		writeln(' 4. schedule        9. showNextDay    14. register         ');
		writeln(' 5. genreFilter    10. selectMovie    15. exit             ');
		writeln();
		write('> ');readln(Fx);
		case Fx of
			'load'			: begin
								loadFilm(tFilm);
								loadTayang(tTayang);
								loadKapasitas(tKapasitas);
								loadMember(tMember);
								loadTanggal(tgl);
								delay(1500);
							  end;
			'schedule'		: schedule(tTayang);
			'genreFilter'	: genreFilter(tFilm);
			'ratingFilter'	: ratingFilter(tFilm);
			'searchMovie'	: searchMovie(tFilm);
			'payCreditCard' : payCreditCard(tPemesanan,tFilm);
			'payMember'		: payMember(tPemesanan, tFilm, tMember, idx);
			'loginMember'	: loginMember(tMember, idx);
			'exit'			: begin
									F15Exit(tKapasitas,tMember,tPemesanan);
									stopProgram:=true;
							  end;
		end; 
		write('press Enter to continue..');readln();
	until stopProgram;
end.
