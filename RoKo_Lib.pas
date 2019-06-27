unit RoKo_Lib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, PSApi,
  TLHelp32, SHFolder, IdGlobal, IdHash, IdHashMessageDigest, DSiWin32;

function DSiGetProcessID(const processName: string): Cardinal;
function GetPIDByTitle(): Cardinal;
function IsOpenProcess() : Cardinal;
function GetPidByName(ProcessName: String): Cardinal;
function GetBasePointerOfModule(ProcessId: DWORD; Modulename: String): Int64;
function ReadMemoryInt(Addr: DWORD): DWORD;
function GetOffset () : String;
function GetOsuPath: String;
function SleepEx(delay: dword) : dword;

var
  ASD : NativeUint;
  Addr : TStringList;
  dwID : DWORD;

type
  TArrayScan = record
  Start: DWORD;
  Finish: DWORD;
  Array_of_bytes: String;
end;

implementation

{$region 'Process'}
//Get PID by process name
function IsOpenProcess() : Cardinal;
var
  s1: WideString;
  s2: String;
  pid: String;
  Name: String;
begin
  Name := 'osu!.exe';//SkypeDecrypt('3334363631363136313731303132313431323636313731373137363331373130');
  //IGetProcessList(s1);
  s2 := s1;
  pid := Copy(s2,s2.IndexOf(Name) - 8, 8);

  if pid = '00000004' then //00000004-System
    pid := '';
  IsOpenProcess := 0;

  if pid <> '' then
  begin;
    //if IsOpen = True then
      //IOpenProcess(pid);
    IsOpenProcess := StrToInt('$' + pid);
  end;
end;

function DSiGetProcessID(const processName: string): Cardinal;
var
  hSnapshot: THandle;
  procEntry: TProcessEntry32;
begin
  Result := 0;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapshot = 0 then
    Exit;
  try
    procEntry.dwSize := Sizeof(procEntry);
    if not Process32First(hSnapshot, procEntry) then
      Exit;
    repeat
      if AnsiSameText(procEntry.szExeFile, processName) then begin
        DSiGetProcessID := procEntry.th32ProcessID;
        Result := procEntry.th32ProcessID;
        break; // repeat
      end;
    until not Process32Next(hSnapshot, procEntry);
  finally DSiCloseHandleAndNull(hSnapshot); end;
end;

//Get PID by process name
function GetPidByName(ProcessName: String): Cardinal;
var
  snap, snap2: Cardinal;
  Process: ProcessENTRY32;
begin
  snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  
  if (snap <> -1) then
  begin
    Process.dwSize := sizeof(Process);
    Process32First(snap, Process);
    while Process32Next(snap, Process) do
    begin
      if uppercase(String(Process.szExeFile)) = uppercase(ProcessName) then
      begin
        GetPidByName := Process.th32ProcessID;
        Exit;
      end;
    end;
  end;
  GetPidByName := 0;
end;

//Get PID by window title
function GetPIDByTitle(): Cardinal;
var
  hWnd: THandle;
  dwPID: DWORD;
begin
  hWnd := FindWindow(0, 0);
  dwPID := 0;
  GetWindowThreadProcessId(hWnd, &dwPID);
  GetPIDByTitle := dwPID;
end;

//Get module base
function GetBasePointerOfModule(ProcessId: DWORD; Modulename: String): Int64;
var
  FSnapshotHandle: THandle;
  FModulEntry32: MODULEENTRY32;
  s: string;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessId);
  try
    if FSnapshotHandle <> INVALID_HANDLE_VALUE then
    begin
      FModulEntry32.dwSize := SizeOf(FModulEntry32);
      if Module32First(FSnapshotHandle, FModulEntry32) then
      begin
        repeat
          s := FModulEntry32.szModule;
          if s = Modulename then
          begin
            Result := Int64(FModulEntry32.modBaseAddr);
            break;
          end;
        until (not Module32Next(FSnapshotHandle, FModulEntry32));
      end;
    end;
  finally
    closeHandle(FSnapshotHandle);
    GetBasePointerOfModule := Result;
  end;
end;

//Mask like '?? ?? ?? ??'
Function GetMask(Array_of_bytes: String): String;
var
  x, y: integer;
  St: string;
  Mask: string;
begin
  St := StringReplace(Array_of_bytes, ' ', '', [rfReplaceAll]);
  y := 1;
  for x := 1 to (Length(St) div 2) do
  begin
    if (St[y] + St[y + 1]) <> '??' then
    begin
      Mask := Mask + 'O';
      y := y + 2;
    end
    else
    begin
      Mask := Mask + 'X';
      y := y + 2;
    end;
  end;
  Result := Mask;
end;

//String to AoB
Procedure StringToArrayByte(Str: string; var Buffer: array of byte);
var
  x, y, z: integer;
  St: string;
begin
  St := StringReplace(Str, ' ', '', [rfReplaceAll]);
  y := 1;
  for x := 0 to Length(St) div 2 - 1 do
  begin
    if St[y] + St[y + 1] <> '??' then
    begin
      Buffer[x] := StrToInt('$' + St[y] + St[y + 1]);
      y := y + 2;
    end
    else
    begin
      Buffer[x] := $00;
      y := y + 2;
    end;
  end;
