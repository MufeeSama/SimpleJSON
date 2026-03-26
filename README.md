# SimpleJSON

一个简洁易用的 Delphi JSON 封装库，基于 `System.JSON` 单元封装，提供更直观的 API。

## 特性

- **类型化属性访问** - 使用 `S/I/L/F/B/D` 属性直接读写不同类型值
- **日期时间支持** - 内置 ISO 8601 日期格式自动转换，支持时区
- **链式调用** - 支持流式 API，代码更简洁
- **自动内存管理** - 基于接口引用计数，无需手动释放
- **嵌套对象支持** - 轻松创建和访问多层嵌套结构
- **路径访问** - 支持 `info.city`、`users.0.name` 格式的路径访问
- **Null 值处理** - 支持 `IsNull`/`SetNull` 操作
- **安全获取值** - `TryGet*` 系列方法避免键不存在时的异常
- **文件读写** - `SaveToFile`/`LoadFromFile` 便捷操作
- **扁平化处理** - `Flatten` 嵌套结构转换
- **类型判断** - `GetValueType` 获取值的实际类型
- **深拷贝** - `Clone` 方法支持对象克隆
- **零依赖** - 仅依赖 Delphi 标准库

## 快速开始

### 基本用法

```delphi
uses
  SimpleJSON;

var
  Json: IJson;
begin
  // 创建对象
  Json := TJson.Create;
  
  // 设置值
  Json.S['name'] := '张三';
  Json.I['age'] := 25;
  Json.L['id'] := 9876543210;      // Int64 大整数
  Json.F['salary'] := 8500.50;
  Json.B['active'] := True;
  Json.D['created'] := Now;         // 日期时间
  
  // 读取值
  Writeln(Json.S['name']);
  Writeln(IntToStr(Json.I['age']));
  Writeln(IntToStr(Json.L['id']));
  
  // 无需 Free，接口自动管理内存
end;
```

### 解析 JSON 字符串

```delphi
var
  Json: IJson;
begin
  Json := TJson.Parse('{"id":1001,"name":"Delphi","price":199.99}');
  if Assigned(Json) then
    Writeln(Json.S['name']);  // 输出: Delphi
end;
```

### 日期时间类型

```delphi
var
  Json: IJson;
begin
  Json := TJson.Create;
  
  // 设置日期时间值 (自动转换为 ISO 8601 格式)
  Json.D['created_at'] := Now;
  Json.D['birthday'] := EncodeDate(1990, 5, 15);
  
  // 读取日期时间值
  Writeln(DateTimeToStr(Json.D['created_at']));
  Writeln(DateToStr(Json.D['birthday']));
  
  // 解析包含日期的 JSON (支持时区)
  Json := TJson.Parse('{"event":"会议","start_time":"2024-01-15T09:30:00+08:00"}');
  Writeln(DateTimeToStr(Json.D['start_time']));
end;
```

支持的日期格式：
- ISO 8601 带毫秒: `2024-01-15T09:30:00.000`
- ISO 8601 不带毫秒: `2024-01-15T09:30:00`
- 带时区: `2024-01-15T09:30:00+08:00`
- UTC 标记: `2024-01-15T09:30:00Z`
- 简短日期: `2024-01-15`

### Null 值处理

```delphi
var
  Json: IJson;
begin
  Json := TJson.Create;
  
  // 设置 null 值
  Json.SetNull('deleted_at');
  
  // 检查是否为 null
  if Json.IsNull('deleted_at') then
    Writeln('deleted_at 是 null');
  
  // 数组中的 null
  Json.A['items'].AddNull;
  if Json.A['items'].IsNull(0) then
    Writeln('第一个元素是 null');
end;
```

### 安全获取值 (TryGet)

```delphi
var
  Json: IJson;
  Name: string;
  Age: Integer;
  Address: IJson;
  Tags: IJsonArray;
begin
  Json := TJson.Parse('{"name":"张三","age":25}');
  
  // 安全获取基本类型
  if Json.TryGetS('name', Name) then
    Writeln('姓名: ' + Name);
  
  if Json.TryGetI('age', Age) then
    Writeln('年龄: ' + IntToStr(Age));
  
  // 安全获取嵌套对象
  if Json.TryGetO('address', Address) then
    Writeln('城市: ' + Address.S['city']);
  
  // 安全获取数组
  if Json.TryGetA('tags', Tags) then
    Writeln('标签数: ' + IntToStr(Tags.Count));
  
  // 键不存在时返回 False
  if not Json.TryGetS('not_exists', Name) then
    Writeln('键不存在');
end;
```

### 嵌套对象

```delphi
var
  Json: IJson;
begin
  Json := TJson.Create;
  
  // 自动创建嵌套对象
  Json.O['address'].S['city'] := '北京';
  Json.O['address'].S['zip'] := '100001';
  
  // 访问嵌套值
  Writeln(Json.O['address'].S['city']);  // 输出: 北京
end;
```

