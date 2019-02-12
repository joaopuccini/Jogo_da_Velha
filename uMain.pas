unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    LayoutGeral: TLayout;
    lbJogoDaVelha: TLabel;
    LayoutCabecalho: TLayout;
    LayoutNoveBotoes: TLayout;
    LayoutPrimeiro: TLayout;
    bt1: TButton;
    bt3: TButton;
    bt2: TButton;
    LayoutTerceiro: TLayout;
    bt7: TButton;
    bt9: TButton;
    bt8: TButton;
    LayoutSegundo: TLayout;
    bt4: TButton;
    bt6: TButton;
    bt5: TButton;
    LayoutJogo: TLayout;
    Line4: TLine;
    Line3: TLine;
    Line1: TLine;
    Line2: TLine;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    procedure bt1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure VerificarVelha;
    procedure VerificarGanhador(botao: TButton);
    procedure LimparBotoes;
  end;
var
  Form1: TForm1;
  VEZ : String;
  MOMENTO : Integer;

implementation

{$R *.fmx}

procedure TForm1.bt1Click(Sender: TObject);
begin
  if TButton(Sender).Text.IsEmpty then
  begin
    if VEZ = 'X' then
      VEZ := 'O'
    else
      VEZ := 'X';

    TButton(Sender).Text := VEZ;
    MOMENTO := MOMENTO + 1;
  end;

  VerificarVelha;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  VEZ := 'X';
  MOMENTO := 0;
end;

procedure TForm1.LimparBotoes;
begin
  bt1.Text := '';
  bt2.Text := '';
  bt3.Text := '';
  bt4.Text := '';
  bt5.Text := '';
  bt6.Text := '';
  bt7.Text := '';
  bt8.Text := '';
  bt9.Text := '';
  MOMENTO  := 0;
end;

procedure TForm1.VerificarGanhador(botao: TButton);
begin
  ShowMessage('Jogador ' + botao.Text + ' ganhou!');
  LimparBotoes;
end;

procedure TForm1.VerificarVelha;
begin

  if MOMENTO <> 10 then
  begin
    if (bt1.Text = bt2.Text) and (bt2.Text = bt3.Text) and (not (bt1.Text.IsEmpty and bt2.Text.IsEmpty and bt3.Text.IsEmpty))then
    begin
      VerificarGanhador(bt1);
    end
    else
    begin
      if (bt4.Text = bt5.Text) and (bt5.Text = bt6.Text) and (not (bt4.Text.IsEmpty and bt5.Text.IsEmpty and bt6.Text.IsEmpty)) then
      begin
        VerificarGanhador(bt4);
      end
      else
      begin
        if (bt7.Text = bt8.Text) and (bt8.Text = bt9.Text) and (not (bt7.Text.IsEmpty and bt8.Text.IsEmpty and bt9.Text.IsEmpty)) then
        begin
          VerificarGanhador(bt7);
        end
        else
        begin
          if (bt1.Text = bt4.Text) and (bt4.Text = bt7.Text) and (not (bt1.Text.IsEmpty and bt4.Text.IsEmpty and bt7.Text.IsEmpty)) then
          begin
            VerificarGanhador(bt1);
          end
          else
          begin
            if (bt2.Text = bt5.Text) and (bt5.Text = bt8.Text) and (not (bt2.Text.IsEmpty and bt5.Text.IsEmpty and bt8.Text.IsEmpty))then
            begin
              VerificarGanhador(bt2);
            end
            else
            begin
              if (bt3.Text = bt6.Text) and (bt6.Text = bt9.Text) and (not (bt3.Text.IsEmpty and bt6.Text.IsEmpty and bt9.Text.IsEmpty))then
              begin
                VerificarGanhador(bt3);
              end
              else
              begin
                if (bt3.Text = bt5.Text) and (bt5.Text = bt7.Text) and (not (bt3.Text.IsEmpty and bt5.Text.IsEmpty and bt7.Text.IsEmpty)) then
                begin
                  VerificarGanhador(bt5);
                end
                else
                begin
                  if (bt1.Text = bt5.Text) and (bt5.Text = bt9.Text) and (not (bt1.Text.IsEmpty and bt5.Text.IsEmpty and bt9.Text.IsEmpty)) then
                  begin
                    VerificarGanhador(bt5);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end
  else
    begin
      ShowMessage('VELHA');
      LimparBotoes;
    end;
end;
end.