end;

//Compare Array
Function CompareArray(DestAddress:DWORD ;CONST Dest: Array of byte; Source: array of byte;
  ALength: integer; Mask: String; var ReTurn : TStringList) : Boolean;
var
  x, y: integer;
  a, b, c: integer;
  begin
  for x := 0 to Length(Dest) - Length(Source) do
  begin
   a:=0;
    for y := 0 to Length(Source) - 1 do
    begin
      if (Dest[x + y] = Source[y]) or (Mask[Y+1] = 'X') then
      begin
        if y = (Length(Source) - 1) then
        begin
          Return.Add(IntToHex(DestAddress+x,8));
        end;
      end
      else
      begin
       Break;
      end;
    end;
  end;
  Result := True;
end;

//Array scanner
Function ArrayScan(Struct: TArrayScan): TStringList;
var
  x, y, z: integer;
  ArrayStruct: TArrayScan;
  mbi: Memory_Basic_Information;
  StartAdr: DWORD;
  FinishAdr: DWORD;
  Mask: String;
  Str : String;
  Buffer: Array of Byte;
  ScanBuffer: Array of Byte;
  data : COPYDATASTRUCT;
  reTurn: TStringList;
  PID: DWORD;
  hProcess: THandle;
begin
  Str := StringReplace(Struct.Array_of_bytes,' ','',[rfReplaceAll]);
  StartAdr := Struct.Start;
  FinishAdr := Struct.Finish;
  Mask := GetMask(Str);
  SetLength(ScanBuffer, Length(Str) div 2);
  StringToArrayByte(Str, ScanBuffer);
  reTurn := TStringList.Create;
while StartAdr <= FinishAdr - $10000 do
  begin
    PID := DSiGetProcessID('osu!.exe');
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
    VirtualQueryEx(hProcess,PDWORD(StartAdr), mbi, sizeof(mbi));
    if ((mbi.RegionSize > 0) and ((mbi.Type_9 = MEM_IMAGE) or
      (mbi.Type_9 = MEM_PRIVATE)) and (mbi.State = MEM_COMMIT) and
      ((mbi.Protect = PAGE_WRITECOPY) or (mbi.Protect = PAGE_EXECUTE_WRITECOPY)
      or (mbi.Protect = PAGE_EXECUTE_READWRITE) or
      (mbi.Protect = PAGE_READWRITE))) then
    begin
      SetLength(Buffer, 0);
      SetLength(Buffer, mbi.RegionSize);
      ReadProcessMemory(hProcess, mbi.BaseAddress, @Buffer[0],
        mbi.RegionSize, ASD);
     CompareArray(DWORD(mbi.BaseAddress),Buffer,ScanBuffer,Length(ScanBuffer),Mask,reTurn);
      StartAdr := DWORD(MBI.BaseAddress) + MBI.RegionSize;
    end
    else
    begin
      StartAdr := DWORD(MBI.BaseAddress) + MBI.RegionSize;
    end;
  end;
     CloseHandle(hProcess);
   Result := reTurn;
end;
{$endregion}

{$region 'ReadDword'}
function ReadMemoryInt(Addr: DWORD): DWORD;
var
  PID: DWORD;
  value: Integer;
  hProcess: THandle;
begin
try
  Result:= 0;
  PID := DSiGetProcessID('osu!.exe'); //GetPidByName('osu!.exe');
  hProcess := OpenProcess(PROCESS_VM_READ, False, PID);
  ReadProcessMemory(hProcess, Pointer(Addr), @value, 4, ASD);
  Result := value;
  CloseHandle(hProcess);
except
end;
end;
{$endregion}

{$region 'RPM - Get Offset'}
function GetOffset (): String;
var
  Arrays : TArrayScan;
  Value: DWORD;
begin
  if (DSiGetProcessID('osu!.exe') <> 0) then
  begin
    try
      Arrays.Start:= StrToInt('$00000000');
      Arrays.Finish:= StrToInt('$0FFFFFFF');
      Arrays.Array_of_bytes:= 'EB 0A A1 ?? ?? ?? ?? A3';
      Addr := ArrayScan(Arrays);
      //ShowMessage(Addr.Strings[0]);
    except;
    end;
    Result := Addr.Strings[0];
  end
  else
    Result := '';
end;
{$endregion}

{$region 'GetOsuPath'}
function GetOsuPath: String;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, Path) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(Path) + 'osu!\';
    //ShowMessage(Result);
  end
  else
    Result := '';
end;
{$endregion}

{$region 'SleepWithNoFreeze'}
function SleepEx(delay: dword) : dword;
var Elapsed, Start: DWORD;
begin;
  Start := GetTickCount;
  Elapsed := 0;
  repeat
    if MsgWaitForMultipleObjects(0, Pointer(nil)^, FALSE, delay-Elapsed, QS_ALLINPUT) <> WAIT_OBJECT_0 then Break;
    Application.ProcessMessages;
    Elapsed := GetTickCount - Start;
  until Elapsed >= delay;
end;
{$endregion}

end.
