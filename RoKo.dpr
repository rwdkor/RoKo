program RoKo;

uses
  Vcl.Forms,
  pasMain in 'pasMain.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  RoKo_Lib in 'RoKo_Lib.pas',
  DSiWin32 in 'DSiWin32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
