unit DataConnector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Stan.Intf;
type
  TDataConnector = class(TFDConnection)
  private
    fFDDriver : TFDPhysMySQLDriverLink;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create; reintroduce; overload;
    destructor Destroy; override;
    property FDDriver: TFDPhysMySQLDriverLink read fFDDriver write fFDDriver;
  end;

implementation

constructor TDataConnector.Create(AOwner: TComponent);
begin
  inherited;
  FDDriver :=  TFDPhysMySQLDriverLink.Create(nil);
  FDDriver.VendorLib := 'libmysql.dll';

  Params.DriverID := 'MySQL';
  Params.Database := 'gametrackerdb';
  //Params.UserName := 'master';
  //Params.Password := 'Ciprian.ana23';
  Params.UserName := 'root';
  Params.Password := '';
  Params.Values['Server'] := 'localhost';
end;

constructor TDataConnector.Create;
begin
  Create(nil);
end;

destructor TDataConnector.Destroy;
begin
  FreeAndNil(fFDDriver);
  inherited;
end;

end.
