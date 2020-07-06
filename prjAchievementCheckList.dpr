program prjAchievementCheckList;

uses
  Vcl.Forms,
  uAchievementShower in 'uAchievementShower.pas' {AchievementTracker},
  DataConnector in 'DataConnector.pas',
  DataHandler in 'DataHandler.pas',
  uEnterURL in 'uEnterURL.pas' {EnterUrlForm},
  uAchievementDetails in 'uAchievementDetails.pas' {ChangeDetailsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAchievementTracker, AchievementTracker);
  Application.CreateForm(TEnterUrlForm, EnterUrlForm);
  Application.CreateForm(TChangeDetailsForm, ChangeDetailsForm);
  Application.Run;
end.
