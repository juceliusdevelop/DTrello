//Jucelio Moura - juceliusdevelop@gmail.com
//https://www.youtube.com/channel/UCMDXBe5-lrP-T-molp2cSBg/videos

unit dtrello.organizations;

interface

uses
  System.SysUtils, System.Classes, dtrello.authenticator,
  FireDAC.Comp.Client, Data.DB;

type
  TOrganizations = class(TComponent)
  private
    FAuthenticator: TAuthenticator;
    FDataSet: TFDMemTable;
    FActive: Boolean;
    procedure SetAuthenticator(const Value: TAuthenticator);
    procedure SetDataSet(const Value: TFDMemTable);
    procedure SetActive(const Value: Boolean);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent;
                            Operation: TOperation); override;
  public
    { Public declarations }
    procedure Refresh;
    function Delete: Boolean; overload;
    function Delete(const AId: string): Boolean; overload;
    function Insert(const AName, ADisplayName, ADesc, AWebSite: string): Boolean;
    function Edit(const AId, FieldName, Value: string): Boolean; overload;
    function Edit(FieldName, Value: string): Boolean; overload;
  published
    { Published declarations }
    property Authenticator: TAuthenticator read FAuthenticator write SetAuthenticator;
    property DataSet: TFDMemTable read FDataSet write SetDataSet;
    property Active: Boolean read FActive write SetActive default False;
  end;

procedure Register;

implementation
  uses System.Threading, trello.util, REST.Client, trello.organizations;

resourcestring
  StrComponentAuthentica = 'Component Authenticator não encontrado.';

{$R ..\Organizations.dcr}

procedure Register;
begin
  RegisterComponents('DTrello', [TOrganizations]);
end;

{ TOrganizations }

function TOrganizations.Delete: Boolean;
begin
  Result:= FDataSet <> nil;
  if Result then
    Result:= Self.Delete(FDataSet.FieldByName('id').AsString);
end;

function TOrganizations.Delete(const AId: string): Boolean;
begin
  Result:= False;
  with Ttrello_organizations.Create(FAuthenticator) do
  begin
    try
      Result:= Delete(AId).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TOrganizations.Edit(FieldName, Value: string): Boolean;
begin
  Result:= FDataSet <> nil;
  if Result then
    Result:= Self.Edit(FDataSet.FieldByName('id').AsString, FieldName, Value);
end;

function TOrganizations.Edit(const AId, FieldName, Value: string): Boolean;
begin
  Result:= False;
  if FAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  with Ttrello_organizations.Create(FAuthenticator) do
  begin
    try
      Result:= Put(AId, FieldName, Value).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TOrganizations.Insert(const AName, ADisplayName, ADesc, AWebSite: string): Boolean;
begin
  Result:= False;
  if FAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  with Ttrello_organizations.Create(FAuthenticator) do
  begin
    try
      Result:= Post([AName, ADisplayName, ADesc, AWebSite]).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

procedure TOrganizations.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAuthenticator)
    then FAuthenticator := nil;
  if (Operation = opRemove) and (AComponent = FDataSet)
    then FDataSet := nil;
end;

procedure TOrganizations.Refresh;
var
  loBook: TBookmark;
begin
  if FDataSet <> nil then
  begin
    FDataSet.DisableControls;
    loBook:= FDataSet.Bookmark;
  end;
  try
    Active:= False;
    Active:= True;
  finally
    if FDataSet <> nil then
    begin
      if FDataSet.BookmarkValid(loBook) then
        FDataSet.GotoBookmark(loBook);
      FDataSet.EnableControls;
    end;
  end;
end;

procedure TOrganizations.SetActive(const Value: Boolean);
var
  loTask: ITask;
begin
  FActive := Value;
  if FActive then
  begin
    if FAuthenticator = nil then
      raise Exception.Create(StrComponentAuthentica);

    loTask:= TTask.Create(
      procedure ()
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          with Ttrello_organizations.Create(FAuthenticator) do
          begin
            if FDataSet <> nil then
              FDataSet.DisableControls;
            try
              FDataSet.DataInJson(Get([]));
            finally
              if FDataSet <> nil then
              begin
                if FDataSet.Active then
                  FDataSet.First;
                FDataSet.EnableControls;
              end;
              Free;
            end;
          end;
        end);
      end
    );
    loTask.Start;
  end else
  begin
    if FDataSet <> nil then
      FDataSet.Close;
  end;
end;

procedure TOrganizations.SetAuthenticator(const Value: TAuthenticator);
begin
  FAuthenticator := Value;
end;

procedure TOrganizations.SetDataSet(const Value: TFDMemTable);
begin
  FDataSet := Value;
end;

end.
