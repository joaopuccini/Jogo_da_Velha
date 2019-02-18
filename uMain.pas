unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.Objects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDac.dapt, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Datasnap.DBClient,
  System.Actions, FMX.ActnList, System.Character;

type
  TEstadoForm = (Principal, Ranking, SelecionarJogador);

  TForm1 = class(TForm)
    pPrincipal: TLayout;
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
    LayoutResetEInformacoes: TLayout;
    btRestart: TButton;
    lbVitorias: TLabel;
    lbX: TLabel;
    edtX: TEdit;
    LayoutVitorias: TLayout;
    LayoutCabecalhoVitoria: TLayout;
    LayoutX: TLayout;
    LayoutO: TLayout;
    edtO: TEdit;
    lbO: TLabel;
    btnReset: TButton;
    LayoutBotoesReset: TLayout;
    LayoutBtnRestart: TLayout;
    LayoutBtnReset: TLayout;
    pSelecionarJogador: TLayout;
    LayoutBotoesXouO: TLayout;
    btnX: TButton;
    btnO: TButton;
    lbCabeclaho: TLabel;
    pRanking: TLayout;
    lbCabecalhoRanking: TLabel;
    lbRodaPeVoltar: TLabel;
    LayoutListaJogadores: TLayout;
    LayoutRankingGeral: TLayout;
    Rectangle5: TRectangle;
    Button2: TButton;
    Label1: TLabel;
    Rectangle3: TRectangle;
    BrushRanking: TBrushObject;
    Estilos: TStyleBook;
    HotKeys: TActionList;
    Esc: TAction;
    Layout1: TLayout;
    Layout2: TLayout;
    edt1: TEdit;
    edt2: TEdit;
    conexao: TFDConnection;
    lbNomeX: TLabel;
    lbNomeO: TLabel;
    lvRanking: TListView;
    cdsRanking: TClientDataSet;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    Layout3: TLayout;
    lbName: TLabel;
    lbPosition: TLabel;
    Label4: TLabel;
    procedure bt1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btRestartClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnXClick(Sender: TObject);
    procedure btnOClick(Sender: TObject);
    procedure EscExecute(Sender: TObject);
    procedure VerificarBotao(Sender: TButton);
    procedure LetrasGrandes(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetEstadoForm(Value: TEstadoForm; resetar: Boolean = true);
    procedure VerificarVelha;
    procedure VerificarGanhador(botao: TButton);
    procedure LimparBotoes;
    procedure LimparBotoesAll;
    procedure IncrementarPontoNoBanco(qtd, id_jogador: Integer);
    function SelecionarNomes(nome: String): string;
    procedure VerificarJogadores;
    function VerificarNoBanco(nome:String): Integer;
    procedure CadastrarNoBanco(nome:String);
    procedure CarregarRanking;

  end;
var
  Form1: TForm1;
  fEstadoForm: TEstadoForm;
  VEZ : String;
  MOMENTO   : Integer;
  PONTO_X   : Integer;
  PONTO_O   : Integer;
  JOGADOR_1 : String;
  JOGADOR_2 : String;
  ID_O      : Integer;
  ID_X      : Integer;
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

procedure TForm1.btnOClick(Sender: TObject);
begin
  VEZ := 'X';
  VerificarBotao(btnO);
end;

procedure TForm1.btnXClick(Sender: TObject);
begin
  VEZ := 'O';
  VerificarBotao(btnX);
end;

procedure TForm1.btRestartClick(Sender: TObject);
begin
  LimparBotoes;
end;

procedure TForm1.btnResetClick(Sender: TObject);
begin
  IncrementarPontoNoBanco(edtO.Text.ToInteger, ID_O);
  IncrementarPontoNoBanco(edtX.Text.ToInteger, ID_X);
  LimparBotoesAll;
  SetEstadoForm(SelecionarJogador);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SetEstadoForm(Ranking);

end;

procedure TForm1.CadastrarNoBanco(nome: String);
var
  Qry : TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  with Qry do
  begin
    Connection := conexao;

    Sql.Add('INSERT INTO jogadores_ranking (nome) VALUES (:nome);');

    ParamByName('nome').AsString := nome;

    ExecSQL;
    Close;
  end;

  FreeAndNil(Qry);
end;

procedure TForm1.CarregarRanking;
var
  Qry      : TFDQuery;
  POSITION : Integer;
begin
  Qry := TFDQuery.Create(nil);
  cdsRanking.EmptyDataSet;
  POSITION := 1;

  with Qry do
  begin
    Connection := conexao;

    Sql.Add('SELECT nome, qtd_vitorias FROM memocash.jogadores_ranking ORDER BY qtd_vitorias DESC');

    Open;
      while not EOF do
      begin
        cdsRanking.Insert;
        cdsRanking.FieldByName('posicao').AsInteger := POSITION;
        cdsRanking.FieldByName('jogador').AsString   := FieldByName('nome').AsString;
        cdsRanking.FieldByName('vitorias').AsInteger := FieldByName('qtd_vitorias').AsInteger;
        cdsRanking.Post;
        Next;
        POSITION := POSITION + 1;
      end;
    Close;

  end;

  cdsRanking.Close;
  cdsRanking.Open;

  FreeAndNil(Qry);
end;

procedure TForm1.EscExecute(Sender: TObject);
begin
  case fEstadoForm  of
    Principal:
    begin
      SetEstadoForm(SelecionarJogador);
      LimparBotoesAll;
    end;

    Ranking:
      SetEstadoForm(Principal);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fEstadoForm <> SelecionarJogador then
    btnResetClick(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetEstadoForm(SelecionarJogador);

  MOMENTO     := 0;
  PONTO_X     := 0;
  PONTO_O     := 0;
  ID_X        := 0;
  ID_O        := 0;
  edtX.Text   := ID_X.ToString;
  edtO.Text   := ID_O.ToString;

end;

procedure TForm1.IncrementarPontoNoBanco(qtd, id_jogador:Integer);
var
  Qry : TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  with Qry do
  begin
    Connection := conexao;

    Sql.Add('UPDATE jogadores_ranking SET qtd_vitorias = qtd_vitorias + :qtd where id = :id_jogador');

    ParamByName('id_jogador').AsInteger := id_jogador;
    ParamByName('qtd').AsInteger        := qtd;
    ExecSQL;
    Close;
  end;
  FreeAndNil(Qry);
end;

procedure TForm1.LetrasGrandes(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  KeyChar := KeyChar.ToUpper;
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
  VEZ := 'X';
end;

procedure TForm1.LimparBotoesAll;
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
  edtX.Text:= '';
  edtO.Text:= '';
  MOMENTO  := 0;
  PONTO_X  := 0;
  PONTO_O  := 0;
  VEZ      := 'X';
  ID_X     := 0;
  ID_O     := 0;
end;

function TForm1.SelecionarNomes(nome: String): string;
begin

end;

procedure TForm1.SetEstadoForm(Value: TEstadoForm; resetar: Boolean);
begin
  if Value = fEstadoForm then
    Exit;

  // ESCONDER TELA
  case fEstadoForm of // TELA ATUAL
    SelecionarJogador:
    begin
      pSelecionarJogador.Visible := false;
      pSelecionarJogador.Enabled := false;
      pSelecionarJogador.SendToBack;
    end;

    Principal:
    begin
      pPrincipal.Visible := false;
      pPrincipal.Enabled := false;
      pPrincipal.SendToBack;
    end;

    Ranking:
    begin
      pRanking.Visible := false;
      pRanking.Enabled := false;
      pRanking.SendToBack;
    end;
  end;

  // MOSTRAR TELA
  case Value of
    SelecionarJogador:
    begin
      pSelecionarJogador.Enabled := true;
      pSelecionarJogador.Visible := true;
      pSelecionarJogador.BringToFront;
    end;

    Principal:
    begin
      pPrincipal.Enabled := true;
      pPrincipal.Visible := true;
      pPrincipal.BringToFront;
    end;

    Ranking:
    begin
      pRanking.Enabled := true;
      pRanking.Visible := true;
      pRanking.BringToFront;
      CarregarRanking;
    end;
  end;

  fEstadoForm := Value;
end;

procedure TForm1.VerificarBotao(Sender: TButton);
var
  Qry : TFDQuery;
begin

  if  edt1.Text.IsEmpty and edt2.Text.IsEmpty then // SE OS DOIS EDIT'S ESTAO VAZIOS
  begin
    SetEstadoForm(Principal);
    Exit;
  end;

  if not edt1.Text.IsEmpty and not edt2.Text.IsEmpty then // SE OS DOIS ESTÃO CHEIOS
  begin
    VerificarJogadores;
    SetEstadoForm(principal);
    Exit;
  end;

  ShowMessage('Preencha os dois campos ou jogue sem se cadastrar');  // SE TEM UM EDIT COM NOME E O OUTRO NÃO
end;

procedure TForm1.VerificarGanhador(botao: TButton);
begin
  ShowMessage('Jogador ' + botao.Text + ' ganhou!');

  if botao.Text = 'X' then
  begin
   PONTO_X := PONTO_X + 1;
   edtX.Text := IntToStr(PONTO_X);

  end
  else
  begin
   PONTO_O := PONTO_O + 1;
   edtO.Text := IntToStr(PONTO_O);
  end;

  VEZ := 'X';
  LimparBotoes;
end;

procedure TForm1.VerificarJogadores;
begin

  ID_X := VerificarNoBanco(edt1.Text);
  if ID_X = 0 then
  begin
    CadastrarNoBanco(edt1.Text);
    ID_X := VerificarNoBanco(edt1.Text);
  end;

  ID_O := VerificarNoBanco(edt2.Text);
  if ID_O = 0 then
  begin
    CadastrarNoBanco(edt2.Text);
    ID_O := VerificarNoBanco(edt2.Text);
  end;

  lbNomeX.Text := edt1.Text;
  lbNomeO.Text := edt2.Text;
end;

function TForm1.VerificarNoBanco(nome: String): Integer;
var
  Qry : TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  with Qry do
  begin
    Connection := conexao;

    Sql.Add('SELECT id FROM jogadores_ranking WHERE nome LIKE :nome');

    ParamByName('nome').AsString := nome;
    Open;

    if FieldByName('id').AsInteger > 0 then
      result := FieldByName('id').AsInteger
    else
      result := 0;
    Close;
  end;

  FreeAndNil(Qry);
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
                if MOMENTO = 9 then
                begin
                  ShowMessage('VELHA');
                  LimparBotoes;
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
