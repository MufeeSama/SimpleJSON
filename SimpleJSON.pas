unit SimpleJSON;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections;

const
  JSON_DATE_FORMAT = 'yyyy-mm-dd"T"hh:nn:ss.zzz';

type
  TJsonValueType = (jvtNull, jvtString, jvtNumber, jvtBoolean, jvtObject, jvtArray);

  IJson = interface;
  IJsonArray = interface;

  IJsonArray = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function GetCount: Integer;
    function GetS(Index: Integer): string;
    function GetI(Index: Integer): Integer;
    function GetL(Index: Integer): Int64;
    function GetF(Index: Integer): Double;
    function GetB(Index: Integer): Boolean;
    function GetD(Index: Integer): TDateTime;
    function GetO(Index: Integer): IJson;
    function GetA(Index: Integer): IJsonArray;
    function IsNull(Index: Integer): Boolean;
    function GetValueType(Index: Integer): TJsonValueType;
    
    function Add(const Value: string): IJsonArray; overload;
    function Add(Value: Integer): IJsonArray; overload;
    function Add(Value: Int64): IJsonArray; overload;
    function Add(Value: Double): IJsonArray; overload;
    function Add(Value: Boolean): IJsonArray; overload;
    function Add(Value: TDateTime): IJsonArray; overload;
    function AddNull: IJsonArray;
    function AddObject: IJson;
    function AddArray: IJsonArray;
    procedure Delete(Index: Integer);
    procedure Clear;
    function Clone: IJsonArray;
    
    function ToJSON: string;
    function Format: string;
    
    property Count: Integer read GetCount;
    property S[Index: Integer]: string read GetS;
    property I[Index: Integer]: Integer read GetI;
    property L[Index: Integer]: Int64 read GetL;
    property F[Index: Integer]: Double read GetF;
    property B[Index: Integer]: Boolean read GetB;
    property D[Index: Integer]: TDateTime read GetD;
    property O[Index: Integer]: IJson read GetO;
    property A[Index: Integer]: IJsonArray read GetA;
  end;

  IJson = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
    function GetS(const Key: string): string;
    procedure SetS(const Key, Value: string);
    function GetI(const Key: string): Integer;
    procedure SetI(const Key: string; Value: Integer);
    function GetL(const Key: string): Int64;
    procedure SetL(const Key: string; Value: Int64);
    function GetF(const Key: string): Double;
    procedure SetF(const Key: string; Value: Double);
    function GetB(const Key: string): Boolean;
    procedure SetB(const Key: string; Value: Boolean);
    function GetD(const Key: string): TDateTime;
    procedure SetD(const Key: string; Value: TDateTime);
    function GetO(const Key: string): IJson;
    function GetA(const Key: string): IJsonArray;
    function GetPath(const Path: string): string;
    
    function IsNull(const Key: string): Boolean;
    procedure SetNull(const Key: string);
    function GetValueType(const Key: string): TJsonValueType;
    
    function TryGetS(const Key: string; out Value: string): Boolean;
    function TryGetI(const Key: string; out Value: Integer): Boolean;
    function TryGetL(const Key: string; out Value: Int64): Boolean;
    function TryGetF(const Key: string; out Value: Double): Boolean;
    function TryGetB(const Key: string; out Value: Boolean): Boolean;
    function TryGetD(const Key: string; out Value: TDateTime): Boolean;
    function TryGetO(const Key: string; out Value: IJson): Boolean;
    function TryGetA(const Key: string; out Value: IJsonArray): Boolean;
    
    function Contains(const Key: string): Boolean;
    procedure Remove(const Key: string);
    procedure Clear;
    function GetKeys: TArray<string>;
    function GetCount: Integer;
    
    function ToJSON: string;
    function Format: string;
    procedure SaveToFile(const FileName: string);
    function Clone: IJson;
    function Flatten: IJson; overload;
    function Flatten(const Prefix: string): IJson; overload;
    
    property S[const Key: string]: string read GetS write SetS;
    property I[const Key: string]: Integer read GetI write SetI;
    property L[const Key: string]: Int64 read GetL write SetL;
    property F[const Key: string]: Double read GetF write SetF;
    property B[const Key: string]: Boolean read GetB write SetB;
    property D[const Key: string]: TDateTime read GetD write SetD;
    property O[const Key: string]: IJson read GetO;
    property A[const Key: string]: IJsonArray read GetA;
    property Path[const Path: string]: string read GetPath;
    property Count: Integer read GetCount;
  end;

  TJsonArray = class;

  TJson = class(TInterfacedObject, IJson)
  private
    FObject: System.JSON.TJSONObject;
    FOwned: Boolean;
    function GetS(const Key: string): string;
    procedure SetS(const Key, Value: string);
    function GetI(const Key: string): Integer;
    procedure SetI(const Key: string; Value: Integer);
    function GetL(const Key: string): Int64;
    procedure SetL(const Key: string; Value: Int64);
    function GetF(const Key: string): Double;
    procedure SetF(const Key: string; Value: Double);
    function GetB(const Key: string): Boolean;
    procedure SetB(const Key: string; Value: Boolean);
    function GetD(const Key: string): TDateTime;
    procedure SetD(const Key: string; Value: TDateTime);
    function GetO(const Key: string): IJson;
    function GetA(const Key: string): IJsonArray;
    function GetPath(const Path: string): string;
  public
    constructor Create; overload;
    constructor Create(AObject: System.JSON.TJSONObject; AOwned: Boolean = True); overload;
    destructor Destroy; override;
    
    class function Parse(const JSONString: string): IJson; static;
    class function ParseFile(const FileName: string): IJson; static;
    class function LoadFromFile(const FileName: string): IJson; static;
    
    function IsNull(const Key: string): Boolean;
    procedure SetNull(const Key: string);
    function GetValueType(const Key: string): TJsonValueType;
    
    function TryGetS(const Key: string; out Value: string): Boolean;
    function TryGetI(const Key: string; out Value: Integer): Boolean;
    function TryGetL(const Key: string; out Value: Int64): Boolean;
    function TryGetF(const Key: string; out Value: Double): Boolean;
    function TryGetB(const Key: string; out Value: Boolean): Boolean;
    function TryGetD(const Key: string; out Value: TDateTime): Boolean;
    function TryGetO(const Key: string; out Value: IJson): Boolean;
    function TryGetA(const Key: string; out Value: IJsonArray): Boolean;
    
    function Contains(const Key: string): Boolean;
    procedure Remove(const Key: string);
    procedure Clear;
    function GetKeys: TArray<string>;
    function GetCount: Integer;
    
    function ToJSON: string;
    function Format: string;
    procedure SaveToFile(const FileName: string);
    function Clone: IJson;
    function Flatten: IJson; overload;
    function Flatten(const Prefix: string): IJson; overload;
    
    property S[const Key: string]: string read GetS write SetS;
    property I[const Key: string]: Integer read GetI write SetI;
    property L[const Key: string]: Int64 read GetL write SetL;
    property F[const Key: string]: Double read GetF write SetF;
    property B[const Key: string]: Boolean read GetB write SetB;
    property D[const Key: string]: TDateTime read GetD write SetD;
    property O[const Key: string]: IJson read GetO;
    property A[const Key: string]: IJsonArray read GetA;
    property Path[const Path: string]: string read GetPath;
    property Count: Integer read GetCount;
  end;

  TJsonArray = class(TInterfacedObject, IJsonArray)
  private
    FArray: System.JSON.TJSONArray;
    FOwned: Boolean;
    FJsonWrappers: TObjectList<TJson>;
    FArrayWrappers: TObjectList<TJsonArray>;
    function GetCount: Integer;
    function GetS(Index: Integer): string;
    function GetI(Index: Integer): Integer;
    function GetL(Index: Integer): Int64;
    function GetF(Index: Integer): Double;
    function GetB(Index: Integer): Boolean;
    function GetD(Index: Integer): TDateTime;
    function GetO(Index: Integer): IJson;
    function GetA(Index: Integer): IJsonArray;
  public
    constructor Create; overload;
    constructor Create(AArray: System.JSON.TJSONArray; AOwned: Boolean = True); overload;
    destructor Destroy; override;
    
    class function Parse(const JSONString: string): IJsonArray; static;
    
    function IsNull(Index: Integer): Boolean;
    function GetValueType(Index: Integer): TJsonValueType;
    
    function Add(const Value: string): IJsonArray; overload;
    function Add(Value: Integer): IJsonArray; overload;
    function Add(Value: Int64): IJsonArray; overload;
    function Add(Value: Double): IJsonArray; overload;
    function Add(Value: Boolean): IJsonArray; overload;
    function Add(Value: TDateTime): IJsonArray; overload;
    function AddNull: IJsonArray;
    function AddObject: IJson;
    function AddArray: IJsonArray;
    procedure Delete(Index: Integer);
    procedure Clear;
    function Clone: IJsonArray;
    
    function ToJSON: string;
    function Format: string;
    
    property Count: Integer read GetCount;
    property S[Index: Integer]: string read GetS;
    property I[Index: Integer]: Integer read GetI;
    property L[Index: Integer]: Int64 read GetL;
    property F[Index: Integer]: Double read GetF;
    property B[Index: Integer]: Boolean read GetB;
    property D[Index: Integer]: TDateTime read GetD;
    property O[Index: Integer]: IJson read GetO;
    property A[Index: Integer]: IJsonArray read GetA;
  end;

