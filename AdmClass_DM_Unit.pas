unit AdmClass_DM_Unit;

interface

uses
  SysUtils, Classes, DB, IBDatabase, IBScript, BDEInfoUnit, IBSQL,
    AdmClass_AdmObjects_Unit, IBCustomDataSet, IBQuery, IBUpdateSQL,
  IBServices,Variants, kbmMemTable;

type

  TFirebirdServer = record
   ServerName: string;
   Local: boolean;
  end;

  TDM_AdmClass = class(TDataModule)
    IBScript_Adm: TIBScript;
    IBTr_Adm: TIBTransaction;
    IBDb_Adm: TIBDatabase;
    ibsSelectListOfTables: TIBSQL;
    ibsSelectListOfTables_From_S_RIGHTS: TIBSQL;
    ibsSelectListOfUsers_From_S_BRIG_NOT_NULL: TIBSQL;
    ibsInsertTableInto_S_RIGHTS: TIBSQL;
    ibsSelectListOfProcedures: TIBSQL;
    ibqYesNo_READ: TIBQuery;
    ibqYesNo_ZAV: TIBQuery;
    ibqYesNo_RASK: TIBQuery;
    ibqYesNo_ZADV: TIBQuery;
    ibqYesNo_POTER: TIBQuery;
    ibqYesNo_NARAD: TIBQuery;
    ibqYesNo_DEL: TIBQuery;
    ibqYesNo_ADMIN: TIBQuery;
    IBTr_YesNo: TIBTransaction;
    ibqYesNo_READID: TIntegerField;
    ibqYesNo_READNAME_R: TIBStringField;
    ibqYesNo_ZAVID: TIntegerField;
    ibqYesNo_ZAVNAME_R: TIBStringField;
    ibqYesNo_RASKID: TIntegerField;
    ibqYesNo_RASKNAME_R: TIBStringField;
    ibqYesNo_ZADVID: TIntegerField;
    ibqYesNo_ZADVNAME_R: TIBStringField;
    ibqYesNo_POTERID: TIntegerField;
    ibqYesNo_POTERNAME_R: TIBStringField;
    ibqYesNo_NARADID: TIntegerField;
    ibqYesNo_NARADNAME_R: TIBStringField;
    ibqYesNo_DELID: TIntegerField;
    ibqYesNo_DELNAME_R: TIBStringField;
    ibqYesNo_ADMINID: TIntegerField;
    ibqYesNo_ADMINNAME_R: TIBStringField;
    ibsTemp: TIBSQL;
    IBSecurityService1: TIBSecurityService;
    ibqSelect_S_BRIG: TIBQuery;
    dsSelect_S_BRIG: TDataSource;
    ibqSelect_S_BRIGID: TIntegerField;
    ibqSelect_S_BRIGNAME_R: TIBStringField;
    ibqSelect_S_BRIGDOLGN: TIBStringField;
    ibqSelect_S_BRIGUID: TIBStringField;
    ibqSelect_S_BRIGPRAVA: TIBStringField;
    ibsUPdatePassword: TIBSQL;
    ibqSelect_S_BRIGSYS_PASSWORD: TIBStringField;
    IBT_ChangePass: TIBTransaction;
    mem_usersPassword: TkbmMemTable;
    mem_usersPassworduid: TStringField;
    mem_usersPasswordsys_password: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
  private
    FAlias, FSysDbaPassword, FPathOfAlias : string;
    FFirebirdServer: TFirebirdServer;
    { Private declarations }
    FTablesList: TStringList;
    FTablesList_From_S_RIGHTS: TStringList;
    FUsersList_From_S_BRIG_NOT_NULL: TStringList;
    FProceduresList: TStringList;
    function GetFTablesList():TStrings;
    function GetFTablesList_From_S_RIGHTS():TStrings;
    function GetFUsersList_From_S_BRIG_NOT_NULL():TStrings;
    function GetFProceduresList():TStrings;
    { определим местоположение сервера Firebird по алиасу }
    procedure DetectServerLocation;
    //
    procedure ActivateIBSecurityService;
  
  public
    { Public declarations }
    constructor Create(AOwner:TComponent; _alias: string; _SysDbaPassword:string); reintroduce; 
    function ScriptExec(var _sql:string):boolean;
    procedure AddTableTo_S_RIGHTS(_tabl_name: string);
    //
    procedure Commit;
    procedure StartTransaction;
    procedure Rollback;
    //
    function FillProceduresList():TStrings;    
    function FillTablesList():TStrings;
    function FillTablesList_From_S_RIGHTS():TStrings;
    function FillUsersList_From_S_BRIG_NOT_NULL():TStrings;
    //
    function DeleteUserFromDataBase(_uid: string): boolean;
    function AddUserToDataBase(_uid: string;var _pass: string; _update_password_if_user_exists: boolean ):boolean;
    function UpdateUserPasswordToDataBase(_uid: string; _pass: string ):boolean;
    function ExistsUser(_uid: string): boolean;
    //
    procedure Connect;
    procedure Init;
    //
    property TablesList: TStrings read GetFTablesList;
    property TablesList_From_S_RIGHTS: TStrings read GetFTablesList_From_S_RIGHTS;
    property UsersList_From_S_BRIG_NOT_NULL: TStrings read GetFUsersList_From_S_BRIG_NOT_NULL;
    property ProceduresList: TStrings read GetFProceduresList;
    property FirebirdServer: TFirebirdServer read FFirebirdServer;
    property Alias:string read FAlias;
    //
 
  end;

