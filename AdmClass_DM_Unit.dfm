object DM_AdmClass: TDM_AdmClass
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 486
  Top = 211
  Height = 666
  Width = 655
  object IBScript_Adm: TIBScript
    Database = IBDb_Adm
    Transaction = IBTr_Adm
    Terminator = ';'
    Left = 184
    Top = 32
  end
  object IBTr_Adm: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = IBDb_Adm
    Left = 32
    Top = 104
  end
  object IBDb_Adm: TIBDatabase
    DatabaseName = 'E:\homework\basa\AVARODESSA.GDB'
    Params.Strings = (
      'password=masterkey'
      'lc_ctype=CYRL'
      'user_name=SYSDBA')
    LoginPrompt = False
    DefaultTransaction = IBTr_Adm
    SQLDialect = 1
    Left = 24
    Top = 32
  end
  object ibsSelectListOfTables: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      'SELECT RDB$RELATION_NAME as tabl_name from RDB$RELATIONS'
      'where (RDB$SYSTEM_FLAG=0)'
      'order by 1')
    Transaction = IBTr_Adm
    Left = 368
    Top = 200
  end
  object ibsSelectListOfTables_From_S_RIGHTS: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      
        'select id, name_r, UR_READ, UR_ZAV, UR_RASK, UR_ZADV, UR_POTER, ' +
        'UR_NARAD, UR_DEL, UR_ADMIN'
      'from s_rights'
      'order by name_r')
    Transaction = IBTr_Adm
    Left = 360
    Top = 144
  end
  object ibsSelectListOfUsers_From_S_BRIG_NOT_NULL: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      'select id, uid, prava,sys_password'
      'from s_brig'
      'where (uid IS NOT NULL)')
    Transaction = IBTr_Adm
    Left = 352
    Top = 88
  end
  object ibsInsertTableInto_S_RIGHTS: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      '')
    Transaction = IBTr_Adm
    Left = 360
    Top = 32
  end
  object ibsSelectListOfProcedures: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      'SELECT rdb$procedure_name proc_name from rdb$procedures')
    Transaction = IBTr_Adm
    Left = 184
    Top = 96
  end
  object ibqYesNo_READ: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 192
    Top = 256
    object ibqYesNo_READID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_READNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_ZAV: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 280
    Top = 256
    object ibqYesNo_ZAVID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_ZAVNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_RASK: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 192
    Top = 320
    object ibqYesNo_RASKID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_RASKNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_ZADV: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 272
    Top = 320
    object ibqYesNo_ZADVID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_ZADVNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_POTER: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 192
    Top = 384
    object ibqYesNo_POTERID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_POTERNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_NARAD: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 288
    Top = 384
    object ibqYesNo_NARADID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_NARADNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_DEL: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 192
    Top = 448
    object ibqYesNo_DELID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_DELNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object ibqYesNo_ADMIN: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_YesNo
    SQL.Strings = (
      'select id, name_r'
      'from s_yesno')
    Left = 280
    Top = 448
    object ibqYesNo_ADMINID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_YESNO.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqYesNo_ADMINNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_YESNO.NAME_R'
      FixedChar = True
      Size = 10
    end
  end
  object IBTr_YesNo: TIBTransaction
    DefaultDatabase = IBDb_Adm
    Left = 32
    Top = 168
  end
  object ibsTemp: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      '')
    Transaction = IBTr_Adm
    Left = 32
    Top = 248
  end
  object IBSecurityService1: TIBSecurityService
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    TraceFlags = []
    SecurityAction = ActionAddUser
    UserID = 0
    GroupID = 0
    Left = 112
    Top = 184
  end
  object ibqSelect_S_BRIG: TIBQuery
    Database = IBDb_Adm
    Transaction = IBTr_Adm
    SQL.Strings = (
      'select id, name_r, dolgn, uid, prava, sys_password'
      'from s_brig'
      'where (del<>'#39'd'#39')'
      'order by name_r')
    Left = 32
    Top = 368
    object ibqSelect_S_BRIGID: TIntegerField
      FieldName = 'ID'
      Origin = 'S_BRIG.ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqSelect_S_BRIGNAME_R: TIBStringField
      FieldName = 'NAME_R'
      Origin = 'S_BRIG.NAME_R'
      FixedChar = True
      Size = 25
    end
    object ibqSelect_S_BRIGDOLGN: TIBStringField
      FieldName = 'DOLGN'
      Origin = 'S_BRIG.DOLGN'
      FixedChar = True
    end
    object ibqSelect_S_BRIGUID: TIBStringField
      FieldName = 'UID'
      Origin = 'S_BRIG.UID'
      FixedChar = True
    end
    object ibqSelect_S_BRIGPRAVA: TIBStringField
      DisplayWidth = 100
      FieldName = 'PRAVA'
      Origin = 'S_BRIG.PRAVA'
      FixedChar = True
      Size = 100
    end
    object ibqSelect_S_BRIGSYS_PASSWORD: TIBStringField
      FieldName = 'SYS_PASSWORD'
      Origin = 'S_BRIG.SYS_PASSWORD'
      Size = 8
    end
  end
  object dsSelect_S_BRIG: TDataSource
    DataSet = ibqSelect_S_BRIG
    Left = 48
    Top = 440
  end
  object ibsUPdatePassword: TIBSQL
    Database = IBDb_Adm
    SQL.Strings = (
      'update s_brig set sys_password=:pass where UID=:uid')
    Transaction = IBT_ChangePass
    Left = 392
    Top = 304
  end
  object IBT_ChangePass: TIBTransaction
    DefaultDatabase = IBDb_Adm
    Left = 416
    Top = 384
  end
  object mem_usersPassword: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.52'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 408
    Top = 528
    object mem_usersPassworduid: TStringField
      FieldName = 'uid'
    end
    object mem_usersPasswordsys_password: TStringField
      FieldName = 'sys_password'
    end
  end
end
