unit trello.cards;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  trello.core, System.JSON, REST.Client, IPPeerCommon, dtrello.authenticator;

type
  Ttrello_cards = class(Ttrello_base)
  private
    FIdList: string;
    procedure SetIdList(const Value: string);
  public
    constructor Create(const AIdList: string; const AAuthenticator: TAuthenticator);
    destructor Destroy; override;

    function Get(const AParams: array of TJSONPair): TRESTResponse;
    function Post(const AParams: array of string): TRESTResponse;
    function Put(const Value: string;
                 const FieldName: string;
                 const AParams: string): TRESTResponse;
    function Delete(const Value: string): TRESTResponse;

    property IdList: string read FIdList write SetIdList;
  end;

implementation
  uses System.StrUtils, REST.Authenticator.OAuth,
       System.Threading, REST.Types, trello.authenticator, trello.constants;

resourcestring
  StrCards = 'cards';

constructor Ttrello_cards.Create(const AIdList: string; const AAuthenticator: TAuthenticator);
begin
  inherited Create(AAuthenticator);
  EndPoint:= StrCards;
  FIdList:= AIdList;
end;

function Ttrello_cards.Delete(const Value: string): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmDELETE,
      Format('%s/%s/%s', [TDTrelloContants.BaseUrl, EndPoint, Value]), []);
  except
    raise;
  end;
end;

destructor Ttrello_cards.Destroy;
begin
//
  inherited;
end;

function Ttrello_cards.Get(const AParams: array of TJSONPair): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmGET,
      Format('%s/lists/%s/%s', [TDTrelloContants.BaseUrl, IdList, EndPoint]), []);
  except
    raise;
  end;
end;

function Ttrello_cards.Post(const AParams: array of string): TRESTResponse;
begin
  try
    Result:= Request(TRESTRequestMethod.rmPOST,
      Format('%s/%s', [TDTrelloContants.BaseUrl, EndPoint]),
      [TJSONPair.Create('name', AParams[0]),
       TJSONPair.Create('idMembers', Authenticator.Id),
       TJSONPair.Create('idList', AParams[1])]);
  except
    raise;
  end;
end;

function Ttrello_cards.Put(const Value, FieldName,
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

procedure Ttrello_cards.SetIdList(const Value: string);
begin
  FIdList := Value;
end;

end.
