program Server;

{$H-}
{$mode delphi}


uses {$ifdef unix} cthreads {$endif} crt, connections, sockets, sysutils, windows;


var
sockMain, sockSlave: connectionSocket;
clCount,nstr: integer;
isConnect: int64;
clSockets: array of longword;
textar: array [5..30] of string;
portstr: string;
port, codeerr: integer;


function decoder(msg: string): string;
	var i: integer;
	fmsg:string[255];
begin
	fmsg:='';
	for i:=1 to Length(UTF8Decode(msg)) do
		fmsg:=fmsg+UTF8Encode(Copy(UTF8Decode(msg),i,1));
	decoder:=fmsg;
end;

procedure servProg;
var
numb, iprv: integer;
clmsg: string[255];
cl: connectionSocket;
NameClient: array [100..999] of string;
begin
	
	cl.acceptConnect(sockMain.numberSocket);
	clCount := clCount + 1;
	Numb := clCount-1;
	setlength(clSockets, clCount);
	clSockets[Numb]:=cl.numberSocket;
	writeln('Connect: ', clSockets[clCount-1], ' - ', getclientip(cl));
	beginthread(@servProg);
	delay(100);
	repeat
	isConnect:=cl.receiveMsg(clmsg);
	clmsg:=decoder(clmsg);
	
	//command manage
	if clmsg[1]=':' Then
	begin
	
	if pos(':name:',clmsg)<>0 then
	begin
	delete(clmsg,1,6);
	NameClient[cl.numberSocket]:=clmsg;
	end;
	
	delete(clmsg,1,length(clmsg));
	end;
	//command manage
	
	if (isConnect <> 0) and (isConnect <> -1) then
		begin
			if clmsg<>'' then
			begin
			
			if (nstr>=4) and (nstr<=24) then
			begin
			clmsg  :=  inttostr(nstr) + ':' + NameClient[cl.numberSocket] + ': ' + clmsg;
			writeln(clmsg);
			for  iprv := 0 to clCount-1 do
			fpsend(clSockets[iprv], @clmsg, 254, 0);
			inc(nstr);
			end
			else
			begin
			nstr:=5;
			clmsg  :=  inttostr(nstr) + ':' + NameClient[cl.numberSocket] + ': ' + clmsg;
			writeln(clmsg);
			for  iprv := 0 to clCount-1 do
			fpsend(clSockets[iprv], @clmsg, 254, 0);
			inc(nstr);
			end;
			end;
			
		end;
		
	until (isConnect = 0) or (isConnect = -1);
	
	writeln('Disconnect: ', cl.numberSocket, ' - ', getclientip(cl));
	if Numb <  clCount-1  then
	for iprv := Numb to clCount-1 do
	begin
		clSockets[iprv] := clSockets[iprv+1];
	end;
	clCount :=  clCount-1;
	setlength(clSockets, clCount);
	cl.socketClose;
end;



begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);

repeat
write(decoder('Укажите порт для сервера (1024-49151): '));
readln(portstr);
val(portstr,port,codeerr);
clrscr;
until (codeerr=0) and (port >= 1024) and (port <= 49151);

nstr:=5;
sockMain.createSocket(port);

repeat
servProg;
delay(100);
until false;
sockMain.socketClose;
end.