function TryParseJSONDateTime(const S: string; out Value: TDateTime): Boolean;

implementation

uses
  System.Character, System.DateUtils;

function TryParseJSONDateTime(const S: string; out Value: TDateTime): Boolean;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  DateStr, TimeStr: string;
  P, TempInt: Integer;
begin
  Result := False;
  Value := 0;
  if S = '' then
    Exit;
    
  DateStr := S;
  TimeStr := '';
  
  P := Pos('T', DateStr);
  if P > 0 then
  begin
    TimeStr := Copy(DateStr, P + 1, MaxInt);
    DateStr := Copy(DateStr, 1, P - 1);
  end;
  
  if (Length(DateStr) > 10) and CharInSet(DateStr[Length(DateStr) - 5], ['+', '-']) then
  begin
    DateStr := Copy(DateStr, 1, Length(DateStr) - 6);
    TimeStr := '';
  end;
  if (Length(TimeStr) > 1) and (TimeStr[Length(TimeStr)] = 'Z') then
    TimeStr := Copy(TimeStr, 1, Length(TimeStr) - 1);
    
  if Length(DateStr) >= 10 then
  begin
    if not TryStrToInt(Copy(DateStr, 1, 4), TempInt) then Exit;
    Year := TempInt;
    if not TryStrToInt(Copy(DateStr, 6, 2), TempInt) then Exit;
    Month := TempInt;
    if not TryStrToInt(Copy(DateStr, 9, 2), TempInt) then Exit;
    Day := TempInt;
    if (Year < 1) or (Year > 9999) then Exit;
    if (Month < 1) or (Month > 12) then Exit;
    if (Day < 1) or (Day > 31) then Exit;
  end
  else
    Exit;
    
  Hour := 0;
  Min := 0;
  Sec := 0;
  MSec := 0;
  
  if TimeStr <> '' then
  begin
    if Length(TimeStr) >= 2 then
    begin
      if TryStrToInt(Copy(TimeStr, 1, 2), TempInt) then Hour := TempInt;
    end;
    if Length(TimeStr) >= 5 then
    begin
      if TryStrToInt(Copy(TimeStr, 4, 2), TempInt) then Min := TempInt;
    end;
    if Length(TimeStr) >= 8 then
    begin
      if TryStrToInt(Copy(TimeStr, 7, 2), TempInt) then Sec := TempInt;
    end;
    if Length(TimeStr) >= 12 then
    begin
      if TryStrToInt(Copy(TimeStr, 10, 3), TempInt) then MSec := TempInt;
    end;
  end;
  
  try
    Value := EncodeDateTime(Year, Month, Day, Hour, Min, Sec, MSec);
    Result := True;
  except
    Result := False;
    Value := 0;
  end;
