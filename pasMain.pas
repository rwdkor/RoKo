unit pasMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RoKo_Lib, Vcl.ExtCtrls, System.StrUtils,
  Math, ShellAPI, Vcl.Tabs, Vcl.DockTabSet;

type
  OffsetThread = class(TThread)
  private
    Status: String;
    OffsetBase: Cardinal;
    Offset: Cardinal;
  protected
    procedure Execute; override;
    procedure Display;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  keyThreadA = class(TThread)
  private
  protected
    procedure Execute; override;
    procedure Display;
  public
    cnt: Integer;
    key: String;
	  keyCount: Integer;
    constructor Create;
    destructor Destroy; override;
  end;

  keyThreadB = class(TThread)
  private
  protected
    procedure Execute; override;
    procedure Display;
  public
    cnt: Integer;
    key: String;
	  keyCount: Integer;
    constructor Create;
    destructor Destroy; override;
  end;

  keyThreadC = class(TThread)
  private
  protected
    procedure Execute; override;
    procedure Display;
  public
    cnt: Integer;
    key: String;
	  keyCount: Integer;
    constructor Create;
    destructor Destroy; override;
  end;

  keyThreadD = class(TThread)
  private
  protected
    procedure Execute; override;
    procedure Display;
  public
    cnt: Integer;
    key: String;
	  keyCount: Integer;
    constructor Create;
    destructor Destroy; override;
  end;

  TfrmMain = class(TForm)
    pnStatusBar: TPanel;
    btnOpenFile: TButton;
    sbPerfect: TScrollBar;
    sbHuman: TScrollBar;
    sbHSet: TScrollBar;
    sbHMiss: TScrollBar;
    btnReset: TButton;
    txtV1: TEdit;
    txtV2: TEdit;
    txtV3: TEdit;
    txtV4: TEdit;
    GroupBox1: TGroupBox;
    lb1: TEdit;
    lb2: TEdit;
    lb3: TEdit;
    lb4: TEdit;
    txtMapName: TEdit;
    lb5: TEdit;
    sbKeyOffset: TScrollBar;
    txtV5: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure sbPerfectChange(Sender: TObject);
    procedure sbHumanChange(Sender: TObject);
    procedure sbHSetChange(Sender: TObject);
    procedure sbHMissChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sbKeyOffsetChange(Sender: TObject);
  private
    { Private declarations }
  public
    OffsetT: OffsetThread;
    KeyTA: KeyThreadA;
    KeyTB: KeyThreadB;
    KeyTC: KeyThreadC;
    KeyTD: KeyThreadD;
    Frame: Integer;
    KeyOffset: Integer;
    KeyList1: TStringList;
    KeyList2: TStringList;
    KeyList3: TStringList;
    KeyList4: TStringList;
    Ready: Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{$region 'offsetThread'}
constructor OffsetThread.Create;
begin

  FreeOnTerminate := False;
  inherited Create(False); //Create suspended.
  //ShowMessage('Created');
  Status := '';
end;

destructor OffsetThread.Destroy;
begin
  inherited;
end;

procedure OffsetThread.Execute;
begin
  while not Terminated do
  begin
    Synchronize(Display);

    if (DSiGetProcessID('osu!.exe') = 0) then
    begin
      Status := '';
    end;

    Synchronize(Display);

    if ((Status = '') and (DSiGetProcessID('osu!.exe') <> 0)) then
    begin
      Status := 'scan';
    end;

    Synchronize(Display);

    if ((Status = 'scan') and (DSiGetProcessID('osu!.exe') <> 0)) then
    begin
      WaitForSingleObject(handle, 1000);
      OffsetBase := StrToInt('$' + GetOffset()) + $D;
      Offset := ReadMemoryInt(ReadMemoryInt(OffsetBase));
      Status := 'done';
    end;

    Synchronize(Display);

    if ((Status = 'done') and (DSiGetProcessID('osu!.exe') <> 0)) then
    begin
      Offset := ReadMemoryInt(ReadMemoryInt(OffsetBase));
    end;
    
    Application.ProcessMessages;
    WaitForSingleObject(handle, 1);
  end;
end;

procedure OffsetThread.Display;
begin
  if (Status = '') then
  begin  
    frmMain.pnStatusBar.Caption := 'Waiting for osu!.exe...';
  end
  else if (Status = 'scan') then
  begin
    frmMain.pnStatusBar.Caption := 'Scanning offset...';
  end
  else if (Status = 'done') then
  begin
    frmMain.Frame := Offset;
    frmMain.Caption := 'RoKo - ' + IntToStr(Offset);
    frmMain.pnStatusBar.Caption := 'Enjoy the game!';
  end;
