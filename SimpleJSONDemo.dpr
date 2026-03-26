program SimpleJSONDemo;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  SimpleJSON;

procedure DemoBasicUsage;
var
  Json: IJson;
begin
  Writeln('=== 1. 基本用法 - 创建和读写 ===');
  
  Json := TJson.Create;
  
  Json.S['name'] := '张三';
  Json.I['age'] := 25;
  Json.B['active'] := True;
  Json.F['salary'] := 8500.50;
  Json.L['id'] := 9876543210;
  
  Writeln('JSON: ' + Json.Format);
  Writeln('姓名: ' + Json.S['name']);
  Writeln('年龄: ' + IntToStr(Json.I['age']));
  Writeln('状态: ' + BoolToStr(Json.B['active'], True));
  Writeln('薪资: ' + FloatToStr(Json.F['salary']));
  Writeln('ID: ' + IntToStr(Json.L['id']));
  Writeln;
end;

procedure DemoDateTime;
var
  Json: IJson;
  Now: TDateTime;
begin
  Writeln('=== 2. 日期时间类型 ===');
  
  Json := TJson.Create;
  Now := System.SysUtils.Now;
  
  Json.D['created_at'] := Now;
  Json.D['birthday'] := EncodeDate(1990, 5, 15);
  
  Writeln('JSON: ' + Json.Format);
  Writeln;
  Writeln('读取日期:');
  Writeln('  created_at: ' + DateTimeToStr(Json.D['created_at']));
  Writeln('  birthday: ' + DateToStr(Json.D['birthday']));
  Writeln;
  
  Writeln('解析包含日期的 JSON:');
  Json := TJson.Parse('{"event":"会议","start_time":"2024-01-15T09:30:00.000","end_date":"2024-12-31"}');
  if Assigned(Json) then
  begin
    Writeln('  event: ' + Json.S['event']);
    Writeln('  start_time: ' + DateTimeToStr(Json.D['start_time']));
    Writeln('  end_date: ' + DateToStr(Json.D['end_date']));
  end;
  Writeln;
end;

procedure DemoParseJSON;
var
  Json: IJson;
begin
  Writeln('=== 3. 解析 JSON 字符串 ===');
  
  Json := TJson.Parse('{"id":1001,"product":"Delphi","price":199.99,"inStock":true}');
  if Assigned(Json) then
  begin
    Writeln('解析成功!');
    Writeln('格式化: ' + Json.Format);
    Writeln('产品: ' + Json.S['product']);
    Writeln('价格: ' + FloatToStr(Json.F['price']));
  end;
  Writeln;
end;

procedure DemoNestedObjects;
var
  Json: IJson;
begin
  Writeln('=== 4. 嵌套对象 ===');
  
  Json := TJson.Create;
  Json.S['name'] := '王五';
  
  Json.O['address'].S['city'] := '北京';
  Json.O['address'].S['zip'] := '100001';
  
  Json.O['contact'].S['email'] := 'wangwu@example.com';
  Json.O['contact'].S['phone'] := '13800138000';
  
  Writeln('嵌套 JSON: ' + Json.Format);
  Writeln;
  Writeln('读取嵌套值:');
  Writeln('  城市: ' + Json.O['address'].S['city']);
  Writeln('  邮箱: ' + Json.O['contact'].S['email']);
  Writeln;
end;

procedure DemoArrays;
var
  Json: IJson;
  i: Integer;
begin
  Writeln('=== 5. 数组操作 ===');
  
  Json := TJson.Create;
  
  Json.A['fruits']
    .Add('苹果')
    .Add('香蕉')
    .Add('橙子');
  
  Json.A['numbers']
    .Add(10)
    .Add(20)
    .Add(30);
  
  Json.A['big_numbers']
    .Add(Int64(12345678901234));
  
  Writeln('JSON: ' + Json.Format);
  Writeln;
  Writeln('遍历数组:');
  for i := 0 to Json.A['fruits'].Count - 1 do
    Writeln('  fruits[' + IntToStr(i) + '] = ' + Json.A['fruits'].S[i]);
  Writeln;
end;

procedure DemoArrayObjects;
var
  Json: IJson;
  i: Integer;