end;

{ TJson }

constructor TJson.Create;
begin
  inherited Create;
  FObject := System.JSON.TJSONObject.Create;
  FOwned := True;
end;

constructor TJson.Create(AObject: System.JSON.TJSONObject; AOwned: Boolean);
begin
  inherited Create;
  FObject := AObject;
  FOwned := AOwned;
end;

destructor TJson.Destroy;
begin
  if FOwned and Assigned(FObject) then
    FObject.Free;
  inherited;
end;

class function TJson.Parse(const JSONString: string): IJson;
var
  Value: System.JSON.TJSONValue;
begin
  Value := System.JSON.TJSONObject.ParseJSONValue(JSONString);
  if Value is System.JSON.TJSONObject then
    Result := TJson.Create(System.JSON.TJSONObject(Value), True)
  else
  begin
    Value.Free;
    Result := nil;
  end;
end;

class function TJson.ParseFile(const FileName: string): IJson;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromFile(FileName, TEncoding.UTF8);
    Result := Parse(List.Text);
  finally
    List.Free;
  end;
end;

class function TJson.LoadFromFile(const FileName: string): IJson;
begin
  Result := ParseFile(FileName);
end;

function TJson.GetS(const Key: string): string;
var
  Value: System.JSON.TJSONValue;
begin
  Result := '';
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
    Result := Value.Value;
