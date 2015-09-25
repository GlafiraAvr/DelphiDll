object FormAdm: TFormAdm
  Left = 369
  Top = 147
  BorderStyle = bsDialog
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
  ClientHeight = 260
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 240
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 7
      Width = 76
      Height = 13
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    object Lb_us: TLabel
      Left = 286
      Top = 139
      Width = 35
      Height = 15
      Caption = 'Lb_us'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Bevel1: TBevel
      Left = 3
      Top = 64
      Width = 440
      Height = 13
      Shape = bsTopLine
    end
    object lInfo: TLabel
      Left = 8
      Top = 48
      Width = 20
      Height = 13
      Caption = 'lInfo'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object DBL_brig: TRxDBLookupCombo
      Left = 8
      Top = 23
      Width = 381
      Height = 23
      DropDownCount = 8
      LookupField = 'ID'
      LookupDisplay = 'NAME_R;DOLGN'
      LookupSource = DM_AdmClass.dsSelect_S_BRIG
      TabOrder = 0
      OnChange = DBL_brigChange
      OnEnter = DBL_brigEnter
    end
    object GrB_prava: TGroupBox
      Left = 5
      Top = 70
      Width = 275
      Height = 166
      Caption = ' '#1055#1088#1072#1074#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object ChB_read: TCheckBox
        Left = 7
        Top = 16
        Width = 117
        Height = 15
        Caption = #1063#1090#1077#1085#1080#1077
        Checked = True
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        OnClick = ChB_readClick
      end
      object ChB_Sprav: TCheckBox
        Left = 7
        Top = 113
        Width = 190
        Height = 15
        Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Admin_chb: TCheckBox
        Left = 7
        Top = 145
        Width = 190
        Height = 15
        Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1080#1077
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = Admin_chbClick
      end
      object ChB_WriteZav: TCheckBox
        Left = 7
        Top = 32
        Width = 193
        Height = 17
        Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1092#1086#1088#1084#1099
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object ChB_WriteRask: TCheckBox
        Left = 7
        Top = 48
        Width = 185
        Height = 17
        Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1088#1072#1089#1082#1086#1087#1086#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object ChB_WriteZadv: TCheckBox
        Left = 7
        Top = 64
        Width = 193
        Height = 17
        Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1079#1072#1076#1074#1080#1078#1077#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object ChB_WriteNarad: TCheckBox
        Left = 7
        Top = 80
        Width = 193
        Height = 17
        Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1074#1099#1077#1079#1076#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object ChB_WritePoter: TCheckBox
        Left = 7
        Top = 96
        Width = 193
        Height = 17
        Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1086#1090#1077#1088#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
      object ChB_DelZav: TCheckBox
        Left = 7
        Top = 128
        Width = 122
        Height = 17
        Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1103#1074#1086#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object bbHelp: TBitBtn
        Left = 246
        Top = 138
        Width = 25
        Height = 25
        Hint = #1057#1087#1088#1072#1074#1082#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = bbHelpClick
        Glyph.Data = {
          82020000424D8202000000000000420000002800000011000000100000000100
          10000300000040020000120B0000120B00000000000000000000007C0000E003
          00001F000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F00000000FF7FFF7FFF7FFF7F
          FF7FFF7FFF7FFF7F0000FF7FFF7FFF7FFF7FFF7F00000000104010420000FF7F
          FF7FFF7FFF7FFF7FFF7FFF7F0000FF7FFF7FFF7F0000000010401042FF7FFF7F
          18630000FF7FFF7FFF7FFF7FFF7FFF7F0000FF7F0000000010401042FF7FFF7F
          FF7FFF7F186318630000FF7FFF7FFF7FFF7FFF7F0000000010401042FF7FFF7F
          FF7F1863104200001863186318630000FF7FFF7FFF7FFF7F00000000FF7FFF7F
          FF7F1863104200001040104000001863186318630000FF7FFF7FFF7F00000000
          FF7F1863104200001040104010401040104000001863186318630000FF7FFF7F
          0000000010420000104010401040E07F10401040104010401040186318631042
          0000FF7F00001040104010401040104010401040004210401040104010400000
          18631042FF7FFF7F0000FF7F104010401040104010401040E07FE07FE07F1040
          1040104000001042FF7FFF7F0000FF7FFF7F1040104010401040104000421040
          0042E07F1040104010400000FF7FFF7F0000FF7FFF7FFF7F1040104010401040
          E07F00420042E07F10401040104010400000FF7F0000FF7FFF7FFF7FFF7F1040
          104010401040E07FE07F10401040104010400000FF7FFF7F0000FF7FFF7FFF7F
          FF7FFF7F10401040104010401040104010400000FF7FFF7FFF7FFF7F0000FF7F
          FF7FFF7FFF7FFF7FFF7F10401040104010400000FF7FFF7FFF7FFF7FFF7FFF7F
          0000FF7FFF7FFF7FFF7FFF7FFF7FFF7F10400000FF7FFF7FFF7FFF7FFF7FFF7F
          FF7FFF7F0000}
      end
    end
    object GrB_Pass: TGroupBox
      Left = 284
      Top = 70
      Width = 136
      Height = 68
      Caption = ' '#1055#1072#1088#1086#1083#1100' '
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Ed_pas1: TEdit
        Left = 6
        Top = 18
        Width = 123
        Height = 21
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PasswordChar = '#'
        TabOrder = 0
        OnChange = Ed_uidChange
        OnEnter = Ed_admEnter
      end
      object Ed_pas2: TEdit
        Left = 6
        Top = 41
        Width = 123
        Height = 21
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PasswordChar = '#'
        TabOrder = 1
        OnChange = Ed_uidChange
        OnEnter = Ed_admEnter
      end
    end
    object BB_Close: TBitBtn
      Left = 284
      Top = 210
      Width = 136
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 3
      OnClick = BB_CloseClick
      Kind = bkClose
    end
    object BB_Save: TBitBtn
      Left = 284
      Top = 183
      Width = 136
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Enabled = False
      TabOrder = 4
      OnClick = BB_SaveClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
    end
    object bbTableRights: TBitBtn
      Left = 284
      Top = 148
      Width = 136
      Height = 25
      Caption = #1055#1088#1072#1074#1072' '#1085#1072' '#1090#1072#1073#1083#1080#1094#1099
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = bbTableRightsClick
      NumGlyphs = 2
    end
  end
  object Pn_stat: TPanel
    Left = 0
    Top = 240
    Width = 425
    Height = 20
    Align = alBottom
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 1
    object Lb_izm: TLabel
      Left = 9
      Top = 2
      Width = 130
      Height = 16
      Caption = 'GGGGGGGGGGGGG'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object pProcess: TPanel
    Left = 40
    Top = 124
    Width = 353
    Height = 49
    BevelInner = bvLowered
    TabOrder = 2
    Visible = False
    object lProcess: TLabel
      Left = 8
      Top = 8
      Width = 334
      Height = 13
      AutoSize = False
      Caption = 'lProcess'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pbProcess: TProgressBar
      Left = 8
      Top = 24
      Width = 337
      Height = 17
      Smooth = True
      TabOrder = 0
    end
  end
  object bbRebuildRights: TBitBtn
    Left = 394
    Top = 22
    Width = 24
    Height = 24
    Hint = 
      #1055#1086#1083#1085#1072#1103' '#1087#1077#1088#1077#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1072#1074' '#1076#1083#1103' '#1074#1089#1077#1093' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081'.'#13#10#1052#1086#1078#1077#1090' '#1087#1086#1085#1072#1076#1086#1073#1080#1090 +
      #1100#1089#1103', '#1077#1089#1083#1080' '#1076#1086#1073#1072#1074#1083#1103#1083#1080#1089#1100'/'#1091#1076#1072#1083#1103#1083#1080#1089#1100' '#1090#1072#1073#1083#1080#1094#1099', '#13#10#1080#1083#1080' '#1093#1088#1072#1085#1080#1084#1099#1077' '#1087#1088#1086#1094#1077#1076#1091#1088 +
      #1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = bbRebuildRightsClick
    Glyph.Data = {
      CA020000424DCA02000000000000420000002800000012000000120000000100
      10000300000088020000120B0000120B00000000000000000000007C0000E003
      00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7CD439D439D439D439D439D439D439D439D439
      D439D439D43993311F7C1F7C1F7C1F7C1F7CF4397D677D679F675D579F637F5F
      7F5F5F575F575F535F5393311F7C1F7C1F7C1F7C1F7CF439BF6FBF6F6002354F
      EE36A71AEE365D575F575F535F5393311F7C1F7C1F7C1F7C1F7C163EBF6FBF6F
      60026002600260026002A71A5F575F575F5793311F7C1F7C1F7C1F7C1F7C163E
      DF73DF7360026002610EFA569F6364125F575F575F5793311F7C1F7C1F7C1F7C
      1F7C163EDF73DF7360026002600260029F635D575F575F575F57D4351F7C1F7C
      1F7C1F7C1F7C7942DF77DF77DF77DF73DF73DF737D677D679F637F5F7F5FD435
      1F7C1F7C1F7C1F7C1F7C7942DE7BDE7BDF73DF73DF736002600260029F679F63
      9F63D4351F7C1F7C1F7C1F7C1F7C9A42DE7BDE7B610E354FDF73354F60026002
      9F679F679F63F5391F7C1F7C1F7C1F7C1F7C9A42FF7FFF7FEE36600260026002
      600260029F679F679F67F5391F7C1F7C1F7C1F7C1F7CBB46FF7FFF7FFF7FEE36
      60026002354F60029F673F679F52F5391F7C1F7C1F7C1F7C1F7CBB46FF7FFF7F
      FF7FFF7FFF7FFF7BFF7BDF737D67F539F539F5391F7C1F7C1F7C1F7C1F7CFD4A
      FF7FFF7FFF7FFF7FFF7FFF7FFF7BFF7B7D67F5399D2A79421F7C1F7C1F7C1F7C
      1F7CFD4AFF7FFF7FFF7FDE7BDE7BDE7BBD77BD777D67F5399A4279421F7C1F7C
      1F7C1F7C1F7CFD4ABB46BB46BB46BB46BB46BB46BB46BB46BB46F5399A421F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
  end
  object pProgress: TPanel
    Left = 40
    Top = 75
    Width = 353
    Height = 49
    BevelInner = bvLowered
    TabOrder = 4
    Visible = False
    object lProgress: TLabel
      Left = 8
      Top = 8
      Width = 334
      Height = 13
      AutoSize = False
      Caption = 'lProgress'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pbProgress: TProgressBar
      Left = 8
      Top = 24
      Width = 337
      Height = 17
      Smooth = True
      TabOrder = 0
    end
  end
end
