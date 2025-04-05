unit JsonUtil;

interface

uses
  Data.DB, System.JSON, System.SysUtils,System.Generics.Collections;

function ParseArray(Body: string): TJsonArray;
function ParseObject(Body: string): TJsonObject;
function IndexByKey(JSONArray:TJSONArray;PrimaryKeyName,PrimaryKeyValue:String;out Match:Boolean):Integer; {Essa função retorna o indice do array que contenha a chave primaria condizente}
function CreateJsonObj(pairName: string; value: string): TJSONObject; overload;
function CreateJsonObj(pairName: string; value: integer): TJSONObject; overload;
function CreateJsonObj(pairName: string; value: double): TJSONObject; overload;
function CreateJsonObjPairs(pairs: array of TJSONPair): TJSONObject;


implementation

function CreateJsonObjPairs(pairs: array of TJSONPair): TJSONObject;
var
  pair: TJSONPair;
begin
  Result := TJSONObject.Create;
  for pair in pairs do
    Result.AddPair(pair);
end;

function ParseArray(body: string): TJsonArray;
begin
  Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(body), 0) as TJsonArray;
end;

function IndexByKey(JSONArray:TJSONArray;PrimaryKeyName,PrimaryKeyValue:String;out Match:Boolean):Integer;
var
  x : Integer;
begin
  Result := 0;
  Match  := False;
  for x := 0 to JSONArray.Count -1 do
  begin
    if JSONArray.Items[x].GetValue<String>(PrimaryKeyName) = PrimaryKeyValue then
    begin
      Match  := True;
      Result := x;
      Break;
    end
    else
    begin
      Continue;
    end;
  end;
end;

function CreateJsonObj(pairName: string; value: string): TJSONObject;
begin
    Result := TJSONObject.Create(TJSONPair.Create(pairName, value));
end;

function CreateJsonObj(pairName: string; value: integer): TJSONObject;
begin
    Result := TJSONObject.Create(TJSONPair.Create(pairName, TJSONNumber.Create(value)));
end;

function CreateJsonObj(pairName: string; value: double): TJSONObject;
begin
    Result := TJSONObject.Create(TJSONPair.Create(pairName, TJSONNumber.Create(value)));
end;

function ParseObject(Body: string): TJsonObject;
begin
    Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Body), 0) as TJsonObject;
end;

end.
