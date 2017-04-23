//Jucelio Moura - juceliusdevelop@gmail.com
//https://www.youtube.com/channel/UCMDXBe5-lrP-T-molp2cSBg/videos

unit dtrello.lists;

interface

uses
  System.SysUtils, System.Classes, dtrello.authenticator,
  FireDAC.Comp.Client, Data.DB;

type
  TLists = class(TComponent)
  private
    FAuthenticator: TAuthenticator;
    FDataSet: TFDMemTable;
    FActive: Boolean;
    FIdBoard: string;
    procedure SetActive(const Value: Boolean);
    procedure SetAuthenticator(const Value: TAuthenticator);
    procedure SetDataSet(const Value: TFDMemTable);
    procedure SetIdBoard(const Value: string);

    //Metodos não existem na api
    function Delete: Boolean; overload;
    function Delete(const AId: string): Boolean; overload;
    { Private declarations }
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent;
                            Operation: TOperation); override;
  public
    { Public declarations }
    function Insert(const AName: string): Boolean;
    procedure Refresh;
    function Edit(const AId, FieldName, Value: string): Boolean; overload;
    function Edit(FieldName, Value: string): Boolean; overload;
  published
    { Published declarations }
    property Authenticator: TAuthenticator read FAuthenticator write SetAuthenticator;
    property DataSet: TFDMemTable read FDataSet write SetDataSet;
    property Active: Boolean read FActive write SetActive default False;
    property IdBoard: string read FIdBoard write SetIdBoard;
  end;

procedure Register;

implementation
  uses System.Threading, trello.util, REST.Client, trello.lists;

{$R ..\Organizations.dcr}

resourcestring
  StrComponentAuthentica = 'Component Authenticator não encontrado.';
  StrInformeOIdentifica = 'Informe o identificador do quadro.';

procedure Register;
begin
  RegisterComponents('DTrello', [TLists]);
end;

{ TBoards }

function TLists.Delete: Boolean;
begin
  Result:= FDataSet <> nil;
  if Result then
    Result:= Self.Delete(FDataSet.FieldByName('id').AsString);
end;

function TLists.Delete(const AId: string): Boolean;
begin
  Result:= False;
  with Ttrello_lists.Create(FIdBoard, FAuthenticator) do
  begin
    try
      Result:= Delete(AId).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TLists.Edit(const AId, FieldName, Value: string): Boolean;
begin
  Result:= False;
  if FAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  if Trim(FIdBoard) = EmptyStr then
    raise Exception.Create(StrInformeOIdentifica);

  with Ttrello_lists.Create(FIdBoard, FAuthenticator) do
  begin
    try
      Result:= Put(AId, FieldName, Value).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TLists.Edit(FieldName, Value: string): Boolean;
begin
  Result:= FDataSet <> nil;
  if Result then
    Result:= Self.Edit(FDataSet.FieldByName('id').AsString, FieldName, Value);
end;

function TLists.Insert(const AName: string): Boolean;
begin
  Result:= False;
  if FAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  if Trim(FIdBoard) = EmptyStr then
    raise Exception.Create(StrInformeOIdentifica);

  with Ttrello_lists.Create(FIdBoard, FAuthenticator) do
  begin
    try
      Result:= Post([AName, FIdBoard]).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

procedure TLists.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAuthenticator)
    then FAuthenticator := nil;
  if (Operation = opRemove) and (AComponent = FDataSet)
    then FDataSet := nil;
end;

procedure TLists.Refresh;
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

procedure TLists.SetActive(const Value: Boolean);
var
  loTask: ITask;
begin
  FActive := Value;
  if FActive then
  begin
    if FAuthenticator = nil then
      raise Exception.Create(StrComponentAuthentica);

    if Trim(FIdBoard) = EmptyStr then
      raise Exception.Create(StrInformeOIdentifica);

    loTask:= TTask.Create(
      procedure ()
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          with Ttrello_lists.Create(FIdBoard, FAuthenticator) do
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

procedure TLists.SetAuthenticator(const Value: TAuthenticator);
begin
  FAuthenticator := Value;
end;

procedure TLists.SetDataSet(const Value: TFDMemTable);
begin
  FDataSet := Value;
end;

procedure TLists.SetIdBoard(const Value: string);
begin
  FIdBoard := Value;
end;

end.