end;
{$endregion}


{$region 'keyThreadA'}
constructor keyThreadA.Create;
begin
  cnt := 0;
  FreeOnTerminate := False;
  inherited Create(true); //Create suspended.
  //ShowMessage('Created');
end;

destructor keyThreadA.Destroy;
begin
  inherited;
end;

procedure keyThreadA.Execute;
begin
  Synchronize(Display);
  while not Terminated do
  begin
    Synchronize(Display);
    Application.ProcessMessages;

    if (StrToInt(SplitString(key, ';')[1]) < (frmMain.Frame - 70)) and (cnt <> 0) then
    begin
      cnt := cnt + 1;
      continue;
    end;

    //Short Note
    if (SplitString(key, ';')[0] = '1') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($44, MapVirtualKey($44, 0), 0, 0);
        //Random sleep
        WaitForSingleObject(handle, 40 + RandomRange(-30, 20));
        //KeyUp D
        keybd_event($44, MapVirtualKey($44, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note push
    if (SplitString(key, ';')[0] = '2') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($44, MapVirtualKey($44, 0), 0, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note pop
    if (SplitString(key, ';')[0] = '3') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($44, MapVirtualKey($44, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    Synchronize(Display);
    Application.ProcessMessages;
    WaitForSingleObject(handle, 1);
  end;
end;

procedure keyThreadA.Display;
begin
  key := frmMain.KeyList1[cnt];
  keyCount := frmMain.KeyList1.Count;
end;
{$endregion}

{$region 'keyThreadB'}
constructor keyThreadB.Create;
begin
  cnt := 0;
  FreeOnTerminate := False;
  inherited Create(true); //Create suspended.
  //ShowMessage('Created');
end;

destructor keyThreadB.Destroy;
begin
  inherited;
end;

procedure keyThreadB.Execute;
begin
  Synchronize(Display);
  while not Terminated do
  begin
    Synchronize(Display);
    Application.ProcessMessages;

    if (StrToInt(SplitString(key, ';')[1]) < (frmMain.Frame - 70)) and (cnt <> 0) then
    begin
      cnt := cnt + 1;
      continue;
    end;

    //Short Note
    if (SplitString(key, ';')[0] = '1') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($46, MapVirtualKey($46, 0), 0, 0);
        //Random sleep
        WaitForSingleObject(handle, 40 + RandomRange(-30, 20));
        //KeyUp D
        keybd_event($46, MapVirtualKey($46, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note push
    if (SplitString(key, ';')[0] = '2') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($46, MapVirtualKey($46, 0), 0, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note pop
    if (SplitString(key, ';')[0] = '3') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($46, MapVirtualKey($46, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    Synchronize(Display);
    Application.ProcessMessages;
    WaitForSingleObject(handle, 1);
  end;
end;

procedure keyThreadB.Display;
begin
  key := frmMain.KeyList2[cnt];
  keyCount := frmMain.KeyList2.Count;
end;
{$endregion}

{$region 'keyThreadC'}
constructor keyThreadC.Create;
begin
  cnt := 0;
  FreeOnTerminate := False;
  inherited Create(true); //Create suspended.
  //ShowMessage('Created');
end;

destructor keyThreadC.Destroy;
begin
  inherited;
end;

procedure keyThreadC.Execute;
begin
  Synchronize(Display);
  while not Terminated do
  begin
    Synchronize(Display);
    Application.ProcessMessages;

    if (StrToInt(SplitString(key, ';')[1]) < (frmMain.Frame - 70)) and (cnt <> 0) then
    begin
      cnt := cnt + 1;
      continue;
    end;

    //Short Note
    if (SplitString(key, ';')[0] = '1') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($4A, MapVirtualKey($4A, 0), 0, 0);
        //Random sleep
        WaitForSingleObject(handle, 40 + RandomRange(-30, 20));
        //KeyUp D
        keybd_event($4A, MapVirtualKey($4A, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note push
    if (SplitString(key, ';')[0] = '2') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($4A, MapVirtualKey($4A, 0), 0, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note pop
    if (SplitString(key, ';')[0] = '3') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($4A, MapVirtualKey($4A, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    Synchronize(Display);
    Application.ProcessMessages;
    WaitForSingleObject(handle, 1);
  end;
end;

procedure keyThreadC.Display;
begin
  key := frmMain.KeyList3[cnt];
  keyCount := frmMain.KeyList3.Count;
end;
{$endregion}

{$region 'keyThreadD'}
constructor keyThreadD.Create;
begin
  cnt := 0;
  FreeOnTerminate := False;
  inherited Create(true); //Create suspended.
  //ShowMessage('Created');
end;

destructor keyThreadD.Destroy;
begin
  inherited;
end;

procedure keyThreadD.Execute;
begin
  Synchronize(Display);
  while not Terminated do
  begin
    Synchronize(Display);
    Application.ProcessMessages;

    if (StrToInt(SplitString(key, ';')[1]) < (frmMain.Frame - 70)) and (cnt <> 0) then
    begin
      cnt := cnt + 1;
      continue;
    end;

    //Short Note
    if (SplitString(key, ';')[0] = '1') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($4B, MapVirtualKey($4B, 0), 0, 0);
        //Random sleep
        WaitForSingleObject(handle, 40 + RandomRange(-30, 20));
        //KeyUp D
        keybd_event($4B, MapVirtualKey($4B, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note push
    if (SplitString(key, ';')[0] = '2') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($4B, MapVirtualKey($4B, 0), 0, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    //Slider Note pop
    if (SplitString(key, ';')[0] = '3') then
    begin
      if (Abs(StrToInt(SplitString(key, ';')[1]) - (frmMain.Frame - 19)) <= frmMain.KeyOffset ) then
      begin
        //KeyDown D
        keybd_event($4B, MapVirtualKey($4B, 0), KEYEVENTF_KEYUP, 0);
        cnt := cnt + 1;
        continue;
      end;
    end;

    Synchronize(Display);
    Application.ProcessMessages;
    WaitForSingleObject(handle, 1);
  end;
end;

procedure keyThreadD.Display;
begin
  key := frmMain.KeyList4[cnt];
  keyCount := frmMain.KeyList4.Count;
end;
{$endregion}

procedure TfrmMain.btnOpenfileClick(Sender: TObject);
const
  BUFF_SIZE = $50000;
var
  selectedFile: string;
  dlg: TFileOpenDialog;
  //
  SL: TStringList;
  Beatmap: TStringList;
  i: Integer;
  StartFrame: Integer;
  EndFrame: Integer;
  dHuman: Integer;
  dBad: Integer;
  keyInfo: Integer;
  BeatmapName: String;
begin
  selectedFile := '';
  dlg := TFileOpenDialog.Create(nil);
  try
    dlg.DefaultFolder := GetOsuPath + 'Songs'; //'osupath\Songs'
    with dlg.FileTypes.Add do
    begin
      DisplayName := 'Osu! Beatmap files';
      FileMask := '*.osu';
    end;

    if dlg.Execute(Handle) then
      selectedFile := dlg.FileName; //selectedFile에 고른 파일의 이름을 넣음
  finally
    dlg.Free;
  end;

  if selectedFile <> '' then
    //ShowMessage('ok');
  begin
    SL := TStringList.Create;
    Beatmap := TStringList.Create;
    try
      SL.LoadFromFile(selectedFile);
      EndFrame := SL.Count - 1;
      for i := 0 to SL.Count - 1 do
      begin
        if (SL[i] = '[HitObjects]') then
        begin
          StartFrame := i;
        end;

        if (SL[i] = '[Metadata]') then
        begin
          BeatmapName := SplitString(SL[i + 1], ':')[1] + ' [' + SplitString(SL[i + 6], ':')[1] + ']';
        end;

      //SL.SaveToFile(selectedFile);
      end;

      //parse #1
      for i := StartFrame to EndFrame do
      begin
        Beatmap.Add(SL[i]);
      end;
    finally
      SL.Free;
    end;

    //parse #2
    keyTA.cnt := 0;
    keyTB.cnt := 0;
    keyTC.cnt := 0;
    keyTD.cnt := 0;
    KeyList1.Clear;
    KeyList2.Clear;
    KeyList3.Clear;
    KeyList4.Clear;

    dHuman := sbHSet.Position;
    dBad := 65;
    keyInfo := 0;

    for i := 0 to Beatmap.Count - 1 do
    begin
      if (SplitString(Beatmap[i], ',')[0] = '64') then
      begin

        if (StrToInt(SplitString(Beatmap[i], ',')[2]) < StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0])) then
        begin
          keyInfo := 2;
        end
        else
        begin
          keyInfo := 1;
        end;

        if (keyInfo = 1) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList1.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList1.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList1.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

        if (keyInfo = 2) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList1.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            KeyList1.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList1.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            KeyList1.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList1.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            KeyList1.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

      end;

      if (SplitString(Beatmap[i], ',')[0] = '192') then
      begin

        if (StrToInt(SplitString(Beatmap[i], ',')[2]) < StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0])) then
        begin
          keyInfo := 2;
        end
        else
        begin
          keyInfo := 1;
        end;

        if (keyInfo = 1) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList2.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList2.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList2.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

        if (keyInfo = 2) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList2.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            KeyList2.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList2.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            KeyList2.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList2.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            KeyList2.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

      end;

      if (SplitString(Beatmap[i], ',')[0] = '320') then
      begin

        if (StrToInt(SplitString(Beatmap[i], ',')[2]) < StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0])) then
        begin
          keyInfo := 2;
        end
        else
        begin
          keyInfo := 1;
        end;

        if (keyInfo = 1) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList3.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList3.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList3.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

        if (keyInfo = 2) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList3.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            KeyList3.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList3.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            KeyList3.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList3.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            KeyList3.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

      end;

      if (SplitString(Beatmap[i], ',')[0] = '448') then
      begin

        if (StrToInt(SplitString(Beatmap[i], ',')[2]) < StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0])) then
        begin
          keyInfo := 2;
        end
        else
        begin
          keyInfo := 1;
        end;

        if (keyInfo = 1) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList4.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList4.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList4.Add( '1;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

        if (keyInfo = 2) then
        begin
          if (RandomRange(1, 101) <= sbPerfect.Position) then
          begin
            KeyList4.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-4, 4)) );
            KeyList4.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-4, 4)) );
            continue;
          end
          else if (RandomRange(1, 101) <= sbHMiss.Position) then
          begin
            KeyList4.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dBad, dBad)) );
            KeyList4.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dBad, dBad)) );
            continue;
          end
          else
          begin
            KeyList4.Add( '2;' + IntToStr(StrToInt(SplitString(Beatmap[i], ',')[2]) + RandomRange(-dHuman, dHuman)) );
            KeyList4.Add( '3;' + IntToStr(StrToInt(SplitString(SplitString(Beatmap[i], ',')[5], ':')[0]) + RandomRange(-dHuman, dHuman)) );
            continue;
          end;
        end;

      end;
    end;

    ShowMessage('게임을 시작하기 전에 확인을 누르세요.');
    keyTA.Resume;
    keyTB.Resume;
    keyTC.Resume;
    keyTD.Resume;
    txtMapName.Text := '로드 완료 : ' + BeatmapName;
    txtMapName.Font.Color := $ff7cec;
  end;
  //<your code here to handle the selected file>
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(Application.ExeName), nil, nil, SW_SHOWNORMAL);
  Application.Terminate; // or, if this is the main form, simply Close;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  //ShowMessage(IntToStr(GetPIDByTitle()));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  frmMain.Ready := false;
  KeyOffset := 27;
  pnStatusBar.Caption := 'Waiting for osu!.exe...';
  OffsetT := OffsetThread.Create;
  keyTA := keyThreadA.Create;
  keyTB := keyThreadB.Create;
  keyTC := keyThreadC.Create;
  keyTD := keyThreadD.Create;
  KeyList1 := TStringList.Create;
  KeyList2 := TStringList.Create;
  KeyList3 := TStringList.Create;
  KeyList4 := TStringList.Create;
  if (GetPidByName('osu!.exe') <> 0) then
  begin
    //ShowMessage(GetOffset());
  end;
