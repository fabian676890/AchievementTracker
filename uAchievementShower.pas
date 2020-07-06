unit uAchievementShower;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, MSHTML, Vcl.ComCtrls,
  Vcl.ExtCtrls, Generics.Collections, DataHandler, Vcl.Menus, uEnterURL;

type
  TAchievement = class;
  TGame = class;
  TGameList = class;
  TAchievementList = class;
  TAchievementTracker = class(TForm)
    Panel1: TPanel;
    lvAchievements: TListView;
    MainMenu: TMainMenu;
    miAddGame: TMenuItem;
    miOptions: TMenuItem;
    PopupMenu: TPopupMenu;
    miBack: TMenuItem;
    Panel2: TPanel;
    Button1: TButton;
    ProgressBar: TProgressBar;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvAchievementsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miAddGameClick(Sender: TObject);
    procedure miBackClick(Sender: TObject);
  private
    { Private declarations }
    httpParser : TIdHttp;
    htmlText : TStringList;
    extractedHtmlText : TStringList;
    urlText : string;
    gameView : boolean;
    gameList : TGameList;
    procedure LoadListView;
    procedure getOnlyAchievements;
    //procedure addAchievementsToList(gameName : string ; achievements : TStringList);
    procedure StartAddingToDB;
    procedure LoadAchievements(customChange : boolean = false; customGID : integer = 0);
  public
    { Public declarations }
  end;

  TAchievement = class(TObject)
  private
    fAchievementID : integer;
    fGameID : integer;
    fAchievementName : string;
    fAchievementDesc : string;
    fDone : boolean;
    dh : TDataHandler;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property AchievementID : integer read fAchievementID write fAchievementID;
    property GameID : integer read fGameID write fGameID;
    property AchievementName : string read fAchievementName write fAchievementName;
    property AchievementDesc : string read fAchievementDesc write fAchievementDesc;
    property Done : boolean read fDone write fDone;
    procedure InsertInDB;
    procedure LoadById(id : integer);
    procedure LoadByName(name : string);
    procedure UpdateByID(id : integer);
    procedure New;
    procedure Save;
  end;

  TGame = class(TObject)
  private
    fGameID : integer;
    fGameName : string;
    fAchievements : TList<TAchievement>;
    dh : TDataHandler;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property GameID : integer read fGameID write fGameID;
    property GameName : string read fGameName write fGameName;
    property AchievementsList : TList<TAchievement> read fAchievements write fAchievements;
    procedure LoadParams(id : integer);
    procedure Insert(rGameName : string ; rAchievementList : TStringList);
    procedure New;
    procedure Save;
  end;

  TGameList = class(TObject)
  private
    fGames : TList<TGame>;
    dh : TDataHandler;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property Games : TList<TGame> read fGames write fGames;
    procedure Load;
  end;

  TAchievementList = class(TObject)
  private
    fAchievements : TList<TAchievement>;
    dh : TDataHandler;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property Achievements : TList<TAchievement> read fAchievements write fAchievements;
    procedure LoadByID(id : integer);
  end;

var
  AchievementTracker: TAchievementTracker;

implementation

uses uAchievementDetails;

{$R *.dfm}

procedure TAchievementTracker.StartAddingToDB;
begin
  httpParser.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
  htmlText.Text := httpParser.Get(urlText);
  getOnlyAchievements;
end;

procedure TAchievementTracker.FormCreate(Sender: TObject);
begin
 httpParser := TIdHttp.Create;
 htmlText := TStringList.Create;
 extractedHtmlText := TStringList.Create;
 gameList := TGameList.Create;

 gameView := true;
end;


procedure TAchievementTracker.FormDestroy(Sender: TObject);
begin
  FreeAndNil(httpParser);
  FreeAndNil(htmlText);
  FreeAndNil(extractedHtmlText);
  FreeAndNil(gameList);
end;

procedure TAchievementTracker.FormShow(Sender: TObject);
begin
  lvAchievements.Column[1].Width := 0;
  lvAchievements.Column[2].Width := 0;
  gameList.Load;
  LoadListView;
end;

procedure TAchievementTracker.LoadListView;
var
  i : integer;
  Itm: TListItem;
const
  cText = 'Showing ';
  cTextpt2 = ' Games from Database';
begin
  gameView := true;
  lvAchievements.Items.Clear;

  for i := 0 to gameList.Games.Count -1 do begin
    Itm := lvAchievements.Items.Add;
    Itm.Caption := gameList.Games[i].GameName;
    Itm.SubItems.Add(IntToStr(gameList.Games[i].GameID));
  end;

  StatusBar.Panels[0].Text := cText + IntToStr(gameList.Games.Count) + cTextpt2;
end;

