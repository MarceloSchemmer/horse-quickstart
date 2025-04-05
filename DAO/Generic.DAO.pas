unit Generic.DAO;

interface

uses
  Connection.Controller,
  System.Classes,
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param;

type
  TGenericDAO = Class
    FDConnection     : TFDConnection;
    sTokenConnection : String;
    iCompanyID       : Integer;

    constructor Create(); reintroduce;
    destructor  Destroy; override;

    procedure SetToken(TokenConnection: string);
  End;

implementation

uses
  ServerCore;

{ TGenericDAO }

constructor TGenericDAO.Create;
begin

end;

destructor TGenericDAO.Destroy;
begin
  if Assigned(FDConnection) then
     FDConnection.Free;
  inherited;
end;

procedure TGenericDAO.SetToken(TokenConnection: string);
begin
   try
      if Assigned(FDConnection) then
         FDConnection.Free;

      FDConnection     := TConnection.CreateConnection;
      sTokenConnection := TokenConnection;
   finally
   end;
end;

end.
