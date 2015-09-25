unit AdmClassUnit;

{
  ������ � �������, ������� ��������� �������� ����� �������������.
  ��������:
  1) ��� ����� ������������ ������ ���������� � �������� ('S_');
  2) ����� �� �������� ��������� ������ ���� ���������
  3) ��� ������ �� ������������ � �� ��������, ������ ��������� ������� (S_RIGHTS) � �������,
  � ������� 10 �������: ID, NAME_R, UR_READ, UR_ZAV, UR_RASK, UR_ZADV, UR_POTER, 
  UR_NARAD, /*, SPRAV - �� ����*/, UR_DEL, UR_ADMIN;
  ������ � ��� - ����� ������ � �����.
}

interface

uses Classes, AdmClass_InitScripts_Unit, AdmClass_DM_Unit, AdmClass_AdmObjects_Unit,
  SysUtils, Controls, AdmClass_Form_Unit, Windows, Forms;

type

  TProcessAdm = class
  public
    { ����� ��������� � �������� }
    Count: integer;
    { ������� ��������� }
    Current: integer;
    { �������� ��������� }
    Text: string;
  end;

  TAdmClass = class
  private
    FAlias: string;
    FUserName: string;
    FSysDbaPassword: string;
    { ����������� }
    FDictTables:TList;
    { �������� ��������� }
    FProcedures:TList;
    { ��������� ������� }
    FTables:TList;
    FProcessAdm: TProcessAdm;
    FOnProcess: TNotifyEvent;
  protected
    procedure CreateInitTables;  
    function Connect():boolean;
    function DisConnect():boolean;
    //
    function IsDictTable(_tabl_name: string):boolean;
    function IsDictTableReallyIsTmpOrIBETable(_tabl_name: string): boolean;
    //
    procedure CreateTablObjects;
    procedure CreateProcsObjects;
    procedure CreateDictObjects;    
    //
    procedure Processed(_all_itteration: integer; var _current_itteration:integer; _text:string);
  public
    constructor Create;
    destructor Destroy; override;
    //
    function ExecScript(_script: string):boolean;
    procedure Init;
    function IsTablPresent(_tabl_name: string): boolean;
    {������� ��������� ������������ �� ��� ���� � ������ ����}
    function CreateUIDByID(_id: integer):string;
    //
    procedure RefreshTablesList;
    procedure RefreshUserList;
    function SetRightsToAdmObjectsForUser(_id: integer; _password, _prava {����� ����� ����� � �������}: string; _update_password_if_user_exists: boolean): boolean;
    //
    function GetServerInfoInText():string;
    //
    procedure ShowTableRightsForm(_parent: TWinControl);
    //
    property Alias: string read FAlias write FAlias;
    property UserName: string read FUserName write FUserName;
    property SysDbaPassword: string read FSysDbaPassword write FSysDbaPassword;
    property OnProcess: TNotifyEvent read FOnProcess write FOnProcess;
  end;

implementation

{TAdmClass}

function TAdmClass.GetServerInfoInText():string;
var _serv: string;
begin
  if DM_AdmClass.FirebirdServer.Local
  then _serv := '���������'
  else _serv := DM_AdmClass.FirebirdServer.ServerName;
  result := '�����: %s;  ������: %s';
  result := Format('�����: %s; ������: %s',[Alias, _serv]);
end;

function TAdmClass.CreateUIDByID(_id: integer):string;
var _id_str: string;
begin
  if (_id<0) then _id_str := '_ERR_' + IntToStr(abs(_id)) 
  else _id_str := IntToStr(_id);
  result := FAlias + '_' + _id_str;
end;

procedure TAdmClass.Processed(_all_itteration: integer; var _current_itteration:integer; _text:string);
begin
  inc(_current_itteration);
  FProcessAdm.Count := _all_itteration;
  FProcessAdm.Current := _current_itteration;
  FProcessAdm.Text := _text;
  if Assigned(FOnProcess) then FOnProcess(FProcessAdm); 
