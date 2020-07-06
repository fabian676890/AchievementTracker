unit uEnterURL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TEnterUrlForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnEnter: TButton;
    edtURL: TEdit;
    procedure btnEnterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EnterUrlForm: TEnterUrlForm;

implementation

{$R *.dfm}

procedure TEnterUrlForm.btnEnterClick(Sender: TObject);
begin
  self.Close;
end;

end.
