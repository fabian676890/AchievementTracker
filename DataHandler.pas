unit DataHandler;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, DataConnector;

  type
    TDataHandler = class(TFDQuery)
    private
      con: TDataConnector;
      procedure SetSQL(const Value: string);
      function GetSQL: string;
    public
      constructor Create(AOwner: TComponent = nil); overload; override;
      destructor Destroy; override;
      property SQLText : string read GetSQL write SetSQL;
      function DoSelect: integer;
      function DoExec: integer;
      procedure SetParam(aName : string ; aValue : variant);
    end;
implementation

{ TDataHandler }

procedure TDataHandler.SetParam(aName: string; aValue: variant);
begin
  case VarType(aValue) of
    varString, varUString, varOleStr : Params.ParamByName(aName).DataType := ftString;
  end;
  Params.ParamByName(aName).Value := aValue;
end;

procedure TDataHandler.SetSQL(const Value: string);
begin
  SQL.Text := Value;
end;

function TDataHandler.GetSQL: string;
begin
  result := SQL.ToString;
end;

constructor TDataHandler.Create(AOwner: TComponent = nil);
begin
  inherited;
  con := TDataConnector.Create;
  Connection := con;
end;

destructor TDataHandler.Destroy;
begin
  FreeAndNil(con);
  inherited;
end;

function TDataHandler.DoExec: integer;
begin
  try
    ExecSQL;
  finally
    result := 0;
  end;
end;

function TDataHandler.DoSelect: integer;
begin
  try
    Open;
  finally
    result := RecordCount;
  end;
end;

end.
