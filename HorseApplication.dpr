program HorseApplication;

{$APPTYPE CONSOLE}
{$R *.res}
uses
  System.SysUtils,
  Windows,
  Connection.Controller in 'Controller\Connection.Controller.pas',
  ServerRouts.Controller in 'Controller\ServerRouts.Controller.pas',
  ServerCore in 'Resources\ServerCore.pas',
  JsonUtil in 'Units\JsonUtil.pas',
  uTools in 'Units\uTools.pas',
  uServerConfig in 'uServerConfig.pas',
  ServerAuth.Controller in 'Controller\ServerAuth.Controller.pas',
  Auth.Controller in 'Controller\Auth.Controller.pas',
  Generic.DAO in 'DAO\Generic.DAO.pas';

end.