end;

procedure TJson.SetS(const Key, Value: string);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, Value);
end;

function TJson.GetI(const Key: string): Integer;
var
  Value: System.JSON.TJSONValue;
begin
  Result := 0;
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
  begin
    if Value is System.JSON.TJSONNumber then
      Result := System.JSON.TJSONNumber(Value).AsInt
    else
      TryStrToInt(Value.Value, Result);
  end;
end;

procedure TJson.SetI(const Key: string; Value: Integer);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, Value);
end;

function TJson.GetL(const Key: string): Int64;
var
  Value: System.JSON.TJSONValue;
begin
  Result := 0;
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
  begin
    if Value is System.JSON.TJSONNumber then
      Result := System.JSON.TJSONNumber(Value).AsInt64
    else
      TryStrToInt64(Value.Value, Result);
  end;
end;

procedure TJson.SetL(const Key: string; Value: Int64);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, Value);
end;

function TJson.GetF(const Key: string): Double;
var
  Value: System.JSON.TJSONValue;
begin
  Result := 0.0;
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
  begin
    if Value is System.JSON.TJSONNumber then
      Result := System.JSON.TJSONNumber(Value).AsDouble
    else
      TryStrToFloat(Value.Value, Result);
  end;
end;

procedure TJson.SetF(const Key: string; Value: Double);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, Value);
end;

function TJson.GetB(const Key: string): Boolean;
var
  Value: System.JSON.TJSONValue;
begin
  Result := False;
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
  begin
    if Value is System.JSON.TJSONBool then
      Result := System.JSON.TJSONBool(Value).AsBoolean
    else
      Result := SameText(Value.Value, 'true');
  end;
end;

procedure TJson.SetB(const Key: string; Value: Boolean);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, Value);
end;

function TJson.GetD(const Key: string): TDateTime;
var
  Value: System.JSON.TJSONValue;
  StrValue: string;
begin
  Result := 0;
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
  begin
    StrValue := Value.Value;
    TryParseJSONDateTime(StrValue, Result);
  end;
end;

procedure TJson.SetD(const Key: string; Value: TDateTime);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, FormatDateTime(JSON_DATE_FORMAT, Value));
end;

function TJson.GetO(const Key: string): IJson;
var
  Value: System.JSON.TJSONValue;
  NewObj: System.JSON.TJSONObject;
begin
  Result := nil;
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  if FObject.TryGetValue(Key, Value) then
  begin
    if Value is System.JSON.TJSONObject then
      Result := TJson.Create(System.JSON.TJSONObject(Value), False);
  end
  else
  begin
    NewObj := System.JSON.TJSONObject.Create;
    FObject.AddPair(Key, NewObj);
    Result := TJson.Create(NewObj, False);
  end;
end;

function TJson.GetA(const Key: string): IJsonArray;
var
  Value: System.JSON.TJSONValue;
  NewArr: System.JSON.TJSONArray;
begin
  Result := nil;
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  if FObject.TryGetValue(Key, Value) then
  begin
    if Value is System.JSON.TJSONArray then
      Result := TJsonArray.Create(System.JSON.TJSONArray(Value), False);
  end
  else
  begin
    NewArr := System.JSON.TJSONArray.Create;
    FObject.AddPair(Key, NewArr);
    Result := TJsonArray.Create(NewArr, False);
  end;
end;

