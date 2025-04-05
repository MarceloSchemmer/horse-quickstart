unit Connection.Controller;

interface

uses
    Data.DB,
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option,
    FireDAC.Stan.Error,
    FireDAC.Stan.Def,
    FireDAC.Stan.Pool,
    FireDAC.Stan.Async,
    FireDAC.Phys.FBDef,
    FireDAC.Phys.Intf,
    FireDAC.Phys,
    FireDAC.Phys.FB,
    FireDAC.Phys.IBBase,
    FireDAC.FMXUI.Wait,
    FireDAC.Comp.Client,
    FireDAC.DApt,
    System.SysUtils,
    System.IOUtils,
    System.StrUtils,
    System.Classes,
    Windows;
type
  TConnection = class
  private
  public
    class function  TestConnection:Boolean;
    class function  CreateConnection: TFDConnection;
    class procedure LoadConfig(Connection: TFDConnection);
  end;

implementation

{ TConnection }

class function TConnection.CreateConnection: TFDConnection;
  var
    Conn: TFDConnection;
  begin
    Conn := TFDConnection.Create(nil);
    LoadConfig(Conn);
    Result := Conn;
  end;

class procedure TConnection.LoadConfig(Connection: TFDConnection);
begin
 {MySQL}
 {$IFDEF DEBUG}
  {***** Informar conexão mysql igual o exemplo a baixo *****}
  {Ambiente de testes}
  Connection.Params.Add('DriverID=MySQL');
  Connection.Params.Add('Server=localhost');
  Connection.Params.Add('Database=meu_banco_de_dados_mysql');
  Connection.Params.Add('User_Name=root');
  Connection.Params.Add('Password=root');
 {$ELSE}
  {Ambiente de produção}
  Connection.Params.Add('DriverID=');
  Connection.Params.Add('Server=');
  Connection.Params.Add('Database=');
  Connection.Params.Add('User_Name=');
  Connection.Params.Add('Password=');
 {$ENDIF}
end;

class function TConnection.TestConnection: Boolean;
var
  Conn: TFDConnection;
begin
  Result := False;
  Conn    := nil;
  try
    Conn := CreateConnection;
    try
      Conn.Connected := True;
      if Conn.Connected then
         Result := True;
    except on E: Exception do
      begin
        SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED);
        Writeln('!!! Erro ao conectar no banco de dados !!!'+E.Message);
        SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),7);
      end;
    end;
  finally
    if Assigned(Conn) then
       Conn.Free;
  end;
end;


end.
