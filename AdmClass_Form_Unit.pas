unit AdmClass_Form_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, DBGrids, RXDBCtrl,
  DBGridEh, AdmClass_DM_Unit, IBCustomDataSet, IBUpdateSQL, DB, IBQuery,
  HlpUnit;

type
  TfrmAdmTableRights = class(TForm)
    Panel1: TPanel;
    bbSave: TBitBtn;
    bbExit: TBitBtn;
    DBGridEh1: TDBGridEh;
    s_rights_q: TIBQuery;
    s_rights_qID: TIntegerField;
    s_rights_qNAME_R: TIBStringField;
    s_rights_qUR_READ: TIntegerField;
    s_rights_qUR_ZAV: TIntegerField;
    s_rights_qUR_RASK: TIntegerField;
    s_rights_qUR_ZADV: TIntegerField;
    s_rights_qUR_POTER: TIntegerField;
    s_rights_qUR_NARAD: TIntegerField;
    s_rights_qUR_DEL: TIntegerField;
    s_rights_qUR_ADMIN: TIntegerField;
    s_rights_qlist_READ: TStringField;
    s_rights_qlist_ZAV: TStringField;
    s_rights_qlist_RASK: TStringField;
    s_rights_qlist_ZADV: TStringField;
    s_rights_qlist_POTER: TStringField;
    s_rights_qlist_NARAD: TStringField;
    s_rights_qlist_DEL: TStringField;
    s_rights_qlist_ADMIN: TStringField;
    s_rights_sur: TDataSource;
    s_rights_upd: TIBUpdateSQL;
    bbFillRights: TBitBtn;
    opdFromScript: TOpenDialog;
    bbHelp: TBitBtn;
    procedure bbExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure s_rights_qBeforeInsert(DataSet: TDataSet);
    procedure s_rights_qAfterEdit(DataSet: TDataSet);
    procedure bbSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure s_rights_qAfterPost(DataSet: TDataSet);
    procedure DBGridEh1ColEnter(Sender: TObject);
    procedure DBGridEh1ColExit(Sender: TObject);
    procedure bbFillRightsClick(Sender: TObject);
    procedure bbHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmAdmTableRights.bbExitClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmAdmTableRights.FormCreate(Sender: TObject);
begin
  inherited;
  DM_AdmClass.ibqYesNo_READ.Open;
  DM_AdmClass.ibqYesNo_ZAV.Open;
  DM_AdmClass.ibqYesNo_RASK.Open;
  DM_AdmClass.ibqYesNo_ZADV.Open;  
  DM_AdmClass.ibqYesNo_POTER.Open;
  DM_AdmClass.ibqYesNo_NARAD.Open;
  DM_AdmClass.ibqYesNo_DEL.Open;
  DM_AdmClass.ibqYesNo_ADMIN.Open;
end;

procedure TfrmAdmTableRights.FormDestroy(Sender: TObject);
begin
  inherited;
  DM_AdmClass.ibqYesNo_READ.Close;
  DM_AdmClass.ibqYesNo_ZAV.Close;
  DM_AdmClass.ibqYesNo_RASK.Close;
  DM_AdmClass.ibqYesNo_ZADV.Close;
  DM_AdmClass.ibqYesNo_POTER.Close;
  DM_AdmClass.ibqYesNo_NARAD.Close;
  DM_AdmClass.ibqYesNo_DEL.Close;
  DM_AdmClass.ibqYesNo_ADMIN.Close;
end;

procedure TfrmAdmTableRights.s_rights_qBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TfrmAdmTableRights.s_rights_qAfterEdit(DataSet: TDataSet);
begin
  inherited;
  bbSave.Enabled := true; 
end;

procedure TfrmAdmTableRights.bbSaveClick(Sender: TObject);
begin
  inherited;
  bbSave.Enabled := false;
  s_rights_q.Post;
end;

procedure TfrmAdmTableRights.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if bbSave.Enabled then
  begin
    if MessageBox(0, 'Сохранить изменения?','Справочник прав таблиц',
      MB_ICONQUESTION or MB_YESNO)=ID_YES
    then s_rights_q.Post
    else s_rights_q.Cancel;
  end;
  DM_AdmClass.Commit;
end;

procedure TfrmAdmTableRights.s_rights_qAfterPost(DataSet: TDataSet);
begin
  inherited;
  bbSave.Enabled := false;
end;

procedure TfrmAdmTableRights.DBGridEh1ColEnter(Sender: TObject);
begin
  inherited;
  if DBGridEh1.SelectedIndex>0 then
    DBGridEh1.Columns[DBGridEh1.SelectedIndex].Color := clMoneyGreen;
end;

procedure TfrmAdmTableRights.DBGridEh1ColExit(Sender: TObject);
begin
  inherited;
  if DBGridEh1.SelectedIndex>0 then
    DBGridEh1.Columns[DBGridEh1.SelectedIndex].Color := clWindow;
end;

procedure TfrmAdmTableRights.bbFillRightsClick(Sender: TObject);
var _strl: TStringList;
  _s: string;
begin
  inherited;
  if opdFromScript.Execute then
  begin
    _strl := TStringList.Create;
    try
      _strl.LoadFromFile(opdFromScript.FileName);
      _s := _strl.Text;
      if DM_AdmClass.ScriptExec(_s)
      then MessageBox(handle,'Скрипт выполнен успешно','АРМ Диспетчера АВР', MB_OK or MB_ICONINFORMATION)
      else MessageBox(handle,'Во время выполнения скрипта произошли ошибки','АРМ Диспетчера АВР', MB_OK or MB_ICONHAND);
    finally
      DM_AdmClass.StartTransaction;
      s_rights_q.Open;
      _strl.Free;
    end;
  end;
end;

procedure TfrmAdmTableRights.bbHelpClick(Sender: TObject);
begin
  ShowHelpByContextID( 2 );
end;

end.
