unit uTools;

interface

uses
     System.JSON,
     System.SysUtils,
     System.Classes,
     System.IOUtils,
     NetEncoding,
     System.TimeSpan,
     System.StrUtils,
     DateUtils,
     IdHashMessageDigest,
     Soap.EncdDecd;

     function EncodeBase64(sTexto:String):String;
     function DecodeBase64(sTexto:String):string;
     function ClearDocument(sDocument:String):String;
     function IsCPFOrCNPJ(Document: string): Boolean;
     function IsValidCPF(CPF: string): Boolean;
     function IsValidCNPJ(CNPJ: string): Boolean;
     function CalculateMD5(const AText: string): string;
     function TextFromBase64(const Input: string): string;
     function NormalizePhoneNumber(const PhoneNumber: string): string;

implementation

function NormalizePhoneNumber(const PhoneNumber: string): string;
var
  Digits, DDI, DDD, NumberPart: string;
begin
  // Remove caracteres não numéricos
  Digits := StringReplace(PhoneNumber, '+', '', [rfReplaceAll]);
  Digits := StringReplace(Digits, ' ', '', [rfReplaceAll]);
  Digits := StringReplace(Digits, '-', '', [rfReplaceAll]);
  Digits := StringReplace(Digits, '(', '', [rfReplaceAll]);
  Digits := StringReplace(Digits, ')', '', [rfReplaceAll]);

  // Verifica se já possui DDI
  if Copy(Digits, 1, 2) = '55' then
  begin
    DDI := '55';
    Delete(Digits, 1, 2);
  end
  else
    DDI := '55'; // Adiciona DDI caso não tenha

  // Captura o DDD
  if Length(Digits) >= 10 then
  begin
    DDD := Copy(Digits, 1, 2);
    NumberPart := Copy(Digits, 3, Length(Digits) - 2);

    // Ajusta o dígito 9 conforme o DDD
    if StrToIntDef(DDD, 0) < 30 then
    begin
      // Adiciona o 9 se não tiver
      if (Length(NumberPart) = 8) then
        NumberPart := '9' + NumberPart;
    end
    else
    begin
      // Remove o 9 se estiver presente
      if (Length(NumberPart) = 9) and (NumberPart[1] = '9') then
        Delete(NumberPart, 1, 1);
    end;

    // Retorna o número formatado
    Result := DDI + DDD + NumberPart;
  end
  else
    Result := ''; // Retorna string vazia se o número for inválido
end;

function TextFromBase64(const Input: string): string;
var
  InputStream: TStringStream;
  OutputStream: TBytesStream;
  OutputBytes: TBytes;
begin
  // Cria um stream de string para a entrada Base64
  InputStream := TStringStream.Create(Input, TEncoding.ASCII);
  try
    // Cria um stream de bytes para a saída
    OutputStream := TBytesStream.Create;
    try
      // Decodifica a entrada Base64 e escreve no stream de saída
      DecodeStream(InputStream, OutputStream);

      // Obtém os bytes resultantes da decodificação
      OutputBytes := OutputStream.Bytes;

      // Converte os bytes de volta para uma string usando UTF-8
      Result := TEncoding.UTF8.GetString(OutputBytes, 0, OutputStream.Size);
    finally
      OutputStream.Free;
    end;
  finally
    InputStream.Free;
  end;
end;

function CalculateMD5(const AText: string): string;
var
  MD5Calculator: TIdHashMessageDigest5;
begin
  MD5Calculator := TIdHashMessageDigest5.Create;
  try
    Result := MD5Calculator.HashStringAsHex(AText);
  finally
    MD5Calculator.Free;
  end;
end;

function ClearDocument(sDocument:String):String;
begin
  sDocument := StringReplace(sDocument, '.', '', [rfReplaceAll]);
  sDocument := StringReplace(sDocument, '-', '', [rfReplaceAll]);
  sDocument := StringReplace(sDocument, '/', '', [rfReplaceAll]);
  Result := sDocument;
end;

function DecodeBase64(sTexto:String):string;
var
  bytes   : TBytes;
begin
  bytes    := TNetEncoding.Base64.DecodeStringToBytes(sTexto);
  Result   := TEncoding.UTF8.GetString(bytes);
