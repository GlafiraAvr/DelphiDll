unit adm;

interface

uses
  Windows, Controls, Forms,
  StdCtrls, RXLookup, Db, Buttons,
  AdmClassUnit, AdmClass_DM_Unit, Classes, ComCtrls, ExtCtrls,
  HlpUnit;

type

  TProc = procedure;

  TFormAdm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Lb_us: TLabel;
    DBL_brig: TRxDBLookupCombo;
    GrB_prava: TGroupBox;
    ChB_read: TCheckBox;
    ChB_Sprav: TCheckBox;
    GrB_Pass: TGroupBox;
    Ed_pas1: TEdit;
    Ed_pas2: TEdit;
    BB_Close: TBitBtn;
    BB_Save: TBitBtn;
    Bevel1: TBevel;
    Pn_stat: TPanel;
    Lb_izm: TLabel;
    Admin_chb: TCheckBox;
    ChB_WriteZav: TCheckBox;
    ChB_WriteRask: TCheckBox;
    ChB_WriteZadv: TCheckBox;
    ChB_WriteNarad: TCheckBox;
    ChB_WritePoter: TCheckBox;
    ChB_DelZav: TCheckBox;
    bbTableRights: TBitBtn;
    pProcess: TPanel;
    lProcess: TLabel;
    pbProcess: TProgressBar;
    bbRebuildRights: TBitBtn;
    pProgress: TPanel;
    lProgress: TLabel;
    pbProgress: TProgressBar;
    lInfo: TLabel;
    bbHelp: TBitBtn;
    procedure DBL_brigChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Ed_uidChange(Sender: TObject);
    procedure BB_SaveClick(Sender: TObject);
    procedure Ed_admEnter(Sender: TObject);
    procedure ChB_readClick(Sender: TObject);
    procedure DBL_brigEnter(Sender: TObject);
    procedure Admin_chbClick(Sender: TObject);
    procedure BB_CloseClick(Sender: TObject);
    procedure bbTableRightsClick(Sender: TObject);
    procedure bbRebuildRightsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbHelpClick(Sender: TObject);
  private
    FOnEndLoadProc: TProc;
    FSysDbaPassword, FAlias: string;
    FAdmClass: TAdmClass;
    isChange:boolean;
    procedure CtrlState;
    procedure OnProcessedAdm(Sender: TObject);
    procedure Up_Rec;
    procedure ElemChange(isCh:boolean);
    procedure RebuildRights;
  public
    procedure Init;
    //
    property SysDbaPassword:string read FSysDbaPassword write FSysDbaPassword;
    property Alias:string read FAlias write FAlias;
    property OnEndLoadProc: TProc read FOnEndLoadProc write FOnEndLoadProc;
  end;

const
  CyrLayout = $4190419;
  LatLayout = $4090409;
  
implementation

{$R *.DFM}

procedure TFormAdm.RebuildRights;
var _i{, _id}: integer;
  _strl: TStrings;
  {_uid,} _rights: string;
begin
  Enabled := false;
  pProgress.Show;
  pProcess.Show;
  try
    _strl := DM_AdmClass.UsersList_From_S_BRIG_NOT_NULL;
    pbProgress.Min := 0;
    pbProgress.Max := _strl.Count;
    pbProgress.Position := 0;
    for _i := 0 to _strl.Count-1 do
    begin
      lProgress.Caption := 'Перестройка прав пользователя ' + _strl.Names[_i];
      _rights := _strl.Values[_strl.Names[_i]];
      if not FAdmClass.SetRightsToAdmObjectsForUser(integer(_strl.Objects[_i]),
      '1'
       {
        пароль '1' - так как не не понадобится - пользователи уже есть. А если вдруг это был
        старорежимынй пользователь, который именовался, не по правилам алиас_айди,
        то этот пароль (1) и будет его первоначальным паролем.
       }, _rights, false) then
        MessageBox(handle,'Ошибка при задании прав пользователю','АРМ Диспетчера АВР', MB_OK or MB_ICONHAND);
      pbProgress.Position := pbProgress.Position + 1;        
    end;        
  finally
    FAdmClass.RefreshUserList;
    //
    DM_AdmClass.StartTransaction;
    DM_AdmClass.ibqSelect_S_BRIG.Open;
    //
    pProcess.Hide;
    pProgress.Hide;
    Enabled := true;
  end;
end;

procedure TFormAdm.Init;
begin
 FAdmClass := TAdmClass.Create;
 FAdmClass.OnProcess := OnProcessedAdm;
 FAdmClass.Alias := FAlias;
 FAdmClass.SysDbaPassword := FSysDbaPassword;
 FAdmClass.Init;
 //
 isChange:=false;
 Up_Rec;
 ElemChange(false);
 CtrlState;
end;

