program Client;

{$MODE delphi}

uses {$ifdef unix} cthreads {$endif} crt, connections, sysutils, windows;

const lenscreen = 25;

var
socketMain: connectionSocket;
msg, name, portstr,ipaddres: string[255];
isconnect: longint;
ycur, key, ikey, i, port, codeerr: integer;
wrtPos: array of string;

//encoder function
function ecd(msgecd: String): String;
var iecd: integer;
begin
	ecd:=msgecd;
	for iecd:=1 to length(msgecd) do
	begin
		if (ord(msgecd[iecd])<>208) and (ord(msgecd[iecd])<>209) then
		ecd[iecd]:=chr(ord(msgecd[iecd])+key);
	end;
end;

//decoder function
function dcd(msgdcd: String): String;
var idcd: integer;
begin
	dcd:=msgdcd;
	for idcd:=1 to length(msgdcd) do
	begin
		if (ord(msgdcd[idcd])<>208) and (ord(msgdcd[idcd])<>209) then
		dcd[idcd]:=chr(ord(msgdcd[idcd])-key);
	end;
end;

//support function
function decoder(msgd: string): string;
	var i: integer;
	fmsg:string[255];
begin
	fmsg:='';
	for i:=1 to Length(UTF8Decode(msgd)) do
		fmsg:=fmsg+UTF8Encode(Copy(UTF8Decode(msgd),i,1));
	decoder:=fmsg;
end;

//receave alltime
procedure check;
begin
	while true do
	begin
		if socketMain.sendMsg(name)<>-1
		then
		begin
			wrtPos[1]:=('|Connect|');
			wrtPos[2]:=('----------------------------------------------------');
			wrtPos[4]:=('----------------------------------------------------');
			wrtPos[25]:=('----------------------------------------------------');
		end
		else
		begin
			socketMain.createSocket(ipaddres,port);
			socketMain.connectSocket;
			wrtPos[1]:=('|Disconnect|');
			wrtPos[2]:=('----------------------------------------------------');
			wrtPos[4]:=('----------------------------------------------------');
			wrtPos[25]:=('----------------------------------------------------');
		end;
		delay(1000);
	end;
end;

//write screen alltime
procedure screen;
var
i:integer;
begin
	while true do
	begin
		for i:=1 to lenscreen do
		begin
			if wrtPos[i]<>'' then
			begin
				gotoXY(1,i);
				clreol;
				write(wrtPos[i]);
			end;
		end;
		delay(800);
	end;
end;

procedure responseMsg;
var
rmsgN: string[255];
msgname: string;
i: integer;
begin
	while true do
	begin

		socketMain.receiveMsg(rmsgN);

		if socketMain.sendMsg(name)=-1 then rmsgN:='';

		if rmsgN<>'' then
		begin

			//scrap and decode
			(*--------*)
			msgname:=copy(rmsgn,1,pos(':',rmsgn)+1);
			delete(rmsgn,1,pos(':',rmsgn)+1);
			rmsgN:=dcd(rmsgN);
			rmsgN:=msgname+rmsgN;
			(*--------*)

			//scroll messege
			for i:=5 to 23 do
				wrtpos[i]:=wrtpos[i+1];

			//last messege
			wrtpos[24]:=rmsgN;

		end;
		
		delay(100);
	end;
end;

begin
	SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
	
	setlength(wrtPos,lenscreen+1);
	beginthread(@screen);
	
	wrtPos[1]:=(decoder('Адрес сервера (формат 192.168.88.1): '));
	gotoXY(1,3);
	readln(ipaddres);
	gotoXY(1,3);
	clreol;
	
	repeat
	wrtPos[1]:=(decoder('Порт сервера: '));
	gotoXY(1,3);
	readln(portstr);
	gotoXY(1,3);
	clreol;
	val(portstr,port,codeerr);
	until codeerr=0;
	
	repeat
	wrtPos[1]:=(decoder('Ключ шифрования (рекомендуется меньше 10): '));
	gotoXY(1,3);
	readln(portstr);
	gotoXY(1,3);
	clreol;
	val(portstr,key,codeerr);
	until codeerr=0;
	
	wrtPos[1]:=(decoder('Ваше имя:'));
	gotoXY(1,3);
	readln(name);
	name:=decoder(name);
	name:=':name:'+name;

	socketMain.createSocket(ipaddres,port);
	socketMain.connectSocket;
	beginthread(@check);
	beginthread(@responseMsg);
	delay(50);

	repeat
		gotoXY(1,3);
		clreol;
		readln(msg);
		
		//name edit
		{if (pos(':name:',msg)<>0) or (pos(':Name:',msg)<>0) or (pos(':NAME:',msg)<>0) then
		begin
			name:=msg;
			gotoXY(1,3);
		end;}
		
		{$ifdef win32}msg:= utf8Encode(msg);{$endif}
		
		if msg<>'' then
		begin
			msg:=ecd(msg);
			isConnect:=socketMain.sendMsg(msg);
		end
		else
			gotoXY(1,3);
	until false;
end.