end;

function EncodeBase64(sTexto:String):String;
var
  Base64  : TBase64Encoding;
begin
  Base64 := Nil;
  try
    Base64   := TBase64Encoding.Create(10,'');
    Result   := Base64.Encode(sTexto);
  finally
    Base64.Free;
  end;
end;

function IsCPFOrCNPJ(Document: string): Boolean;
begin
  Document := StringReplace(Document, '.', '', [rfReplaceAll]);
  Document := StringReplace(Document, '-', '', [rfReplaceAll]);
  Document := StringReplace(Document, '/', '', [rfReplaceAll]);

  if Length(Document) = 11 then
  begin
    Result := IsValidCPF(Document);
  end
  else if Length(Document) = 14 then
  begin
    Result := IsValidCNPJ(Document);
  end
  else
    Result := False;
end;

function IsValidCPF(CPF: string): Boolean;
var
  Digito1, Digito2: Integer;
  Soma, i, Resto: Integer;
begin
  Result := False;

  // Verifica se tem 11 dígitos e se não são todos iguais
  if (Length(CPF) <> 11) or (CPF = StringOfChar(CPF[1], 11)) then
    Exit;

  try
    // Cálculo do primeiro dígito verificador
    Soma := 0;
    for i := 1 to 9 do
      Soma := Soma + StrToInt(CPF[i]) * (11 - i);

    Resto := Soma mod 11;
    if Resto < 2 then
      Digito1 := 0
    else
      Digito1 := 11 - Resto;

    // Cálculo do segundo dígito verificador
    Soma := 0;
    for i := 1 to 10 do
      Soma := Soma + StrToInt(CPF[i]) * (12 - i);

    Resto := Soma mod 11;
    if Resto < 2 then
      Digito2 := 0
    else
      Digito2 := 11 - Resto;

    // Verifica se os dígitos calculados são iguais aos dígitos informados
    Result := (Digito1 = StrToInt(CPF[10])) and (Digito2 = StrToInt(CPF[11]));
  except
    Result := False;
  end;
end;

function IsValidCNPJ(CNPJ: string): Boolean;
var
  i, Soma, Resto, Digito1, Digito2: Integer;
  Peso1: array[1..12] of Integer;
  Peso2: array[1..13] of Integer;
begin
  Result := False;

  // Inicializa os arrays de peso
  Peso1[1] := 5; Peso1[2] := 4; Peso1[3] := 3; Peso1[4] := 2;
  Peso1[5] := 9; Peso1[6] := 8; Peso1[7] := 7; Peso1[8] := 6;
  Peso1[9] := 5; Peso1[10] := 4; Peso1[11] := 3; Peso1[12] := 2;

  Peso2[1] := 6; Peso2[2] := 5; Peso2[3] := 4; Peso2[4] := 3;
  Peso2[5] := 2; Peso2[6] := 9; Peso2[7] := 8; Peso2[8] := 7;
  Peso2[9] := 6; Peso2[10] := 5; Peso2[11] := 4; Peso2[12] := 3;
  Peso2[13] := 2;

  // Verifica se tem 14 dígitos e se não são todos iguais
  if (Length(CNPJ) <> 14) or (CNPJ = StringOfChar(CNPJ[1], 14)) then
    Exit;

  try
    // Cálculo do primeiro dígito verificador
    Soma := 0;
    for i := 1 to 12 do
      Soma := Soma + StrToInt(CNPJ[i]) * Peso1[i];

    Resto := Soma mod 11;
    if Resto < 2 then
      Digito1 := 0
    else
      Digito1 := 11 - Resto;

    // Cálculo do segundo dígito verificador
    Soma := 0;
    for i := 1 to 13 do
      Soma := Soma + StrToInt(CNPJ[i]) * Peso2[i];

    Resto := Soma mod 11;
    if Resto < 2 then
      Digito2 := 0
    else
      Digito2 := 11 - Resto;

    // Verifica se os dígitos calculados são iguais aos dígitos informados
    Result := (Digito1 = StrToInt(CNPJ[13])) and (Digito2 = StrToInt(CNPJ[14]));
  except
    Result := False;
  end;
end;



end.
