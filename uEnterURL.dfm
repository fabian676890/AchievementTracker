object EnterUrlForm: TEnterUrlForm
  Left = 0
  Top = 0
  Caption = 'Achievement Tracker - Enter URL'
  ClientHeight = 67
  ClientWidth = 635
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
    Width = 635
    Height = 67
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 352
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Panel2: TPanel
      Left = 0
      Top = 26
      Width = 635
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 168
      ExplicitTop = 96
      ExplicitWidth = 185
      object btnEnter: TButton
        Left = 240
        Top = 8
        Width = 161
        Height = 25
        Caption = 'Enter URL'
        TabOrder = 0
        OnClick = btnEnterClick
      end
    end
    object edtURL: TEdit
      Left = 8
      Top = 8
      Width = 617
      Height = 21
      TabOrder = 1
    end
  end
end
