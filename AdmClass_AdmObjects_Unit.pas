unit AdmClass_AdmObjects_Unit;

{ объекты администрирования и всё что с ними связано }

interface

uses SysUtils;

const

  { имя таблицы, где хранятся права на все таблицы, кроме справочников }
  RIGHTS_TABL_NAME = 'S_RIGHTS';

type

  TUserRightsEnum =
    (
      turRead, turZav, turRask,
      turZadv, turPoter, turNarad,
      turSPRAV, turDel, turAdmin
    );

  TSetUserRights = set of TUserRightsEnum;

const

  {все таблицы справочников должны начинаться с такого префикса}
  DICT_PREFIX = 'S_';

  USER_RIGHTS_STR_COUNT = 9;
  USER_RIGHTS_STR : array [0..USER_RIGHTS_STR_COUNT-1] of string =
    (
      'READ;' {просмотр}, 'ZAV;' {редактирование заявки}, 'RASK;' {редактирование раскопок},
      'ZADV;'{редактирование задвижек}, 'POTER;' {редактирование потерь}, 'NARAD;' {редактирование выездов},
      'SPRAV;'{редактирование спраовчников}, 'DEL;' {разрешение ставить заявки на удаление}, 'ADMIN;' {права админа}
    );
    
type
  { объект администрирования (таблица либо процедура) }
  TAdmObj = class
  private
    function GetFUserRights():TSetUserRights;
    procedure SetFUserRights(value:TSetUserRights);
  protected
    FUser: string;
    FName, FSQL: string;
    FSetOfUserRights: TSetUserRights;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function FormatSQL():string; virtual; abstract;    
    //
    class function ConvertSetOfUserRightsToStr(_SetUserRights: TSetUserRights):string;
    class function ConvertStrUserRightsToSetOf(_UserRights: string):TSetUserRights;
    //
    property UserRights:TSetUserRights read GetFUserRights write SetFUserRights;
    property Name: string read FName write FName;
    property User: string read FUser write FUser;
  end;

  { просто таблица }
  TAdmTable = class (TAdmObj)
  private
    FReadOnly, FAdmin: boolean;
  protected
  public
    constructor Create;
    function FormatSQL():string; override;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    property Admin: boolean read FAdmin write FAdmin;
  end;

  { справочник }
  TAdmSprav = class (TAdmTable)
  private
  protected
  public
    constructor Create;
    function FormatSQL():string; override;    
  end;

  { хранимая процедура }
  TAdmProc = class (TAdmObj)
  private
  protected
  public
    constructor Create;
    function FormatSQL():string; override;    
  end;


implementation

{TAdmTable}

function TAdmTable.FormatSQL():string;
var _s: string;
begin
  _s := '';
  if FAdmin then _s := ' WITH GRANT OPTION';
  if FReadOnly
  then result := Format(FSQL,['select', FName, FUser])
  else result := Format(FSQL,['select,insert,update,delete,REFERENCES', FName, FUser + _s]);
end;

constructor TAdmTable.Create;
begin
  inherited;
  FReadOnly := false;
  FSQL := 'GRANT %s ON  %s TO %s';
end;

{TAdmSprav}

function TAdmSprav.FormatSQL():string;
begin
  result := inherited FormatSQL();
end;

constructor TAdmSprav.Create;
begin
  inherited;
  FSetOfUserRights := FSetOfUserRights + [turAdmin];  
end;

{TAdmProc}

function TAdmProc.FormatSQL():string;
begin
  result := Format(FSQL,[FName, FUser]);
end;

constructor TAdmProc.Create;
begin
  inherited;
  FSQL := 'GRANT EXECUTE ON PROCEDURE %s TO %s';
end;

{TAdmObj}

class function TAdmObj.ConvertSetOfUserRightsToStr(_SetUserRights: TSetUserRights):string;
var _i: TUserRightsEnum;
begin
  result := '';
  for _i := turRead to turAdmin do
    if (_i in _SetUserRights) then result := result + USER_RIGHTS_STR[integer(_i)];
end;

class function TAdmObj.ConvertStrUserRightsToSetOf(_UserRights: string):TSetUserRights;
var
  //_s: string;
  _i:integer;
begin
  result := [];
  for _i := 0 to USER_RIGHTS_STR_COUNT-1 do
  begin
    if POS(USER_RIGHTS_STR[_i],_UserRights)>0 then
      result := result + [TUserRightsEnum(_i)];
  end;
  //
  {
  для совместимости с строкой со старым типом права, т.е. там где просто
  были права на изменения WRITE; бы заколбасим, как права на ZAV;RASK;ZADV;POTER;NARAD;
  }
  if POS('WRITE;',_UserRights)>0 then
  begin
    result := result + [turZav, turRask, turZadv, turPoter, turNarad];
  end;
end;

function TAdmObj.GetFUserRights():TSetUserRights;
begin
  result := FSetOfUserRights;
end;

procedure TAdmObj.SetFUserRights(value:TSetUserRights);
begin
  FSetOfUserRights := value;
end;

constructor TAdmObj.Create;
begin
  FName := '';
  FUser := '';
  FSetOfUserRights := [turRead];
end;

destructor TAdmObj.Destroy;
begin
  inherited;
end;


end.