end;

procedure TAdmClass.ShowTableRightsForm(_parent: TWinControl);
var _frmAdmTableRights: TfrmAdmTableRights;
begin
  _frmAdmTableRights := TfrmAdmTableRights.Create(nil);
  try
    _frmAdmTableRights.Parent := nil; //_parent;
    _frmAdmTableRights.DBGridEh1.Columns[0].PickList :=
    DM_AdmClass.TablesList_From_S_RIGHTS;
    DM_AdmClass.StartTransaction;
    _frmAdmTableRights.s_rights_q.Open;
    _frmAdmTableRights.ShowModal;
    RefreshTablesList;
    DM_AdmClass.StartTransaction;
    DM_AdmClass.ibqSelect_S_BRIG.Open;
  finally
    _frmAdmTableRights.Free;
  end;
end;

procedure TAdmClass.RefreshUserList;
begin
  DM_AdmClass.FillUsersList_From_S_BRIG_NOT_NULL;
end;

procedure TAdmClass.RefreshTablesList;
begin
  DM_AdmClass.FillTablesList_From_S_RIGHTS;
  CreateTablObjects;
end;

function TAdmClass.SetRightsToAdmObjectsForUser(_id: integer; _password, _prava: string; _update_password_if_user_exists: boolean ):boolean;
  procedure _ExecSQL(_sql: string);
  begin
    DM_AdmClass.ibsTemp.Close;
    DM_AdmClass.StartTransaction;
    DM_AdmClass.ibsTemp.SQL.Text := _sql;
    try
      DM_AdmClass.ibsTemp.ExecQuery;
    except
      DM_AdmClass.Commit;
      //DM_AdmClass.Rollback;
      DM_AdmClass.StartTransaction;
    end;
  end;
  procedure RevokeAll(_obj, _uid: string);
  begin
    _ExecSQL(Format('revoke all on %s from %s', [_obj, _uid]));
  end;
var _setOfRights: TSetUserRights;
  _mulSets: TSetUserRights;
  _i: integer;
  _sql: string;
  _all_iterations, _curr_itteration: integer;
  _text: string;
  _uid: string;