var
  DM_AdmClass: TDM_AdmClass;

implementation

{$R *.dfm}

procedure TDM_AdmClass.Connect;
var
  _bdei:TBDEInfo;
  //_pass:string;
begin
  _bdei := TBDEInfo.Create;
  try
    FPathOfAlias := '';
    FPathOfAlias := _bdei.IBGetPathOfAlias(FAlias);
    IBDB_Adm.DatabaseName := FPathOfAlias;
    IBDB_Adm.Params[0] := 'password=' + FSysDbaPassword;
    try
    IBDB_Adm.Connected := true;
    except
      on E:Exception do
        raise Exception.Create('Ошибка при подключении к базе данных '#13 + 'с алиасом ' + FAlias +#13 +
        'и путём: ' + FPathOfAlias + ';' + #13 + E.Message);
    end;
    DetectServerLocation;
    //
    FillProceduresList();
    FillTablesList();
  finally
    _bdei.Free;
  end;
end;

procedure TDM_AdmClass.Init;
begin
  StartTransaction;
  ibqSelect_S_BRIG.Open;
  //
  FillTablesList_From_S_RIGHTS();
  FillUsersList_From_S_BRIG_NOT_NULL();
end;

function TDM_AdmClass.ExistsUser(_uid: string): boolean;
begin
  //result := false;
  with IBSecurityService1 do
  begin
    Active := True;
    try
      DisplayUser(_uid);
      //Edit2.Text := UserInfo[0].FirstName;
      result := Assigned(UserInfo[0]);
      if result then
      begin
        //UserInfo[0].
      end;
    finally
      Active := False;
    end;
  end;
end;

procedure TDM_AdmClass.ActivateIBSecurityService;
var _p:string;
begin
  if FFirebirdServer.Local then _p := 'Local' else _p := 'TCP';
  try
    IBSecurityService1.Active := true;
  except
    raise Exception.Create('Неудача подключения IBSecurityService к серверу:'#13 +
    '"' + FFirebirdServer.ServerName + '" по порту "' + _p + '"' );
  end;
end;

procedure TDM_AdmClass.DetectServerLocation;
var {_i, } _k, _l: integer;
  _s:string;
begin
  _l := length(FPathOfAlias);
  _k := POS(':',FPathOfAlias);
  if (_k<1) or ((_k+1)>_l) then raise Exception.Create('Неправильно задан алиас!');
  _s := Copy(FPathOfAlias, 1, _k-1);
  FFirebirdServer.Local := FPathOfAlias[_k+1]='\'; {т.е. буква диска};
  if FFirebirdServer.Local
  then FFirebirdServer.ServerName := ''
  else FFirebirdServer.ServerName := _s;
  //
  IBSecurityService1.ServerName := FFirebirdServer.ServerName;
  if FFirebirdServer.Local
  then IBSecurityService1.Protocol := Local
  else IBSecurityService1.Protocol := TCP;
  IBSecurityService1.Params.Clear;
  IBSecurityService1.Params.Add('user_name=sysdba');
  IBSecurityService1.Params.Add('password=' + FSysDbaPassword);
end;

function TDM_AdmClass.DeleteUserFromDataBase(_uid: string): boolean;
begin
  result := true;
  try
    with IBSecurityService1 do
    begin
      ActivateIBSecurityService;
      try
        UserName := _uid;
        DeleteUser;
      finally
        Active := False;
      end;
    end;
  except
    result := false;
  end;
end;

function TDM_AdmClass.UpdateUserPasswordToDataBase(_uid: string; _pass: string):boolean;
begin
  try
    with IBSecurityService1 do
    begin
      ActivateIBSecurityService;
      try
        UserName := _uid;
        FirstName := '';
        MiddleName := '';
        LastName := '';
        UserID := 0;
        GroupID := 0;
        Password := _pass;
        ModifyUser;
        result := true;
      finally
        Active := false;
      end;
    end;
  except
    result := false;    
  end;    
end;

function TDM_AdmClass.AddUserToDataBase( _uid: string; var _pass: string; _update_password_if_user_exists: boolean ):boolean;
 var old_pass:string;
 change_pass:boolean;
begin
 change_pass:=false;
 old_pass:='';
 if mem_usersPassword.Locate('uid',VarArrayOf([_uid]),[loPartialKey]) then
     if not mem_usersPassword.FieldByName('sys_password').IsNull then
       old_pass:=mem_usersPassword.FieldByName('sys_password').AsString
      else
       change_pass:=true;
  if (not _update_password_if_user_exists) and (old_pass<>'') then
   begin
    _pass:=old_pass;
   end ;
  result := ExistsUser(_uid);
  if not result then
  begin
    try
      with IBSecurityService1 do
      begin
        ActivateIBSecurityService;
        //
        try
          UserName := _uid;
          FirstName := '';
          MiddleName := '';
          LastName := '';
          UserID := 0;
          GroupID := 0;
          Password := _pass;
          AddUser;
          change_pass:=true;
          result := true;
        finally
          Active := false;
        end;
      end;
    except
      result := false;
    end;
  end
    else
  begin
    if _update_password_if_user_exists or change_pass then
    begin
      try
        result := UpdateUserPasswordToDataBase( _uid, _pass );
        change_pass:=true;
      except
        result := false;
      end;
    end;
  end;
  if (not change_pass) and (old_pass<>'') then
  _pass:=old_pass;

end;

function TDM_AdmClass.FillProceduresList():TStrings;
begin
  FProceduresList.Clear;
  with ibsSelectListOfProcedures do
  begin
    Close;
    StartTransaction;
    ExecQuery;
    while not (EOF) do
    begin
      FProceduresList.Add(AnsiUpperCase(trim(FieldByName('proc_name').AsString)));
      Next;
    end;
    Close;
  end;
  result := FProceduresList;
end;

procedure TDM_AdmClass.AddTableTo_S_RIGHTS(_tabl_name: string);
begin
  with ibsInsertTableInto_S_RIGHTS do
  begin
    Close;
    StartTransaction;
    SQL.Text :=
      ' insert into s_rights (name_r, ur_read, ur_admin) values ( "' + _tabl_name + '", 1, 1) ';
    try
      ExecQuery;
      Commit;
    except
      Rollback;
    end;
    Close;      
  end;
end;

function TDM_AdmClass.FillUsersList_From_S_BRIG_NOT_NULL():TStrings;
begin
  FUsersList_From_S_BRIG_NOT_NULL.Clear;
  if mem_usersPassword.Active  then
     mem_usersPassword.Close;
  mem_usersPassword.Open;
  with ibsSelectListOfUsers_From_S_BRIG_NOT_NULL do
  begin
    Close;
    StartTransaction;
    ExecQuery;
    //
    while not (EOF) do
    begin
      FUsersList_From_S_BRIG_NOT_NULL.AddObject(
        (AnsiUpperCase(trim(FieldByName('uid').AsString)) + '=' +
        AnsiUpperCase(trim(FieldByName('prava').AsString)) ),
        pointer(FieldByName('id').AsInteger)
      );
      mem_usersPassword.Append;
      mem_usersPassword.FieldByName('uid').AsString:=FieldByName('uid').AsString;
      mem_usersPassword.FieldByName('sys_password').AsString:=FieldByName('sys_password').AsString;
      mem_usersPassword.Post;

      Next;
    end;
    Close;
  end;
  result := FUsersList_From_S_BRIG_NOT_NULL;
end;

function TDM_AdmClass.FillTablesList_From_S_RIGHTS():TStrings;
var _rights: string;
begin
  FTablesList_From_S_RIGHTS.Clear;
  with ibsSelectListOfTables_From_S_RIGHTS do
  begin
    Close;
    StartTransaction;
    ExecQuery;
    //
    while not (EOF) do
    begin
      _rights := '';
      {UR_READ, UR_ZAV, UR_RASK, UR_ZADV, UR_POTER, UR_NARAD, UR_DEL, UR_ADMIN}
      if (FieldByName('UR_READ').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turRead)];
      if (FieldByName('UR_ZAV').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turZav)];
      if (FieldByName('UR_RASK').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turRask)];
      if (FieldByName('UR_ZADV').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turZadv)];
      if (FieldByName('UR_POTER').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turPoter)];
      if (FieldByName('UR_NARAD').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turNarad)];
      if (FieldByName('UR_DEL').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turDel)];
      if (FieldByName('UR_ADMIN').AsInteger=1) then _rights := _rights + USER_RIGHTS_STR[integer(turAdmin)];
      //
      FTablesList_From_S_RIGHTS.Add(
        AnsiUpperCase(trim(FieldByName('name_r').AsString)) + '=' + _rights);
      Next;
    end;
    Close;
  end;
  result := FTablesList_From_S_RIGHTS;  
