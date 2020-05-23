unit BaseTestCase;

interface

uses
    System.SysUtils,
    TestFrameWork;

type
    TBaseTestCase = class(TTestCase)
    private
        FCurrentProcToCheck: TProc;
        procedure RunCurrentProcToCheck;
    public
        procedure CheckException(AMethod: TProc; AExceptionClass: TClass; AMsg :string); overload;
        procedure CheckNoException(AMethod: TProc; AMsg :string);
    end;


implementation

procedure TBaseTestCase.CheckException(AMethod: TProc; AExceptionClass: TClass; AMsg: string);
begin
    FCurrentProcToCheck := AMethod;
    inherited CheckException(RunCurrentProcToCheck, AExceptionClass, AMsg);
end;

procedure TBaseTestCase.CheckNoException(AMethod: TProc; AMsg: string);
begin
    try
        AMethod;
    except
        on E: Exception do
          Check(False, AMsg + ' / No Exception expected but got: ' + E.Message);
    end;
end;

procedure TBaseTestCase.RunCurrentProcToCheck;
begin
    Assert(Assigned(FCurrentProcToCheck));
    FCurrentProcToCheck;
end;


end.