procedure TAchievementTracker.getOnlyAchievements;
var
  doc: OleVariant;
  el: OleVariant;
  i: integer;
  FoundTitle: boolean;
  //strings :TStringlist;
  //gameName : string;
  tempGame : TGame;
  tempAchievement : TAchievement;
begin
  tempGame := TGame.Create;
  tempAchievement := TAchievement.Create;
  try
    FoundTitle := false;
    //LoadListView
    //strings := TStringList.Create;
    ///strings.Text := =htmlText.Text;
    doc := coHTMLDocument.Create as IHTMLDocument2;
    doc.write(htmlText.Text);
    doc.Close;

    //strings.clear;
    for i := 0 to doc.body.all.length -1 do begin
      el := doc.body.all.item(i);
      if (el.tagName = 'H1') and (el.className = 'gh pagetitle topmargin2') then begin
        tempGame.New;
        tempGame.fGameName := StringReplace(el.innerText, ' Achievements', '',[rfReplaceAll, rfIgnoreCase]);
        tempGame.Save;

      end;
      if (el.tagName = 'A') and (el.className = 'title') then begin
        //strings.Add(el.innerText);
        tempAchievement.New;
        tempAchievement.GameID := tempGame.GameID;
        tempAchievement.AchievementName := el.innerText;
        FoundTitle := true;
        continue;
      end;
      if FoundTitle then begin
        el := doc.body.all.item(i);
        tempAchievement.AchievementDesc := el.innerText;
        tempAchievement.Done := false;
        tempAchievement.InsertInDB;

        FoundTitle := False;
        //Strings.Add(el.innerText);
      end;
    end;
  finally
    gameList.fGames.Add(tempGame);
    LoadListView;
    FreeAndNil(tempGame);
    FreeAndNil(tempAchievement);
  end;
end;

procedure TAchievementTracker.lvAchievementsClick(Sender: TObject);
var
  selectedAchievement : TAchievement;
  detailsForm : TChangeDetailsForm;
  //j : integer;
begin
  selectedAchievement := TAchievement.Create;
  detailsForm := TChangeDetailsForm.Create(nil);

  try
    if lvAchievements.Selected <> nil then begin
      if gameView then begin
        LoadAchievements();
        gameView := false;
      end else if not gameView then begin
        selectedAchievement.LoadByName(lvAchievements.Items.Item[lvAchievements.Selected.Index].Caption);

        detailsForm := TChangeDetailsForm.Create(nil);
        try
          with selectedAchievement do begin
            detailsForm.LoadForm(fAchievementID, fGameID, fAchievementName, fAchievementDesc, fDone);
          end;
          detailsForm.ShowModal;
          LoadAchievements(true, selectedAchievement.fGameID);
        finally
          detailsForm.Free;
        end;
      end;
    end;
  finally
    FreeAndNil(selectedAchievement);
  end;
end;

procedure TAchievementTracker.LoadAchievements(customChange : boolean = false ; customGID : integer = 0);
var
  achievementLists : TAchievementList;
  Itm: TListItem;
  i : integer;
const
  cDone = '✓';
  cNotDone = '✗';
  cText = 'Showing ';
  cTextpt2 = ' Achievements from Database';
begin
  achievementLists := TAchievementList.Create;
  try
    if not customChange then
      achievementLists.LoadByID(StrToInt(lvAchievements.Items.Item[lvAchievements.Selected.Index].SubItems[0]))//Caption))
    else
      achievementLists.LoadByID(customGID);

    lvAchievements.Items.Clear;

    for i := 0 to achievementLists.Achievements.Count -1 do begin
      Itm := lvAchievements.Items.Add;
      Itm.Caption := achievementLists.Achievements[i].AchievementName;
      Itm.SubItems.Add(achievementLists.Achievements[i].AchievementDesc);
      if achievementLists.Achievements[i].Done then
        Itm.SubItems.Add(cDone)
      else
        Itm.SubItems.Add(cNotDone);
    end;
    lvAchievements.Column[1].Width := 1020;
    lvAchievements.Column[2].Width := 40;
    FreeAndNil(Itm);

    StatusBar.Panels[0].Text := cText + IntToStr(achievementLists.Achievements.Count) + cTextpt2;
  finally
    FreeAndNil(achievementLists);
  end;
end;

//procedure TAchievementTracker.addAchievementsToList(gameName : string ; achievements: TStringList);
//var
//  game : TGame;
//begin
//  game := TGame.Create;
//  try
//    game.Insert(gameName, achievements);
//  finally
//    FreeAndNil(game);
//  end;
//end;

procedure TAchievementTracker.miAddGameClick(Sender: TObject);
var
  enterForm : TEnterUrlForm;