end;

procedure TfrmMain.sbHSetChange(Sender: TObject);
begin
  //lbHExcell.Caption := IntToStr(sbHSet.Position);
  txtV3.Text := IntToStr(sbHSet.Position);
end;

procedure TfrmMain.sbHMissChange(Sender: TObject);
begin
  //lbHMiss.Caption := IntToStr(sbHMiss.Position) + ' %';
  txtV4.Text := IntToStr(sbHMiss.Position);
end;

procedure TfrmMain.sbHumanChange(Sender: TObject);
begin
  //lbPerfect.Caption := IntToStr(sbPerfect.Position) + ' %';
  //lbHuman.Caption := IntToStr(sbHuman.Position) + ' %';
  txtV2.Text := IntToStr(sbHuman.Position);
  sbPerfect.Position := 100 - sbHuman.Position;
end;

procedure TfrmMain.sbPerfectChange(Sender: TObject);
begin
  //lbPerfect.Caption := IntToStr(sbPerfect.Position) + ' %';
  //lbHuman.Caption := IntToStr(sbHuman.Position) + ' %';
  txtV1.Text := IntToStr(sbPerfect.Position);
  sbHuman.Position := 100 - sbPerfect.Position;
end;
procedure TfrmMain.sbKeyOffsetChange(Sender: TObject);
begin
  txtV5.Text := IntToStr(sbKeyOffset.Position);
  KeyOffset := sbKeyOffset.Position;
end;

end.