function TJson.GetPath(const Path: string): string;
var
  Parts: TArray<string>;
  CurrentValue: System.JSON.TJSONValue;
  CurrentObj: System.JSON.TJSONObject;
  CurrentArr: System.JSON.TJSONArray;
  i, Index: Integer;
  Key: string;
begin
  Result := '';
  if not Assigned(FObject) then
    Exit;
  Parts := Path.Split(['.', '[', ']'], TStringSplitOptions.ExcludeEmpty);
  CurrentValue := FObject;
  
  for i := 0 to Length(Parts) - 1 do
  begin
    Key := Parts[i];
    
    if CurrentValue is System.JSON.TJSONObject then
    begin
      CurrentObj := System.JSON.TJSONObject(CurrentValue);
      if not CurrentObj.TryGetValue(Key, CurrentValue) then
        Exit;
    end
    else if CurrentValue is System.JSON.TJSONArray then
    begin
      CurrentArr := System.JSON.TJSONArray(CurrentValue);
      if TryStrToInt(Key, Index) and (Index >= 0) and (Index < CurrentArr.Count) then
        CurrentValue := CurrentArr.Items[Index]
      else
        Exit;
    end
    else
      Exit;
  end;
  
  if Assigned(CurrentValue) then
    Result := CurrentValue.Value;
end;

function TJson.IsNull(const Key: string): Boolean;
var
  Value: System.JSON.TJSONValue;
begin
  Result := False;
  if Assigned(FObject) and FObject.TryGetValue(Key, Value) then
    Result := Value is System.JSON.TJSONNull;
end;

procedure TJson.SetNull(const Key: string);
var
  OldPair: System.JSON.TJSONPair;
begin
  if not Assigned(FObject) then
    FObject := System.JSON.TJSONObject.Create;
  OldPair := FObject.RemovePair(Key);
  OldPair.Free;
  FObject.AddPair(Key, System.JSON.TJSONNull.Create);
end;

function TJson.GetValueType(const Key: string): TJsonValueType;
var
  Value: System.JSON.TJSONValue;
begin
  Result := jvtNull;
  if not Assigned(FObject) or not FObject.TryGetValue(Key, Value) then
    Exit;
  if Value is System.JSON.TJSONNull then
    Result := jvtNull
  else if Value is System.JSON.TJSONString then
    Result := jvtString
  else if Value is System.JSON.TJSONNumber then
    Result := jvtNumber
  else if Value is System.JSON.TJSONBool then
    Result := jvtBoolean
  else if Value is System.JSON.TJSONObject then
    Result := jvtObject
  else if Value is System.JSON.TJSONArray then
    Result := jvtArray;
end;

function TJson.TryGetS(const Key: string; out Value: string): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := '';
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and not (JSONValue is System.JSON.TJSONNull) then
    Value := JSONValue.Value;
end;

function TJson.TryGetI(const Key: string; out Value: Integer): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := 0;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and not (JSONValue is System.JSON.TJSONNull) then
  begin
    if JSONValue is System.JSON.TJSONNumber then
      Value := System.JSON.TJSONNumber(JSONValue).AsInt
    else
      Result := TryStrToInt(JSONValue.Value, Value);
  end;
end;

function TJson.TryGetL(const Key: string; out Value: Int64): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := 0;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and not (JSONValue is System.JSON.TJSONNull) then
  begin
    if JSONValue is System.JSON.TJSONNumber then
      Value := System.JSON.TJSONNumber(JSONValue).AsInt64
    else
      Result := TryStrToInt64(JSONValue.Value, Value);
  end;
end;

function TJson.TryGetF(const Key: string; out Value: Double): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := 0.0;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and not (JSONValue is System.JSON.TJSONNull) then
  begin
    if JSONValue is System.JSON.TJSONNumber then
      Value := System.JSON.TJSONNumber(JSONValue).AsDouble
    else
      Result := TryStrToFloat(JSONValue.Value, Value);
  end;
end;

function TJson.TryGetB(const Key: string; out Value: Boolean): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := False;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and not (JSONValue is System.JSON.TJSONNull) then
  begin
    if JSONValue is System.JSON.TJSONBool then
      Value := System.JSON.TJSONBool(JSONValue).AsBoolean
    else
      Value := SameText(JSONValue.Value, 'true');
  end;
end;