begin
  Writeln('=== 6. 对象数组 ===');
  
  Json := TJson.Create;
  
  Json.A['users'].AddObject
    .S['name'] := '用户1';
  Json.A['users'].O[0].I['age'] := 20;
  
  Json.A['users'].AddObject
    .S['name'] := '用户2';
  Json.A['users'].O[1].I['age'] := 25;
  
  Writeln('JSON: ' + Json.Format);
  Writeln;
  Writeln('遍历用户:');
  for i := 0 to Json.A['users'].Count - 1 do
    Writeln('  ' + Json.A['users'].O[i].S['name'] + ' - ' + 
            IntToStr(Json.A['users'].O[i].I['age']) + '岁');
  Writeln;
end;

procedure DemoPathAccess;
var
  Json: IJson;
begin
  Writeln('=== 7. 路径访问 ===');
  
  Json := TJson.Create;
  Json.S['name'] := '测试';
  Json.O['info'].S['city'] := '上海';
  Json.O['info'].I['count'] := 100;
  Json.A['tags'].Add('tag1').Add('tag2');
  
  Writeln('JSON: ' + Json.Format);
  Writeln;
  Writeln('路径访问:');
  Writeln('  name = ' + Json.Path['name']);
  Writeln('  info.city = ' + Json.Path['info.city']);
  Writeln('  info.count = ' + Json.Path['info.count']);
  Writeln('  tags.0 = ' + Json.Path['tags.0']);
  Writeln('  tags.1 = ' + Json.Path['tags.1']);
  Writeln;
end;

procedure DemoModifyAndRemove;
var
  Json: IJson;
begin
  Writeln('=== 8. 修改和删除 ===');
  
  Json := TJson.Create;
  Json.S['name'] := '原始名称';
  Json.I['value'] := 100;
  
  Writeln('原始: ' + Json.Format);

  Json.S['name'] := '修改后的名称';
  Json.I['value'] := 200;
  Json.S['newField'] := '新增字段';
  
  Writeln('修改后: ' + Json.Format);
  
  Json.Remove('value');
  Writeln('删除 value 后: ' + Json.Format);
  
  Writeln('是否存在 name: ' + BoolToStr(Json.Contains('name'), True));
  Writeln('是否存在 value: ' + BoolToStr(Json.Contains('value'), True));
  Writeln;
end;

procedure DemoIterateKeys;
var
  Json: IJson;
  Keys: TArray<string>;
  Key: string;
begin
  Writeln('=== 9. 遍历键 ===');
  
  Json := TJson.Create;
  Json.S['key1'] := 'value1';
  Json.S['key2'] := 'value2';
  Json.S['key3'] := 'value3';
  
  Writeln('键数量: ' + IntToStr(Json.Count));
  Writeln('所有键:');
  
  Keys := Json.GetKeys;
  for Key in Keys do
    Writeln('  ' + Key + ' = ' + Json.S[Key]);
  Writeln;
end;

procedure DemoNullAndTryGet;
var
  Json: IJson;
  Value: string;
  IntValue: Integer;
begin
  Writeln('=== 10. Null 值和 TryGet 安全获取 ===');
  
  Json := TJson.Create;
  Json.S['name'] := '测试';
  Json.SetNull('deleted_at');
  
  Writeln('JSON: ' + Json.Format);
  Writeln;
  Writeln('检查 Null:');
  Writeln('  name 是 null: ' + BoolToStr(Json.IsNull('name'), True));
  Writeln('  deleted_at 是 null: ' + BoolToStr(Json.IsNull('deleted_at'), True));
  Writeln;
  Writeln('TryGet 安全获取:');
  if Json.TryGetS('name', Value) then
    Writeln('  name = ' + Value)
  else
    Writeln('  name 不存在或为 null');
  
  if Json.TryGetS('not_exists', Value) then
    Writeln('  not_exists = ' + Value)
  else
    Writeln('  not_exists 不存在');
    
  if Json.TryGetI('age', IntValue) then
    Writeln('  age = ' + IntToStr(IntValue))
  else
    Writeln('  age 不存在');
  Writeln;
end;

procedure DemoFileOperations;
var
  Json: IJson;
  FileName: string;
begin
  Writeln('=== 11. 文件读写 ===');
  
  FileName := 'test.json';
  
  Json := TJson.Create;
  Json.S['name'] := '文件测试';
  Json.I['version'] := 1;
  Json.D['created'] := Now;
  
  Writeln('保存到文件: ' + FileName);
  Json.SaveToFile(FileName);
  
  Writeln('从文件加载:');
  Json := TJson.LoadFromFile(FileName);
  if Assigned(Json) then
  begin
    Writeln('  name: ' + Json.S['name']);
    Writeln('  version: ' + IntToStr(Json.I['version']));
    Writeln('  created: ' + DateTimeToStr(Json.D['created']));
  end;
  Writeln;