end;

function TDM_AdmClass.GetFUsersList_From_S_BRIG_NOT_NULL():TStrings;
begin
  result := FUsersList_From_S_BRIG_NOT_NULL;
end;

function TDM_AdmClass.GetFTablesList_From_S_RIGHTS():TStrings;
begin
  result := FTablesList_From_S_RIGHTS;
end;

function TDM_AdmClass.GetFProceduresList():TStrings;
begin
  result := FProceduresList;
end;

procedure TDM_AdmClass.StartTransaction;
begin
  if not IBDb_Adm.DefaultTransaction.InTransaction then IBDb_Adm.DefaultTransaction.StartTransaction;
end;

procedure TDM_AdmClass.Commit;
begin
  if IBDb_Adm.DefaultTransaction.InTransaction then IBDb_Adm.DefaultTransaction.Commit;
end;

procedure TDM_AdmClass.Rollback;
begin
  if IBDb_Adm.DefaultTransaction.InTransaction then IBDb_Adm.DefaultTransaction.Rollback;
end;

function TDM_AdmClass.GetFTablesList():TStrings;
begin
  result := FTablesList; 
end;

function TDM_AdmClass.FillTablesList():TStrings;
begin
  FTablesList.Clear;
  with ibsSelectListOfTables do
  begin
    Close;
    StartTransaction;
    ExecQuery;
    while not (EOF) do
    begin
      FTablesList.Add(AnsiUpperCase(trim(FieldByName('tabl_name').AsString)));
      Next;
    end;
    Close;
  end;
  result := FTablesList;
