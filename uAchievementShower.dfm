object AchievementTracker: TAchievementTracker
  Left = 0
  Top = 0
  Caption = 'Achievement Tracker'
  ClientHeight = 647
  ClientWidth = 1281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1281
    Height = 593
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lvAchievements: TSMListView
      Left = 0
      Top = 0
      Width = 1281
      Height = 593
      Align = alClient
      Columns = <
        item
          Width = 500
        end
        item
        end
        item
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      PopupMenu = PopupMenu
      ReadOnly = False
      TabStop = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvAchievementsClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 612
    Width = 1281
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Color = clBtnHighlight
    ParentBackground = False
    TabOrder = 1
    object Button1: TButton
      Left = 1200
      Top = 6
      Width = 75
      Height = 25
      Caption = '<- Back'
      TabOrder = 0
      OnClick = miBackClick
    end
    object ProgressBar: TProgressBar
      Left = 8
      Top = 8
      Width = 1186
      Height = 21
      TabOrder = 1
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 593
    Width = 1281
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Text = 'Sup'
        Width = 50
      end>
  end
  object MainMenu: TMainMenu
    Left = 1104
    Top = 16
    object miOptions: TMenuItem
      Caption = 'Options'
      object miAddGame: TMenuItem
        Caption = 'Add Game by URL'
        ShortCut = 16462
        OnClick = miAddGameClick
      end
    end
  end
  object PopupMenu: TPopupMenu
    Left = 1152
    Top = 16
    object miBack: TMenuItem
      Caption = '<- Back'
      ShortCut = 16450
      OnClick = miBackClick
    end
  end
end
