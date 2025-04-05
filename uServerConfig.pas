unit uServerConfig;

interface

uses
  Connection.Controller, System.SysUtils,Windows;

procedure SetConfig;

implementation

uses
  ServerCore,Horse;

procedure SetConfig;
begin
  IsConsole                   := False;
  ReportMemoryLeaksOnShutdown := True;
  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_GREEN);
  Writeln('''
           _____ ______ _______      _______ _____   ____  _____              ____  _   _ _      _____ _   _ ______
          / ____|  ____|  __ \ \    / /_   _|  __ \ / __ \|  __ \            / __ \| \ | | |    |_   _| \ | |  ____|
         | (___ | |__  | |__) \ \  / /  | | | |  | | |  | | |__) |  ______  | |  | |  \| | |      | | |  \| | |__
          \___ \|  __| |  _  / \ \/ /   | | | |  | | |  | |  _  /  |______| | |  | | . ` | |      | | | . ` |  __|
          ____) | |____| | \ \  \  /   _| |_| |__| | |__| | | \ \           | |__| | |\  | |____ _| |_| |\  | |____
         |_____/|______|_|  \_\  \/   |_____|_____/ \____/|_|  \_\           \____/|_| \_|______|_____|_| \_|______|
        ''');
  {$IFDEF DEBUG}
    THorse.Listen(9000,
    procedure
    begin
      SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_BLUE);
      Writeln('Servidor rodando na porta '+THorse.Port.ToString);
      SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED);
      Writeln('Ambiente de Desenvolvimento');
      SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),7);
      TConnection.TestConnection;
      WriteLN(#13#10);
      Readln;
    end);
  {$ELSE}
    THorse.Listen(9000,
    procedure
    begin
      SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_BLUE);
      Writeln('Servidor rodando na porta '+THorse.Port.ToString);
      SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),7);
      TConnection.TestConnection;
      WriteLN(#13#10);
      Readln;
    end);
  {$ENDIF}
end;

end.