procedure TFormAdm.OnProcessedAdm(Sender: TObject);
var _pra: TProcessAdm;
begin
  _pra := (Sender as TProcessAdm);
  if _pra.Current=1 then
  begin
    pbProcess.Min := 1;
    pbProcess.Max := _pra.Count;
  end;
  lProcess.Caption := _pra.Text;
  pbProcess.Position := _pra.Current;
  Application.ProcessMessages;
end;

procedure TFormAdm.DBL_brigChange(Sender: TObject);
begin
  with DM_AdmClass.ibqSelect_S_BRIG do
  begin
    Ed_pas1.Text:='';
    Ed_pas2.Text:='';
    ChB_Read.Checked:=(pos('READ;', FieldByName('PRAVA').asString)>0);
    ChB_Sprav.Checked:=(pos('SPRAV;', FieldByName('PRAVA').asString)>0);
    ChB_WriteZav.Checked:=(pos('ZAV;',  FieldByName('PRAVA').asString)>0);
    ChB_WriteRask.Checked:=(pos('RASK;', FieldByName('PRAVA').asString)>0);
    ChB_WriteZadv.Checked:=(pos('ZADV;', FieldByName('PRAVA').asString)>0);
    ChB_WritePoter.Checked:=(pos('POTER;', FieldByName('PRAVA').asString)>0);
    ChB_WriteNarad.Checked:=(pos('NARAD;', FieldByName('PRAVA').asString)>0);
    ChB_DelZav.Checked:=(pos('DEL;', FieldByName('PRAVA').asString)>0);
    //
    { для совместимости со старым вариантом прав }
    if ( POS( 'WRITE;', FieldByName('PRAVA').asString ) > 0 ) then
    begin
      ChB_WriteZav.Checked := TRUE;
      ChB_WriteRask.Checked := TRUE;
      ChB_WriteZadv.Checked := TRUE;
      ChB_WritePoter.Checked := TRUE;
      ChB_WriteNarad.Checked := TRUE;
    end;
    //
    Admin_chb.Checked:=(pos('ADMIN;', FieldByName('PRAVA').asString) > 0);    
    ElemChange(false);
  end;   
end;

procedure TFormAdm.FormCreate(Sender: TObject);
begin
  FOnEndLoadProc := nil;
  FSysDbaPassword := 'masterkey';
  FAlias := 'AVARLUG_TEPLO';
  //
  pProcess.Left := 36;
  pProcess.Top := 122;
  pProgress.Left := 36;
  pProgress.Top := 73;
end;

procedure TFormAdm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    ActivateKeyboardLayout(CyrLayout,0);
  except
  end;
end;

procedure TFormAdm.Ed_uidChange(Sender: TObject);
begin
  ElemChange(true);
end;

procedure TFormAdm.ElemChange(isCh:boolean);
begin
 if isCh then
  begin
   Lb_izm.Caption:='Изменения не сохранены';
   isChange:=true;
  end
 else
  begin
   Lb_izm.Caption:='';
   isChange:=false;
  end;
 CtrlState;
end;


procedure TFormAdm.BB_SaveClick(Sender: TObject);
var _passw :string;
    _rights: string;
    _id : integer;
begin
  _id := DM_AdmClass.ibqSelect_S_BRIG.FieldByName('ID').asInteger;
  { сформируем строку с правами }  
  _rights := '';
  if ChB_Read.Checked then _rights := 'READ;';
  if ChB_WriteZav.Checked then _rights := _rights + 'ZAV;';
  if ChB_WriteRask.Checked then _rights := _rights + 'RASK;';
  if ChB_WriteZadv.Checked then _rights := _rights + 'ZADV;';
  if ChB_writePoter.Checked then _rights := _rights + 'POTER;';
  if ChB_WriteNarad.Checked then _rights := _rights + 'NARAD;';
  if ChB_Sprav.Checked then _rights := _rights + 'SPRAV;';
  if ChB_DelZav.Checked then _rights := _rights + 'DEL;';
  if Admin_chb.Checked then _rights := _rights + 'ADMIN;';
  //
  if (Ed_pas1.Text<>Ed_pas2.Text) or (Ed_pas1.Text='') then
  begin
    MessageBox(handle,'Пароли не совпадают. Либо пусты.', 'АРМ Диспетчера АВР', MB_OK or MB_ICONHAND);
    exit;
  end;
  //
  _passw := Ed_pas1.Text;
  pProcess.Show;
  try
    if not FAdmClass.SetRightsToAdmObjectsForUser(_id, _passw, _rights, true) then
      MessageBox(handle,'Ошибка при задании прав. Попробуйте еще.','АРМ Диспетчера АВР', MB_OK or MB_ICONHAND);
  finally
    pProcess.Hide;
  end;
  //
  FAdmClass.RefreshUserList;
  self.BringToFront;
  if DM_AdmClass.UsersList_From_S_BRIG_NOT_NULL.IndexOfName(FAdmClass.CreateUIDByID(_id))>-1
  then MessageBox(handle,'Пользоватеть получил доступ к базе!','АРМ Диспетчера АВР', MB_OK or MB_ICONINFORMATION)
  else MessageBox(handle,'Пользоватеть не получил доступ к базе! Попробуйте еще.','АРМ Диспетчера АВР', MB_OK or MB_ICONHAND);
  //
  Up_rec;