begin
  enterForm := TEnterUrlForm.Create(nil);
  try
    enterForm.ShowModal;
    urlText := enterForm.edtURL.Text;
    ProgressBar.Position := 0;
    if urlText <> '' then
      StartAddingToDB;
  finally
    enterForm.Free;
  end;
end;

procedure TAchievementTracker.miBackClick(Sender: TObject);
begin
  lvAchievements.Column[1].Width := 0;
  lvAchievements.Column[2].Width := 0;
  gameList.Load;
  LoadListView;
end;

{ TGame }

constructor TGame.Create;
begin
  fAchievements := TList<TAchievement>.Create;
  dh := TDataHandler.Create();
end;

destructor TGame.Destroy;
begin
  FreeAndNil(fAchievements);
  FreeAndNil(dh);
  inherited;
end;

procedure TGame.Insert(rGameName: string; rAchievementList: TStringList);
var
  tempAchievement : TAchievement;
  i : integer;
  gameID : integer;
  addedTitle: boolean;
begin
  tempAchievement := TAchievement.Create;
  try
    addedTitle := false;
    gameID := 0;

//    dh.SQLText := 'INSERT INTO games(GameName) '+
//                  'VALUES (:gamename)';
//    dh.SetParam('gamename', rGameName);
//    dh.DoExec;

    dh.SQLText := 'SELECT * ' +
                  'FROM games ' +
                  'WHERE GameName = :gamename';
    dh.SetParam('gamename', rGameName);
    if dh.DoSelect > 0 then
      gameID := dh.FieldByName('GameID').AsInteger;

    for i := 0 to rAchievementList.Count -1 do begin
      if not addedTitle then begin
        tempAchievement.GameID := gameID;
        tempAchievement.AchievementName := rAchievementList.Strings[i];
        addedTitle := true;
        continue;
      end;
      if addedTitle then begin
        tempAchievement.AchievementDesc := rAchievementList.Strings[i];
        tempAchievement.Done := false;
        addedTitle := false;
      end;
      //AchievementsList.Add(tempAchievement);
      tempAchievement.InsertInDB;
      tempAchievement := TAchievement.Create;
      //AchievementTracker.ProgressBar.Position := AchievementTracker.ProgressBar.Position + 1;
    end;

//    for i := 0 to AchievementsList.Count -1 do begin
//      AchievementsList[i].InsertInDB;
//    end;

    AchievementTracker.LoadListView;
  finally
    FreeAndNil(tempAchievement);
  end;
end;

procedure TGame.LoadParams(id: integer);
var
  tempAchievement : TAchievement;
begin
  tempAchievement := TAchievement.Create;
  try
    dh.SQLText := 'SELECT * ' +
                  'FROM games ' +
                  'WHERE GameID = :gameid';
    dh.SetParam('gameid', id);

    if dh.DoSelect > 0 then begin
      GameName := dh.FieldByName('GameName').AsString;
    end;

    dh.SQLText := 'SELECT * '+
                  'FROM achievements ' +
                  'WHERE GameID = :gameid';
    dh.SetParam('gameid', id);

    if dh.DoSelect > 0 then begin
      while not dh.Eof do begin
        tempAchievement.AchievementID := dh.FieldByName('AchievementID').AsInteger;
        tempAchievement.GameID := id;
        tempAchievement.AchievementName := dh.FieldByName('AchievementName').AsString;
        tempAchievement.AchievementDesc := dh.FieldByName('AchievementDesc').AsString;
        tempAchievement.Done := dh.FieldByName('Done').AsBoolean;
        AchievementsList.Add(tempAchievement);
        dh.Next;
      end;
    end;
  finally
    FreeAndNil(tempAchievement);
  end;
end;

procedure TGame.New;
begin
  dh.SQLText := 'SELECT MAX(GameID) + 1 ' +
                'AS LastID ' +
                'FROM games';

  if dh.DoSelect > 0 then
    self.GameID := dh.FieldByName('LastID').AsInteger;
end;

procedure TGame.Save;
begin
  dh.SQLText := 'INSERT INTO games(GameID, GameName)'+
                  'VALUES (:gid, :gamename)';
  dh.SetParam('gid', self.fGameID);
  dh.SetParam('gamename', self.fGameName);
  dh.DoExec;
end;

{ TAchievement }

constructor TAchievement.Create;
begin
  dh := TDataHandler.Create();
end;

destructor TAchievement.Destroy;
begin
  FreeAndNil(dh);
  inherited;
end;

