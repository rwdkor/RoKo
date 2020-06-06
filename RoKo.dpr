program RoKo;

uses
  Vcl.Forms,
  DSiWin32 in 'DSiWin32.pas',
  pasMain in 'pasMain.pas' {frmMain},
  RoKo_Lib in 'RoKo_Lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
