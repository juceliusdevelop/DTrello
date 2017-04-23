unit dtrello.demo.principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, dtrello.authenticator, dtrello.cards,
  dtrello.lists, dtrello.boards, dtrello.organizations, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tdtrello_demo_principal = class(TForm)
    grp_organization: TGroupBox;
    grdpnl_organization: TGridPanel;
    btn_active_org: TButton;
    btn_insert_org: TButton;
    btn_edit_org: TButton;
    btn_delete_org: TButton;
    dbg_organization: TDBGrid;
    grp_board: TGroupBox;
    GridPanel1: TGridPanel;
    btn_active_bor: TButton;
    btn_insert_bor: TButton;
    btn_edit_bor: TButton;
    btn_delete_bor: TButton;
    dbg_boads: TDBGrid;
    grp_list: TGroupBox;
    GridPanel2: TGridPanel;
    btn_active_lis: TButton;
    btn_insert_lis: TButton;
    btn_edit_lis: TButton;
    btn_delete_lis: TButton;
    dbg_lists: TDBGrid;
    grp_card: TGroupBox;
    GridPanel3: TGridPanel;
    btn_active_car: TButton;
    btn_insert_car: TButton;
    btn_edit_car: TButton;
    btn_delete_car: TButton;
    dbg_cards: TDBGrid;
    mtb_organization: TFDMemTable;
    mtb_board: TFDMemTable;
    mtb_list: TFDMemTable;
    mtb_card: TFDMemTable;
    ds_organization: TDataSource;
    ds_board: TDataSource;
    ds_list: TDataSource;
    ds_card: TDataSource;
    Organizations1: TOrganizations;
    Boards1: TBoards;
    Lists1: TLists;
    Cards1: TCards;
    Authenticator1: TAuthenticator;
    procedure btn_active_orgClick(Sender: TObject);
    procedure btn_delete_orgClick(Sender: TObject);
    procedure btn_insert_orgClick(Sender: TObject);
    procedure btn_edit_orgClick(Sender: TObject);
    procedure btn_active_borClick(Sender: TObject);
    procedure btn_delete_borClick(Sender: TObject);
    procedure btn_insert_borClick(Sender: TObject);
    procedure btn_edit_borClick(Sender: TObject);
    procedure btn_active_lisClick(Sender: TObject);
    procedure btn_insert_lisClick(Sender: TObject);
    procedure btn_edit_lisClick(Sender: TObject);
    procedure btn_active_carClick(Sender: TObject);
    procedure btn_insert_carClick(Sender: TObject);
    procedure btn_delete_carClick(Sender: TObject);
    procedure btn_edit_carClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtrello_demo_principal: Tdtrello_demo_principal;

implementation

{$R *.dfm}

procedure Tdtrello_demo_principal.btn_active_borClick(Sender: TObject);
begin
  Boards1.IdOrganization:= Organizations1.DataSet.FieldByName('id').AsString;
  Boards1.Active:= True;
end;

procedure Tdtrello_demo_principal.btn_active_carClick(Sender: TObject);
begin
  Cards1.IdList:= Lists1.DataSet.FieldByName('id').AsString;
  Cards1.Active:= True;
end;

procedure Tdtrello_demo_principal.btn_active_lisClick(Sender: TObject);
begin
  Lists1.IdBoard:= Boards1.DataSet.FieldByName('id').AsString;
  Lists1.Active:= True;
end;

procedure Tdtrello_demo_principal.btn_active_orgClick(Sender: TObject);
begin
  Organizations1.Active:= True;
end;

procedure Tdtrello_demo_principal.btn_delete_borClick(Sender: TObject);
begin
  Boards1.IdOrganization:= Organizations1.DataSet.FieldByName('id').AsString;
  if Boards1.Active then
    if Boards1.Delete then
      Boards1.Refresh
end;

procedure Tdtrello_demo_principal.btn_delete_carClick(Sender: TObject);
begin
  Cards1.IdList:= Lists1.DataSet.FieldByName('id').AsString;
  if Cards1.Active then
    if Cards1.Delete then
      Cards1.Refresh
end;

procedure Tdtrello_demo_principal.btn_delete_orgClick(Sender: TObject);
begin
  if Organizations1.Active then
    if Organizations1.Delete then
      Organizations1.Refresh
end;

procedure Tdtrello_demo_principal.btn_edit_borClick(Sender: TObject);
var
  loNewName: string;
begin
  if InputQuery('Informe', 'Informe o novo valor:', loNewName) then
  Boards1.IdOrganization:= Organizations1.DataSet.FieldByName('id').AsString;
  if Boards1.Active then
    if Boards1.Edit('name', loNewName) then
      Boards1.Refresh
end;

procedure Tdtrello_demo_principal.btn_edit_carClick(Sender: TObject);
var
  loNewName: string;
begin
  if InputQuery('Informe', 'Informe o novo valor:', loNewName) then
  Cards1.IdList:= Lists1.DataSet.FieldByName('id').AsString;
  if Cards1.Active then
    if Cards1.Edit('name', loNewName) then
      Cards1.Refresh
end;

procedure Tdtrello_demo_principal.btn_edit_lisClick(Sender: TObject);
var
  loNewName: string;
begin
  if InputQuery('Informe', 'Informe o novo valor:', loNewName) then
  Lists1.IdBoard:= Boards1.DataSet.FieldByName('id').AsString;
  if Lists1.Active then
    if Lists1.Edit('name', loNewName) then
      Lists1.Refresh
end;

procedure Tdtrello_demo_principal.btn_edit_orgClick(Sender: TObject);
var
  loNewDisplayName: string;
begin
  if InputQuery('Informe', 'Informe o novo valor:', loNewDisplayName) then
    if Organizations1.Active then
      if Organizations1.Edit('displayName', loNewDisplayName) then
        Organizations1.Refresh
end;

procedure Tdtrello_demo_principal.btn_insert_borClick(Sender: TObject);
var
  loName: string;
begin
  if InputQuery('Informe', 'Informe o valor:', loName) then
  Boards1.IdOrganization:= Organizations1.DataSet.FieldByName('id').AsString;
  if Boards1.Insert(loName) then
    Boards1.Refresh;
end;

procedure Tdtrello_demo_principal.btn_insert_carClick(Sender: TObject);
var
  loName: string;
begin
  if InputQuery('Informe', 'Informe o valor:', loName) then
  Cards1.IdList:= Lists1.DataSet.FieldByName('id').AsString;
  if Cards1.Insert(loName) then
    Cards1.Refresh;
end;

procedure Tdtrello_demo_principal.btn_insert_lisClick(Sender: TObject);
var
  loName: string;
begin
  if InputQuery('Informe', 'Informe o valor:', loName) then
  Lists1.IdBoard:= Boards1.DataSet.FieldByName('id').AsString;
  if Lists1.Insert(loName) then
    Lists1.Refresh;
end;

procedure Tdtrello_demo_principal.btn_insert_orgClick(Sender: TObject);
var
  loDisplayName: string;
begin
  if InputQuery('Informe', 'Informe o valor:', loDisplayName) then
  if Organizations1.Insert('uToppicOrg', loDisplayName, 'Uma Descrição', '') then
    Organizations1.Refresh;
end;

end.