procedure TAchievement.InsertInDB;
begin
  dh.SQLText := 'INSERT INTO achievements ' +
                'VALUES (:aid, :gameID,:achievementName,:achievementDesc,:done)';
  dh.SetParam('aid', AchievementID);
  dh.SetParam('gameID', GameID);
  dh.SetParam('achievementName', AchievementName);
  dh.SetParam('achievementDesc', AchievementDesc);
  dh.SetParam('done', Done);
  dh.DoExec;
end;

procedure TAchievement.LoadById(id: integer);
begin
  dh.SQLText := 'SELECT * ' +
                'FROM achievements ' +
                'WHERE AchievementID = :aid';
  dh.SetParam('aid', id);

  if dh.DoSelect > 0 then begin
    AchievementID := id;
    GameID := dh.FieldByName('GameID').AsInteger;
    AchievementName := dh.FieldByName('AchievementName').AsString;
    AchievementDesc := dh.FieldByName('AchievementDesc').AsString;
    Done := dh.FieldByName('Done').AsBoolean;
  end;
end;

procedure TAchievement.LoadByName(name: string);
begin
  dh.SQLText := 'SELECT * ' +
                'FROM achievements ' +
                'WHERE AchievementName = :aname';
  dh.SetParam('aname', name);

  if dh.DoSelect > 0 then begin
    AchievementID := dh.FieldByName('AchievementID').AsInteger;
    GameID := dh.FieldByName('GameID').AsInteger;
    AchievementName := dh.FieldByName('AchievementName').AsString;
    AchievementDesc := dh.FieldByName('AchievementDesc').AsString;
    Done := dh.FieldByName('Done').AsBoolean;
  end;
end;

procedure TAchievement.New;
begin
  dh.SQLText := 'SELECT MAX(AchievementID) + 1 ' +
                'AS LastID ' +
                'FROM achievements';

  if dh.DoSelect > 0 then
    self.AchievementID := dh.FieldByName('LastID').AsInteger;
end;

procedure TAchievement.Save;
begin
  //
end;

procedure TAchievement.UpdateByID(id: integer);
begin
  dh.SQLText := 'UPDATE achievements ' +
                'SET AchievementID= :aid, GameID=:gid, AchievementName=:aname, AchievementDesc=:adesc, Done=:adone ' +
                'WHERE AchievementID = :aid';
  dh.SetParam('aid', id);
  dh.SetParam('gid', GameID);
  dh.SetParam('aname', AchievementName);
  dh.SetParam('adesc', AchievementDesc);
  dh.SetParam('adone', Done);
  dh.DoExec;
end;

{ TGameList }

constructor TGameList.Create;
begin
  fGames := TList<TGame>.Create;
  dh := TDataHandler.Create;
end;

destructor TGameList.Destroy;
begin
  FreeAndNil(fGames);
  FreeAndNil(dh);
  inherited;
end;

procedure TGameList.Load;
var
  tempGame : TGame;
begin
  tempGame := TGame.Create;
  self.Games.Clear;
  try
    dh.SQLText := 'SELECT * '+
                  'FROM games';
    if dh.DoSelect > 0 then begin
      dh.First;
      while not dh.Eof do begin
        tempGame.fGameID := dh.FieldByName('GameID').AsInteger;
        tempGame.fGameName := dh.FieldByName('GameName').AsString;
        Games.Add(tempGame);
        tempGame := TGame.Create;
        dh.Next;
      end;
    end;
  finally
    FreeAndNil(tempGame);
  end;
end;

{ TAchievementList }

constructor TAchievementList.Create;
begin
  fAchievements := TList<TAchievement>.Create;
  dh := TDataHandler.Create;
end;

destructor TAchievementList.Destroy;
begin
  FreeAndNil(fAchievements);
  FreeAndNil(dh);
  inherited;
end;

procedure TAchievementList.LoadByID(id : integer);
var
  tempAchievement : TAchievement;
begin
  tempAchievement := TAchievement.Create;
  try
    dh.SQLText := 'SELECT * '+
                  'FROM achievements '+
                  'WHERE GameID = :gameID ' +
                  'ORDER BY Done DESC';
    dh.SetParam('gameID', id);
    if dh.DoSelect > 0 then begin
      dh.First;
      while not dh.Eof do begin
        tempAchievement.fAchievementID := dh.FieldByName('AchievementID').AsInteger;
        tempAchievement.fGameID := dh.FieldByName('GameID').AsInteger;
        tempAchievement.fAchievementName := dh.FieldByName('AchievementName').AsString;
        tempAchievement.fAchievementDesc := dh.FieldByName('AchievementDesc').AsString;
        tempAchievement.fDone := dh.FieldByName('Done').AsBoolean;
        Achievements.Add(tempAchievement);
        tempAchievement := TAchievement.Create;
        dh.Next;
      end;
    end;
  finally
    FreeAndNil(tempAchievement);
  end;
end;

end.
