program prjAchievementCheckList;

uses
  Vcl.Forms,
  uAchievementShower in 'uAchievementShower.pas' {AchievementTracker},
  DataConnector in '..\Datasource\DataConnector.pas',
  DataHandler in '..\Datasource\DataHandler.pas',
  uEnterURL in '..\AchievementAdd\uEnterURL.pas' {EnterUrlForm},
  uAchievementDetails in '..\AchievementDetails\uAchievementDetails.pas' {ChangeDetailsForm},
  SMListView in '..\Components\SMListView.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAchievementTracker, AchievementTracker);
  Application.Run;
end.
