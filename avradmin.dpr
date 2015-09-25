library avradmin;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  MemCheck,
  Classes,
  adm,
  Windows,
  SysUtils,
  HlpUnit,
  Forms,
  IBSQLMonitor,
  BDEInfoUnit in 'BDEInfoUnit.pas';

{$R *.res}

var

  hApplication: THandle;

procedure ShowAvrAdmin(_OnEndLoad:pointer; _alias:PChar; _sysDbaPass:PChar);
var
  _frms: TFormAdm;
begin
  _frms := TFormAdm.Create( Application );
  try
    try
      _frms.Alias := string(_alias);
      _frms.SysDbaPassword := string(_sysDbaPass);
      _frms.OnEndLoadProc := _OnEndLoad;
      _frms.Init;
      //raise Exception.Create('pizdets');
       _frms.ShowModal;
    except
      on E:Exception do
      begin
        Application.ProcessMessages;
        MessageBox(0, PChar(E.Message),'avradmin.dll',MB_ICONWARNING);
      end;        
    end;
  finally
    _frms.Free;
  end;
end;

procedure ShowAvrAdmin2( _hApplication: THandle; _OnEndLoad:pointer; _alias:PChar; _sysDbaPass:PChar);
begin
  hApplication := Application.Handle;
  Application.Handle := _hApplication;
  try
    ShowAvrAdmin( _OnEndLoad, _alias, _sysDbaPass );
  finally
    Application.Handle := hApplication;
  end;
end;

  procedure MyDLLProc(Reason: Integer);
  begin
    case Reason of
      DLL_PROCESS_DETACH:
        begin
          { DLL выгружаетс€ из пам€ти }
        end;
      DLL_THREAD_ATTACH:
        begin
          { в оперативную пам€ть загружаетс€ новый процесс, использующий ресурсы и/или код из данной библиотеки; }
        end;
      DLL_THREAD_DETACH:
        begin
          { один из процессов, использующих библиотеку, "выгружаетс€" из пам€ти. }
        end;
    end;
  end;
  
exports

  ShowAvrAdmin,
  ShowAvrAdmin2;

begin

  // MemChk;

  IBSQLMonitor.DisableMonitoring;
  HELP_FILE_NAME := ExtractFilePath( HELP_FILE_NAME ) + 'AvrAdmin.hlp';
  DLLProc := @MyDLLProc;
    
end.