begin
  result := false;
  //
  _uid := CreateUIDByID(_id);
  //
  _curr_itteration := 0;
  _all_iterations := FTables.Count + FDictTables.Count + FProcedures.Count + 3;
  //
  Processed( _all_iterations, _curr_itteration, '�������� ������������ ' + _uid + '...');
  if DM_AdmClass.AddUserToDataBase(_uid, _password, _update_password_if_user_exists) then
  begin
    { ���� ������ ������� ������������ �� �������, �� ���� ��� � ���� }
    Processed( _all_iterations, _curr_itteration, '�������� �����...');
    _ExecSQL( Format('update s_brig set uid="%s", prava="%s",sys_password="%s" where id=%s',[_uid, _prava, _password, IntToStr(_id)]));
    result := true;
    //
    if result then
    begin
      DM_AdmClass.StartTransaction;
      _text := '%s ��� ' + _uid;
      try
        _setOfRights := TAdmObj.ConvertStrUserRightsToSetOf(_prava);
        { ��� ������ �������� ����� �� ������� }
        for _i := 0 to FTables.Count-1 do
        begin
          TAdmTable(FTables[_i]).User := _uid;
          _mulSets := (TAdmTable(FTables[_i])).UserRights * _setOfRights;
          TAdmTable(FTables[_i]).ReadOnly := not ((_mulSets<>[]) and (_mulSets<>[turRead]));
          TAdmTable(FTables[_i]).Admin := (turAdmin in _mulSets); 
          _sql := (TAdmTable(FTables[_i])).FormatSQL;
          //
          Processed( _all_iterations, _curr_itteration, Format(_text,[TAdmTable(FTables[_i]).Name]) );          
          RevokeAll(TAdmTable(FTables[_i]).Name, _uid);
          _ExecSQL(_sql);
        end;
        //
        { ��������� �� ������������ }
        { ������� ����� �� ������������� ������������ }
        for _i := 0 to FDictTables.Count-1 do
        begin
          (TAdmSprav(FDictTables[_i])).ReadOnly := not (turSPRAV in _setOfRights);
          TAdmSprav(FDictTables[_i]).User := _uid;
          { ���� ���������� ��� �� ����� ���� �� ����������, � ��������� �������,
          ��� ������� IBE$... ��� ������� S_ORG :), �� ����� ��� ����� }
          if (IsDictTableReallyIsTmpOrIBETable(TAdmSprav(FDictTables[_i]).Name))
          then
            begin
              (TAdmSprav(FDictTables[_i])).ReadOnly := FALSE;
              TAdmSprav(FDictTables[_i]).Admin := TRUE;
            end
          else TAdmSprav(FDictTables[_i]).Admin := (turAdmin in _setOfRights);
          _sql := (TAdmSprav(FDictTables[_i])).FormatSQL;
          //
          Processed( _all_iterations, _curr_itteration, Format(_text,[TAdmSprav(FDictTables[_i]).Name]) );          
          RevokeAll(TAdmSprav(FDictTables[_i]).Name, _uid);
          _ExecSQL(_sql);
        end;
        //
        {������� ����� �� ���������� ��������}
        for _i := 0 to FProcedures.Count-1 do
        begin
          TAdmProc(FProcedures[_i]).User := _uid;
          _sql := (TAdmProc(FProcedures[_i])).FormatSQL;
          //
          Processed( _all_iterations, _curr_itteration, Format(_text,[TAdmProc(FProcedures[_i]).Name]) );          
          RevokeAll(TAdmProc(FProcedures[_i]).Name, _uid);
          _ExecSQL(_sql);
        end;
        Processed( _all_iterations, _curr_itteration, '������������� ����������...');
        DM_AdmClass.Commit;  
      except
        DM_AdmClass.Rollback;
      end;      
    end;
  end;    
end;

function TAdmClass.IsDictTableReallyIsTmpOrIBETable(_tabl_name: string): boolean;
begin
  _tabl_name := AnsiUpperCase(_tabl_name);
  result := (POS('IBE$',_tabl_name)>0) or (POS('TMP_',_tabl_name)=1)
    or (POS('S_ORG',_tabl_name)>0) or (POS('ORD_PEOPLE',_tabl_name)=1);
end;

function TAdmClass.IsDictTable(_tabl_name: string):boolean;
begin
  _tabl_name := AnsiUpperCase(_tabl_name);
  result := (_tabl_name[1] = DICT_PREFIX[1]) and (_tabl_name[2] = DICT_PREFIX[2])
    or (
      (POS('IBE$',_tabl_name)>0) or
      (POS('TMP_',_tabl_name)=1) or
      (POS('ORD_PEOPLE',_tabl_name)=1) or // ��� ����������-���� :)
      (POS('S_ORG',_tabl_name)=1) // ��� ��� ���� ����������-���� :)
    );
end;

procedure TAdmClass.CreateTablObjects;
var
  _i: integer;
  _admt: TAdmTable;
begin
  FTables.Clear;
  for _i := 0 to DM_AdmClass.TablesList_From_S_RIGHTS.Count-1 do
  begin
    _admt := TAdmTable.Create;
    _admt.Name := DM_AdmClass.TablesList_From_S_RIGHTS.Names[_i];
    _admt.UserRights := _admt.ConvertStrUserRightsToSetOf(
      DM_AdmClass.TablesList_From_S_RIGHTS.Values[DM_AdmClass.TablesList_From_S_RIGHTS.Names[_i]]);
    FTables.Add(_admt);
  end;
end;

procedure TAdmClass.CreateProcsObjects;
var
  _i: integer;
  _admp: TAdmProc;