end;

function TDM_AdmClass.ScriptExec(var _sql:string):boolean;
begin
  //result := false;
  IBScript_Adm.Script.Text := _sql;
  try
    IBScript_Adm.ExecuteScript;
    if IBTr_Adm.InTransaction then IBTr_Adm.Commit;
    result := true;
  except
    on E:Exception do
    begin
      if IBTr_Adm.InTransaction then IBTr_Adm.Rollback;
      //raise exception.Create('Ошибка выполнения скрипта!'+#13+E.Message);
      result := false;
    end;
  end;
end;

constructor TDM_AdmClass.Create(AOwner:TComponent; _alias: string; _SysDbaPassword:string);
begin
  FAlias := _alias;
  FSysDbaPassword := _SysDbaPassword;
  FTablesList := TStringList.Create;
  FTablesList_From_S_RIGHTS := TStringList.Create;
  FUsersList_From_S_BRIG_NOT_NULL := TStringList.Create;
  FProceduresList := TStringList.Create;
  inherited Create(AOwner);
end;

procedure TDM_AdmClass.DataModuleDestroy(Sender: TObject);
begin
  if IBSecurityService1.Active then IBSecurityService1.Active := false;
  FTablesList.Free;
  FTablesList_From_S_RIGHTS.Free;
  FUsersList_From_S_BRIG_NOT_NULL.Free;
  FProceduresList.Free;
  //
  ibqSelect_S_BRIG.Close;
  mem_usersPassword.Close;
  //
  IBDb_Adm.Connected := false;
  IBDb_Adm.ForceClose;
  IBDb_Adm.SetHandle( nil );
end;



end.