### 数组操作

```delphi
var
  Json: IJson;
  i: Integer;
begin
  Json := TJson.Create;
  
  // 链式添加数组元素
  Json.A['fruits']
    .Add('苹果')
    .Add('香蕉')
    .Add('橙子');
  
  // 添加大整数
  Json.A['ids'].Add(Int64(12345678901234));
  
  // 遍历数组
  for i := 0 to Json.A['fruits'].Count - 1 do
    Writeln(Json.A['fruits'].S[i]);
end;
```

### 对象数组

```delphi
var
  Json: IJson;
begin
  Json := TJson.Create;
  
  // 添加对象到数组
  Json.A['users'].AddObject.S['name'] := '用户1';
  Json.A['users'].O[0].I['age'] := 20;
  
  Json.A['users'].AddObject.S['name'] := '用户2';
  Json.A['users'].O[1].I['age'] := 25;
end;
```

### 路径访问

```delphi
var
  Json: IJson;
begin
  Json := TJson.Create;
  Json.S['name'] := '测试';
  Json.O['info'].S['city'] := '上海';
  Json.A['tags'].Add('tag1').Add('tag2');
  
  // 使用路径访问
  Writeln(Json.Path['name']);        // 输出: 测试
  Writeln(Json.Path['info.city']);   // 输出: 上海
  Writeln(Json.Path['tags.0']);      // 输出: tag1
end;
```

### 文件读写

```delphi
var
  Json: IJson;
begin
  // 创建并保存
  Json := TJson.Create;
  Json.S['name'] := '测试';
  Json.I['version'] := 1;
  Json.SaveToFile('config.json');
  
  // 从文件加载
  Json := TJson.LoadFromFile('config.json');
  Writeln(Json.S['name']);
  
  // 也可以使用 ParseFile (别名)
  Json := TJson.ParseFile('config.json');
end;
```

### 扁平化处理

```delphi
var
  Json, Flat, Restored: IJson;
begin
  // 原始嵌套 JSON
  Json := TJson.Create;
  Json.S['name'] := '张三';
  Json.O['address'].S['city'] := '北京';
  Json.O['address'].S['zip'] := '100001';
  Json.A['tags'].Add('tag1').Add('tag2');
  
  // 扁平化 - 将嵌套结构转为单层键值对
  Flat := Json.Flatten;
  // 结果: {"name":"张三","address.city":"北京","address.zip":"100001","tags.0":"tag1","tags.1":"tag2"}
end;
```

### 带前缀扁平化 (合并多个对象)

```delphi
var
  User, Order, UserFlat, OrderFlat, Merged: IJson;
  Key: string;
begin
  User := TJson.Create;
  User.S['name'] := '张三';
  User.I['age'] := 25;
  
  Order := TJson.Create;
  Order.S['id'] := 'ORD-001';
  Order.F['amount'] := 199.99;
  
  // 带前缀扁平化
  UserFlat := User.Flatten('user');
  OrderFlat := Order.Flatten('order');
  
  // 合并到一个对象
  Merged := TJson.Create;
  for Key in UserFlat.GetKeys do
    Merged.S[Key] := UserFlat.S[Key];
  for Key in OrderFlat.GetKeys do
    Merged.S[Key] := OrderFlat.S[Key];
  
  // 结果: {"user.name":"张三","user.age":"25","order.id":"ORD-001","order.amount":"199.99"}
end;
```

### 类型判断

```delphi
var
  Json: IJson;
begin
  Json := TJson.Parse('{"name":"张三","age":25,"active":true,"data":null}');
  
  // 获取值的类型
  case Json.GetValueType('name') of
    jvtString:  Writeln('name 是字符串');
    jvtNumber:  Writeln('name 是数字');
    jvtBoolean: Writeln('name 是布尔值');
    jvtObject:  Writeln('name 是对象');
    jvtArray:   Writeln('name 是数组');
    jvtNull:    Writeln('name 是 null');
  end;
  
  // 数组元素类型判断
  if Json.A['items'].GetValueType(0) = jvtString then
    Writeln('第一个元素是字符串');
end;
```

### 对象克隆

```delphi
var
  Original, Cloned: IJson;
begin
  Original := TJson.Create;
  Original.S['name'] := '原始对象';
  Original.I['value'] := 100;
  
  // 深拷贝
  Cloned := Original.Clone;
  
  // 修改克隆不影响原始对象
  Cloned.S['name'] := '克隆对象';
  
  Writeln(Original.S['name']);  // 输出: 原始对象
  Writeln(Cloned.S['name']);    // 输出: 克隆对象
end;
```

## API 参考