begin
  FProcedures.Clear;
  for _i := 0 to DM_AdmClass.ProceduresList.Count-1 do
  begin
    _admp := TAdmProc.Create;
    _admp.Name := DM_AdmClass.ProceduresList[_i];
    FProcedures.Add(_admp);
  end;
end;

procedure TAdmClass.CreateDictObjects;
var
  _i: integer;
  _adms: TAdmSprav;
begin
  FDictTables.Clear;
  for _i := 0 to DM_AdmClass.TablesList.Count-1 do
  begin
    if IsDictTable(DM_AdmClass.TablesList[_i]) then
    begin
      _adms := TAdmSprav.Create;
      _adms.Name := DM_AdmClass.TablesList[_i];
      FDictTables.Add(_adms);
    end;
  end;
end;

procedure TAdmClass.Init;
var
  _i, _j: integer;
  _s: string;
  _ok: boolean;
begin
  FProcessAdm := TProcessAdm.Create;
  Connect;
  CreateInitTables;
  DM_AdmClass.Init;
  //
  { �������� ��� �� ������� ���� (�� ���������� ����������) ���� � S_RIGHTS }
  for _i := 0 to DM_AdmClass.TablesList.Count-1 do
  begin
    _s := DM_AdmClass.TablesList[_i];
    if not IsDictTable(_s) then
    begin
      _ok := false;
      for _j := 0 to DM_AdmClass.TablesList_From_S_RIGHTS.Count-1 do
      begin
        if (_s=DM_AdmClass.TablesList_From_S_RIGHTS.Names[_j]) then
        begin
          _ok := true;
          break;
        end;
      end;
      if not _ok then DM_AdmClass.AddTableTo_S_RIGHTS(_s);
    end;
  end;
  { ������ ��������� ������ ������ �� S_RIGHTS }
  DM_AdmClass.FillTablesList_From_S_RIGHTS;
  { ������ ��������� �� ���� �������� �� S_RIGHTS ����� ���� �������� }
  CreateTablObjects;
  { ������ ��������� �� ���� ���������� ����� ���� �������� }
  CreateProcsObjects;
  { ������ ��������� �� ���� ������������ ����� ���� �������� }
  CreateDictObjects;
end;

function TAdmClass.ExecScript(_script: string):boolean;
begin
  result := DM_AdmClass.ScriptExec(_script);
end;

function TAdmClass.IsTablPresent(_tabl_name: string): boolean;
begin
  result := DM_AdmClass.TablesList.IndexOf(_tabl_name)>-1;
end;

procedure TAdmClass.CreateInitTables;
var _ok: boolean;
begin
  _ok := true;
  if not IsTablPresent('S_RIGHTS') then _ok := ExecScript(SCRIPT_S_RIGHTS_CREATE);
  if not IsTablPresent('S_YESNO') and _ok then _ok := ExecScript(SCRIPT_S_YESNO_CREATE);
  if not _ok then raise Exception.Create('������ �������� ������ S_RIGHTS � S_YESNO');
end;

function TAdmClass.Connect():boolean;
begin
  result := TRUE;
  DM_AdmClass := TDM_AdmClass.Create(Application, FAlias, FSysDbaPassword);
  DM_AdmClass.Connect;
end;

function TAdmClass.DisConnect():boolean;
begin
  result := TRUE;
  DM_AdmClass.Free;
  DM_AdmClass := nil;
end;

constructor TAdmClass.Create;
begin
  FOnProcess := nil;
  FDictTables := TList.Create;
  FProcedures := TList.Create;
  FTables := TList.Create;
  //
  FAlias := '';
  FSysDbaPassword := 'masterkey';
end;

destructor TAdmClass.Destroy;
begin
  FDictTables.Free;
  FProcedures.Free;
  FTables.Free;
  Disconnect;
  FProcessAdm.Free;
  inherited;
end;

end.
