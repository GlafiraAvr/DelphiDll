unit BDEInfoUnit;

interface
uses DBTables,Classes, SysUtils;

type
  TBDEInfo=class
  private
    FDataBases:TStringList;
    function GetFDataBases:TStrings;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    //
    function IBGetPathOfAlias(_alias:string):string;
    function IBAddAlias(_alias,_path:string):boolean;
    procedure IBDeleteAlias(_alias:string);
    function IsAlias(value:string):boolean;
    //
    property DataBases:TStrings read GetFDataBases;
  end;

implementation

function TBDEInfo.IsAlias(value:string):boolean;
var _list:TStringList;
begin
  _list:=TStringList.Create;
  try
    Session.GetAliasNames(_list);
    result:=_list.IndexOf(value)>-1;
    //result:=Session.GetFindDatabase(value)<>nil;
  finally
    _list.Free;
  end;    
end;

procedure TBDEInfo.IBDeleteAlias(_alias:string);
begin
  if Session.IsAlias(_alias) then
    begin
      Session.DeleteAlias(_alias);
      Session.SaveConfigFile;
    end;
end;

function TBDEInfo.IBAddAlias(_alias,_path:string):boolean;
var
  MyList: TStringList;
begin
  result:=true;
  IBDeleteAlias(_alias);
  MyList:=TStringList.Create;
  try
    with MyList do
    begin
      Add('ENABLE SCHEMA CACHE=FALSE');
      //MyList.Add('LANGDRIVER=Pdox ANSI Cyrillic');
      Add('SERVER NAME='+_path);
      Add('USER NAME=MYNAME');
    end;
    try
      Session.AddAlias(_alias, 'INTRBASE', MyList);
      //
      {MyList.Clear;
      MyList.Add('LANGDRIVER=Pdox ANSI Cyrillic');
      Session.ModifyDriver('INTRBASE', MyList);}
      //
      Session.SaveConfigFile;
    except
      result:=FALSE;
    end;
  finally
    MyList.Free;
  end;
end;

function TBDEInfo.GetFDataBases:TStrings;
begin
  Result:=FDataBases;
end;

function TBDEInfo.IBGetPathOfAlias(_alias:string):string;
var
  theStrList:TStringList;
  //GPath:String;
begin
  theStrList:=TStringList.Create;
  try
    try
      Session.GetAliasParams(_alias,theStrList);
      result:=copy(theStrList[0],13,length(theStrList[0]));
    except
      on E:Exception do
      raise Exception.Create('Алиас ' + _alias + ' не зарегистрирован на копмьютере:'#13+
        E.Message);
    end;      
  finally
    theStrList.Free;
  end;
end;

constructor TBDEInfo.Create;
begin
  FDataBases:=TStringList.Create;
  Session.ConfigMode:=cmAll;
  Session.GetDatabaseNames(FDataBases);
end;

destructor TBDEInfo.Destroy;
begin
  FDataBases.Free;
  inherited Destroy;
end;

end.
