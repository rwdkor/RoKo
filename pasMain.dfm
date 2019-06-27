object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RoKo'
  ClientHeight = 254
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnStatusBar: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 229
    Width = 303
    Height = 25
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkSoft
    BevelOuter = bvNone
    Caption = 'Waiting for osu!.exe...'
    ParentBackground = False
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 153
    Caption = #49444#51221
    Padding.Left = 5
    Padding.Top = 15
    TabOrder = 1
    object sbHMiss: TScrollBar
      Left = 87
      Top = 101
      Width = 160
      Height = 19
      Hint = 'Bad %'
      Ctl3D = True
      PageSize = 0
      ParentCtl3D = False
      ParentShowHint = False
      Position = 5
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnChange = sbHMissChange
    end
    object sbHSet: TScrollBar
      Left = 87
      Top = 74
      Width = 160
      Height = 19
      Hint = 'Legit Range'
      Ctl3D = True
      Max = 50
      PageSize = 0
      ParentCtl3D = False
      ParentShowHint = False
      Position = 30
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnChange = sbHSetChange
    end
    object sbHuman: TScrollBar
      Left = 87
      Top = 47
      Width = 160
      Height = 19
      Hint = 'Legit %'
      Ctl3D = True
      PageSize = 0
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      OnChange = sbHumanChange
    end
    object sbPerfect: TScrollBar
      Left = 87
      Top = 20
      Width = 160
      Height = 19
      Hint = 'Perfect %'
      Ctl3D = True
      PageSize = 0
      ParentCtl3D = False
      ParentShowHint = False
      Position = 100
      ShowHint = True
      TabOrder = 3
      TabStop = False
      OnChange = sbPerfectChange
    end
    object txtV1: TEdit
      Left = 253
      Top = 18
      Width = 33
      Height = 21
      TabStop = False
      Alignment = taCenter
      Ctl3D = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 4
      Text = '100'
    end
    object txtV2: TEdit
      Left = 253
      Top = 45
      Width = 33
      Height = 21
      TabStop = False
      Alignment = taCenter
      Ctl3D = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 5
      Text = '0'
    end
    object txtV3: TEdit
      Left = 253
      Top = 72
      Width = 33
      Height = 21
      TabStop = False
      Alignment = taCenter
      Ctl3D = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 6
      Text = '30'
    end
    object txtV4: TEdit
      Left = 253
      Top = 99
      Width = 33
      Height = 21
      TabStop = False
      Alignment = taCenter
      Ctl3D = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 7
      Text = '5'
    end
    object lb1: TEdit
      Left = 8
      Top = 18
      Width = 73
      Height = 21
      TabStop = False
      AutoSize = False
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ReadOnly = True
      TabOrder = 8
      Text = 'Perfect'
    end
    object lb2: TEdit
      Left = 8
      Top = 45
      Width = 73
      Height = 21
      TabStop = False
      AutoSize = False
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ReadOnly = True
      TabOrder = 9
      Text = 'Legit'
    end
    object lb3: TEdit
      Left = 8
      Top = 72
      Width = 73
      Height = 21
      TabStop = False
      AutoSize = False
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ReadOnly = True
      TabOrder = 10
      Text = 'Legit Range'
    end
    object lb4: TEdit
      Left = 8
      Top = 99
      Width = 73
      Height = 21
      TabStop = False
      AutoSize = False
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ReadOnly = True
      TabOrder = 11
      Text = 'Bad'
    end
    object lb5: TEdit
      Left = 8
      Top = 126
      Width = 73
      Height = 21
      TabStop = False
      Enabled = False
      TabOrder = 12
      Text = 'Key Timing'
    end
    object sbKeyOffset: TScrollBar
      Left = 87
      Top = 128
      Width = 161
      Height = 17
      Max = 50
      Min = -50
      PageSize = 0
      Position = 33
      TabOrder = 13
      TabStop = False
      OnChange = sbKeyOffsetChange
    end
    object txtV5: TEdit
      Left = 253
      Top = 126
      Width = 33
      Height = 21
      TabStop = False
      Alignment = taCenter
      TabOrder = 14
      Text = '33'
    end
  end
  object txtMapName: TEdit
    Left = 8
    Top = 167
    Width = 297
    Height = 21
    TabStop = False
    ReadOnly = True
    TabOrder = 2
    Text = #54540#47112#51060' '#54624' '#47605#51012' '#49440#53469#54644#51452#49464#50836'.'
  end
  object btnOpenFile: TButton
    Left = 8
    Top = 194
    Width = 110
    Height = 27
    Hint = 'Choose the beatmap'
    Caption = #47605' '#50676#44592
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TabStop = False
    OnClick = btnOpenFileClick
  end
  object btnReset: TButton
    Left = 195
    Top = 194
    Width = 110
    Height = 27
    Hint = 'Restart RoKo (if you play another beatmap)'
    Caption = #52488#44592#54868
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TabStop = False
    OnClick = btnResetClick
  end
end