end;

procedure DemoComplexStructure;
var
  Json: IJson;
  i: Integer;
begin
  Writeln('=== 12. 复杂结构示例 ===');
  
  Json := TJson.Create;
  Json.S['company'] := 'ABC科技';
  Json.S['version'] := '1.0.0';
  Json.L['total_records'] := 9876543210;
  
  Json.O['config'].S['env'] := 'production';
  Json.O['config'].B['debug'] := False;
  
  Json.A['servers']
    .AddObject.S['host'] := '192.168.1.1';
  Json.A['servers'].O[0].I['port'] := 8080;
  
  Json.A['servers'].AddObject.S['host'] := '192.168.1.2';
  Json.A['servers'].O[1].I['port'] := 8081;
  
  for i := 0 to 2 do
    Json.A['features'].Add('feature' + IntToStr(i + 1));
  
  Json.SetNull('deleted_at');
  
  Writeln('完整 JSON:');
  Writeln(Json.Format);
  Writeln;
end;

procedure DemoFlatten;
var
  Json, Flat, User, Order, Merged: IJson;
  UserFlat, OrderFlat: IJson;
  Key: string;
begin
  Writeln('=== 13. 扁平化处理 ===');
  
  Json := TJson.Create;
  Json.S['name'] := '张三';
  Json.O['address'].S['city'] := '北京';
  Json.O['address'].S['zip'] := '100001';
  Json.A['tags'].Add('tag1').Add('tag2');
  Json.B['active'] := True;
  
  Writeln('原始嵌套 JSON:');
  Writeln(Json.Format);
  Writeln;
  
  Flat := Json.Flatten;
  Writeln('扁平化后:');
  Writeln(Flat.Format);
  Writeln;
  
  Writeln('=== 14. 带前缀扁平化 (合并多个对象) ===');
  
  User := TJson.Create;
  User.S['name'] := '张三';
  User.I['age'] := 25;
  
  Order := TJson.Create;
  Order.S['id'] := 'ORD-001';
  Order.F['amount'] := 199.99;
  
  UserFlat := User.Flatten('user');
  OrderFlat := Order.Flatten('order');
  
  Merged := TJson.Create;
  for Key in UserFlat.GetKeys do
    Merged.S[Key] := UserFlat.S[Key];
  for Key in OrderFlat.GetKeys do
    Merged.S[Key] := OrderFlat.S[Key];
  
  Writeln('合并结果:');
  Writeln(Merged.Format);
  Writeln;
  Writeln('解析合并结果:');
  Writeln('  user.name = ' + Merged.S['user.name']);
  Writeln('  user.age = ' + Merged.S['user.age']);
  Writeln('  order.id = ' + Merged.S['order.id']);
  Writeln('  order.amount = ' + Merged.S['order.amount']);
  Writeln;
end;

procedure DemoAutoMemory;
begin
  Writeln('=== 15. 自动内存管理 ===');
  Writeln('使用接口引用计数，无需手动 Free');
  Writeln;
  
  var Json1: IJson := TJson.Create;
  Json1.S['test'] := '自动释放';
  
  var Json2: IJson := TJson.Parse('{"a":1,"b":2}');
  Writeln('Json2.a = ' + IntToStr(Json2.I['a']));
  
  Writeln('离开作用域后自动释放，无需 Free');
  Writeln;
end;

begin
  try
    Writeln('========================================');
    Writeln('  SimpleJSON 简化用法演示');
    Writeln('========================================');
    Writeln;
    
    DemoBasicUsage;
    DemoDateTime;
    DemoParseJSON;
    DemoNestedObjects;
    DemoArrays;
    DemoArrayObjects;
    DemoPathAccess;
    DemoModifyAndRemove;
    DemoIterateKeys;
    DemoNullAndTryGet;
    DemoFileOperations;
    DemoComplexStructure;
    DemoFlatten;
    DemoAutoMemory;
    
    Writeln('========================================');
    Writeln('  演示完成!');
    Writeln('========================================');
    Writeln;
    Write('按 Enter 键退出...');
    Readln;
  except
    on E: Exception do
    begin
      Writeln('错误: ' + E.ClassName + ' - ' + E.Message);
      Readln;
    end;
  end;
end.
