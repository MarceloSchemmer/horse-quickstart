unit Auth.Controller;

interface

uses Horse,
     Horse.JWT,
     System.JSON,
     System.SysUtils,
     ServerAuth.Controller,
     JsonUtil,
     Connection.Controller;

procedure RegisterRoutes;
procedure GenerateToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Confirm(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  ServerCore;

procedure RegisterRoutes;
begin
  {$IFDEF DEBUG}
  THorse.Post('v1/auth/generatetoken',GenerateToken);
  THorse.AddCallback(HorseJWT(SECRET,THorseJWTConfig.New.SessionClass(TMyClaims))).Post('v1/auth/confirm',Confirm);
  {$ENDIF}
end;

procedure GenerateToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  {$IFDEF DEBUG}
  try
    Res.Send(ServerAuth.Controller.CreateToken(Req.Query['token'])).Status(THTTPStatus.OK);
  except
    on E: Exception do
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', e.Message)).Status(THTTPStatus.InternalServerError);
    end;
  end;
  {$ENDIF}
end;

procedure Confirm(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  {$IFDEF DEBUG}
  try
     Res.Send('Access granted for the token : '+GetTokenRequest(Req)).Status(THTTPStatus.OK);
  except on E: Exception do
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', e.Message)).Status(THTTPStatus.InternalServerError);
    end;
  end;
  {$ENDIF}
end;
end.