function TJson.TryGetD(const Key: string; out Value: TDateTime): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
  StrValue: string;
begin
  Value := 0;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and not (JSONValue is System.JSON.TJSONNull) then
  begin
    StrValue := JSONValue.Value;
    Result := TryParseJSONDateTime(StrValue, Value);
  end;
end;

function TJson.TryGetO(const Key: string; out Value: IJson): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := nil;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and (JSONValue is System.JSON.TJSONObject) then
    Value := TJson.Create(System.JSON.TJSONObject(JSONValue), False)
  else
    Result := False;
end;

function TJson.TryGetA(const Key: string; out Value: IJsonArray): Boolean;
var
  JSONValue: System.JSON.TJSONValue;
begin
  Value := nil;
  Result := Assigned(FObject) and FObject.TryGetValue(Key, JSONValue);
  if Result and (JSONValue is System.JSON.TJSONArray) then
    Value := TJsonArray.Create(System.JSON.TJSONArray(JSONValue), False)
  else
    Result := False;
end;

function TJson.Contains(const Key: string): Boolean;
var
  Value: System.JSON.TJSONValue;
begin
  Result := Assigned(FObject) and FObject.TryGetValue(Key, Value);
end;

procedure TJson.Remove(const Key: string);
var
  OldPair: System.JSON.TJSONPair;
begin
  if Assigned(FObject) then
  begin
    OldPair := FObject.RemovePair(Key);
    OldPair.Free;
  end;
end;

procedure TJson.Clear;
begin
  if Assigned(FObject) then
    FreeAndNil(FObject);
  FObject := System.JSON.TJSONObject.Create;
end;

function TJson.GetKeys: TArray<string>;
var
  i: Integer;
begin
  SetLength(Result, 0);
  if not Assigned(FObject) then
    Exit;
  SetLength(Result, FObject.Count);
  for i := 0 to FObject.Count - 1 do
    Result[i] := FObject.Pairs[i].JsonString.Value;
end;

function TJson.GetCount: Integer;
begin
  if Assigned(FObject) then
    Result := FObject.Count
  else
    Result := 0;
end;

function TJson.ToJSON: string;
begin
  if Assigned(FObject) then
    Result := FObject.ToJSON
  else
    Result := '{}';
end;

function TJson.Format: string;
begin
  if Assigned(FObject) then
    Result := FObject.Format
  else
    Result := '{}';
end;

