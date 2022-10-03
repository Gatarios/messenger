unit connections;

interface

uses Sockets, crt;

type connectionSocket = object
public
NameClient: string;
numberSocket: LongWord;
addrlist: sockaddr;
socketLen: LongWord;
procedure createSocket(sockIp: string; sockPort: LongWord);
function connectSocket: longint;
procedure connectSocket;
procedure createSocket(sockPort: LongWord);
procedure acceptConnect(numsock: longint);
function receiveMsg(var msg: string): int64;
procedure receiveMsg(var msg: string);
function sendMsg(msg: string): longint;
procedure sendMsg(msg: string);
procedure socketClose;
end;

function GetClientIP(socketNum: connectionSocket): string;
procedure connectionHelp;

implementation

//client socket
procedure connectionSocket.createSocket(sockIp: string; sockPort: LongWord);
begin
numberSocket:=fpsocket(AF_INET, SOCK_STREAM, 0);
if numberSocket = -1 then
write('Error create socket: ', socketError);
addrlist.sa_family:=af_inet;
addrlist.sin_addr:=StrtoNetAddr(sockIp);
addrlist.sin_port:=htons(sockPort);
socketLen:=sizeof(sockaddr);
end;

//clent socket connect
function connectionSocket.connectSocket: longint;
begin
socketLen:=sizeof(sockaddr);
connectSocket:=fpconnect(numberSocket, @addrlist, socketLen);
end;

//clent socket connect
procedure connectionSocket.connectSocket;
begin
socketLen:=sizeof(sockaddr);
fpconnect(numberSocket, @addrlist, socketLen);
end;

//main socket server
procedure connectionSocket.createSocket(sockPort: LongWord);
begin
numberSocket:=fpsocket(AF_INET, SOCK_STREAM, 0);
if numberSocket = -1 then
write('Error create socket: ', socketError);
addrlist.sa_family:=af_inet;
addrlist.sin_addr.s_addr:=htonl(INADDR_ANY);
addrlist.sin_port:=htons(sockPort);
socketLen:=sizeof(sockaddr);
if fpbind(numberSocket, @addrlist, socketLen) = -1 then
write('Error bind socket: ', socketError);
if fplisten(numberSocket, SOCK_STREAM) =-1 then
write('Error listen socket: ', socketError);
end;

//accept connections in main server socket out slave server socket
procedure connectionSocket.acceptConnect(numsock: longint);
begin
socketLen:=sizeof(sockaddr);
numberSocket:=fpaccept(numsock, @addrlist, @socketLen);
if numbersocket =-1
then write('Error accept connection: ', socketError, ' ', numberSocket);
end;

//take msg out client
//msg - point varriable to write recieves
function connectionSocket.receiveMsg(var msg: string): int64;
var pmsg: string;
begin
receiveMsg:=fprecv(numberSocket, @pmsg, 254, 0);
//if (receiveMsg = -1) and (socketError<>10054) and (socketError<>10057)
//then write('Error receive message: ', socketError, ' ', numberSocket);
msg:=pmsg;
end;

//take msg out client
//msg - point varriable to write recieves
procedure connectionSocket.receiveMsg(var msg: string);
var pmsg: string;
begin
//if (fprecv(numberSocket, @pmsg, 254, 0) = -1) and (socketError<>10054) and (socketError<>10057)
//then write('Error receive message: ', socketError, ' ', numberSocket);
msg:=pmsg;
end;

//send msg
function connectionSocket.sendMsg(msg: string): longint;
var pmsg: string;
i: longint;
begin
pmsg:=msg;
//fpconnect(numberSocket, @addrlist, length(msg)+4);
sendMsg:=fpsend(numberSocket, @pmsg, 254, 0);
//if (sendMsg=-1) and (socketError<>10057)
//then write('Error send message: ', socketError, ' ', numberSocket);
end;

//send msg
procedure connectionSocket.sendMsg(msg: string);
var pmsg: string;
i: longint;
begin
pmsg:=msg;
//fpconnect(numberSocket, @addrlist, length(msg)+4);
//if (fpsend(numberSocket, @pmsg, 254, 0) =-1) and (socketError<>10057)
//then write('Error send message: ', socketError, ' ', numberSocket);
end;

//close socket
procedure connectionSocket.SocketClose;
begin
CloseSocket(numberSocket);
end;

function GetClientIP(socketNum: connectionSocket): string;
begin
GetClientIp:=netaddrtostr(socketNum.addrlist.sin_addr);
end;

procedure connectionHelp;
begin
writeln('type connectionSocket = object');
writeln('public');
writeln('NameClient: string;');
writeln('numberSocket: LongWord;');
writeln('addrlist: sockaddr;');
writeln('socketLen: LongWord;');
writeln('procedure createSocket(sockIp: string; sockPort: LongWord);');
writeln('procedure createSocket(sockPort: LongWord);');
writeln('procedure acceptConnect(numsock: longint);');
writeln('function receiveMsg(var msg: string): int64;');
writeln('procedure receiveMsg(var msg: string);');
writeln('procedure sendMsg(msg: string);');
writeln('procedure socketClose;');
writeln('end;');
writeln;
writeln('function GetClientIP(socketNum: connectionSocket): string;');
writeln('procedure connectionHelp;');
end;
end.