### IJson 接口

| 属性/方法 | 说明 |
|-----------|------|
| `S[Key]` | 字符串类型读写 |
| `I[Key]` | 整数类型读写 (32位) |
| `L[Key]` | 长整数类型读写 (64位) |
| `F[Key]` | 浮点数类型读写 |
| `B[Key]` | 布尔类型读写 |
| `D[Key]` | 日期时间类型读写 (ISO 8601 格式) |
| `O[Key]` | 获取嵌套对象 |
| `A[Key]` | 获取数组 |
| `Path[Path]` | 路径方式访问值 |
| `IsNull(Key)` | 检查值是否为 null |
| `SetNull(Key)` | 设置值为 null |
| `GetValueType(Key)` | 获取值的类型 |
| `TryGetS(Key, out)` | 安全获取字符串值 |
| `TryGetI(Key, out)` | 安全获取整数值 |
| `TryGetL(Key, out)` | 安全获取长整数值 |
| `TryGetF(Key, out)` | 安全获取浮点数值 |
| `TryGetB(Key, out)` | 安全获取布尔值 |
| `TryGetD(Key, out)` | 安全获取日期时间值 |
| `TryGetO(Key, out)` | 安全获取嵌套对象 |
| `TryGetA(Key, out)` | 安全获取数组 |
| `Contains(Key)` | 检查键是否存在 |
| `Remove(Key)` | 删除指定键 |
| `Clear` | 清空对象 |
| `GetKeys` | 获取所有键名 |
| `Count` | 获取键数量 |
| `ToJSON` | 输出紧凑 JSON 字符串 |
| `Format` | 输出格式化 JSON 字符串 |
| `SaveToFile(FileName)` | 保存到文件 |
| `Clone` | 深拷贝对象 |
| `Flatten` | 扁平化嵌套结构 |
| `Flatten(Prefix)` | 带前缀扁平化 |

### IJsonArray 接口

| 属性/方法 | 说明 |
|-----------|------|
| `S[Index]` | 获取字符串元素 |
| `I[Index]` | 获取整数元素 |
| `L[Index]` | 获取长整数元素 |
| `F[Index]` | 获取浮点数元素 |
| `B[Index]` | 获取布尔元素 |
| `D[Index]` | 获取日期时间元素 |
| `O[Index]` | 获取对象元素 |
| `A[Index]` | 获取数组元素 (嵌套数组) |
| `IsNull(Index)` | 检查元素是否为 null |
| `GetValueType(Index)` | 获取元素类型 |
| `Add(Value)` | 添加元素，返回 Self 支持链式调用 |
| `AddNull` | 添加 null 元素 |
| `AddObject` | 添加对象并返回 |
| `AddArray` | 添加数组并返回 |
| `Delete(Index)` | 删除指定位置元素 |
| `Clear` | 清空数组 |
| `Count` | 获取元素数量 |
| `ToJSON` | 输出紧凑 JSON 字符串 |
| `Format` | 输出格式化 JSON 字符串 |
| `Clone` | 深拷贝数组 |

### 类方法

| 方法 | 说明 |
|------|------|
| `TJson.Create` | 创建空 JSON 对象 |
| `TJson.Parse(String)` | 从字符串解析 JSON |
| `TJson.ParseFile(FileName)` | 从文件解析 JSON |
| `TJson.LoadFromFile(FileName)` | 从文件加载 JSON (ParseFile 别名) |
| `TJsonArray.Create` | 创建空 JSON 数组 |
| `TJsonArray.Parse(String)` | 从字符串解析 JSON 数组 |

### 类型枚举

```delphi
TJsonValueType = (jvtNull, jvtString, jvtNumber, jvtBoolean, jvtObject, jvtArray);
```

## 与原生 System.JSON 对比

### 原生写法

```delphi
var
  Obj: TJSONObject;
begin
  Obj := TJSONObject.Create;
  try
    Obj.AddPair('name', TJSONString.Create('张三'));
    Obj.AddPair('age', TJSONNumber.Create(25));
    Writeln(Obj.GetValue<string>('name'));
  finally
    Obj.Free;
  end;
end;
```

### SimpleJSON 写法

```delphi
var
  Json: IJson;
begin
  Json := TJson.Create;
  Json.S['name'] := '张三';
  Json.I['age'] := 25;
  Writeln(Json.S['name']);
  // 无需 Free
end;
```

## 文件结构

```
jsontest/
├── SimpleJSON.pas        # 核心封装单元
├── SimpleJSONDemo.dpr    # 演示程序
└── README.md             # 本文档
```

## 编译要求

- Delphi 10.4 Sydney 或更高版本
- 支持 Win32/Win64 平台

## 编译方法

```bash
dcc32 SimpleJSONDemo.dpr
```

## 许可证

MIT License