procedure TJson.SaveToFile(const FileName: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Text := Format;
    List.SaveToFile(FileName, TEncoding.UTF8);
  finally
    List.Free;
  end;
end;

function TJson.Clone: IJson;
begin
  if Assigned(FObject) then
    Result := TJson.Parse(FObject.ToJSON)
  else
    Result := TJson.Create;
end;

procedure DoFlattenArray(Arr: System.JSON.TJSONArray; const Prefix: string; Result: System.JSON.TJSONObject); forward;

procedure DoFlattenObject(Obj: System.JSON.TJSONObject; const Prefix: string; Result: System.JSON.TJSONObject);
var
  i: Integer;
  Key, NewKey: string;
  Value: System.JSON.TJSONValue;
begin
  if not Assigned(Obj) then
    Exit;
  for i := 0 to Obj.Count - 1 do
  begin
    Key := Obj.Pairs[i].JsonString.Value;
    if Prefix <> '' then
      NewKey := Prefix + '.' + Key
    else
      NewKey := Key;
    Value := Obj.Pairs[i].JsonValue;
    
    if Value is System.JSON.TJSONObject then
      DoFlattenObject(System.JSON.TJSONObject(Value), NewKey, Result)
    else if Value is System.JSON.TJSONArray then
      DoFlattenArray(System.JSON.TJSONArray(Value), NewKey, Result)
    else
      Result.AddPair(NewKey, Value.Clone as System.JSON.TJSONValue);
  end;
end;

procedure DoFlattenArray(Arr: System.JSON.TJSONArray; const Prefix: string; Result: System.JSON.TJSONObject);
var
  i: Integer;
  NewKey: string;
  Value: System.JSON.TJSONValue;
begin
  if not Assigned(Arr) then
    Exit;
  for i := 0 to Arr.Count - 1 do
  begin
    NewKey := Prefix + '.' + IntToStr(i);
    Value := Arr.Items[i];
    
    if Value is System.JSON.TJSONObject then
      DoFlattenObject(System.JSON.TJSONObject(Value), NewKey, Result)
    else if Value is System.JSON.TJSONArray then
      DoFlattenArray(System.JSON.TJSONArray(Value), NewKey, Result)
    else
      Result.AddPair(NewKey, Value.Clone as System.JSON.TJSONValue);
  end;
end;

function TJson.Flatten: IJson;
var
  ResultObj: System.JSON.TJSONObject;
begin
  ResultObj := System.JSON.TJSONObject.Create;
  try
    if Assigned(FObject) then
      DoFlattenObject(FObject, '', ResultObj);
    Result := TJson.Create(ResultObj, True);
  except
    ResultObj.Free;
    raise;
  end;
end;

function TJson.Flatten(const Prefix: string): IJson;
var
  ResultObj: System.JSON.TJSONObject;
begin
  ResultObj := System.JSON.TJSONObject.Create;
  try
    if Assigned(FObject) then
      DoFlattenObject(FObject, Prefix, ResultObj);
    Result := TJson.Create(ResultObj, True);
  except
    ResultObj.Free;
    raise;
  end;
end;

{ TJsonArray }

constructor TJsonArray.Create;
begin
  inherited Create;
  FArray := System.JSON.TJSONArray.Create;
  FOwned := True;
  FJsonWrappers := TObjectList<TJson>.Create(False);
  FArrayWrappers := TObjectList<TJsonArray>.Create(False);
end;

constructor TJsonArray.Create(AArray: System.JSON.TJSONArray; AOwned: Boolean);
begin
  inherited Create;
  FArray := AArray;
  FOwned := AOwned;
  FJsonWrappers := TObjectList<TJson>.Create(False);
  FArrayWrappers := TObjectList<TJsonArray>.Create(False);
end;

destructor TJsonArray.Destroy;
begin
  FJsonWrappers.Free;
  FArrayWrappers.Free;
  if FOwned and Assigned(FArray) then
    FArray.Free;
  inherited;
end;

class function TJsonArray.Parse(const JSONString: string): IJsonArray;
var
  Value: System.JSON.TJSONValue;
begin
  Value := System.JSON.TJSONObject.ParseJSONValue(JSONString);
  if Value is System.JSON.TJSONArray then
    Result := TJsonArray.Create(System.JSON.TJSONArray(Value), True)
  else
  begin
    Value.Free;
    Result := nil;
  end;
end;

function TJsonArray.GetCount: Integer;
begin
  if Assigned(FArray) then
    Result := FArray.Count
  else
    Result := 0;
end;

function TJsonArray.GetS(Index: Integer): string;
begin
  Result := '';
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
    Result := FArray.Items[Index].Value;
end;

function TJsonArray.GetI(Index: Integer): Integer;
var
  Value: System.JSON.TJSONValue;
begin
  Result := 0;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    if Value is System.JSON.TJSONNumber then
      Result := System.JSON.TJSONNumber(Value).AsInt;
  end;
end;

function TJsonArray.GetL(Index: Integer): Int64;
var
  Value: System.JSON.TJSONValue;
begin
  Result := 0;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    if Value is System.JSON.TJSONNumber then
      Result := System.JSON.TJSONNumber(Value).AsInt64;
  end;
end;

function TJsonArray.GetF(Index: Integer): Double;
var
  Value: System.JSON.TJSONValue;
begin
  Result := 0.0;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    if Value is System.JSON.TJSONNumber then
      Result := System.JSON.TJSONNumber(Value).AsDouble;
  end;
end;

function TJsonArray.GetB(Index: Integer): Boolean;
var
  Value: System.JSON.TJSONValue;
begin
  Result := False;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    if Value is System.JSON.TJSONBool then
      Result := System.JSON.TJSONBool(Value).AsBoolean;
  end;
end;

function TJsonArray.GetD(Index: Integer): TDateTime;
var
  Value: System.JSON.TJSONValue;
  StrValue: string;
begin
  Result := 0;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    StrValue := Value.Value;
    TryParseJSONDateTime(StrValue, Result);
  end;
end;

function TJsonArray.GetO(Index: Integer): IJson;
var
  Value: System.JSON.TJSONValue;
  Json: TJson;
begin
  Result := nil;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    if Value is System.JSON.TJSONObject then
    begin
      Json := TJson.Create(System.JSON.TJSONObject(Value), False);
      FJsonWrappers.Add(Json);
      Result := Json;
    end;
  end;
end;

function TJsonArray.GetA(Index: Integer): IJsonArray;
var
  Value: System.JSON.TJSONValue;
  Arr: TJsonArray;
begin
  Result := nil;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
  begin
    Value := FArray.Items[Index];
    if Value is System.JSON.TJSONArray then
    begin
      Arr := TJsonArray.Create(System.JSON.TJSONArray(Value), False);
      FArrayWrappers.Add(Arr);
      Result := Arr;
    end;
  end;
end;

function TJsonArray.IsNull(Index: Integer): Boolean;
begin
  Result := False;
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
    Result := FArray.Items[Index] is System.JSON.TJSONNull;
end;

function TJsonArray.GetValueType(Index: Integer): TJsonValueType;
var
  Value: System.JSON.TJSONValue;
begin
  Result := jvtNull;
  if not Assigned(FArray) or (Index < 0) or (Index >= FArray.Count) then
    Exit;
  Value := FArray.Items[Index];
  if Value is System.JSON.TJSONNull then
    Result := jvtNull
  else if Value is System.JSON.TJSONString then
    Result := jvtString
  else if Value is System.JSON.TJSONNumber then
    Result := jvtNumber
  else if Value is System.JSON.TJSONBool then
    Result := jvtBoolean
  else if Value is System.JSON.TJSONObject then
    Result := jvtObject
  else if Value is System.JSON.TJSONArray then
    Result := jvtArray;
end;

function TJsonArray.Add(const Value: string): IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.Add(Value);
  Result := Self;
end;

function TJsonArray.Add(Value: Integer): IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.Add(Value);
  Result := Self;
end;

function TJsonArray.Add(Value: Int64): IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.Add(Value);
  Result := Self;
end;

function TJsonArray.Add(Value: Double): IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.Add(Value);
  Result := Self;
end;

function TJsonArray.Add(Value: Boolean): IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.Add(Value);
  Result := Self;
end;

function TJsonArray.Add(Value: TDateTime): IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.Add(FormatDateTime(JSON_DATE_FORMAT, Value));
  Result := Self;
end;

function TJsonArray.AddNull: IJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  FArray.AddElement(System.JSON.TJSONNull.Create);
  Result := Self;
end;

function TJsonArray.AddObject: IJson;
var
  NewObj: System.JSON.TJSONObject;
  Json: TJson;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  NewObj := System.JSON.TJSONObject.Create;
  FArray.Add(NewObj);
  Json := TJson.Create(NewObj, False);
  FJsonWrappers.Add(Json);
  Result := Json;
end;

function TJsonArray.AddArray: IJsonArray;
var
  NewArr: System.JSON.TJSONArray;
  Arr: TJsonArray;
begin
  if not Assigned(FArray) then
    FArray := System.JSON.TJSONArray.Create;
  NewArr := System.JSON.TJSONArray.Create;
  FArray.Add(NewArr);
  Arr := TJsonArray.Create(NewArr, False);
  FArrayWrappers.Add(Arr);
  Result := Arr;
end;

procedure TJsonArray.Delete(Index: Integer);
begin
  if Assigned(FArray) and (Index >= 0) and (Index < FArray.Count) then
    FArray.Remove(Index);
end;

procedure TJsonArray.Clear;
begin
  if Assigned(FArray) then
    FreeAndNil(FArray);
  FArray := System.JSON.TJSONArray.Create;
  FJsonWrappers.Clear;
  FArrayWrappers.Clear;
end;

function TJsonArray.Clone: IJsonArray;
begin
  if Assigned(FArray) then
    Result := TJsonArray.Parse(FArray.ToJSON)
  else
    Result := TJsonArray.Create;
end;

function TJsonArray.ToJSON: string;
begin
  if Assigned(FArray) then
    Result := FArray.ToJSON
  else
    Result := '[]';
end;

function TJsonArray.Format: string;
begin
  if Assigned(FArray) then
    Result := FArray.Format
  else
    Result := '[]';
end;

end.
