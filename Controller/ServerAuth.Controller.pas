unit ServerAuth.Controller;

interface

uses Horse,
     Horse.JWT,
     JOSE.Core.JWT,
     JOSE.Types.JSON,
     JOSE.Core.Builder,
     System.JSON,
     System.SysUtils,
     Dataset.Serialize,
     FireDAC.Comp.Client,
     FireDAC.Stan.Param;

type
  TMyClaims = class(TJWTClaims)
  strict private
    function  GetToken: String;
    procedure SetToken(const Value: String);
  public
    property TOKEN: String read GetToken write SetToken;
  end;

function CreateToken(token: String): string;
function GetTokenRequest(Req: THorseRequest): String;

implementation

uses
  ServerCore;

function CreateToken(token: String): string;
var
  jwt: TJWT;
  claims: TMyClaims;
begin
  try
    jwt    := TJWT.Create();
    claims := TMyClaims(jwt.Claims);

    try
      claims.TOKEN := token;
      Result := TJOSE.SHA256CompactToken(SECRET, jwt);
    except
      Result := '';
    end;

  finally
    FreeAndNil(jwt);
  end;
end;

function GetTokenRequest(Req: THorseRequest): String;
var
  claims: TMyClaims;
begin
  claims := Req.Session<TMyClaims>;
  Result := claims.TOKEN;
end;

function TMyClaims.GetToken: String;
begin
  Result := FJSON.getValue<String>('token','');
end;

procedure TMyClaims.SetToken(const Value: string);
begin
  TJSONUtils.SetJSONValueFrom<String>('token', Value, FJSON);
end;

end.
