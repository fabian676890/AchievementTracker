unit uAchievementDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TChangeDetailsForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtAchievementId: TEdit;
    edtGameID: TEdit;
    edtName: TEdit;
    cbDone: TCheckBox;
    btnClose: TButton;
    btnSave: TButton;
    edtDesc: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadForm(fAchievementID : integer; fGameID : integer; fAchievementName : string; fAchievementDesc : string; fDone : boolean);
  end;

var
  ChangeDetailsForm: TChangeDetailsForm;

implementation

uses uAchievementShower;

{$R *.dfm}

{ TChangeDetailsForm }

procedure TChangeDetailsForm.LoadForm(fAchievementID : integer; fGameID : integer; fAchievementName : string; fAchievementDesc : string; fDone : boolean);
begin
  edtAchievementId.Text := IntToStr(fAchievementID);
  edtGameID.Text := IntToStr(fGameID);
  edtName.Text := fAchievementName;
  edtDesc.Lines.Text := fAchievementDesc;
  cbDone.Checked := fDone;
end;

procedure TChangeDetailsForm.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TChangeDetailsForm.btnSaveClick(Sender: TObject);
var
  achievement : TAchievement;
begin
  achievement := TAchievement.Create;
  try
    achievement.AchievementID := StrToInt(edtAchievementId.Text);
    achievement.GameID := StrToInt(edtGameID.Text);
    achievement.AchievementName := edtName.Text;
    achievement.AchievementDesc := edtDesc.Lines.Text;
    achievement.Done := cbDone.Checked;

    achievement.UpdateByID(StrToInt(edtAchievementId.Text));

    self.Close;
  finally
    FreeAndNil(achievement);
  end;
end;

end.