end;

procedure TFormAdm.Up_Rec;
var _tmp_id:integer;
begin
  DM_AdmClass.StartTransaction;
  with DM_AdmClass.ibqSelect_S_BRIG do
  begin
    _tmp_id := FieldByName('ID').asInteger;
    Close;
    Open;
    Locate('ID',_tmp_id,[]);
  end;
  DBL_brigChange(Self);
end;

procedure TFormAdm.Ed_admEnter(Sender: TObject);
begin
  ActivateKeyboardLayout(LatLayout,0);             
end;

procedure TFormAdm.ChB_readClick(Sender: TObject);
begin
  ChB_Sprav.Enabled:=ChB_Read.Checked;
  Admin_chb.Enabled:=ChB_Read.Checked;
  ChB_WriteZav.Enabled:=ChB_Read.Checked;
  ChB_WriteRask.Enabled:=ChB_Read.Checked;
  ChB_WriteZadv.Enabled:=ChB_Read.Checked;
  ChB_WriteNarad.Enabled:=ChB_Read.Checked;
  ChB_WritePoter.Enabled:=ChB_Read.Checked;
  ChB_DelZav.Enabled:=ChB_Read.Checked;
  if not ChB_Read.Checked then
    begin
      ChB_Sprav.Checked:=false;
      Admin_chb.Checked:=false;
      ChB_WriteZav.Checked:=false;
      ChB_WriteRask.Checked:=false;
      ChB_WriteZadv.Checked:=false;
      ChB_WriteNarad.Checked:=false;
      ChB_WritePoter.Checked:=false;
      ChB_DelZav.Enabled:=false;
    end;
  CtrlState;
end;

procedure TFormAdm.DBL_brigEnter(Sender: TObject);
begin
  ActivateKeyboardLayout(CyrLayout,0);
end;

//*******************************************************************
procedure TFormAdm.CtrlState;
begin
 BB_Save.Enabled:=(ChB_read.Checked)and(DBL_brig.Text <> '');
end;

//*******************************************************************
procedure TFormAdm.Admin_chbClick(Sender: TObject);
begin
 if Admin_chb.Checked then
   begin
     ChB_read.Checked:=true;
     ChB_Sprav.Checked:=true;
     ChB_WriteZav.Checked:=true;
     ChB_WriteRask.Checked:=true;
     ChB_WriteZadv.Checked:=true;
     ChB_WritePoter.Checked:=true;
     ChB_WriteNarad.Checked:=true;
     ChB_DelZav.Checked:=true;
     //
     ChB_read.Enabled:=false;
     ChB_Sprav.Enabled:=false;
     ChB_WriteZav.Enabled:=false;
     ChB_WriteRask.Enabled:=false;
     ChB_WriteZadv.Enabled:=false;
     ChB_WritePoter.Enabled:=false;
     ChB_WriteNarad.Enabled:=false;
     ChB_DelZav.Enabled:=false;
   end
    else
   begin
     ChB_read.Enabled:=true;
     ChB_Sprav.Enabled:=true;
     ChB_WriteZav.Enabled:=true;
     ChB_WriteRask.Enabled:=true;
     ChB_WriteZadv.Enabled:=true;
     ChB_WritePoter.Enabled:=true;
     ChB_WriteNarad.Enabled:=true;
     ChB_DelZav.Enabled:=true;
   end;
 CtrlState;
end;


procedure TFormAdm.BB_CloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFormAdm.bbTableRightsClick(Sender: TObject);
begin
  inherited;
  FAdmClass.ShowTableRightsForm(self);
end;

procedure TFormAdm.bbRebuildRightsClick(Sender: TObject);
begin
  inherited;
  RebuildRights;
end;

procedure TFormAdm.FormShow(Sender: TObject);
begin
  inherited;
  lInfo.Caption := FAdmClass.GetServerInfoInText(); 
  if Assigned(FOnEndLoadProc) then FOnEndLoadProc; 
end;

procedure TFormAdm.FormDestroy(Sender: TObject);
begin
  FAdmClass.Free;
end;

procedure TFormAdm.bbHelpClick(Sender: TObject);
begin
  ShowHelpByContextID( 1 );
end;

end.
