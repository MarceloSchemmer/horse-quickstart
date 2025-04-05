unit ServerCore;

interface

uses Horse,
     Horse.OctetStream,
     Horse.Jhonson,
     Horse.Compression,
     Horse.CORS,
     System.SysUtils,
     ServerRouts.Controller,
     FireDAC.Stan.Intf,
     FireDAC.Stan.Option,
     FireDAC.Stan.Error,
     FireDAC.UI.Intf,
     FireDAC.Phys.Intf,
     FireDAC.Stan.Def,
     FireDAC.Stan.Pool,
     FireDAC.Stan.Async,
     FireDAC.Phys,
     FireDAC.ConsoleUI.Wait,
     FireDAC.Comp.Client,
     FireDAC.Phys.FBDef,
     FireDAC.Phys.IBBase,
     FireDAC.Phys.FB,
     FireDAC.DApt,
     Data.DB,
     System.JSON,
     DataSet.Serialize,
     uServerConfig,
     FireDAC.Phys.MySQL;
type
  EExceptParam = Class(Exception);

const
  {$IFDEF DEBUG}
  SECRET                         : String   = 'AQUI_VAI_TOKEN_SEU_SECRET_JWT';   {Chave Secreta para geração de JWT}
  End_Point_Root                 : String   = 'URL_ESPELHO_DO_ROOT_DO_SEU_SITE'; {Url espelho do endereço root do site (exemplo : http://localhost:9000)}
  {$ELSE}
  {$ENDIF}

var
  FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink; {Auxiliar para conexão MySQL}

implementation

uses Connection.Controller;

initialization
  {$IFDEF  MSWINDOWS}
  THorse.MaxConnections       := 1000;
  {$ENDIF}
  THorse.Use(OctetStream);
  THorse.Use(Compression());
  THorse.Use(Jhonson());
  THorse.Use(CORS);
  TDataSetSerializeConfig.GetInstance.Export.FormatDate := 'DD/MM/YYYY';
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition:= TCaseNameDefinition.cndNone;
  ServerRouts.Controller.RegisterAllRoutes; {Registrando todas as rotas do servidor}
  uServerConfig.SetConfig;
finalization
  THorse.StopListen;

  if Assigned(FDPhysMySQLDriverLink) then
     FDPhysMySQLDriverLink.Free;
end.
