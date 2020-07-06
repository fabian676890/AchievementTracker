object ChangeDetailsForm: TChangeDetailsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Achievement Tracker - Change Details'
  ClientHeight = 295
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 365
    Height = 295
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 64
    ExplicitTop = 72
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Label1: TLabel
      Left = 48
      Top = 16
      Width = 86
      Height = 13
      Caption = 'Achievement ID : '
    end
    object Label2: TLabel
      Left = 83
      Top = 51
      Width = 48
      Height = 13
      Caption = 'Game ID :'
    end
    object Label3: TLabel
      Left = 32
      Top = 86
      Width = 99
      Height = 13
      Caption = 'Achievement Name :'
    end
    object Label4: TLabel
      Left = 36
      Top = 121
      Width = 98
      Height = 13
      Caption = 'Achievement Desc : '
    end
    object edtAchievementId: TEdit
      Left = 137
      Top = 13
      Width = 213
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edtGameID: TEdit
      Left = 137
      Top = 48
      Width = 213
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object edtName: TEdit
      Left = 137
      Top = 83
      Width = 213
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object cbDone: TCheckBox
      Left = 154
      Top = 233
      Width = 41
      Height = 17
      Caption = 'Done'
      TabOrder = 3
    end
    object btnClose: TButton
      Left = 194
      Top = 264
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 4
      OnClick = btnCloseClick
    end
    object btnSave: TButton
      Left = 275
      Top = 264
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 5
      OnClick = btnSaveClick
    end
    object edtDesc: TMemo
      Left = 137
      Top = 118
      Width = 213
      Height = 109
      ReadOnly = True
      TabOrder = 6
    end
  end
end
