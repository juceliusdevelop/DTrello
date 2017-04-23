unit trello.boards;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  trello.core, System.JSON, REST.Client, IPPeerCommon, dtrello.authenticator;

type
  Ttrello_boards = class(Ttrello_base)
  private
    FIdOrganization: string;
    procedure SetIdOrganization(const Value: string);
  public
    constructor Create(const AIdOrganization: string; const AAuthenticator: TAuthenticator);
    destructor Destroy; override;

    function Get(const AParams: array of TJSONPair): TRESTResponse;
    function Post(const AParams: array of string): TRESTResponse;
    function Put(const Value: string;
                 const FieldName: string;
                 const AParams: string): TRESTResponse;
    function Delete(const Value: string): TRESTResponse;

    property IdOrganization: string read FIdOrganization write SetIdOrganization;
  end;

implementation
  uses System.StrUtils, REST.Authenticator.OAuth,
       System.Threading, REST.Types, trello.authenticator, trello.constants;

resourcestring
  StrBoards = 'boards';

{ Ttrello_boards }

constructor Ttrello_boards.Create(const AIdOrganization: string; const AAuthenticator: TAuthenticator);
begin
  inherited Create(AAuthenticator);
  EndPoint:= StrBoards;
  FIdOrganization:= AIdOrganization;
end;

function Ttrello_boards.Delete(const Value: string): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmDELETE,
      Format('%s/%s/%s', [TDTrelloContants.BaseUrl, EndPoint, Value]), []);
  except
    raise;
  end;
end;

destructor Ttrello_boards.Destroy;
begin
//
  inherited;
end;

function Ttrello_boards.Get(const AParams: array of TJSONPair): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmGET,
      Format('%s/organizations/%s/%s', [TDTrelloContants.BaseUrl, IdOrganization, EndPoint]), []);
  except
    raise;
  end;
end;

function Ttrello_boards.Post(const AParams: array of string): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmPOST,
      Format('%s/%s', [TDTrelloContants.BaseUrl, EndPoint]),
      [TJSONPair.Create('name', AParams[0]),
       TJSONPair.Create('idOrganization', AParams[1])]);
  except
    raise;
  end;
end;

function Ttrello_boards.Put(const Value, FieldName,
  AParams: string): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmPUT,
      Format('%s/%s/%s/%s', [TDTrelloContants.BaseUrl, EndPoint, Value, FieldName]),
      [TJSONPair.Create('value', AParams)]);
  except
    raise;
  end;
end;

procedure Ttrello_boards.SetIdOrganization(const Value: string);
begin
  FIdOrganization := Value;
end;

end.
